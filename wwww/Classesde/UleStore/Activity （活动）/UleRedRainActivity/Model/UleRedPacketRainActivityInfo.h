//
//  UleRedPacketRainActivityInfo.h
//  UleApp
//
//  Created by zemengli on 2018/8/3.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedRainTheme : NSObject
@property (nonatomic, strong) NSString * theme;
/*1 分享
 2 支付
 3 满金额
 4 整点红包雨*/
@property (nonatomic, strong) NSString * type;//红包类型
@property (nonatomic, copy)   NSString * limit;//type=1的分享红包一天的请求次数
@property (nonatomic, strong) NSString * interval;//活动时间
@property (nonatomic, strong) NSString * shareText;//分享文案
@property (nonatomic, strong) NSString * failText;//抽奖失败之后的文案（随机取一个）
@property (nonatomic, strong) NSString * shareImage;//分享朋友圈的图片
@end

@interface RedRainThemes : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSMutableArray * themes;
@property (nonatomic, strong) NSString * flag;//是否在活动期间
@property (nonatomic, strong) NSString * image_url;//游戏入口图片
@property (nonatomic, strong) NSString * url;//游戏链接
//*****新的游戏图片和链接******
@property (nonatomic, strong) NSString * double_image_url;
@property (nonatomic, strong) NSString * double_url;
@end




@interface RedRainFieldInfo : NSObject
@property (nonatomic, strong) NSString * fieldId;
@property (nonatomic, strong) NSString * startTime;
@property (nonatomic, strong) NSString * endTime;
@end


@interface RedRainActivityInfoContent : NSObject
@property (nonatomic, strong) NSString * activityCode;
@property (nonatomic, strong) NSString * themeCode;
@property (nonatomic, strong) NSMutableArray * fieldInfos;
@end

@interface UleRedPacketRainActivityInfo : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * message;
@property (nonatomic, strong) NSMutableArray * content;
@property (nonatomic, strong) RedRainActivityInfoContent * tomorrowContent;//第二天活动场次

@property (nonatomic, strong) NSString * activityUrl;//活动期间跳转链接
@property (nonatomic, strong) NSString * defaultUrl;//活动未开始跳转链接

@end

