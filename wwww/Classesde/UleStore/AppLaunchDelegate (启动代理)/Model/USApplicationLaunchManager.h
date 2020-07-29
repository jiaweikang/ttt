//
//  USApplicationLaunchManager.h
//  u_store
//
//  Created by xstones on 2018/4/16.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "USAuthorizetionHelper.h"
#import "UleModulesDataToAction.h"

typedef void(^USApiRequestSuccessBlock)(UIView *view);
typedef void(^USApiRequestFailBlock)(void);

@interface USApplicationLaunchManager : NSObject
@property (nonatomic, assign) BOOL isGuideViewShowed;//广告页是否展示
@property (nonatomic, strong) UleUCiOSAction    *iosGuideAction;//点击广告页跳转
@property (nonatomic, copy) NSString    *firstTabVCName;
//我的模块更新标记
@property (nonatomic, strong) NSString *poststore_my_update;
+ (instancetype)sharedManager;

/**
 *  展示广告页
 */
- (void)showGuideView;

/**
 *  应用启动
 */
- (void)applicationDidFinishLaunch;

/**
 *  DidBecomeActive
 */
- (void)applicationDidBecomeActive;

/**
 *  后台进入前台
 */
-(void)applicationWillEnterForeground;

/**
 *  广告页消失
 */
- (void)applicationGuideViewDidDisappear;

/**
 *  登录进入首页
 */
- (void)applicationEnterMainPageFromLogin;

/**
 *  注册进入首页
 */
- (void)applicationEnterMainPageFromRegist;

/**
 *  获取下拉刷新动图
 */
- (void)startRequestDropDownGifViewInfor;

/**
 * 注册通知
 */
- (void)startRequestPushRegist;

/**
 * 提示开启推送弹框
 */
- (void)showApplicationNotificationAlerView;

/**
 * 版本更新
 */
- (void)startReuestVersionUpdateInfoCompleteWithSuccess:(USApiRequestSuccessBlock)sucBlock failure:(USApiRequestFailBlock)failBlock;


/// 请求用户信息
/// @param requestInGourp 是否是启动时的group请求
/// @param selectedAtLast 是否选中到最后一个tab
- (void)startRequestUserInfoInGroup:(BOOL)requestInGourp isSelectedAtLast:(BOOL)selectedAtLast;

/**
 *设置userAgent
 */
- (void)registWebviewAgent;
/**
 *初始化并开启记录日志
 */
- (void)startRecordLogAndBugly:(BOOL) bugly;


/**
 网络监控
 */
+ (void)controlNetWork;
@end
