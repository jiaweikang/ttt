//
//  UleNewRedPacketRainManager.m
//  UleApp
//
//  Created by zemengli on 2019/7/11.
//  Copyright © 2019 ule. All rights reserved.
//

#import "UleNewRedPacketRainManager.h"
#import "UleRedPacketRainActivityInfo.h"
#import "US_NetworkExcuteManager.h"
#import "UleRedPacketRainManager.h"
#import "US_RedPacketApi.h"
#import "UleRedPacketRainLocalManager.h"

#import "UleGetTimeTool.h"
#import "NSString+FTDate.h"
#import <NSObject+YYModel.h>


@interface UleNewRedPacketRainManager ()
{
    
}
@property (nonatomic, strong) UleNetworkExcute * networkClient_CDN;
@property (nonatomic, copy)   NSString     * mRedPacketRain_theme;
@property (nonatomic, copy)   NSString     * mRedPacketRainInfoURL;

@property (nonatomic, strong) NSMutableArray * fieldModelArray;

@property (nonatomic, strong) RedRainTheme * mRedRainTheme;

@property (nonatomic, strong) UleRedPacketRainModel * redRainModel;
@end

@implementation UleNewRedPacketRainManager
/** 单例 */
+ (instancetype)sharedManager {
    
    static UleNewRedPacketRainManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[UleNewRedPacketRainManager alloc] init];
        });
    }
    return sharedManager;
}

//处理活动场次数据
- (void)handleRedRainActivityData:(UleRedPacketRainActivityInfo *)activityInfo{
    if ([activityInfo.content count]<=0) {
        return;
    }
    [self.fieldModelArray removeAllObjects];
    //当天所有活动场次 根据themeCode匹配 然后装进数组
    for (RedRainActivityInfoContent * infoContent in activityInfo.content) {
        //找到主题对应的所有的活动
        if ([infoContent.themeCode isEqualToString:self.mRedPacketRain_theme]) {
            for (int i=0; i<[infoContent.fieldInfos count]; i++) {
                RedRainFieldInfo * fieldInfo=[infoContent.fieldInfos objectAtIndex:i];
                NSDate * startDate = [fieldInfo.startTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * endDate = [fieldInfo.endTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval startTime=[startDate timeIntervalSince1970]*1000;
                NSTimeInterval endTime=[endDate timeIntervalSince1970]*1000;
                UleRedPacketRainModel * redRainModel=[[UleRedPacketRainModel alloc]init];
                redRainModel.startTime=startTime;
                redRainModel.endTime=endTime;
                redRainModel.startDate=fieldInfo.startTime;
                redRainModel.endDate=fieldInfo.endTime;
                redRainModel.activityCode=infoContent.activityCode;
                redRainModel.fieldId=fieldInfo.fieldId;
                [self.fieldModelArray addObject:redRainModel];
            }
        }
    }
    
    //如果有第二天的活动场次 根据themeCode匹配 然后装进数组
    if (activityInfo.tomorrowContent && [activityInfo.tomorrowContent.fieldInfos count]>0) {
        //找到主题对应的所有的活动
        if ([activityInfo.tomorrowContent.themeCode isEqualToString:self.mRedPacketRain_theme]) {
            for (int i=0; i<[activityInfo.tomorrowContent.fieldInfos count]; i++) {
                RedRainFieldInfo * fieldInfo=[activityInfo.tomorrowContent.fieldInfos objectAtIndex:i];
                NSDate * startDate = [fieldInfo.startTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate * endDate = [fieldInfo.endTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSTimeInterval startTime=[startDate timeIntervalSince1970]*1000;
                NSTimeInterval endTime=[endDate timeIntervalSince1970]*1000;
                UleRedPacketRainModel * redRainModel=[[UleRedPacketRainModel alloc]init];
                redRainModel.startTime=startTime;
                redRainModel.endTime=endTime;
                redRainModel.startDate=fieldInfo.startTime;
                redRainModel.endDate=fieldInfo.endTime;
                redRainModel.activityCode=activityInfo.tomorrowContent.activityCode.length>0?activityInfo.tomorrowContent.activityCode:@"";
                if (fieldInfo.fieldId) {
                    redRainModel.fieldId=[NSString stringWithFormat:@"%ld",(long)fieldInfo.fieldId];
                }
                [self.fieldModelArray addObject:redRainModel];
            }
        }
    }
    
    //根据活动开始时间排序 按开始时间升序排序
    if ([self.fieldModelArray count]>1) {
        // 排序key, 某个对象的属性名称，是否升序, YES-升序, NO-降序
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
        NSArray * array = [[self.fieldModelArray copy] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        self.fieldModelArray = [array mutableCopy];
    }
    
    [self goToActivityViewWithUrl:activityInfo.activityUrl DefaultUrl:activityInfo.defaultUrl];
}

//判断需要跳转的活动页
- (void)goToActivityViewWithUrl:(NSString *)activityUrl DefaultUrl:(NSString *)defaultUrl{
    NSString * webUrl=@"";
    //找到了正在进行的活动 就跳红包雨活动页
    if ([self findStartActivity]) {
        NSLog(@"有正在进行活动");
        if (activityUrl.length ==0) {
            return;
        }
        webUrl=[NSString stringWithFormat:@"%@?codeid=%@",activityUrl,self.redRainModel.activityCode];
    }
    //没有找到当前场次 跳转默认活动页
    else{
        NSLog(@"活动未开始");
        if (defaultUrl.length ==0) {
            return;
        }
        webUrl=defaultUrl;
    }
    
    NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
    [dic setObject:webUrl forKey:@"key"];
    [dic setObject:@YES forKey:@"slidePopDisabled"];//禁止滑动返回
    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
    
}

//找到是否有已开始活动
- (BOOL)findStartActivity{
    if ([self.fieldModelArray count]>0) {
        NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
        for (int i=0; i<[self.fieldModelArray count]; i++) {
            UleRedPacketRainModel * redRainModel = [self.fieldModelArray objectAtIndex:i];
            //找出当前在哪一个活动中
            if (currentTime>redRainModel.startTime && currentTime<redRainModel.endTime) {
                //NSLog(@"______找到当前已经开始场次");
                self.redRainModel=redRainModel;
                return YES;
            }
        }
    }
    return NO;
}


#pragma mark - request
//获取活动主题信息
- (void)requestRedPacketRainTheme{
    
    @weakify(self);
    [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketTheme] success:^(id responseObject) {
        @strongify(self);
        RedRainThemes * themeData = [RedRainThemes yy_modelWithDictionary:responseObject];
        //活动开启期间才请求活动场次数据
        if ([themeData.flag boolValue]) {
            for (RedRainTheme * themeObj in themeData.themes) {
                //根据活动场景类型找到对应的活动主题
                if([themeObj.type isEqualToString:UleRedPacketTypeRain]){
                    self.mRedPacketRain_theme=themeObj.theme;
                    self.mRedRainTheme=themeObj;
                    break;
                }
            }
            if (self.mRedPacketRain_theme.length>0) {
                //有活动主题 视为活动开启 显示首页下拉背景图
                self.isActivating=YES;
                //下拉刷新才需要请求场次
                if (self.isPullDownRefresh) {
                    [self requestRedPacketRainInfo];
                }
                else{
                    if (self.requestThemeFinishBlock) {
                        self.requestThemeFinishBlock();
                    }
                }
            }
        }
        else
        {
            if (self.requestThemeFinishBlock&&!self.isPullDownRefresh) {
                self.requestThemeFinishBlock();
            }
        }
    } failure:^(UleRequestError *error) {
        if (!self.isPullDownRefresh) {
            if (self.requestThemeFinishBlock) {
                self.requestThemeFinishBlock();
            }
        }
    }];
}
//根据主题 获取活动场次信息
- (void)requestRedPacketRainInfo{
    @weakify(self);
    [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketInfoRainWithTheme:self.mRedPacketRain_theme] success:^(id responseObject) {
        @strongify(self);
        UleRedPacketRainActivityInfo * activityInfo = [UleRedPacketRainActivityInfo yy_modelWithDictionary:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([activityInfo.content count]<=0) {
                //当天没有活动场次 直接跳默认会场
                [self goToActivityViewWithUrl:activityInfo.activityUrl DefaultUrl:activityInfo.defaultUrl];
            }else{
                [self handleRedRainActivityData:activityInfo];
            }
        });
        
    } failure:^(UleRequestError *error) {
        
    }];
}

#pragma mark -  <getter setter>
- (UleNetworkExcute *)networkClient_CDN{
    if (!_networkClient_CDN) {
        _networkClient_CDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_CDN;
}


- (UleRedPacketRainModel *)redRainModel{
    if (_redRainModel==nil) {
        _redRainModel=[[UleRedPacketRainModel alloc]init];
    }
    return _redRainModel;
}

//当天活动场次
- (NSMutableArray *)fieldModelArray{
    if (_fieldModelArray==nil) {
        _fieldModelArray = [NSMutableArray new];
    }
    return _fieldModelArray;
}
@end


