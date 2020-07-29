//
//  US_LoginManager.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_LoginManager.h"
#import "US_loginGuideVC.h"
#import "UleBaseNaviViewController.h"
//#import "ViewController.h"
#import "LoginSuccessModel.h"
#import "USApplicationLaunchManager.h"
#import <Ule_SecurityKit.h>
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
#import "US_NetworkExcuteManager.h"
#import "US_LoginApi.h"
#import <ModuleYLXD/UleCTMediator+ModuleYLXD.h>
#import "DeviceInfoHelper.h"
#define  kscreenScale  [UIScreen mainScreen].bounds.size.width/375.0

@interface US_LoginManager ()
@property (nonatomic, strong) CLUIConfigure * baseUIConfigure;
@property (nonatomic, strong) CLOrientationLayOut * clOrientationLayOutPortrait;
@property (nonatomic, assign) BOOL isSuccessLoadShanYan;//是否成功拉起闪验登录页面
@end

@implementation US_LoginManager

+ (instancetype)sharedManager {
    static US_LoginManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedManager) {
            _sharedManager=[[US_LoginManager alloc] init];
        }
    });
    return _sharedManager;
}

+ (void)logOutToLoginWithMessage:(NSString *)msg{
    [US_UserUtility logoutSuccess];
    US_LoginGuideVC *loginVC=[[US_LoginGuideVC alloc]init];
    UleBaseNaviViewController *naviVC=[[UleBaseNaviViewController alloc]initWithRootViewController:loginVC];
    [UIApplication sharedApplication].keyWindow.rootViewController=naviVC;
    if (msg.length>0) {
        [UleMBProgressHUD showHUDAddedTo:loginVC.view withText:msg afterDelay:1.5];
    }
}

- (NSDictionary *) logInDecryptData:(NSDictionary *)dic{

    NSString *encryptStr = [dic objectForKey:@"data"];
    if ([NSString isNullToString:encryptStr].length==0)
        return nil;
    //获取key
    NSString *o_key = [CalcKeyIvHelper shared].x_Emp_Key;
    //获取向量
    NSString *o_Iv = [CalcKeyIvHelper shared].x_Emp_Iv;
    NSData *o_ivData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    NSData *decryptData = [Ule_SecurityKit M_DecryptWithData:[NSData dataFromBase64String:encryptStr] WithKey:o_key WithIV:[o_ivData bytes]];
    NSDictionary *decryptDic = [NSJSONSerialization JSONObjectWithData:decryptData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers  error:nil];
    return decryptDic;
}

- (void)logInToMainviewWithData:(NSDictionary *)dataDic fromType:(LogInMainViewTypeFrom)type
{
    USLog(@"%@", [NSString dictionaryToJson:dataDic]);
    [self saveUserInfoToLocalWithData:dataDic];
    //注册通知
    [[USApplicationLaunchManager sharedManager] startRequestPushRegist];
    [US_UserUtility sharedLogin].isUserFirstLogin=NO;
    if (self.isSuccessLoadShanYan) {
        [CLShanYanSDKManager finishAuthControllerCompletion:^{
            [UleMBProgressHUD hideHUD];
            [self presentMainView];
            if (type == LogInMainViewTypeFromLogin) {
                [[USApplicationLaunchManager sharedManager] applicationEnterMainPageFromLogin];
            }else if (type == LogInMainViewTypeFromRegist) {
                [[USApplicationLaunchManager sharedManager]applicationEnterMainPageFromRegist];
            }
        }];
    }else{
        [UleMBProgressHUD hideHUD];
        [self presentMainView];
        if (type == LogInMainViewTypeFromLogin) {
            [[USApplicationLaunchManager sharedManager] applicationEnterMainPageFromLogin];
        }else if (type == LogInMainViewTypeFromRegist) {
            [[USApplicationLaunchManager sharedManager]applicationEnterMainPageFromRegist];
        }
    }
}

- (void)saveUserInfoToLocalWithData:(NSDictionary *)dataDic{
    LoginSuccessModel *loginModel=[LoginSuccessModel yy_modelWithDictionary:dataDic];
    [US_UserUtility saveLoginName:loginModel.mobileNumber usrOnlyid:loginModel.usrOnlyid mobileNumber:loginModel.mobileNumber headImg:loginModel.imageUrl userToken:loginModel.userToken stationName:loginModel.stationName storeDesc:loginModel.storeDesc userName:loginModel.usrName isUserProtocol:loginModel.isUserProtocol protocolUrl:loginModel.protocolUrl carInsurance:[NSString stringWithFormat:@"%ld", (long)loginModel.AuthMap.carInsurance] websiteType:[NSString stringWithFormat:@"%ld", (long)loginModel.websiteType] lockFlag:loginModel.lockFlag donateFlag:loginModel.donateFlag qualificationFlag:loginModel.qualificationFlag identifiedFlag:loginModel.identified yzgFlag:loginModel.yzgFlag];
    [US_UserUtility saveOrgType:loginModel.orgType orgCode:loginModel.orgCode orgName:loginModel.enterpriseName orgProvinceCode:loginModel.orgProvince orgProvinceName:loginModel.orgProvinceName orgCityCode:loginModel.orgCity orgCityName:loginModel.orgCityName orgAreaCode:loginModel.orgArea orgAreaName:loginModel.orgAreaName orgTownCode:loginModel.orgTown orgTownName:loginModel.stationInfo3 enterpriseOrgFlag:loginModel.enterpriseOrgFlag];
    [US_UserUtility saveLastOrgId:loginModel.lastOrgId];
    [US_UserUtility saveLastOrgName:loginModel.lastOrgName];
}


- (void)presentMainView{
    [[UleCTMediator sharedInstance] uleMediator_presentMainView];
}

+ (void)showLoginView{
    US_LoginManager * mananger=[US_LoginManager sharedManager];
    [mananger didLoginWithShanYanAuthPage:@"" withTarget:nil withParam:nil];
}

- (void)showotherLoginType:(id)sender{

    [[UIViewController currentViewController] pushNewViewController:@"US_LoginVC" isNibPage:NO withData:nil];

}

//一键登录
- (void)didLoginWithShanYanAuthPage:(NSString *)tString withTarget:(id)tTarget withParam:(id)tParam{
    self.baseUIConfigure.clOrientationLayOutPortrait = self.clOrientationLayOutPortrait;
    [UleMBProgressHUD showHUDWithText:@""];
    self.isSuccessLoadShanYan=YES;
    [CLShanYanSDKManager quickAuthLoginWithConfigure:self.baseUIConfigure openLoginAuthListener:^(CLCompleteResult * _Nonnull completeResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UleMBProgressHUD hideHUD];
            if (completeResult.error) {
                NSLog(@"拉起一键登录失败");
                self.isSuccessLoadShanYan=NO;
                [self showotherLoginType:nil];
            }else{
                
            }
        });

    }  oneKeyLoginListener:^(CLCompleteResult * _Nonnull completeResult) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeResult.error) {
                NSLog(@"一键登录失败");
                if(completeResult.code != 1011){
                    [UleMBProgressHUD showHUDWithText:@"一键登录失败" afterDelay:showDelayTime];
                    [CLShanYanSDKManager finishAuthControllerCompletion:nil];
                }
            }else{
                //SDK成功获取到Token
                NSString * token=[completeResult.data objectForKey:@"token"];
                [self startRequestOnekeyLoginWithToken:token];
            }
        });
    }];
}

- (void)startRequestOnekeyLoginWithToken:(NSString *)token{
    [UleMBProgressHUD showHUDWithText:@""];
    [[US_NetworkExcuteManager uleAPIRequestClient] beginRequest:[US_LoginApi buildOnekeyLoginWithToken:token] success:^(id responseObject) {
        NSDictionary * dic=[self logInDecryptData:responseObject];
//        [self saveUserInfoToLocalWithData:dic];
//        [CLShanYanSDKManager finishAuthControllerCompletion:^{
//            [UleMBProgressHUD hideHUD];
            [[US_LoginManager sharedManager] logInToMainviewWithData:dic fromType:LogInMainViewTypeFromLogin];
//        }];
    } failure:^(UleRequestError *error) {
        if (error.error.code == 70520||error.error.code == 70407) {
            [UleMBProgressHUD showHUDWithText:[NSString stringWithFormat:@"暂停开放注册！您可找%@店主推荐邀请，即可开通",[DeviceInfoHelper getAppName]] afterDelay:2];
        }else{
            [UleMBProgressHUD showHUDWithText:[error.error.userInfo objectForKey:NSLocalizedDescriptionKey] afterDelay:showDelayTime];
        }
        [CLShanYanSDKManager finishAuthControllerCompletion:nil];
    }];
}

#pragma mark - <getter and setter>
- (CLUIConfigure * )baseUIConfigure{
    if (!_baseUIConfigure) {
        _baseUIConfigure = [CLUIConfigure new];
        _baseUIConfigure.viewController = [UIViewController currentViewController];
        _baseUIConfigure.clLogoImage = [UIImage imageNamed:@"US_icon.png"];
        _baseUIConfigure.clLogoCornerRadius=@(10*kscreenScale);
        _baseUIConfigure.clAppPrivacyFirst = @[@"《服务协议与隐私政策》",[NSURL URLWithString:[UleStoreGlobal shareInstance].config.serverProtocol]];
        _baseUIConfigure.clShanYanSloganHidden=@1;
        _baseUIConfigure.clNavigationAttributesTitleText=[[NSMutableAttributedString alloc] initWithString:@"登录/注册"];
        _baseUIConfigure.clLoginBtnText=@"";
        _baseUIConfigure.clLoginBtnNormalBgImage=[UIImage bundleImageNamed:@"btn_OneClick_login"];
        _baseUIConfigure.clCheckBoxCheckedImage=[UIImage bundleImageNamed:@"login_agree"];
        _baseUIConfigure.clCheckBoxUncheckedImage=[UIImage bundleImageNamed:@"login_unagree"];
        _baseUIConfigure.clLoginBtnTextColor=[UIColor whiteColor];
        _baseUIConfigure.manualDismiss=@YES;
        @weakify(self);
        _baseUIConfigure.customAreaView = ^(UIView * _Nonnull customAreaView) {
            @strongify(self);
        UIButton * otherType=[[UIButton alloc] initWithFrame:CGRectMake((__MainScreen_Width-345*kscreenScale)/2.0, __MainScreen_Height/2.0+55*kscreenScale, 345*kscreenScale, 45*kscreenScale)];
        otherType.titleLabel.font=[UIFont boldSystemFontOfSize:17*kscreenScale];
        otherType.layer.cornerRadius=(45*kscreenScale)/2.0;
        otherType.layer.borderWidth=0.7;
        otherType.tintColor=[UIColor convertHexToRGB:@"dddddd"];
        [otherType setTitle:@"其他登录方式" forState:UIControlStateNormal];
        [otherType setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [customAreaView addSubview:otherType];
        [otherType addTarget:self action:@selector(showotherLoginType:) forControlEvents:UIControlEventTouchUpInside];
        };
    }
    _baseUIConfigure.viewController = [UIViewController currentViewController];
    return _baseUIConfigure;
}
- (CLOrientationLayOut *)clOrientationLayOutPortrait{
    if (!_clOrientationLayOutPortrait) {
        _clOrientationLayOutPortrait = [CLOrientationLayOut new];
        //logo
        _clOrientationLayOutPortrait.clLayoutLogoWidth=@(110*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLogoHeight=@(110*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLogoCenterX=@(0*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLogoTop=@(100*kscreenScale);
        //手机号码
        _clOrientationLayOutPortrait.clLayoutPhoneCenterX=@(0*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutPhoneTop=@(230*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutPhoneWidth=@(200);
        _clOrientationLayOutPortrait.clLayoutPhoneHeight=@(40);
        //登录按键
        _clOrientationLayOutPortrait.clLayoutLoginBtnCenterX=@(0*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLoginBtnCenterY=@(20*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLoginBtnHeight=@(45*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutLoginBtnWidth=@(345*kscreenScale);
        //运营商授权
        _clOrientationLayOutPortrait.clLayoutSloganCenterX=@(0*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutSloganTop=@(__MainScreen_Height-100);
        //协议
        _clOrientationLayOutPortrait.clLayoutAppPrivacyCenterX=@(0*kscreenScale);
        _clOrientationLayOutPortrait.clLayoutAppPrivacyBottom=@(0);
        _clOrientationLayOutPortrait.clLayoutAppPrivacyHeight= @(75);
        _clOrientationLayOutPortrait.clLayoutAppPrivacyWidth=@(__MainScreen_Width-60);
    }
    return _clOrientationLayOutPortrait;
}

@end
