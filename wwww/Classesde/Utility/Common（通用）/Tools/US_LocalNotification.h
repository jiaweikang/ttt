//
//  US_LocalNotification.h
//  u_store
//
//  Created by mac_chen on 2018/8/6.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US_LocalNotification : NSObject

+ (instancetype)sharedManager;

/**
 *  本地推送
 */
- (void)localNotificationRegist:(NSMutableArray *)timeArr titleStr:(NSString *)titleStr keyStr:(NSString *)keyStr interval:(NSTimeInterval)interval;

/**
 *  根据key移除本地推送
 */
- (void)cancelRedPacketRainLocalNotification:(NSString *)notificationKeys;

@end
