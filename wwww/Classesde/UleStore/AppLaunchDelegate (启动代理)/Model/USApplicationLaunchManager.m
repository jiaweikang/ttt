//
//  USApplicationLaunchManager.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USApplicationLaunchManager.h"
#import <UserNotifications/UserNotifications.h>
#import "Ule_LockVC.h"
#import "US_NetworkExcuteManager.h"
#import "USApplicationLaunchApi.h"
#import "CalcKeyIvHelper.h"
#import <Ule_SecurityKit.h>
#import "NSData+Base64.h"
#import "LoginSuccessModel.h"
#import "USGuideViewController.h"
#import "US_LoginManager.h"
#import "US_ReferrerData.h"
#import "FeatureModel_TabBarInfor.h"
#import "USImageDownloadManager.h"
#import <FileController.h>
#import <Bugly/Bugly.h>
#import <UMCommon/UMConfigure.h>
#import "NSDate+USAddtion.h"
#import "US_GoodsSourceApi.h"
#import "FeatureModel_GIFRefresh.h"
#import "UserDefaultManager.h"
#import "US_NotificationAlertView.h"
#import "UleRedPacketRainLocalManager.h"
#import "FeatureModel_VersionUpdate.h"
#import "USScreenshotHelper.h"
#import "USCookieHelper.h"
#import "NSString+FTDate.h"
#import "UleKoulingDetectManager.h"
#import "UleGetTimeTool.h"
#import "FeatureModel_ActivityDialog.h"
#import "USCustomAlertViewManager.h"
#import "UIView+ShowAnimation.h"
#import "UlePushHelper.h"
#import "USUniversalAlertView.h"
#import "US_UpdateAlertView.h"
#import "US_EnterpriseApi.h"
#import "US_EnterpriseDataModel.h"
#import "US_EnterpriseWholeSaleModel.h"
#import "LogStatisticsManager.h"
typedef void(^lockViewDiddisAppear)(void);

@class Ule_LockVC;
@interface USApplicationLaunchManager ()
@property (strong, nonatomic) Ule_LockVC *m_lock;
@property (nonatomic, strong) UleNetworkExcute  *apiClient;
@property (nonatomic, strong) UleNetworkExcute  *cdnClient;
@property (nonatomic, strong) UleNetworkExcute  *trackClient;
@property (nonatomic, strong) UleNetworkExcute  *vpsClient;
@property (nonatomic, strong) UleNetworkExcute  *networkClient_UstaticCDN;
// guide view
@property (nonatomic, strong) USGuideViewController *mGuideVC;

@property (nonatomic, assign) BOOL  mBecomeActiveWithoutLaunch;//后台进入前台的becomeActive

@end

@implementation USApplicationLaunchManager

+ (instancetype)sharedManager{
    static USApplicationLaunchManager *sharedManager=nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager=[[USApplicationLaunchManager alloc]init];
        });
    }
    return sharedManager;
}

- (void)dealloc{

}

#pragma mark - <USApplicationLaunch>
- (void)applicationDidFinishLaunch{
    //tabbar推荐位
    [self startRequestTabbar];
    //下拉刷新动图（所有页面）
    [self startRequestDropDownGifViewInfor];
    //请求服务器时间
    if (![US_UserUtility isTodaySavedForKey:kUserDefault_serverTimeRequestDate]) {
        [self startRequestServerTime];
    }
    if ([US_UserUtility sharedLogin].mIsLogin) {
        [self startRequestEnterpriseRecommendSelectedAtLast:NO];
    }
}

- (void)applicationDidBecomeActive{
    if (self.mBecomeActiveWithoutLaunch&&[US_UserUtility sharedLogin].mIsLogin) {
        [self launchWithJumpInfo];
    }
}

-(void)applicationWillEnterForeground{
    //显示手势锁
    [[USApplicationLaunchManager sharedManager] showLockViewController:^{
        [[USCustomAlertViewManager sharedManager] startRequestAlertViewWillEnterForeground];
    }];
    self.mBecomeActiveWithoutLaunch = YES;
}

- (void)applicationGuideViewDidDisappear{
    if ([US_UserUtility sharedLogin].mIsLogin) {
        //监听截屏事件
        if (kSystemVersion < 11.0) {
            [[USScreenshotHelper shared] startMonitoring];
        }
        //用户信息
//        [self startRequestUserInfo];
        //推荐人信息
        [self startRequestReferrerInfo];
        //请求mall_cookie
        if ([[NSString dateWithStartDay:[US_UserUtility sharedLogin].userMallCookieRequestedDate endDay:[NSDate date]] intValue] > 7) {
            [[USCookieHelper sharedHelper] requestMall_cookieComplete:nil];
        }
        //显示手势锁
        [[USApplicationLaunchManager sharedManager] showLockViewController:^{
            [[USCustomAlertViewManager sharedManager] startRequestAppicationAlertView];
        }];
    }
}

- (void)applicationEnterMainPageFromLogin{
    [self launchWithJumpInfo];
    //请求mall_cookie
    [[USCookieHelper sharedHelper] requestMall_cookieComplete:nil];
    //请求所有弹框
    [[USCustomAlertViewManager sharedManager] startRequestAppicationAlertView];
    //查询企业商品数量用于动态移出企业模块
    [self startRequestEnterpriseRecommendSelectedAtLast:NO];
}

- (void)applicationEnterMainPageFromRegist{
    //请求mall_cookie
    [[USCookieHelper sharedHelper] requestMall_cookieComplete:nil];
    //红包雨
    [[USCustomAlertViewManager sharedManager] startRequestAppicationAlertView];
    //查询企业商品数量用于动态移出企业模块
    [self startRequestEnterpriseRecommendSelectedAtLast:NO];
}

#pragma mark - 获取当前viewController
/** appdelegate */
- (id<UIApplicationDelegate>)applicationDelegate {
    return [UIApplication sharedApplication].delegate;
}

#pragma mark -弹出手势解锁
- (void)showLockViewController:(lockViewDiddisAppear) disappearBlock{
    //处理手势之前先取消弹框自动显示，否则会导致后台回前台时弹框提前弹出来
    [CustomAlertViewManager sharedManager].isCancelShowAutomic=YES;
    // 保存了手势密码 且已开启
    NSString *pswd = [Ule_LockPasswordFile readLockPassword];
    NSString *status = [Ule_LockPasswordFile readLockStatus];
    if (pswd && status && [status isEqualToString:@"1"]) {
        // 未初始化 或者未添加至window
        if(!_m_lock || self.m_lock.lockIsShow == NO){
            [_m_lock.view removeFromSuperview];
            _m_lock = nil;
            self.m_lock = [[Ule_LockVC alloc] initWithType:UleLockVCTypeCheck];
            [self.applicationDelegate.window addSubview:self.m_lock.view];
            self.m_lock.lockIsShow = YES;
            self.m_lock.didRemovedBlock =disappearBlock;
        }
    }else{
        if (disappearBlock) {
            disappearBlock();
        }
    }
}

#pragma mark - <展示广告页>
- (void)showGuideView
{
    self.mGuideVC = [[USGuideViewController alloc]init];
    self.mGuideVC.statusBarHidden=YES;
    // 添加
    UIViewController *tRootViewController = self.applicationDelegate.window.rootViewController;
    UIViewController *parentVC = nil;
    if ([tRootViewController isKindOfClass:[UITabBarController class]]) {
        parentVC = tRootViewController;
    }else if ([tRootViewController isKindOfClass:[UINavigationController class]]) {
        parentVC = [UIViewController currentViewController];
    }
    if (parentVC) {
        self.isGuideViewShowed=YES;
        [parentVC.view addSubview:self.mGuideVC.view];
        [parentVC addChildViewController:self.mGuideVC];
        if ([parentVC isKindOfClass:[UITabBarController class]]) {
            [self.mGuideVC beginAppearanceTransition:YES animated:YES];
        }
        [parentVC.view addSubview:self.mGuideVC.view];
        if ([parentVC isKindOfClass:[UITabBarController class]]) {
            [self.mGuideVC endAppearanceTransition];
        }
        [self.mGuideVC didMoveToParentViewController:parentVC];
    }
    
    // 回调
    @weakify(self);
    self.mGuideVC.mDismissComplete = ^(UleUCiOSAction *tModuleAction) {
        @strongify(self);
        [self dismissGuideView:tModuleAction];
    };
}

/** 移除引导页 */
- (void)dismissGuideView:(UleUCiOSAction *)tModuleAction {
    self.mGuideVC.statusBarHidden=NO;
    [self.mGuideVC setNeedsStatusBarAppearanceUpdate];
    
    UIViewController *parentVC = self.mGuideVC.parentViewController;
    [self.mGuideVC willMoveToParentViewController:nil];
    if ([parentVC isKindOfClass:[UITabBarController class]]) {
        [self.mGuideVC beginAppearanceTransition:NO animated:YES];
    }
    [self.mGuideVC.view removeFromSuperview];
    if ([parentVC isKindOfClass:[UITabBarController class]]) {
        [self.mGuideVC endAppearanceTransition];
    }
    [self.mGuideVC removeFromParentViewController];
    self.mGuideVC = nil;
    self.isGuideViewShowed=NO;
    [self applicationGuideViewDidDisappear];
    
    //广告页跳转
    //广告页消失后弹出推送alert
    if ([UlePushHelper shared].pushAlertInfo) {
        [[UlePushHelper shared]handleRemoteNotification:[UlePushHelper shared].pushAlertInfo];
    }else if (tModuleAction) {
        if ([US_UserUtility sharedLogin].mIsLogin) {
            //广告页跳转
            [[UIViewController currentViewController] pushNewViewController:tModuleAction.mViewControllerName isNibPage:tModuleAction.mIsXib withData:tModuleAction.mParams];
        }else {
            self.iosGuideAction = tModuleAction;
        }
    }else if ([US_UserUtility sharedLogin].mIsLogin) {
        [self launchWithJumpInfo];
    }
}


//携带参数的跳转
- (void)launchWithJumpInfo {
    
    //广告页消失后弹出推送alert
    if ([UlePushHelper shared].pushAlertInfo) {
        [[UlePushHelper shared]handleRemoteNotification:[UlePushHelper shared].pushAlertInfo];
    }
    
    //携带推送信息（登录后查看）
    if ([UlePushHelper shared].pushInfo) {
        //如果是后台收到通知不用弹框
        [LogStatisticsManager shareInstance].srcid=Srcid_Push;
        [[UlePushHelper shared]handlePushAction:[UlePushHelper shared].pushInfo];
    }
    if ([UlePushHelper shared].msgInfo) {
        [[UlePushHelper shared] handlePushParams:[UlePushHelper shared].msgInfo alertStr:nil];
    }
    //携带广告页点击的跳转
    else if (self.iosGuideAction) {
        UleUCiOSAction *iosAction = self.iosGuideAction;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIViewController currentViewController] pushNewViewController:iosAction.mViewControllerName isNibPage:iosAction.mIsXib withData:iosAction.mParams];
            self.iosGuideAction = nil;
        });
    }
}

#pragma mark - <开启推送弹框>
- (void)showApplicationNotificationAlerView{
    if ([US_UserUtility isNeedShowNotificationAlertView]) {
        US_NotificationAlertView *notiAlertView=[[US_NotificationAlertView alloc]init];
        [notiAlertView show];
    }
}

#pragma mark - <网络请求>
- (void)startRequestPushRegist{
    [self.trackClient beginRequest:[USApplicationLaunchApi buildPushRegist] success:nil failure:nil];
}

- (void)startRequestServerTime{
    [self.vpsClient beginRequest:[USApplicationLaunchApi buildServerTimeRequest] success:^(id responseObject) {
        NSString * currentTime = [NSString isNullToString:[responseObject objectForKey:@"sysTime"]];
        if (currentTime.length>0) {
            NSDate *serverDate=[currentTime dateFromFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSTimeInterval serverInterval=[serverDate timeIntervalSince1970]*1000;//转为时间戳
            NSTimeInterval interval=serverInterval-[UleGetTimeTool getLocalTime];//算出时间差
            [[NSUserDefaults standardUserDefaults] setDouble:interval forKey:@"Vi_TimeInterval"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [US_UserUtility saveCurrentdateWithKey:kUserDefault_serverTimeRequestDate];
        }
    } failure:^(UleRequestError *error) {
        USLog(@"%@", error);
    }];
}

//请求用户信息
- (void)startRequestUserInfoInGroup:(BOOL)requestInGourp isSelectedAtLast:(BOOL)selectedAtLast{
    if ([US_UserUtility sharedLogin].m_userToken.length==0) {
        if (requestInGourp) {
            [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
        }
        return;
    }
    if (selectedAtLast) {
        [UleMBProgressHUD showHUDWithText:@"加载中..."];
    }
    @weakify(self);
    [self.apiClient beginRequest:[USApplicationLaunchApi buildRequestUserInfo] success:^(id responseObject) {
        @strongify(self);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSString *encryptStr = [responseDic objectForKey:@"data"];
            if ([NSString isNullToString:encryptStr].length==0) return;
            //获取key
            NSString *o_key = [CalcKeyIvHelper shared].x_Emp_Key;
            //获取向量
            NSString *o_Iv = [CalcKeyIvHelper shared].x_Emp_Iv;
            NSData *o_ivData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
            
            NSData *decryptData = [Ule_SecurityKit M_DecryptWithData:[NSData dataFromBase64String:encryptStr] WithKey:o_key WithIV:[o_ivData bytes]];
            NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:decryptData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers  error:nil];
            //保存到本地
            if (dataDic.allKeys.count>0) {
                //用户信息接口未返回token
                NSMutableDictionary *compleDic = [NSMutableDictionary dictionaryWithDictionary:dataDic];
                [compleDic setObject:[US_UserUtility sharedLogin].m_userToken forKey:@"X-Emp-Token"];
                [[US_LoginManager sharedManager] saveUserInfoToLocalWithData:compleDic];
                //发送通知
                if (requestInGourp) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UserInfoRequest_Success object:nil];
                }else{
                    [self startRequestEnterpriseRecommendSelectedAtLast:selectedAtLast];
                }
            } else {
                if (requestInGourp) {
                    [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
                }
            }
        } else {
            if (requestInGourp) {
                [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
            }
        }
    } failure:^(UleRequestError *error) {
        if (requestInGourp) {
              [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
        }else if (selectedAtLast) {
            [UleMBProgressHUD hideHUD];
            [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
        }
        if (error.error.code==70516) {
            [US_LoginManager logOutToLoginWithMessage:@"该用户已注销"];
        }
    }];
}

- (void)startRequestEnterpriseRecommendSelectedAtLast:(BOOL)isSelectedAtLast{
    NSString *userInfoStr = [NSString stringWithFormat:@"O%@P%@C%@A%@T%@", [US_UserUtility sharedLogin].m_orgType, [US_UserUtility sharedLogin].m_provinceCode, [US_UserUtility sharedLogin].m_cityCode, [US_UserUtility sharedLogin].m_areaCode, [US_UserUtility sharedLogin].m_townCode];
    NSString * localStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfoStr"];
    [UserDefaultManager setLocalDataString:userInfoStr key:@"userInfoStr"];
    if (![userInfoStr isEqualToString:localStr]) {
        //清空本地批销专区id
        [US_UserUtility savePixiaoZoneId:nil];
        if ([[US_UserUtility sharedLogin].m_provinceCode isEqualToString:@"58093"]) {
            if (isSelectedAtLast) {
                [UleMBProgressHUD hideHUD];
            }
            //非企业没必要请求
            //如果用户是掌柜，且企业没数据时，显示掌柜模块
            [US_UserUtility sharedLogin].enterpriseMark=@"1";
            NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
            [userInfo setObject:@NO forKey:@"hadEnterprice"];
            [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
            return;
        }
    }
    if (![userInfoStr isEqualToString:localStr] || ![NSDate todayHadRequestForKey:kUSerDefault_ReqeustEnterpirse]) {
        [NSDate saveDate:[NSDate date] Forkey:kUSerDefault_ReqeustEnterpirse];
        @weakify(self);
        [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildEnterpriseRecommendWithPageIndex:1] success:^(id responseObject) {
            @strongify(self);
            US_EnterpriseRecommend * enterpise=[US_EnterpriseRecommend yy_modelWithDictionary:responseObject];
            if ([enterpise.data.totalCount integerValue]==0) {
                [self startRequestEnterpriseBannerAtLast:isSelectedAtLast];
            }else{
                if (isSelectedAtLast){
                    [UleMBProgressHUD hideHUD];
                }
                NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
                [userInfo setObject:@YES forKey:@"hadEnterprice"];
                [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
                //请求分销专区id并保存
                [self requestWholeSaleZondIdAndSave];
            }
        } failure:^(UleRequestError *error) {
            if (isSelectedAtLast) {
                [UleMBProgressHUD hideHUD];
                [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
            }
        }];
    }else {
        if (isSelectedAtLast) {
            [UleMBProgressHUD hideHUD];
            [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
        }
        //请求分销专区id并保存
        [self requestWholeSaleZondIdAndSave];
    }
}

- (void)startRequestEnterpriseBannerAtLast:(BOOL)isSelectedAtLast{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildEnterpriseBanner] success:^(id responseObject) {
        @strongify(self);
        US_EnterpriseBanner *bannerModel = [US_EnterpriseBanner yy_modelWithDictionary:responseObject];
        if (bannerModel.data.count<=0) {
            [self startRequestWholeSaleZoneIdAtLast:isSelectedAtLast];
        }else{
            if (isSelectedAtLast){
                [UleMBProgressHUD hideHUD];
            }
            NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
            [userInfo setObject:@YES forKey:@"hadEnterprice"];
            [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
            //请求分销专区id并保存
            [self requestWholeSaleZondIdAndSave];
        }
    } failure:^(UleRequestError *error) {
        if (isSelectedAtLast) {
            [UleMBProgressHUD hideHUD];
            [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
        }
    }];
}

- (void)startRequestWholeSaleZoneIdAtLast:(BOOL)isSelectedAtLast{
    if (![US_UserUtility sharedLogin].pixiaoZoneId) {
        @weakify(self);
        [self startRequestWholeSaleZoneIdSuccess:^(id responseObj) {
            @strongify(self);
            NSMutableArray *zoneIdStrList=[NSMutableArray array];
            id zoneIdList=responseObj[@"data"];
            if ([zoneIdList isKindOfClass:[NSArray class]]) {
                NSArray *zoneIdArr=[NSArray arrayWithArray:zoneIdList];
                for (int i=0; i<zoneIdArr.count; i++) {
                    NSString *zoneId=[NSString stringWithFormat:@"%@", zoneIdArr[i]];
                    [zoneIdStrList addObject:zoneId];
                }
            }
            [US_UserUtility savePixiaoZoneId:zoneIdStrList];
            [self startRequestWholeSaleListAtLast:isSelectedAtLast];
        } failure:^(UleRequestError *error) {
            if (isSelectedAtLast) {
                [UleMBProgressHUD hideHUD];
                [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
            }
        }];
    }else {
        [self startRequestWholeSaleListAtLast:isSelectedAtLast];
    }
}

- (void)startRequestWholeSaleListAtLast:(BOOL)isSelectedAtLast{
    if ([US_UserUtility sharedLogin].pixiaoZoneId.count>0) {
        [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildWholeSaleItemListByPageStart:@(1)] success:^(id responseObject) {
            if (isSelectedAtLast){
                [UleMBProgressHUD hideHUD];
            }
            US_EnterpriseWholeSaleModel *wholeSaleModel=[US_EnterpriseWholeSaleModel yy_modelWithDictionary:responseObject];
            NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
            if ([wholeSaleModel.data.total integerValue]==0) {
                //用户是掌柜，且企业没数据时，显示掌柜模块
                [US_UserUtility sharedLogin].enterpriseMark=@"1";
                [userInfo setObject:@NO forKey:@"hadEnterprice"];
                [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
            }else {
                [userInfo setObject:@YES forKey:@"hadEnterprice"];
                [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
            }
        } failure:^(UleRequestError *error) {
            if (isSelectedAtLast) {
                [UleMBProgressHUD hideHUD];
                [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
            }
        }];
    }else {
        //zoneId为空不请求专区商品列表
        if (isSelectedAtLast){
            [UleMBProgressHUD hideHUD];
        }
        //用户是掌柜，且企业没数据时，显示掌柜模块
        NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
        [US_UserUtility sharedLogin].enterpriseMark=@"1";
        [userInfo setObject:@NO forKey:@"hadEnterprice"];
        [userInfo setObject:isSelectedAtLast?@"1":@"0" forKey:@"selectedAtLast"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
    }
}

- (void)startRequestWholeSaleZoneIdSuccess:(void(^)(id responseObj))successBlock failure:(void(^)(UleRequestError *error))failureBlock{
    [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildWholeSaleZoneId] success:^(id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(UleRequestError *error) {
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (void)requestWholeSaleZondIdAndSave{
    if (![US_UserUtility sharedLogin].pixiaoZoneId) {
        [self startRequestWholeSaleZoneIdSuccess:^(id responseObj) {
            NSMutableArray *zoneIdStrList=[NSMutableArray array];
            id zoneIdList=responseObj[@"data"];
            if ([zoneIdList isKindOfClass:[NSArray class]]) {
                NSArray *zoneIdArr=[NSArray arrayWithArray:zoneIdList];
                for (int i=0; i<zoneIdArr.count; i++) {
                    NSString *zoneId=[NSString stringWithFormat:@"%@", zoneIdArr[i]];
                    [zoneIdStrList addObject:zoneId];
                }
            }
            [US_UserUtility savePixiaoZoneId:zoneIdStrList];
        } failure:^(UleRequestError *error) {
            
        }];
    }
}

- (void)startRequestReferrerInfo{
    //请求成功过就不请求
    if ([US_UserUtility sharedLogin].isUserRederrerRequested) return;
    [self.apiClient beginRequest:[USApplicationLaunchApi buildGetReferrerInfoRequest] success:^(id responseObject) {
        [US_UserUtility sharedLogin].isUserRederrerRequested=YES;
        US_ReferrerData * referrerData=[US_ReferrerData yy_modelWithDictionary:responseObject];
        if (referrerData.data && referrerData.data != nil&&referrerData.data.recommendProvinceId.length>0) {
            [US_UserUtility saveUserReferrerId:NonEmpty(referrerData.data.recommendProvinceId)];
        }
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startRequestTabbar{
    [self.networkClient_UstaticCDN beginRequest:[USApplicationLaunchApi buildRequestTabbar] success:^(id responseObject) {
        FeatureModel_TabBarInfor *tabbarModel = [FeatureModel_TabBarInfor mj_objectWithKeyValues:responseObject];
        NSMutableArray *filterArray = [NSMutableArray array];
        NSMutableArray *imgUrlList = [NSMutableArray array];
        for (int i=0; i<tabbarModel.indexInfo.count; i++) {
            TabbarIndexInfo *itemIndex = tabbarModel.indexInfo[i];
            if ([UleModulesDataToAction canInputDataMin:itemIndex.minversion withMax:itemIndex.maxversion withDevice:itemIndex.devicetype withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]]) {
                [filterArray addObject:itemIndex];
                [imgUrlList addObject:itemIndex.normal_icon];
                [imgUrlList addObject:itemIndex.select_icon];
            }
        }
        [[USImageDownloadManager sharedManager] downloadImageList:imgUrlList success:^(NSMutableArray * _Nullable resultArr) {
            for (int i=0; i<filterArray.count; i++) {
                TabbarIndexInfo *itemIndex = filterArray[i];
                itemIndex.normal_imageData = UIImagePNGRepresentation([resultArr objectAt:i*2]);
                itemIndex.select_imageData = UIImagePNGRepresentation([resultArr objectAt:i*2+1]);
            }
            
            [NSKeyedArchiver archiveRootObject:filterArray toFile:[FileController fullpathOfFilename:TabbarListName_update]];
        } fail:^(NSError * _Nullable error) {
        }];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startRequestDropDownGifViewInfor{
    NSString * sectionkey= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_DropDownRefresh);
    if ([NSDate todayHadRequestForKey:sectionkey]) {
        return;
    }
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:sectionkey] success:^(id responseObject) {
        @strongify(self);
        [self fetchHomeGIFRefreshDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startReuestVersionUpdateInfoCompleteWithSuccess:(USApiRequestSuccessBlock)sucBlock failure:(USApiRequestFailBlock)failBlock{
    @weakify(self);
    USApiRequestSuccessBlock successBlock = nil;
    USApiRequestFailBlock failureBlock = nil;
    if (sucBlock) {
        successBlock = [sucBlock copy];
    }
    if (failBlock) {
        failureBlock = [failBlock copy];
    }
    
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_Update)] success:^(id responseObject) {
        @strongify(self);
        [self fetchVersionUpdateDicInfo:responseObject successBlock:successBlock];
    } failure:^(UleRequestError *error) {
        if (failBlock) {
            failBlock();
        }
    }];
}

#pragma mark - <set userAgent>
- (void)registWebviewAgent{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    //add my info to the new agent
    NSString *agentAppendstr=[NSString stringWithFormat:@"%@/%@_%@_%@_%@_tracklog-%@_deviceId%@_",NonEmpty([UleStoreGlobal shareInstance].config.agentPrefix),@"ios",NonEmpty([UleStoreGlobal shareInstance].config.appName),NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),NonEmpty([UleStoreGlobal shareInstance].config.versionNum),NonEmpty([UleStoreGlobal shareInstance].config.agentClientTracklog),[US_UserUtility sharedLogin].openUDID];
    NSString *newAgent = [oldAgent stringByAppendingString:agentAppendstr];
    NSLog(@"new agent :%@", newAgent);
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
}

- (void)startRecordLogAndBugly:(BOOL) bugly{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //开启bugly 友盟
        if (bugly) {
            [Bugly startWithAppId:NonEmpty([UleStoreGlobal shareInstance].config.buglyAppID)];
            //注册友盟
            [UMConfigure initWithAppkey:NonEmpty([UleStoreGlobal shareInstance].config.UMAppKey) channel:@"App Store"];
            [UMConfigure setEncryptEnabled:YES];
        }
        //开启自定义行为统计
        [ule_statistics startAppClient:[UleStoreGlobal shareInstance].config.appKey mode:[UleStoreGlobal shareInstance].config.envSer secretkey:[UleStoreGlobal shareInstance].config.appSecretKey];
        [UleMbLogOperate addMBLogLaunchList];
        [ule_statistics startBeginUploadLog];
        
        //手动上传launch一天上传一次
        if (![NSDate todayHadRequestForKey:kUserDefault_launchApiSuc]) {
            [self.trackClient beginRequest:[USApplicationLaunchApi buildUploadLanchInfoRequest] success:^(id responseObject) {
                [NSDate saveDate:[NSDate date] Forkey:kUserDefault_launchApiSuc];
            } failure:nil];
        }
     
    });
    NSTimeInterval diffTime=[[[NSUserDefaults standardUserDefaults] objectForKey:@"Vi_TimeInterval"] doubleValue];
    [LogStatisticsManager initWithAppKey:[UleStoreGlobal shareInstance].config.logAppKey appName:NonEmpty([UleStoreGlobal shareInstance].config.clientType) deviceID:[US_UserUtility sharedLogin].openUDID difftime:diffTime andEnv:[UleStoreGlobal shareInstance].config.envSer];
    if ([US_UserUtility sharedLogin].mIsLogin) {
        [LogStatisticsManager addxdsCode:[US_UserUtility sharedLogin].m_townCode xdaCode:[US_UserUtility sharedLogin].m_areaCode xdcCode:[US_UserUtility sharedLogin].m_cityCode xdpCode:[US_UserUtility sharedLogin].m_provinceCode xdOrgCode:[US_UserUtility sharedLogin]. m_orgCode xdorgType:[US_UserUtility sharedLogin]. m_orgType];
    }
}
#pragma mark - <private function>
- (void)fetchHomeGIFRefreshDicInfo:(NSDictionary *)dic{
    FeatureModel_GIFRefresh * gifRefresh=[FeatureModel_GIFRefresh yy_modelWithDictionary:dic];
    for (int i=0; i<gifRefresh.indexInfo.count; i++) {
        GIFRefreshIndexInfo * indexItem=gifRefresh.indexInfo[i];
        BOOL canInput=[UleModulesDataToAction canInputDataMin:indexItem.min_version withMax:indexItem.max_version withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        if (canInput && [indexItem.refreshModel isEqualToString:@"1"]){
            [[USImageDownloadManager sharedManager]asyncDownloadWithLink:[NSString isNullToString:indexItem.imgUrl] success:^(NSData * _Nullable data) {
                [UserDefaultManager setLocalDataObject:data key:kUserDefault_dropDownGifView];;
                [NSDate saveDate:[NSDate date] Forkey: NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_DropDownRefresh)];
            } fail:^(NSError * _Nullable error) {
            }];
            break;
        }
    }
}

- (void)fetchVersionUpdateDicInfo:(NSDictionary *)dic successBlock:(USApiRequestSuccessBlock)sucBlock{
    FeatureModel_VersionUpdate * versionModle=[FeatureModel_VersionUpdate yy_modelWithDictionary:dic];
    VersionIndexInfo *versionItem = [versionModle.indexInfo firstObject];
    [US_UserUtility saveLocalPreviewUrl:[NSString stringWithFormat:@"%@", versionItem.attribute9]];
    [US_UserUtility saveLimitDomain:[NSString stringWithFormat:@"%@",versionItem.attribute13]];
    [US_UserUtility saveCommsionTitle:[NSString isNullToString:versionItem.commission_title]];
    [US_UserUtility saveHomeListingFlag:[NSString isNullToString:versionItem.index_listings_flag]];
    //我的模块更新标记
    self.poststore_my_update = versionItem.poststore_my_update;
    if ([[NSString isNullToString:versionItem.attribute1] compare:NonEmpty([UleStoreGlobal shareInstance].config.appVersion)] > 0) {
        //是否强制更新
        BOOL isForced = [versionItem.attribute4 boolValue];
        NSInteger currentV = [NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue];
        if ([NSString isNullToString:versionItem.attribute7].length>0) {
            NSInteger forcedUpdateV = [versionItem.attribute7 integerValue];
            isForced = currentV<forcedUpdateV;
        }
        
        if (!isForced&&![US_UserUtility isNeedShowVersionUpdateAlertView]) {
            if (sucBlock) {
                sucBlock(nil);
            }
        }else {
            US_UpdateAlertView * updateAlertView = [[US_UpdateAlertView alloc] initWithType:isForced?UleUpdateAlertViewTypeMustUpdate:UleUpdateAlertViewTypeNormal andTitle:@"发现新版本哦" andMessage:[NSString stringWithFormat:@"%@",[versionItem.attribute2 stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]]];
            updateAlertView.confirmClickBlock = ^{
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:versionItem.attribute3]];
            };
            updateAlertView.orderNum = UnitAlertOrderVersionUpdate;
            if (sucBlock) {
                sucBlock(updateAlertView);
            }else{
                //            [USCustomAlertViewManager sharedManager].isCancelShowAutomic=YES;
                [updateAlertView showViewWithAnimation:AniamtionAlert];
            }
        }
    }else {
        if (sucBlock) {
            sucBlock(nil);
        }
    }
}

+ (void)controlNetWork{
    [[UleReachability  sharedManager] setReachabilityStatusChangeBlock:^(UleReachabilityStatus status) {
        if (status == UleReachabilityStatusUnknown || status == UleReachabilityStatusNotReachable) {
            NSLog(@"无网络");
        }
        else{
            NSLog(@"有网络");
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkChange" object:nil];
    }];
    [[UleReachability sharedManager] startMonitoring];
}

#pragma mark - <getter>
- (UleNetworkExcute *)apiClient{
//    if (!_apiClient) {
        _apiClient=[US_NetworkExcuteManager uleAPIRequestClient];
//    }
    return _apiClient;
}

- (UleNetworkExcute *)cdnClient
{
//    if (!_cdnClient) {
        _cdnClient=[US_NetworkExcuteManager uleCDNRequestClient];
//    }
    return _cdnClient;
}
- (UleNetworkExcute *)trackClient{
//    if (!_trackClient) {
        _trackClient=[US_NetworkExcuteManager uleTrackRequestClient];
//    }
    return _trackClient;
}
-(UleNetworkExcute *)vpsClient{
//    if (!_vpsClient) {
        _vpsClient=[US_NetworkExcuteManager uleVPSRequestClient];
//    }
    return _vpsClient;
}
- (UleNetworkExcute *)networkClient_UstaticCDN{
//    if (!_networkClient_UstaticCDN) {
        _networkClient_UstaticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
//    }
    return _networkClient_UstaticCDN;
}
@end
