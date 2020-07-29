//
//  UleWebViewApiBridge.m
//  UleApp
//
//  Created by uleczq on 2017/7/18.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleWebViewApiBridge.h"
#import "UleModulesDataToAction.h"
#import "UleWebBarButton.h"
#import <AVFoundation/AVFoundation.h>
#import "UleMbLogOperate.h"
#import "UlePopupMenu.h"
#import "UleNativePayManager.h"
#import <UIViewController+UleExtension.h>
#import "UleTabBarViewController.h"
#import "US_UpdateUserInfoVC.h"
#import "US_LoginManager.h"
#import "USBookContactManager.h"
#import "UleRedRainNotificationManager.h"
#import "USLocationManager.h"
#import "UleAudioMananger.h"
#import "Ule_RSABase64.h"
#import "DeviceInfoHelper.h"
//#import "NewWebShareModel.h"
typedef enum : NSUInteger {
    UleWebNativeActionUrl,              //0、兼容旧版Url解析方式
    UleWebNativeActionScan,             //1、扫码
    UleWebNativeActionShare,            //2、分享
    UleWebNativeActionPush,             //3、跳转到指定页面
    UleWebNativeActionJSFunc,           //4、调用JS方法
    UleWebNativeActionRegistNotify,     //5、JS注册通知
    UleWebNativeActionPostNotify,       //6、发送通知
    UleWebNativeActionMenuList,         //7、导航栏上菜单列表
    UleWebNativeActionJumpApp         //8、跳转App
} UleWebNativeActionType;

@interface UleWebViewApiBridge ()<UlePopupMenuDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray * menuListArray;
@property (nonatomic, strong) NSString * mActionType;
@property (nonatomic, strong) NSString * mAction;
@property (nonatomic, strong) UIButton * addFavButton;
@property (nonatomic, strong) UleAudioMananger * audioManageer;
@end

@implementation UleWebViewApiBridge

#pragma mark - JS 调用 原生方法
/**
 * 配置导航栏
 */
- (id)setNativeTitle:(NSDictionary *) args{
    NSString * title=args[@"title"];
    NSArray * rightBtns=args[@"rightIcon"];
    NSMutableArray * rightItems=[[NSMutableArray alloc] init];
    for (int i=0; i<rightBtns.count; i++) {
        NSDictionary * dic=rightBtns[i];
        UleWebBarButton * btn=[[UleWebBarButton alloc] initWithFrame:CGRectMake(0, 0, 35, 40) withTitle:dic[@"iconTitle"] andIcon:dic[@"imgUrl"]];
        btn.bindData=dic;
        NSString * minversion=dic[@"minversion"];
        NSString * maxversion=dic[@"maxversion"];
        BOOL isCanUse=YES;
        if (minversion.length>0&&maxversion.length>0) {
            isCanUse= [UleModulesDataToAction canInputDataMin:minversion withMax:maxversion withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
        }
        if (isCanUse) {
            [rightItems addObject:btn];
            [btn addTouchTarget:self action:@selector(btnClick:)];
        }
    }
    rightItems= [[[rightItems reverseObjectEnumerator] allObjects] mutableCopy];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadNavigationBarWithTitle:andRightButtons:)]) {
        [self.delegate loadNavigationBarWithTitle:title andRightButtons:rightItems];
    }
    NSDictionary * leftBtnInfo=args[@"leftIcon"];
    if (leftBtnInfo) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(setLeftBackButtonAction:)]) {
            NSString *iosAction=leftBtnInfo[@"ios_action"];
            UleUCiOSAction * commonAction=[UleModulesDataToAction resolveModulesActionStr:iosAction];
            [self.delegate setLeftBackButtonAction:commonAction];
        }
    }
    return nil;
}
/**
 *  添加导航栏(如果右侧有按键也能支持，但不支持左侧按键)
 */
- (id)setNativeSearchBar:(NSDictionary *)args{
    [self setNativeTitle:args];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(loadNavigationSearchBar)]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate loadNavigationSearchBar];
        });
    }
    return nil;
}

- (id)hiddenNativeNavigationBar:(NSDictionary *)args{
    NSLog(@"===hidden Native Nav ===");
    BOOL showFromStatus=[args[@"showStatus"] boolValue];
    BOOL showNativeNavigation=[args[@"hiddenNativeNav"] boolValue];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(hiddenNavigationBar:offSetStatus:animated:)]) {
        [self.delegate hiddenNavigationBar:showNativeNavigation offSetStatus:showFromStatus animated:YES];
    }
    return nil;
}

/**
 *  通用解析事件方法
 */
- (id)generalAction:(NSDictionary *)args{
    NSString * type=args[@"type"];
    id action=args[@"ios_action"];
    NSString * minversion=args[@"minversion"];
    NSString * maxversion=args[@"maxversion"];
    BOOL isCanUse=YES;
    if (minversion.length>0&&maxversion.length>0) {
        isCanUse= [UleModulesDataToAction canInputDataMin:minversion withMax:maxversion withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
    }
    if (isCanUse) {
        BOOL needLogin=[args[@"needlogin"] boolValue];
        if (needLogin&&![US_UserUtility sharedLogin].mIsLogin) {
            [self gotoNativeLoginVC:@""];
        }else{
            UleWebNativeActionType actionType=[type integerValue];
            [self handleAction:action forType:actionType];
            NSString * logTitle=args[@"logTitle"];
            if (logTitle.length>0) {
                [UleMbLogOperate addMbLogClick:logTitle moduleid:@"" moduledesc:@"" networkdetail:nil];
            }
        }
    }
    return nil;
}

/**
 *  显示导航栏上多个按键菜单
 */
- (void)showNavigatonMenuList:(id)action atButton:(UleWebBarButton *) barButton{
    if ([action isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dic=(NSDictionary *)action;
        NSArray * lists=dic[@"ios_action"];
        _menuListArray=[[NSMutableArray alloc] init];
        NSMutableArray * titleArray=[[NSMutableArray alloc] init];
        NSMutableArray * iconArray=[[NSMutableArray alloc] init];
        for (int i=0; i<lists.count; i++) {
            NSDictionary * args=lists[i];
            NSString * minversion=args[@"minversion"];
            NSString * maxversion=args[@"maxversion"];
            BOOL isCanUse=YES;
            if (minversion.length>0&&maxversion.length>0) {
                isCanUse= [UleModulesDataToAction canInputDataMin:minversion withMax:maxversion withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
            }
            if (isCanUse) {
                NSString * title= [args[@"iconTitle"] length]>0?args[@"iconTitle"]:@"";
                NSString * imgUrl= [args[@"imgUrl"] length]>0?args[@"imgUrl"]:@"";
                [titleArray addObject:title];
                [iconArray addObject:imgUrl];
                [_menuListArray addObject:args];
            }
        }
        [UlePopupMenu showOnView:barButton titles:titleArray icons:iconArray delegate:self];
    }
}

/*
 * 原生支付（支付宝，微信）
 */
- (id) uleNativePay:(NSDictionary *)args result:(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    //TODO: 支付相关
    [[UleNativePayManager shareInstance] startNativePayWithParams:args result:completionHandler];
    return nil;
}

//红包雨设置提醒
- (id) setH5Alarms:(NSDictionary *)args result:(void (^)(NSString * _Nullable isHaveAuthority))completionHandler{
    [[UleRedRainNotificationManager sharedManager] setRedRainNotification:args result:completionHandler];
    return nil;
}
//取消提醒
- (id)cancelH5Alarms:(NSDictionary *)args{
    [[UleRedRainNotificationManager sharedManager] cancelRedRainNotification];
    return nil;
}

- (id)getH5AlarmsStatus:(NSString *)themeCode result:(void (^)(NSString * _Nullable isOpen))completionHandler{
    NSString * open=[[UleRedRainNotificationManager sharedManager] getRedRainNotificationIsOpen:themeCode]?@"true":@"false";
    if (completionHandler) {
        completionHandler(open);
    }
    return nil;
}

/**
 * 跳转到原生页面+回调 (暂定专用 之后增加数据段判断 H5战队&店主信息原生)
 */
- (id)jumpWithCallBack:(NSDictionary *)args {
    //{"ios_action":"US_UpdateUserInfoVC::1","android_action":"action&&.ui.StoreChangeActivity"，"jsFuntion":"callNativeAppShopCallback"}
    [self gotoUpdateVC:args];
    return nil;
}

/**
 *  获取用户信息 2019.06.15
 */
- (id)getNativeUserInfo:(NSDictionary *)args {
    id action = args[@"ios_action"];
    NSString *minversion = args[@"minversion"];
    NSString *maxversion = args[@"maxversion"];
    
    BOOL isCanUse = YES;
    if (minversion.length>0 && maxversion.length>0) {
        isCanUse= [UleModulesDataToAction canInputDataMin:NonEmpty(minversion) withMax:NonEmpty(maxversion) withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
    }
    
    if (isCanUse) {
        BOOL needLogin = [args[@"needlogin"] boolValue];
        if (needLogin && ![US_UserUtility sharedLogin].mIsLogin) {
            [self gotoNativeLoginVC:@""];
            
        } else {
            NSString *headurl=[US_UserUtility sharedLogin].m_userHeadImgUrl;
            if ([NSString isNullToString:headurl].length <= 0) {
                headurl = @"https://pic.ule.com/item/user_0102/desc20190618/a6dac43759a34c34_-1x-1.png";
            }
            
            NSDictionary *params = @{
                                     @"userid" : [US_UserUtility sharedLogin].m_userId,
                                     @"headImage" : headurl,
                                     @"storeName" : [US_UserUtility sharedLogin].m_stationName,
                                     @"mobileNumber" : [US_UserUtility sharedLogin].m_mobileNumber
                                     };
            
            [self didRunJSFunction2:action bookContactsDic:params];
        }
    }
    
    return nil;
}

/**
 * 获取定位adcode信息
 **/
- (id)getCurrentCityCode:(NSDictionary *)args{
    id action = args[@"ios_action"];
    NSString *minversion = args[@"minversion"];
    NSString *maxversion = args[@"maxversion"];
    BOOL isCanUse = [UleModulesDataToAction canInputDataMin:NonEmpty(minversion) withMax:NonEmpty(maxversion) withDevice:@"0" withAppVersion:[[UleStoreGlobal shareInstance].config.versionNum integerValue]];
    if (isCanUse) {
        NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
        NSString * cityCode;
        if ([USLocationManager sharedLocation].adcode&&[USLocationManager sharedLocation].adcode.length>0) {
            cityCode=[USLocationManager sharedLocation].adcode;
        }else{
            cityCode=@"0";
        }
        [dic setValue:cityCode forKey:@"cityCode"];
        [dic setValue:[NSString isNullToString:[USLocationManager sharedLocation].lastLatitude] forKey:@"latitude"];
        [dic setValue:[NSString isNullToString:[USLocationManager sharedLocation].lastLongitude] forKey:@"longitude"];
        [self didRunJSFunction2:action bookContactsDic:dic];
    }
    return nil;
}

/**
 *  通讯录 2019.01.23
 */
- (id)uleContact:(NSDictionary *)args {
    //eg. {"ios_action":"checkPhoneBookCallback","android_action":"checkPhoneBookCallback","minversion":"166","maxversion":"999"}
    //NSString * type=args[@"type"];
    id action = args[@"ios_action"];
    NSString *minversion = args[@"minversion"];
    NSString *maxversion = args[@"maxversion"];
    BOOL isCanUse = [UleModulesDataToAction canInputDataMin:NonEmpty(minversion) withMax:NonEmpty(maxversion) withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
    if (isCanUse) {
        BOOL needLogin = [args[@"needlogin"] boolValue];
        if (needLogin && ![US_UserUtility sharedLogin].mIsLogin) {
            [self gotoNativeLoginVC:@""];
        } else {
            [self gotoBookContactWithCallback2:action];
        }
    }
    return nil;
}

- (void)showAlertWithNOBookContancts {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" message:@"您已经拒绝了访问通讯录权限，请开启权限，否则该部分功能不能被正常使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去设置", nil];
    [alertView show];
}

- (id)addOwnGoodsAction:(NSDictionary *)args{
    if (![[US_UserUtility sharedLogin].qualificationFlag  isEqualToString:@"1"]) {
        //跳转注册
        NSString *urlStr=[NSString stringWithFormat:@"%@/mxiaodian/user/merchant/reg.html#/",[UleStoreGlobal shareInstance].config.mUleDomain];
        NSMutableDictionary *params=@{@"key":urlStr,
                                      @"hasnavi":@"1",
                                      @"title":@"自有商品注册"}.mutableCopy;
        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uleMerchant://"]]){
            //编辑
            NSString *str = @"uleMerchant://EditGoodsViewController";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }else{
            //跳转到应用市场
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id684673362"]];
        }
    }
    return nil;
}

//获取经纬度
- (id)getCurrentCoordinate:(NSDictionary *)args{
    id action = args[@"ios_action"];
    NSString *minversion = args[@"minversion"];
    NSString *maxversion = args[@"maxversion"];
    BOOL isCanUse = [UleModulesDataToAction canInputDataMin:NonEmpty(minversion) withMax:NonEmpty(maxversion) withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
    if (isCanUse) {
        BOOL needLogin = [args[@"needlogin"] boolValue];
        if (needLogin && ![US_UserUtility sharedLogin].mIsLogin) {
            [self gotoNativeLoginVC:@""];
        } else {
            [[USLocationManager sharedLocation]checkLocationAuthorizationWithAlertMessage:@"开通网点需获取您当前的位置" cancelActionBlock:^{
                [self popToRootView];
            }];
            [[USLocationManager sharedLocation] getCurrentLocation:^(TencentLBSLocation * _Nonnull currentLocation) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSDictionary *params=@{@"latitude":[[NSNumber numberWithDouble:currentLocation.location.coordinate.latitude] stringValue],
                                           @"longitude":[[NSNumber numberWithDouble:currentLocation.location.coordinate.longitude] stringValue]};
                    if ([self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
                        [self.delegate runJsFunction:action andParams:@[[NSString jsonStringWithDictionary:params]]];
                    }
                });
            }];
        }
    }
    
    return nil;
}

- (id)makePhoneCall:(NSDictionary *)args{
    NSString *phoneNum=[NSString isNullToString:[NSString stringWithFormat:@"%@", args[@"phoneNum"]]];
    if (phoneNum.length>0) {
        NSURL *url=[NSURL URLWithString:[phoneNum stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    return nil;
}

#pragma mark -导航栏button点击事件

- (void)btnClick:(UleWebBarButton *)barButton{
    NSDictionary * dic=barButton.bindData;
    UleWebNativeActionType type=[dic[@"type"] integerValue];
    if (type == UleWebNativeActionMenuList) {
        [self showNavigatonMenuList:dic atButton:barButton];
    }else{
        [self generalAction:barButton.bindData];
    }
}

#pragma mark - delegate
- (void)didClickAtIndex:(NSInteger)index{
    if (self.menuListArray.count>index) {
        NSDictionary * dic=self.menuListArray[index];
        NSString * action=dic[@"ios_action"];
        if ([action isEqualToString:@"ProductActivity"]) {
            UleTabBarViewController *tabar=(UleTabBarViewController*)[UIViewController currentViewController].tabBarController;
            [tabar selectTabBarItemAtIndex:0 animated:NO];
            [[UIViewController currentViewController].navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self generalAction:dic];
        }
    }
}

#pragma mark -事件处理
- (void)handleAction:(id)action forType:(UleWebNativeActionType) type{
    switch (type) {
        case UleWebNativeActionUrl:{
            [self didHandleWebViewUrlAction:action];
        }
            break;
        case UleWebNativeActionScan:{
            [self showScanViewController:action];
        }
            break;
        case UleWebNativeActionShare:{
            [self shareWithDic:action];
        }
            break;
        case UleWebNativeActionPush:{
            [self gotoNativeViewController:action];
        }
            break;
        case UleWebNativeActionJSFunc:{
            [self didRunJSFunction:action];
        }
            break;
        case UleWebNativeActionRegistNotify:{
            [self registNotify:action];
        }
            break;
        case UleWebNativeActionPostNotify:{
            [self postNotify:action];
        }
            break;
        case UleWebNativeActionMenuList:{}
            break;
        case UleWebNativeActionJumpApp:{
            [self jumpAnotherApp:action];
        }
            break;
        default:
            break;
    }
}


#pragma mark - Native 方法
- (id)callChatVoice:(NSDictionary *)args {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UleStoreApp.bundle/MsgBeep" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:path];
    SystemSoundID sid = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &sid);
    AudioServicesAddSystemSoundCompletion(0, NULL, NULL, complete, NULL);
    AudioServicesPlayAlertSound(sid);
    return nil;
}

static void complete( SystemSoundID ssID,void* __nullable clientData) {
    //注销自己创建的系统提示音
    AudioServicesDisposeSystemSoundID(ssID);
}

/**
 * 跳原生登录
 */
- (void)gotoNativeLoginVC:(NSString *) action{
    dispatch_async(dispatch_get_main_queue(), ^{
        [US_LoginManager logOutToLoginWithMessage:@"请登录"];
    });
}

/**
 *跳原生通用页面
 */
- (void)gotoNativeViewController:(NSString *) action{
    UleUCiOSAction * commonAction=[UleModulesDataToAction resolveModulesActionStr:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[commonAction.mViewControllerName lowercaseString]hasPrefix:@"tab"]) {
            NSString *tabIndex=[[commonAction.mViewControllerName lowercaseString]substringFromIndex:3];
            [self gotoTab:[tabIndex integerValue]];
        }else{
            UleBaseViewController *currentVC=(UleBaseViewController *)[UIViewController currentViewController];
#warning tt 此处xib为了兼容旧工程，统一改成NO
            [currentVC pushNewViewController:commonAction.mViewControllerName isNibPage:NO/*commonAction.mIsXib*/ withData:commonAction.mParams];
        }
    });
}


- (void)gotoTab:(NSInteger)tab{
    [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:NO];
    UleTabBarViewController *tabar=(UleTabBarViewController*)[UIViewController currentViewController].tabBarController;
    [tabar selectTabBarItemAtIndex:tab animated:NO];
}

/**
 * pop页面
 */
- (void)popViewController{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIViewController currentViewController].navigationController popViewControllerAnimated:YES];
    });
}

- (void)popToRootView{
    if ([self.delegate respondsToSelector:@selector(popToHomeAction)]) {
        [self.delegate popToHomeAction];
    }
}


/**
 *扫码
 */
- (void)showScanViewController:(NSString *) action {
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(author ==AVAuthorizationStatusRestricted ||
       author == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:[NSString stringWithFormat:@"相机开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"相机\">\"%@\"",[DeviceInfoHelper getAppName]]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //        [[UleAppLaunchInfoManager sharedManager].currentViewController pushNewViewController:@"PublicScannerViewController" isNibPage:NO withData:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToScanViewController:)]) {
            [self.delegate jumpToScanViewController:action];
        }
    });
}

/**
 *分享
 */
- (void)shareWithDic:(NSString *)action{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(jsFunctionShareInWebview:)]) {
            [self.delegate jsFunctionShareInWebview:action];
        }
    });
}

/**
 * 注册通知
 */
- (void)registNotify:(NSString *) action{
    NSData *jsonData = [action dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jsNotifyFunction:) name:dic[@"functionName"] object:nil];
}

/**
 *发送通知
 */
- (void)postNotify:(NSString *)action{
    NSData *jsonData = [action dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    [[NSNotificationCenter defaultCenter] postNotificationName:dic[@"functionName"] object:nil userInfo:dic];
}

/**
 *跳转app
 */
- (void)jumpAnotherApp:(NSString *)action{
    NSData *jsonData = [action dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    NSString *urlScheme=[NSString isNullToString:dic[@"urlScheme"]];
    NSString *appStoreUrl=[NSString isNullToString:dic[@"appStoreUrl"]];
    if (urlScheme.length>0){
        NSURL *url=[NSURL URLWithString:[urlScheme stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }else{
            //跳转到应用市场
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
        }
    }else{
        //跳转到应用市场
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreUrl]];
    }
}

/**
 *Native调用JS方法
 */
- (void)didRunJSFunction:(NSString *)action{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
            [self.delegate runJsFunction:action andParams:@[@""]];
        }
    });
    
}
/**
 * Native调用JS方法2 带回调
 */
- (void)didRunJSFunction2:(NSString *)action bookContactsDic:(NSDictionary *)bookContactsDic {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
            [self.delegate runJsFunction:action andParams:@[[NSString jsonStringWithDictionary:bookContactsDic]]];
        }
    });
}

/**
 * 获取通讯录联系人信息
 */
- (void)gotoBookContactWithCallback:(void(^)(NSDictionary *bookContactsDic))callback {
    [[USBookContactManager sharedInstance] getCallback:^(NSDictionary *params) {
        if (callback) {
            callback(params);
        }
    }];
}

- (void)gotoBookContactWithCallback2:(id)action {
    @weakify(self);
    [[USBookContactManager sharedInstance] getCallback:^(NSDictionary *params) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([params[@"returnCode"] isEqualToString:@"0001"]) {
                [self showAlertWithNOBookContancts];
            }
            [self didRunJSFunction2:action bookContactsDic:params];
        });
    }];
}

/**
 *兼容老版本链接截取方式
 */
-(void)didHandleWebViewUrlAction:(NSString *)action{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(handleRequestUrl:)]) {
            [self.delegate handleRequestUrl:action];
        }
    });
}
/**
 * 通知回调
 */
- (void)jsNotifyFunction:(NSNotification *)notify{
    NSDictionary * dic=notify.userInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
            [self.delegate runJsFunction:dic[@"functionName"] andParams:@[dic[@"functionParams"]]];
        }
    });
}

/**
 * H5战队 跳转到 店主信息原生
 */
- (void)gotoUpdateVC:(NSDictionary *)args {
    NSString *jsFuntion = args[@"jsFuntion"];
    NSString *action = args[@"ios_action"];
    UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:action];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([[commonAction.mViewControllerName lowercaseString] hasPrefix:@"tab"]) {
            NSString *tabIndex = [[commonAction.mViewControllerName lowercaseString]substringFromIndex:3];
            [self gotoTab:[tabIndex integerValue]];
        } else {
            if ([action isEqualToString:@"US_UpdateUserInfoVC::1"]) {
                [[UIViewController currentViewController] pushNewViewController:@"US_UpdateUserInfoVC" isNibPage:NO withData:@{@"isFromH5Team":@"1",@"jsFunction":jsFuntion}.mutableCopy];
            }
        }
    });
}

/**
 * 开始录音
 */
- (void)startRecorderAudio:(NSDictionary *)args {
    id action = args[@"ios_action"];
    [self.audioManageer startRecorderAudioWithCurrentViewController:[UIViewController currentViewController] startStatus:^(BOOL success){
        //要先获取录音权限 返回一个是否成功开始录音的状态
        NSDictionary *params=@{@"returnCode":success?@"0000":@"0001",
                               @"returnMessage":@""};
        
        if ([self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
            [self.delegate runJsFunction:action andParams:@[[NSString jsonStringWithDictionary:params]]];
        }
    }];
}

/**
 * 结束录音
 */
- (void)endRecorderAudio:(NSDictionary *)args {
    id action = args[@"ios_action"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.audioManageer endRecorderAudio];
        NSString * filePath=[self.audioManageer getRecorderAudioMp3Path];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (!filePath || ![fileManager fileExistsAtPath:filePath isDirectory:FALSE]) {
            return;
        }
        NSURL * url=[NSURL fileURLWithPath:filePath];
        NSData * data=[NSData dataWithContentsOfURL:url];
        NSString *dataStream = [Ule_RSABase64 ule_encode:data];
        NSDictionary *params=@{@"recorderAudioData":dataStream};
        
        if ([self.delegate respondsToSelector:@selector(runJsFunction:andParams:)]) {
            [self.delegate runJsFunction:action andParams:@[[NSString jsonStringWithDictionary:params]]];
        }
    });
    
}

#pragma lify Cycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - textField delegate
//- (void)uleNavigationSearchBarClick{
//    if(self.mAction.length>0){
//        UleWebNativeActionType actionType=[self.mActionType integerValue];
//        [self handleAction:self.mAction forType:actionType];
//    }
//}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    switch (textField.returnKeyType) {
        case UIReturnKeySearch:
            [textField resignFirstResponder];
            if ([self.delegate respondsToSelector:@selector(gotoStoreSearchViewController:)]) {
                [self.delegate gotoStoreSearchViewController:textField.text];
            }
            textField.text = @"";
            break;
        default:
            break;
    }
    return YES;
}
- (void)addFavStore:(id)sender{
    
}

#pragma mark setter and getter

- (UIButton *)addFavButton{
    if (!_addFavButton) {
        _addFavButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_addFavButton setBackgroundColor:[UIColor clearColor]];
        [_addFavButton setImage:[UIImage bundleImageNamed:@"VI_product_fav_normal"] forState:UIControlStateNormal];
        [_addFavButton setImage:[UIImage bundleImageNamed:@"VI_product_fav_selected"] forState:UIControlStateSelected];
        [_addFavButton addTarget:self action:@selector(addFavStore:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFavButton;
}

- (UleAudioMananger *)audioManageer{
    if (!_audioManageer) {
        _audioManageer=[[UleAudioMananger alloc] init];
    }
    return _audioManageer;
}

/**
 * 提示没有通讯录权限
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        if ([[UIDevice currentDevice].systemVersion floatValue]>=8.0 && [[UIDevice currentDevice].systemVersion floatValue]<10.0) { //iOS8.0和iOS9.0
            //废弃NSURL * url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
            //或
            //NSURL *url = [NSURL URLWithString:@"prefs:root=com.app.app"];
            //或
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
            
        } else if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0) { //iOS10.0及以后
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) { }];
                }
            }
        }
    }
}

@end
