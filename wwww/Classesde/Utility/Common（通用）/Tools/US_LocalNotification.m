//
//  US_LocalNotification.m
//  u_store
//
//  Created by mac_chen on 2018/8/6.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_LocalNotification.h"

@interface US_LocalNotification ()

@property (nonatomic, assign) NSTimeInterval interval;

@end

@implementation US_LocalNotification

+(instancetype)sharedManager
{
    static US_LocalNotification *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager=[[US_LocalNotification alloc] init];
        });
    }
    return sharedManager;
}

#pragma mark - 本地推送
- (void)localNotificationRegist:(NSMutableArray *)timeArr titleStr:(NSString *)titleStr keyStr:(NSString *)keyStr interval:(NSTimeInterval)interval
{
    self.interval = interval;
    //每次创建本地通知时清除之前的本地通知
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (timeArr.count > 0) {
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        for (int i = 0; i < timeArr.count; i++) {
            [timeArr replaceObjectAtIndex:i withObject:[dateFormat dateFromString:timeArr[i]]];
        }
        
        for (int i = 0; i < timeArr.count; i++) {
            NSDate *fireDate = [self setDate:timeArr[i]];
            NSDate *nowDate = [NSDate date];
            if ([self compareDate:fireDate withAnotherDay:nowDate] == 1) {
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertBody = titleStr;
                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                localNotification.soundName=@"UleStoreApp.bundle/5103.wav";
                localNotification.fireDate = [self setDate:timeArr[i]];
                localNotification.alertAction = nil;
                localNotification.applicationIconBadgeNumber = 1;
                localNotification.soundName = UILocalNotificationDefaultSoundName;
                //发送通知内容及规则
                NSDictionary *apsDic = [[NSDictionary alloc] initWithObjectsAndKeys:titleStr,@"alert", nil];
                NSDictionary *notiKeyDic = [[NSDictionary alloc] initWithObjectsAndKeys:keyStr,@"notiKey", nil];
                NSDictionary *msgDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"REDPACKETRAIN",@"text", nil];
                NSDictionary * info = [[NSDictionary alloc] initWithObjectsAndKeys:notiKeyDic,@"localNotificationKey",apsDic,@"aps",msgDic,@"msg",nil];
                

                localNotification.userInfo = info;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            }
        }
    }
}

//移除本地推送
- (void)cancelRedPacketRainLocalNotification:(NSString *)notificationKeys{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // 获取所有本地通知数组
//    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
//
//    for (UILocalNotification *notification in localNotifications)
//    {
//        NSDictionary *userInfo = notification.userInfo;
//        if (userInfo)
//        {
//            // 根据设置通知参数时指定的key来获取通知参数
//            NSString *info = userInfo[@"localNotificationKey"];
//
//            // 如果找到需要取消的通知，则取消
//            if (info != nil && [info isEqualToString:notificationKeys])
//            {
//                [[UIApplication sharedApplication] cancelLocalNotification:notification];
//                break;
//            }
//        }
//    }
}

- (NSDate *)setDate:(NSDate *)localDate
{
    //取得系统时间
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:localDate];
//    NSInteger hour = [components hour];
//    NSInteger min = [components minute];
//    NSInteger sec = [components second];
//    NSInteger week = [components weekday];
    
    NSDate *date = [NSDate dateWithTimeInterval:-(self.interval) sinceDate:localDate];
//    NSDate *date = [NSDate dateWithTimeInterval:7 sinceDate:[NSDate date]];
    
//    NSLog(@"现在是%ld：%ld：%ld,周%ld", hour, min, sec, week);
    
    return date;
}

//时间对比
- (int)compareDate:(NSDate *)date1 withAnotherDay:(NSDate *)date2
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:date1];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:date2];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"date1比 date2时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"date1比 date2时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
    
}

@end
