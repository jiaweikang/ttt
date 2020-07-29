
//
//  MyStoreViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreViewModel.h"
#import "US_MystoreApi.h"
#import "US_UserCenterApi.h"
#import "US_HomeBtnData.h"
#import "UleModulesDataToAction.h"
#import "US_GetCommissionIndex.h"
#import "UserShareInfoModel.h"
#import "US_MystoreCellModel.h"
#import "US_NewsClass.h"
#import "FileController.h"
#import "US_ReferrerData.h"
#import "NSDate+USAddtion.h"
#import "UserDefaultManager.h"
#import "US_MyOrderApi.h"

//#define  kCellNameAndCellId @{@"1":@"MyStoreGroupOneCell",@"2":@"MyStoreGroupTwoCell",@"3":@"MyStoreGroupThreeCell",@"4":@"MyStoreGroupFourCell"}
#define  kCellNameAndCellId @{@"1":@"MyStoreGroupThreeCell",@"2":@"MyStoreGroupFiveCell",@"3":@"MyStoreGroupOneCell",@"4":@"MyStoreGroupSixCell",@"5":@"MyStoreGroupSevenCell",@"6":@"MyStoreGroupEightCell"}



static  NSString * const key_CommisionInfoSuccess =  @"getCommisionInfoSuccess";
static  NSString * const key_ShareInfoSuccess     =  @"getShareInfoSuccess";
static  NSString * const key_WithdrawCommisionSuccess  =@"getWithdrawCommisionSuccess";

@interface MyStoreViewModel ()

@property (nonatomic, strong) UleNetworkExcute * vpsClient;
@property (nonatomic, strong) UleNetworkExcute * uleClient;
@property (nonatomic, strong) UleNetworkExcute * cdnClient;
@property (nonatomic, strong) UleNetworkExcute * serviceClient;
@property (nonatomic, strong) UleNetworkExcute * networkClient_UstaticCDN;
@property (nonatomic, strong) MyStoreViewModelBlock newPushMesssageCallBack;
@property (nonatomic, strong) NSDictionary  *shareOrderNumDic;
@end

@implementation MyStoreViewModel
#pragma mark - <lifycyle>
- (void)dealloc{

}

#pragma mark - <network>
//获取收益信息
- (void)getCommisionInfo{
    if (![self isCanRequestForSuccessKey:key_CommisionInfoSuccess]) {
        //直接取本地数据
        self.commisionValue=[UserDefaultManager getLocalDataString:@"value_commision"];
        if (self.sucessBlock) {
            self.sucessBlock(self);
        }
        return;
    }
    @weakify(self);
    [self.vpsClient beginRequest:[US_MystoreApi buildGetCommisionRequest] success:^(id responseObject) {
        @strongify(self);
        US_GetCommissionIndex *commissionData=[US_GetCommissionIndex yy_modelWithDictionary:responseObject];
        self.commisionValue=commissionData.data.unIssueCms;
        //成功保存数据到本地
        [UserDefaultManager setLocalDataString: self.commisionValue key:@"value_commision"];
        if (self&&self.sucessBlock) {
            self.sucessBlock(self);
        }
        [NSDate saveDate:[NSDate date] Forkey:key_CommisionInfoSuccess];
    } failure:^(UleRequestError *error) {
    }];
    
}
//获取访客以及订单信息
- (void)getShareInfo{
    if (![self isCanRequestForSuccessKey:key_ShareInfoSuccess]) {
        self.visitorValue=[UserDefaultManager getLocalDataString:@"value_visitor"];
        self.orderValue=[UserDefaultManager getLocalDataString:@"value_order"];
        if (self.sucessBlock) {
            self.sucessBlock(self);
        }
        return;
    }
    //访客量
    @weakify(self);
    [self.uleClient beginRequest:[US_MystoreApi buildGetShareInfoVisitCountRequest] success:^(id responseObject) {
        @strongify(self);
        UserShareInfoModel *shareInfoModel=[UserShareInfoModel yy_modelWithDictionary:responseObject];
        self.visitorValue=shareInfoModel.data.today.shareUV;
        //成功保存数据到本地
        [UserDefaultManager setLocalDataString: self.visitorValue key:@"value_visitor"];
        if (self&&self.sucessBlock) {
            self.sucessBlock(self);
        }
        [NSDate saveDate:[NSDate date] Forkey:key_ShareInfoSuccess];
    } failure:^(UleRequestError *error) {
        
    }];
    //订单量
    [self.uleClient beginRequest:[US_MystoreApi buildGetShareInfoOrderCountRequest] success:^(id responseObject) {
        @strongify(self);
        UserShareInfoOrderModel *shareInfoOrderModel=[UserShareInfoOrderModel yy_modelWithDictionary:responseObject];
        NSString *orderCount=[NSString isNullToString:shareInfoOrderModel.data.orderCount];
        self.orderValue=orderCount;
        [UserDefaultManager setLocalDataString: self.orderValue key:@"value_order"];
        if (self&&self.sucessBlock) {
            self.sucessBlock(self);
        }
    } failure:^(UleRequestError *error) {
        
    }];
}
//获取未读消息
- (void)getNewPushMessageCountSuccess:(MyStoreViewModelBlock)success{
    self.newPushMesssageCallBack = [success copy];
    @weakify(self);
    [self.vpsClient beginRequest:[US_MystoreApi buildGetNewPushMessageNumRequest] success:^(id responseObject) {
        @strongify(self);
        NSDictionary * dic=(NSDictionary *)responseObject;
        NSString * data=dic[@"data"];
        if (data&&[data boolValue]) {
            if (self.newPushMesssageCallBack) {
                self.newPushMesssageCallBack(data);
            }
        }
    } failure:^(UleRequestError *error) {
    }];
}
//获取推荐位的banner ，按键等模块数据信息
- (void)getMiddleButtonsIsRequestNewData:(BOOL)isReq{
    if (isReq) {
        //再从网络请求数据
        @weakify(self);
        [self.networkClient_UstaticCDN beginRequest:[US_MystoreApi buildGetButtonListRequest] success:^(id responseObject) {
            @strongify(self);
            US_HomeBtnData *info = [US_HomeBtnData yy_modelWithDictionary:responseObject];
            NSMutableArray *mystoreArray = [NSMutableArray array];
            for (int i=0; i<info.indexInfo.count; i++) {
                HomeBtnItem * item=info.indexInfo[i];
                BOOL canInput=[UleModulesDataToAction canInputDataMin:item.minversion withMax:item.maxversion withDevice:item.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
                if (canInput) {
                    [mystoreArray addObject:item];
                }
            }
            //保存本地
            [NSKeyedArchiver archiveRootObject:mystoreArray toFile:[FileController fullpathOfFilename:kCacheFile_MyStore]];
            //处理数据
            [self handleMystoreGroupDatas:mystoreArray];
        } failure:^(UleRequestError *error) {
            @strongify(self);
            //取缓存数据
            NSArray *goodsSourceTabCacheArray=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_MyStore]]];
            if (goodsSourceTabCacheArray.count>0) {
                [self handleMystoreGroupDatas:goodsSourceTabCacheArray.mutableCopy];
            }
            if (self.failedBlock) {
                self.failedBlock(error);
            }
        }];
    }else {
        //取缓存数据刷新
        NSArray *goodsSourceTabCacheArray=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_MyStore]]];
        if (goodsSourceTabCacheArray.count>0) {
            [self handleMystoreGroupDatas:goodsSourceTabCacheArray.mutableCopy];
        }
    }
}
//
- (void)getNewsList{
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_mNewsList andParams:nil];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    @weakify(self);
    [self.uleClient beginRequest:request success:^(id responseObject) {
        @strongify(self);
        US_NewsClass * news=[US_NewsClass yy_modelWithDictionary:responseObject];
        US_MystoreCellModel * newsCellModel=[self findNewsCellModel];
        if (newsCellModel&&self.sucessBlock) {
            newsCellModel.extentInfo=news.list;
            self.sucessBlock(self);
        }
    } failure:^(UleRequestError *error) {

    }];
}
//获取可提现收益
- (void)getWithdrawCommision{
    if (![self isCanRequestForSuccessKey:key_WithdrawCommisionSuccess]) {
        self.withdrawCommison=[UserDefaultManager getLocalDataString:@"value_withdrawCommision"];
        if ([self.withdrawCommison hasPrefix:@"可提现余额:￥"]) {
            self.withdrawCommison=[self.withdrawCommison substringFromIndex:7];
        }
        if (self.sucessBlock) {
            self.sucessBlock(self);
        }
        return;
    }
    @weakify(self);
    [self.vpsClient beginRequest:[US_UserCenterApi buildGetIncomeRequestWithAccTypeId:@""] success:^(id responseObject) {
        @strongify(self);
        NSDictionary * dic = [responseObject objectForKey:@"data"];
        NSString * withdrawcommison = [dic objectForKey:@"balance"];
        CGFloat amount = withdrawcommison ? [withdrawcommison floatValue] : 0.00;
        self.withdrawCommison=[NSString stringWithFormat:@"%.2f",amount];
        //成功保存数据到本地
        [UserDefaultManager setLocalDataString:self.withdrawCommison key:@"value_withdrawCommision"];
        if (self.sucessBlock) {
            self.sucessBlock(self);
        }
        [NSDate saveDate:[NSDate date] Forkey:key_WithdrawCommisionSuccess];
    } failure:^(UleRequestError *error) {

    }];
}
//获取客户订单数量
- (void)getShareOrderCount{
    [self.uleClient beginRequest:[US_MyOrderApi buildOrderCountWithOrderFlag:@"3"] success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[NSDictionary dictionaryWithDictionary:[responseObject objectForKey:@"data"]];
            US_MystoreCellModel *cellModel=[self findShareOrderNumCell];
            cellModel.extentInfo=dic;
            cellModel.isNewData=YES;
            self.shareOrderNumDic=[NSDictionary dictionaryWithDictionary:dic];
            if (self.sucessBlock) {
                self.sucessBlock(self);
            }
        }
    } failure:^(UleRequestError *error) {
        
    }];
}


- (BOOL)isCanRequestForSuccessKey:(NSString *)successKey{
     //如果成功则五分钟内不能再次请求
    if ([NSDate getDateForkey:successKey]) {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:[NSDate getDateForkey:successKey]];
        if (timeInterval<5*60) {
            return NO ;
        }
    }
    return YES;
}

#pragma mark - <数据处理>
- (void)handleMystoreGroupDatas:(NSMutableArray *)dataArray{
//    UleSectionBaseModel * sectionModel=self.mDataArray.firstObject;
//    if (sectionModel==nil) {
//        sectionModel=[[UleSectionBaseModel alloc] init];
//        [self.mDataArray addObject:sectionModel];
//    }
//    [sectionModel.cellArray removeAllObjects];
    [self.mDataArray removeAllObjects];
    for (int i=0; i<dataArray.count; i++) {
        HomeBtnItem * item=dataArray[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:item.minversion withMax:item.maxversion withDevice:item.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        // 可以录入数据并过滤不需要显示的数据
        if (canInput&&[self filterHomeBtnItmeCanShowInfo:item]) {
            // 查找同groupsort 对象
            NSPredicate *tempDPredicate = [NSPredicate predicateWithFormat:@"groupsort == %@", item.groupsort];
            US_MystoreSectionModel *tempSectionModel=(US_MystoreSectionModel*)[[self.mDataArray filteredArrayUsingPredicate:tempDPredicate]firstObject];
            if (tempSectionModel) {
                US_MystoreCellModel *tempData = [tempSectionModel.cellArray firstObject];
                if ([item.groupid isEqualToString:@"6"]) {
                    US_MystoreCellModel *newCellModel = [[US_MystoreCellModel alloc] init];
                    newCellModel.isNewData=YES;
                    newCellModel.groupsort = [item.groupsort mutableCopy];
                    newCellModel.groupid = [item.groupid mutableCopy];
                    newCellModel.cellName =NonEmpty(kCellNameAndCellId[item.groupid]);
                    newCellModel.extentInfo=item;
                    [tempSectionModel.cellArray addObject:newCellModel];
                }else {
                    // 如果存在,读取后添加当前,重新保存
                    if (tempData) {
                        [tempData.indexInfo addObject:item];
                    }
                    // 如果不存在,新建后添加当前,保存
                    else {
                        tempData = [[US_MystoreCellModel alloc] init];
                        tempData.isNewData=YES;
                        tempData.indexInfo = [[NSMutableArray alloc] initWithCapacity:0];
                        tempData.groupsort = [item.groupsort mutableCopy];
                        tempData.groupid = [item.groupid mutableCopy];
                        tempData.cellName =NonEmpty(kCellNameAndCellId[item.groupid]);
                        if ([tempData.cellName isEqualToString:@"MyStoreGroupThreeCell"]) {
                            CGFloat whRate=[item.wh_rate floatValue]>0?[item.wh_rate floatValue]:2.14;
                            tempData.height=__MainScreen_Width/whRate;
                        }else if ([tempData.cellName isEqualToString:@"MyStoreGroupFiveCell"]) {
                            tempData.extentInfo=self.shareOrderNumDic;
                        }
                        [tempData.indexInfo addObject:item];
                        if (tempData.cellName.length>0) {
                            [tempSectionModel.cellArray addObject:tempData];
                        }
                    }
                }
                //添加header
                if ([NSString isNullToString:item.ios_action].length==0) {
                    tempSectionModel.headViewName=@"MyStoreSectionHeaderView";
                    tempSectionModel.headHeight=KScreenScale(80);
                    tempSectionModel.headData=item;
                    tempSectionModel.footViewName=@"MyStoreSectionFooterView";
                    tempSectionModel.footHeight=KScreenScale(20);
                }
            }else {
                tempSectionModel=[[US_MystoreSectionModel alloc]init];
                tempSectionModel.groupsort=[item.groupsort mutableCopy];
                tempSectionModel.groupid=[item.groupid mutableCopy];
                if ([NSString isNullToString:item.ios_action].length!=0) {
                    US_MystoreCellModel *newCellModel = [[US_MystoreCellModel alloc] init];
                    newCellModel.isNewData=YES;
                    newCellModel.indexInfo = [[NSMutableArray alloc] initWithCapacity:0];
                    newCellModel.groupsort = [item.groupsort mutableCopy];
                    newCellModel.groupid = [item.groupid mutableCopy];
                    newCellModel.cellName =NonEmpty(kCellNameAndCellId[item.groupid]);
                    if ([newCellModel.cellName isEqualToString:@"MyStoreGroupEightCell"]) {
                        newCellModel.extentInfo=item;
                    }else {
                        if ([newCellModel.cellName isEqualToString:@"MyStoreGroupThreeCell"]) {
                            CGFloat whRate=[item.wh_rate floatValue]>0?[item.wh_rate floatValue]:2.14;
                            newCellModel.height=(__MainScreen_Width-KScreenScale(40))/whRate;
                        }else if ([newCellModel.cellName isEqualToString:@"MyStoreGroupFiveCell"]) {
                            newCellModel.extentInfo=self.shareOrderNumDic;
                        }
                        [newCellModel.indexInfo addObject:item];
                    }
                    if (newCellModel.cellName.length>0) {
                        [tempSectionModel.cellArray addObject:newCellModel];
                    }
                }else {
                    //添加header
                    if ([item.groupid isEqualToString:@"6"]) {
                        tempSectionModel.headBackColor=[UIColor clearColor];
                    }
                    tempSectionModel.headViewName=@"MyStoreSectionHeaderView";
                    tempSectionModel.headHeight=KScreenScale(80);
                    tempSectionModel.headData=item;
                    tempSectionModel.footViewName=@"MyStoreSectionFooterView";
                    tempSectionModel.footHeight=KScreenScale(20);
                }
                [self.mDataArray addObject:tempSectionModel];
            }
        }
    }
    //根据groupsort排序
    [self.mDataArray sortUsingComparator:^NSComparisonResult(US_MystoreCellModel *  _Nonnull obj1, US_MystoreCellModel *  _Nonnull obj2) {
        NSInteger v1 = [obj1.groupsort integerValue];
        NSInteger v2 = [obj2.groupsort integerValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self findNewsCellModel]) {
            [self getNewsList];
        }
        if ([self findShareOrderNumCell]) {
            [self getShareOrderCount];
        }
        if (self.sucessBlock) {
            self.sucessBlock(self);
        }
    });
}

- (US_MystoreCellModel *)findNewsCellModel{
    US_MystoreCellModel * cellModel=nil;
    for (int i=0; i<self.mDataArray.count; i++) {
        US_MystoreSectionModel *sectionModel=(US_MystoreSectionModel*)self.mDataArray[i];
        for (int j=0; j<sectionModel.cellArray.count; j++) {
            US_MystoreCellModel * temp=sectionModel.cellArray[j];
            if ([temp.cellName isEqualToString:@"MyStoreGroupFourCell"]) {
                cellModel=temp;
            }
        }
    }
    return cellModel;
}
- (US_MystoreCellModel *)findShareOrderNumCell{
    US_MystoreCellModel * cellModel=nil;
    for (int i=0; i<self.mDataArray.count; i++) {
        US_MystoreSectionModel *sectionModel=(US_MystoreSectionModel*)self.mDataArray[i];
        for (int j=0; j<sectionModel.cellArray.count; j++) {
            US_MystoreCellModel * temp=sectionModel.cellArray[j];
            if ([temp.cellName isEqualToString:@"MyStoreGroupFiveCell"]) {
                cellModel=temp;
            }
        }
    }
    return cellModel;
}

- (BOOL)filterHomeBtnItmeCanShowInfo:(HomeBtnItem *)item{
    //取本地保存的对应账号的掌柜类型
    NSString *authorization = [US_UserUtility sharedLogin].m_websiteType;
    if (authorization&&authorization.length>0&&item.authorization&&item.authorization.length>0){ //websiteType为空则显示全部模块
        NSArray * authorizationArr = [item.authorization componentsSeparatedByString:@","];
        BOOL isContain = [authorizationArr containsObject:authorization];
        if (!isContain) {
            return NO;
        }
    }
    if (([item.ios_action rangeOfString:@"carIns"].location != NSNotFound || [item.title isEqualToString:@"车险"]) && [US_UserUtility sharedLogin].m_carInsurance.integerValue == 0){
        return NO;
    }
    //控制我的钱包 金豆红包的显示
    if ([item.log_title isEqualToString:@"GOLDBEAN"] || [item.ios_action rangeOfString:@"金豆红包"].location!=NSNotFound) {
//        [US_UserUtility sharedLogin].isShowGoldBean=YES;
//        [US_UserUtility sharedLogin].goldBeanAction=item.ios_action;
        return NO;
    }
    if (item.showProvince&&item.showProvince.length>0&&[US_UserUtility sharedLogin].m_provinceCode.length>0) {
        if ([[US_UserUtility sharedLogin].m_orgType intValue]==1000) {
            //帅康用户
            if ([item.showProvince rangeOfString:[US_UserUtility sharedLogin].m_provinceCode].location==NSNotFound) {
                return NO;
            }
        }else{
            /*根据推荐人过滤逻辑注释掉2020-4-2 沈翔东口述*/
            //如果用户是邮乐用户，则根据推荐人的省份信息过滤
//            if ([[US_UserUtility sharedLogin].m_provinceCode isEqualToString:@"58093"]) {
//                if ([NSString isNullToString:[US_UserUtility sharedLogin].m_userReferrerId].length > 0) {
//                    if ([item.showProvince rangeOfString:[US_UserUtility sharedLogin].m_userReferrerId].location==NSNotFound) {
//                        return NO;
//                    }
//                }
//                else{
//                    if([item.showProvince rangeOfString:[US_UserUtility sharedLogin].m_provinceCode].location==NSNotFound)
//                        return NO;
//                }
//            }
//            else{
                if([item.showProvince rangeOfString:[US_UserUtility sharedLogin].m_provinceCode].location==NSNotFound)
                    return NO;
//            }
        }
    }
    //创业简报样式
    if ([item.log_title isEqualToString:@"ylxdapp_my_banner1"]) {
        self.headBackImageUrl=item.link;
        self.headBackgroudColor=item.titlecolor;
    }
    //取出赚钱攻略的ios_action
    if ([item.functionId isEqualToString:@"StoreClass"]) {
        self.promote_iosAction=item.ios_action;
        self.strategyImageUrl=item.link;
    }
    
    if ([item.functionId isEqualToString:@"MyStore"]) {
        NSString *storeAction = [NSString isNullToString:item.ios_action];
        if (storeAction.length==0) {
            storeAction=[NSString stringWithFormat:@"WebDetailViewController::0&&key::%@/mxiaodian/store/index.html?flag=preview&needShare=true##title::浏览小店##hasnavi::1",[UleStoreGlobal shareInstance].config.mUleDomain];
        }
        [US_UserUtility sharedLogin].myStoreLink=storeAction;
    }
    return YES;
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)vpsClient{
    if (!_vpsClient) {
        _vpsClient=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _vpsClient;
}
- (UleNetworkExcute *)cdnClient{
    if (!_cdnClient) {
        _cdnClient=[US_NetworkExcuteManager uleCDNRequestClient];
    }
    return _cdnClient;
}
- (UleNetworkExcute *)uleClient{
    if (!_uleClient) {
        _uleClient=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _uleClient;
}
- (UleNetworkExcute *)serviceClient{
    if (!_serviceClient) {
        _serviceClient=[US_NetworkExcuteManager uleServerRequestClient];
    }
    return _serviceClient;
}
- (UleNetworkExcute *)networkClient_UstaticCDN{
    if (!_networkClient_UstaticCDN) {
        _networkClient_UstaticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_UstaticCDN;
}

@end
