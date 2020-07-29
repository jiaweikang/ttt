//
//  USUniversalAlertModelManager.m
//  u_store
//
//  Created by mac_chen on 2019/2/20.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USUniversalAlertModelManager.h"
#import "NSString+Addition.h"
#import "NSObject+YYModel.h"
#import "CalcKeyIvHelper.h"
#import "Ule_SecurityKit.h"
#import "US_NetworkExcuteManager.h"
#import "US_ShareApi.h"
#import "USApplicationLaunchApi.h"
#import "FileController.h"
#import "UleModulesDataToAction.h"
#import "USUniversalAlertView.h"
#import "USApplicationLaunchManager.h"
#import <UIView+ShowAnimation.h>
#import "USCustomAlertViewManager.h"
#import "NSDate+USAddtion.h"
#import "UleGetTimeTool.h"
#import "USActivityAlertLocalModel.h"

static NSString *const KEY_LocalActivityAlertData = @"ActivityAlertData.data";


@interface USUniversalAlertModelManager ()
@property (nonatomic, strong) UleNetworkExcute  *apiClient;
@property (nonatomic, strong) UleNetworkExcute  *networkClient_UstaticCDN;
@property (nonatomic, copy) ShareRequestSuccessBlock successBlock;
@property (nonatomic, strong) ActivityDialogIndexInfo *model;

@end

static NSMutableArray *showedUserIdArr = nil;

@implementation USUniversalAlertModelManager

+ (instancetype)sharedManager {
    
    static USUniversalAlertModelManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            showedUserIdArr = [NSMutableArray array];
            sharedManager = [[USUniversalAlertModelManager alloc] init];
        });
    }
    return sharedManager;
}

- (void)startRequestActivityDialog{
    [self.networkClient_UstaticCDN beginRequest:[USApplicationLaunchApi buildRequestHomeActivityDialog] success:^(id responseObject) {
        [self fetchActivityDialogDicInfo:responseObject];
        [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
    } failure:^(UleRequestError *error) {
        [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
    }];
}

- (void)getShareUrlWithData:(NSMutableDictionary *)data successBlock:(ShareRequestSuccessBlock)shareRequestSuccessBlock{
    //造数据结构
    NSDictionary *params = @{@"shareFrom":@"1",
                             @"shareChannel":@"1",
                             @"listInfo":@[data]};
    [self requestCreateUrlWithParams:params];
    self.successBlock = [shareRequestSuccessBlock copy];
}

#pragma mark - 网络请求
//获取分享链接
- (void)requestCreateUrlWithParams:(NSDictionary *)params {
    @weakify(self);
    [self.apiClient beginRequest:[US_ShareApi buildActShareListingUrlRequest:[NSString jsonStringWithDictionary:params]] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        ShareCreateId *shareCreateId = [ShareCreateId yy_modelWithDictionary:responseObject];
        NSString *shareUrl = @"";
        if ([NSString isNullToString:shareCreateId.data.shareUrl4].length > 0) {
            shareUrl = [NSString stringWithFormat:@"%@", shareCreateId.data.shareUrl4];
        } else {
            NSString *shareUrl3=[NSString stringWithFormat:@"%@",shareCreateId.data.shareUrl3];
            shareUrl=[shareUrl3 stringByAppendingString:[NSString stringWithFormat:@"%@appName=%@",[shareUrl3 containsString:@"?"]?@"&":@"?",[UleStoreGlobal shareInstance].config.appName]];
        }
        if ([shareUrl containsString:@"?"]) {
            shareUrl = [NSString stringWithFormat:@"%@&storeid=%@", shareUrl, [US_UserUtility sharedLogin].m_userId];
        } else {
            shareUrl = [NSString stringWithFormat:@"%@?storeid=%@", shareUrl, [US_UserUtility sharedLogin].m_userId];
        }
        if (self->_successBlock) {
            self->_successBlock(shareUrl, shareCreateId.data);
        }
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUD];
    }];
}

#pragma mark - <>
- (void)fetchActivityDialogDicInfo:(NSDictionary *)dic{
    FeatureModel_ActivityDialog *model = [FeatureModel_ActivityDialog mj_objectWithKeyValues:dic];
    NSMutableArray *filteredArray = [NSMutableArray array];
    //过滤在活动有效期内的数据
    for (ActivityDialogIndexInfo *item in model.indexInfo) {
        if ([UleModulesDataToAction canInputDataMin:item.min_version withMax:item.max_version withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]]) {
            if ([self filterProvince:item]) {
                [filteredArray addObject:item];
            }
        }
    }

    //清除无效缓存
    [self deleteLocalActivityAlertUselessCache:filteredArray];
    
    //获取一个本次该弹出的弹框数据
    //弹框逻辑为多个活动弹框 每次打开只弹出一个 轮换弹出 pop_type_param是每天最大弹出次数
   ActivityDialogIndexInfo *alertInfo = [self getShouldShowAlertData:filteredArray];
    if (!alertInfo) {
        return;
    }
    
    NSMutableArray * alertArr = [NSMutableArray new];
    [alertArr addObject:alertInfo];
    for (ActivityDialogIndexInfo *item in alertArr) {
        USUniversalAlertView *universalAlertView = [USUniversalAlertView alertWithData:item confirmBlock:^(AlertClickType alertClickType) {
            if ([item.button_type isEqualToString:@"0"]) {
                [LogStatisticsManager onClickLog:Home_IndexDialog andTev:NonEmpty(item.log_title)];
                if (item.link.length > 0) {
                    NSMutableDictionary *dic = @{
                                                 @"title": item.title,
                                                 @"key": item.link,
                                                 }.mutableCopy;
                    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
                } else if (item.ios_action.length > 0) {
                    UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:item.ios_action];
                    [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
                }
            } else {
                if (alertClickType == alertClickType_image) {
                    [LogStatisticsManager onClickLog:Home_IndexDialog andTev:NonEmpty(item.log_title)];
                    if (item.link.length > 0) {
                        NSMutableDictionary *dic = @{
                                                     @"title": item.title,
                                                     @"key": item.link,
                                                     }.mutableCopy;
                        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
                    } else if (item.ios_action.length > 0) {
                        UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:item.ios_action];
                        [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
                    }
                }
            }
        } closeBlock:^{
            
        }];
        universalAlertView.alpha_backgroundView=@"0.7";
        universalAlertView.bindVCName = [USApplicationLaunchManager sharedManager].firstTabVCName;
        universalAlertView.orderNum = UnitAlertOrderActivity;
        [[CustomAlertViewManager sharedManager] addCustomAlertView:universalAlertView identify:item.activity_code];
    }
}

//筛选省份,没配默认不限制省份
- (BOOL)filterProvince:(ActivityDialogIndexInfo *)info
{
    if ([NSString isNullToString:info.showProvince].length > 0) {
        if ([US_UserUtility sharedLogin].m_provinceCode.length > 0 && [info.showProvince containsString:[US_UserUtility sharedLogin].m_provinceCode]) {
            return [self filtereData:info];
        }
    } else {
        return [self filtereData:info];
    }
    return NO;
}

//筛选符合条件的数据
- (BOOL)filtereData:(ActivityDialogIndexInfo *)info{
    //判断是否在活动期间内（必须是有效起止时间）
    //没有配置时间默认没有一直有效
    if ([self validateWithTime:info.activity_time] || [NSString isNullToString:info.activity_time].length <= 0) {
        return YES;
    }
    return NO;
}

//匹配删除本地存的无用数据
- (void)deleteLocalActivityAlertUselessCache:(NSMutableArray *)filteredArray{
    USActivityAlertLocalModel * alertLocalModel=[self getLocalActivityAlertData];
    NSMutableArray * AlertLocalArr=[alertLocalModel.alertDataArr mutableCopy];
    if (!alertLocalModel) {
        return;
    }
    //有删除操作 逆序遍历
    for (USActivityLocalAlertInfo * alertModel in AlertLocalArr.reverseObjectEnumerator) {
        BOOL findOld=NO;
        for (ActivityDialogIndexInfo * alertInfo in filteredArray) {
            if ([alertInfo.activity_code isEqualToString:alertModel.activityCode]) {
                findOld=YES;
                break;
            }
        }
        if (!findOld) {
            [AlertLocalArr removeObject:alertModel];
        }
    }
    if (AlertLocalArr.count < alertLocalModel.alertDataArr.count) {
        alertLocalModel.alertDataArr=[AlertLocalArr copy];
        [self saveLocalActivityAlertData:alertLocalModel];
    }
}

- (USActivityAlertLocalModel *)getLocalActivityAlertData{
    //读取本地存储的弹框数据
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:KEY_LocalActivityAlertData];
    // unarchiveObjectWithFile会调用initWithCoder
    USActivityAlertLocalModel * alertLocalModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return alertLocalModel;
}

- (void)saveLocalActivityAlertData:(USActivityAlertLocalModel *)alertLocalModel{
    NSString *tempPath = NSTemporaryDirectory();
    NSString *filePath = [tempPath stringByAppendingPathComponent:KEY_LocalActivityAlertData];
    [NSKeyedArchiver archiveRootObject:alertLocalModel toFile:filePath];
}

- (ActivityDialogIndexInfo *)getShouldShowAlertData:(NSMutableArray *)filteredArray{
    
    USActivityAlertLocalModel * alertLocalModel=[self getLocalActivityAlertData];
    //如果本地没有此用户弹框数据 说明从没弹过 直接取第一个显示
    if (!alertLocalModel.alertDataArr || alertLocalModel.alertDataArr.count == 0) {
        return filteredArray.firstObject;
    }
    
    //获取当天日期
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSString * currentDateStr=[NSDate DateStringFromTimestamp:currentTime DateFormat:@"YYYYMMdd"];
    
    //不是当天 重置remainder 重置弹出次数
    if (![alertLocalModel.lastShowDate isEqualToString:currentDateStr]) {
        alertLocalModel.remainder=@"0";
        for (USActivityLocalAlertInfo * alertLocalInfo in alertLocalModel.alertDataArr) {
            alertLocalInfo.alertShowCount=@"0";
        }
    }
    
    for (ActivityDialogIndexInfo * alertInfo in filteredArray.reverseObjectEnumerator) {
        BOOL findOld=NO;
       for (USActivityLocalAlertInfo * alertLocalInfo in alertLocalModel.alertDataArr) {
           if ([alertInfo.activity_code isEqualToString:alertLocalInfo.activityCode]) {
               findOld=YES;
               //字段为空没有次数上限 直接把已弹出次数赋值给请求到的弹框数据
               if ([NSString isNullToString:alertInfo.pop_type_param].length <= 0) {
                       alertInfo.nowDayShowedCount=alertLocalInfo.alertShowCount;
                   break;
               }else{
                   
                   if ([alertLocalInfo.alertShowDate isEqualToString:currentDateStr]) {
                       //如果已弹出次数大于等于接口返回设置的最大显示次数 就删除此条数据
                       if (alertLocalInfo.alertShowCount.integerValue >= alertInfo.pop_type_param.integerValue) {
                           [filteredArray removeObject:alertInfo];
                           break;
                       }
                       //如果弹出日期是当天 就把弹出次数赋值给接口数据
                       alertInfo.nowDayShowedCount=alertLocalInfo.alertShowCount;
                   }
                   //如过不是当天 说明当天没有弹出过 赋值0
                   else{
                       alertInfo.nowDayShowedCount=@"0";
                   }
               }
               break;
           }
           //如果在本地数据中没有找到匹配到的 说明是新返回的活动弹框 从没有弹出过 赋值0
           if (!findOld) {
               alertInfo.nowDayShowedCount=@"0";
           }
       }
    }
    
    //然后根据已弹出次数找出下一个需要弹出的活动框
    //先用弹出次数除2取余 找出第一个等于0的还未弹出过
    BOOL findOne=NO;
    for (ActivityDialogIndexInfo * alertInfo in filteredArray){
        if (alertInfo.nowDayShowedCount.integerValue %2 == alertLocalModel.remainder.integerValue) {
            findOne=YES;
            [self saveLocalActivityAlertData:alertLocalModel];
            return alertInfo;
        }
    }
    if (!findOne) {
        //如果都已经是奇数 说明都已经弹出过一遍 找除2取余等于1的
        if (alertLocalModel.remainder.integerValue == 0) {
            alertLocalModel.remainder=@"1";
        }else{
            alertLocalModel.remainder=@"0";
        }
        [self saveLocalActivityAlertData:alertLocalModel];

        for (ActivityDialogIndexInfo * alertInfo in filteredArray){
            if (alertInfo.nowDayShowedCount.integerValue %2 == alertLocalModel.remainder.integerValue) {
                return alertInfo;
            }
        }
    }
    [self saveLocalActivityAlertData:alertLocalModel];
    return nil;
}



//记录通用弹窗展示次数
- (void)setAlertShowTimes:(NSString *)activeId{
    //获取当天日期
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSString * currentDateStr=[NSDate DateStringFromTimestamp:currentTime DateFormat:@"YYYYMMdd"];
    
    USActivityAlertLocalModel * alertLocalModel=[self getLocalActivityAlertData];
    
    if (alertLocalModel) {
        BOOL isFind=NO;
        for (USActivityLocalAlertInfo * alertModel in alertLocalModel.alertDataArr) {
            if ([activeId isEqualToString:alertModel.activityCode]) {
                NSInteger alertShowCount=alertModel.alertShowCount.integerValue;
                alertModel.alertShowCount=[NSString stringWithFormat:@"%ld",alertShowCount+1];
                alertModel.alertShowDate=currentDateStr;
                isFind = YES;
                break;
            }
        }
        if (!isFind) {
            USActivityLocalAlertInfo * alertModel=[[USActivityLocalAlertInfo alloc] init];
            alertModel.activityCode=activeId;
            alertModel.alertShowCount=@"1";
            alertModel.alertShowDate=currentDateStr;
            NSMutableArray * muArr=[alertLocalModel.alertDataArr mutableCopy];
            [muArr addObject:alertModel];
            alertLocalModel.alertDataArr=[muArr copy];
        }
    }
    else{
        alertLocalModel = [[USActivityAlertLocalModel alloc] init];
        alertLocalModel.remainder=@"0";
        NSMutableArray * arr = [NSMutableArray new];
        USActivityLocalAlertInfo * alertModel=[[USActivityLocalAlertInfo alloc] init];
        alertModel.activityCode=activeId;
        alertModel.alertShowCount=@"1";
        alertModel.alertShowDate=currentDateStr;
        [arr addObject:alertModel];
        alertLocalModel.alertDataArr=[arr copy];
    }
    alertLocalModel.lastShowDate=currentDateStr;
    [self saveLocalActivityAlertData:alertLocalModel];
}

//当前时间是否在某个时间段内
- (BOOL)validateWithTime:(NSString *)timeStr {
    //必须配置有效起止时间
    NSArray *timeArr = [timeStr componentsSeparatedByString:@"#"];
    if (timeArr.count > 1 && ([NSString stringWithFormat:@"%@", timeArr[0]].length > 0 && [NSString stringWithFormat:@"%@", timeArr[1]].length > 0)) {
        NSString *startTime = timeArr[0];
        NSString *expireTime = timeArr[1];
        NSDate *today = [NSDate date];

        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

        NSDate *start = [dateFormat dateFromString:startTime];
        NSDate *expire = [dateFormat dateFromString:expireTime];

        if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (UleNetworkExcute *)apiClient{
    if (!_apiClient) {
        _apiClient = [US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _apiClient;
}

- (UleNetworkExcute *)networkClient_UstaticCDN{
    if (!_networkClient_UstaticCDN) {
        _networkClient_UstaticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_UstaticCDN;
}
@end
