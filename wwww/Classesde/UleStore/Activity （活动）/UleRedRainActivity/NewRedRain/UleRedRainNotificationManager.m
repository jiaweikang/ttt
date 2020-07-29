//
//  UleRedRainNotificationManager.m
//  UleStoreApp
//
//  Created by zemengli on 2019/8/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "UleRedRainNotificationManager.h"
#import "UleRedPacketRainActivityInfo.h"
#import "US_NetworkExcuteManager.h"
#import "UleRedPacketRainManager.h"
#import "US_RedPacketApi.h"
#import "UleRedPacketRainLocalManager.h"
#import "UleRedRainNotificationModel.h"
#import "UleGetTimeTool.h"
#import "NSString+FTDate.h"
#import <NSObject+YYModel.h>
#import "USAuthorizetionHelper.h"
#import "UleModulesDataToAction.h"

typedef void(^SetNotificationReslutBlock)(NSString * _Nullable result);

@interface UleRedRainNotificationManager ()
{
    
}
@property (nonatomic, strong) UleNetworkExcute * networkClient_CDN;
@property (nonatomic, strong) NSMutableArray * localNotificationlArray;
@property (nonatomic, strong) SetNotificationReslutBlock reslutBlock;
@end
@implementation UleRedRainNotificationManager
/** 单例 */
+ (instancetype)sharedManager {
    
    static UleRedRainNotificationManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[UleRedRainNotificationManager alloc] init];
        });
    }
    return sharedManager;
}
//处理活动场次数据
- (void)handleRedRainActivityData:(UleRedPacketRainActivityInfo *)activityInfo{
    if ([activityInfo.content count]<=0 && [activityInfo.tomorrowContent.fieldInfos count]<=0) {
        return;
    }
    
    UleRedRainNotificationModel * notificationModel = [self getRedRainNotificationModelData];
    if (!notificationModel || notificationModel.themeCode.length<=0) {
        return;
    }
    NSString * redPacketRain_theme=notificationModel.themeCode;
    
    [self.localNotificationlArray removeAllObjects];
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    //当天所有活动场次 根据themeCode匹配 然后装进数组
    for (RedRainActivityInfoContent * infoContent in activityInfo.content) {
        //找到主题对应的所有的活动
        if ([infoContent.themeCode isEqualToString:redPacketRain_theme]) {
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
                
                //只为创建本地推送用 不用排序
                NSTimeInterval  interval = (startTime-currentTime)/1000;
                if (interval>2*60) {
                    [self.localNotificationlArray addObject:redRainModel];
                }
            }
        }
    }
    
    //如果有第二天的活动场次 根据themeCode匹配 然后装进数组
    if (activityInfo.tomorrowContent && [activityInfo.tomorrowContent.fieldInfos count]>0) {
        //找到主题对应的所有的活动
        if ([activityInfo.tomorrowContent.themeCode isEqualToString:redPacketRain_theme]) {
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
                //只为创建本地推送用 不用排序
                NSTimeInterval  interval = (startTime-currentTime)/1000;
                if (interval>2*60) {
                    [self.localNotificationlArray addObject:redRainModel];
                }
            }
        }
    }
    if (self.localNotificationlArray.count >0) {
        [self handleLocalNotification];
    }
}
- (void)handleLocalNotification{
    //先取消推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UleRedRainNotificationModel * notificationModel = [self getRedRainNotificationModelData];
    
    //把当天场次和第二天场次  一起创建推送
    //每场活动的本地推送
    NSTimeInterval currentTime=[UleGetTimeTool getServerTime];
    NSMutableArray * notificationKeyArr=[NSMutableArray new];
    if ([self.localNotificationlArray count]>0) {
        for (int i=0; i<[self.localNotificationlArray count]; i++) {
            UleRedPacketRainModel * redRainModel = [self.localNotificationlArray objectAtIndex:i];
            // 找到即将开始场次 创建提前两分钟提醒
            NSTimeInterval  interval = (redRainModel.startTime-currentTime)/1000;
            [notificationKeyArr addObject:redRainModel.startDate];
            //NSLog(@"创建一个提醒 %@",redRainModel.startDate);
            [self setRedPacketRainLocalNotificationWithTitle:notificationModel.title content:notificationModel.content actionStr:notificationModel.ios_action interval:interval-2*60];//
        }
    }
}

- (void)setRedPacketRainLocalNotificationWithTitle:(NSString *)title content:(NSString *)content actionStr:(NSString *)actionStr interval:(NSTimeInterval)interval{
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    NSDate *now=[NSDate new];
    notification.fireDate=[now dateByAddingTimeInterval:interval];
    notification.timeZone=[NSTimeZone defaultTimeZone];
    notification.alertBody=content.length>0?content:@"";
    if ([[UIDevice currentDevice].systemVersion floatValue]>=8.2) {
        notification.alertTitle=title.length>0?title:@"";
    }
    notification.soundName=@"UleStoreApp.bundle/5103.wav";
    notification.applicationIconBadgeNumber += 1;//应用程序图标右上角显示的消息数
    NSDictionary * bodyDic=[[NSDictionary alloc] initWithObjectsAndKeys:content.length>0?content:@"",@"body",title.length>0?title:@"",@"title", nil];
    NSDictionary * titleDic=[[NSDictionary alloc] initWithObjectsAndKeys:bodyDic,@"alert", nil];
    NSDictionary * paramDic=[[NSDictionary alloc] initWithObjectsAndKeys:actionStr.length>0?actionStr:@"",@"text", nil];
    NSDictionary * info=[[NSDictionary alloc] initWithObjectsAndKeys:paramDic,@"msg",titleDic,@"aps",nil];
    notification.userInfo=info;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)cancelRedRainNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"RedRainNotificationModelData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//根据主题 获取活动场次信息
- (void)requestRedPacketRainInfo:(NSString *)themeCode{
    @weakify(self);
    NSString * redPacketRain_theme=@"";
    if (themeCode.length>0) {
        redPacketRain_theme=themeCode;
    }else{
        UleRedRainNotificationModel * notificationModel = [self getRedRainNotificationModelData];
        if (notificationModel.themeCode.length>0) {
            redPacketRain_theme=notificationModel.themeCode;
        }
    }
    if (redPacketRain_theme.length<=0) {
        return;
    }
    if (![USAuthorizetionHelper currentNotificationAllowed]) {
        return;
    }
    [self.networkClient_CDN beginRequest:[US_RedPacketApi buildNewRedPacketInfoRainWithTheme:redPacketRain_theme] success:^(id responseObject) {
        @strongify(self);
        UleRedPacketRainActivityInfo * activityInfo = [UleRedPacketRainActivityInfo yy_modelWithDictionary:responseObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleRedRainActivityData:activityInfo];
        });
        
    } failure:^(UleRequestError *error) {
        
    }];
}

- (BOOL)getRedRainNotificationIsOpen:(NSString *)themeCode{
    if (![USAuthorizetionHelper currentNotificationAllowed]) {
        return NO;
    }
    UleRedRainNotificationModel * notificationModel = [self getRedRainNotificationModelData];
    return [notificationModel.themeCode isEqualToString:themeCode];
}
- (UleRedRainNotificationModel *)getRedRainNotificationModelData{
    //读取本地存储的弹框数据
    NSData *myEncodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"RedRainNotificationModelData"];
    UleRedRainNotificationModel * notificationModel = [NSKeyedUnarchiver unarchiveObjectWithData:myEncodedObject];
    return notificationModel;
}

- (void)setRedRainNotification:(NSDictionary *)args result:(void (^)(NSString * _Nullable isHaveAuthority))completionHandler{
    self.reslutBlock = [completionHandler copy];
    if (![USAuthorizetionHelper currentNotificationAllowed]) {
        if (self.reslutBlock) {
            self.reslutBlock(@"false");
        }
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:@"开启消息通知，优惠权益再也不错过" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString]; dispatch_async(dispatch_get_main_queue(), ^{
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            });
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:sureAction];
        [alertControl addAction:cancelAction];
        [[UIViewController currentViewController] presentViewController:alertControl animated:YES completion:^{
        }];
        return;
    }
    if (self.reslutBlock) {
        self.reslutBlock(@"true");
    }
    NSString * minversion=args[@"minversion"];
    NSString * maxversion=args[@"maxversion"];
    BOOL isCanUse=YES;
    if (minversion.length>0&&maxversion.length>0) {
        isCanUse= [UleModulesDataToAction canInputDataMin:minversion withMax:maxversion withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
    }
    if (isCanUse) {
        NSString * title=args[@"title"];
        NSString * themeCode=args[@"themeCode"];
        NSString * content=args[@"content"];
        NSString * iosAction=args[@"ios_action"];
        
        [self saveRedRainNotificationDataWithTitle:title content:content actionStr:iosAction themeCode:themeCode];
    }
}

- (void)saveRedRainNotificationDataWithTitle:(NSString *)title content:(NSString *)content actionStr:(NSString *)actionStr themeCode:(NSString *)themeCode{
    UleRedRainNotificationModel * notificationModel=[UleRedRainNotificationModel new];
    notificationModel.title=title.length>0?title:@"";
    notificationModel.content=content.length>0?content:@"";
    notificationModel.ios_action=actionStr.length>0?actionStr:@"";
    notificationModel.themeCode=themeCode.length>0?themeCode:@"";
    [self saveRedRainNotificationModelData:notificationModel];
    
    [self requestRedPacketRainInfo:themeCode];
}
- (void)saveRedRainNotificationModelData:(UleRedRainNotificationModel *)notificationModel{
    NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:notificationModel];
    [[NSUserDefaults standardUserDefaults] setObject:archiveData forKey:@"RedRainNotificationModelData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -  <getter setter>
- (UleNetworkExcute *)networkClient_CDN{
    if (!_networkClient_CDN) {
        _networkClient_CDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_CDN;
}
- (NSMutableArray *)localNotificationlArray{
    if (_localNotificationlArray==nil) {
        _localNotificationlArray = [NSMutableArray new];
    }
    return _localNotificationlArray;
}
@end
