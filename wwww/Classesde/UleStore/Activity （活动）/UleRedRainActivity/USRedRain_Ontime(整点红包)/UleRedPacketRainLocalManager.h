//
//  UleRedPacketRainManager.h
//  UleApp
//
//  Created by zemengli on 2018/7/24.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleRedPacketRainManager.h"
#import "UleRedPacketRainActivityInfo.h"


/*1 分享
 2 支付
 3 满金额
 4 整点红包雨*/
#define UleRedPacketTypeCash    @"1"//现金红包活动场景
#define UleRedPacketTypeRain    @"4"//整点红包雨活动场景

//红包雨通知
#define UleRedPacketNotiKeys                @"notificationKeys"

//红包雨分享
#define kRedRainShareUrl        @"/event/activity/20180919/guidDownload/index.html"
#define kRedRainShareTitle      @"邮乐爽11购物节，狂欢再起！"
#define kRedRainShareContent    @"邮乐爽十一，全民抢红包。精选好物低至11元，爱拼爱秒上邮乐。"
#define kRedRainShareImageUrl   @"https://pic.ule.com/item/user_0102/desc20180829/389a96574fdba596_-1x-1.png"
#define kRedRainMainExpoUrl     @"https://www.ule.com/event/2018/0511/nianh/index.html"

typedef void(^UleRedpacketPermissionBlock)(BOOL activityFlag);
typedef void(^UleRedRainActivityEnterGameBlock)(NSString  * activityiOSURL);

@interface UleRedPacketRainLocalManager : NSObject
@property (nonatomic, strong) NSString * gifUrl;
@property (nonatomic, strong) NSString * headbackimageUrl;

@property (nonatomic, assign) BOOL isRedRainActivity;//当前在红包雨活动期间
@property (nonatomic, assign) BOOL isShowingActivityView;//当前显示的有活动弹框
@property (nonatomic, assign) BOOL isPullDownRefresh;//是否是下拉刷新 手动下拉刷新 每次都显示场次倒计时或者开抢
@property (nonatomic, strong) UleRedPacketRainModel *cashRedFieldInfo;//现金红包的场次信息
@property (nonatomic, copy) UleRedpacketPermissionBlock permissionBlock;//活动状态改变
//@property (nonatomic, strong) UleRedRainActivityEnterGameBlock redRainEnterGameBlock;

@property (nonatomic, strong) NSString * enterGameImageUrl;//游戏入口图片URL
@property (nonatomic, strong) NSString * enterGameiOSURL;//游戏入口点击跳转

@property (nonatomic, strong) RedRainTheme * mRedRainThemeModel_4;//type 4 整点红包雨的数据模型
@property (nonatomic, strong) RedRainTheme * mRedRainThemeModel_1;//type 1 现金红包的数据模型

@property (nonatomic, strong) UleRedPacketRainModel * redRainModel;
/** 单例 */
+ (instancetype)sharedManager;

//- (void)handleHomeHeaderRefreshActivityInfo:(NSDictionary *)data;
//
//- (NSMutableArray *)getHeaderRefreshPics;

//进入游戏
- (void)enterGameAction;

//获取活动主题信息
- (void)requestRedPacketRainTheme;
//获取活动场次信息
//- (void)requestRedPacketRainInfo;
//关闭定时器
- (void)countDownStop;

@end

