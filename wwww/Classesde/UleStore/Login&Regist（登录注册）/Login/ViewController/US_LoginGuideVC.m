//
//  US_loginGuideViewController.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_LoginGuideVC.h"
#import "LoginGuideView.h"
#import "US_LoginManager.h"
#import <UleReachability.h>
#import "US_LoginApi.h"
#import "US_LoginManager.h"
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
@implementation USLoginNaviController

- (void)viewDidLoad
{
    [super viewDidLoad];
    US_LoginGuideVC *guideVC = [[US_LoginGuideVC alloc]init];
    [self setViewControllers:@[guideVC]];
}

@end


@interface US_LoginGuideVC ()
@property (nonatomic, strong)UIButton           *registBtn;
@property (nonatomic, strong)UIButton           *loginBtn;
@property (nonatomic, assign)BOOL               isShowBtnAnimated;
@property (nonatomic, assign)BOOL               KouLingLoginRequesting;
@property (nonatomic, copy)NSString * pasteboardStr;
@end

@implementation US_LoginGuideVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //网络状态改变监测
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginGuideVCKouLingLogin) name:@"NetWorkChange" object:nil];
    //后台回前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginGuideVCKouLingLogin) name:AppWillEnterForeground object:nil];
    _isShowBtnAnimated=YES;
    [self hideCustomNavigationBar];
    [self addGuideScrollView];
    [self addBtns];
    [self getPasteboardString];
    [CLShanYanSDKManager preGetPhonenumber:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //动画
    if (_isShowBtnAnimated) {
        [self showBtnsAnimated];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isShowBtnAnimated=NO;
}

- (void)addGuideScrollView
{
    LoginGuideView *guideView=[[LoginGuideView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:guideView];
}

- (void)addBtns{
    if ([[UleStoreGlobal shareInstance].config.isShowRegistBtn boolValue]) {
        [self.view addSubview:self.registBtn];
        [self.view addSubview:self.loginBtn];
        self.registBtn.sd_layout.bottomSpaceToView(self.view, KScreenScale(70))
        .leftSpaceToView(self.view, KScreenScale(28))
        .widthIs(KScreenScale(326))
        .heightIs(KScreenScale(82));
        self.loginBtn.sd_layout.topEqualToView(_registBtn)
        .bottomEqualToView(_registBtn)
        .widthRatioToView(_registBtn, 1.0)
        .heightRatioToView(_registBtn, 1.0)
        .rightSpaceToView(self.view, KScreenScale(30));
    }else {
        [self.view addSubview:self.loginBtn];
        self.loginBtn.sd_layout.centerXEqualToView(self.view)
        .bottomSpaceToView(self.view, KScreenScale(70))
        .widthIs(KScreenScale(326))
        .heightIs(KScreenScale(82));
    }
}

#pragma mark - <Action>
- (void)loginBtnAction {
    [UleMbLogOperate addMbLogClick:@""
                          moduleid:@"登录"
                        moduledesc:@"ylxdapp_dl_kskd"
                     networkdetail:@""];
    
//    [self pushNewViewController:@"US_LoginVC" isNibPage:NO withData:nil];
    
     [US_LoginManager showLoginView];
}

- (void)registBtnAction {
    [UleMbLogOperate addMbLogClick:@""
                          moduleid:@"注册"
                        moduledesc:@"ylxdapp_zc_kskd"
                     networkdetail:@""];
   
    [self pushNewViewController:@"US_PreRegisterVC" isNibPage:NO withData:nil];
}

- (void)loginGuideVCKouLingLogin{
    [self getPasteboardString];
    
    if ([UleReachability  sharedManager].isReachable) {
        if (self.pasteboardStr.length > 0 && !_KouLingLoginRequesting) {
            _KouLingLoginRequesting=YES;
            [self loginTopViewQuickLogin:self.pasteboardStr];
        }
    }
}

//快捷登录
- (void)loginTopViewQuickLogin:(NSString *)kouLing{
    [UleMBProgressHUD showHUDWithText:@""];
    
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildQuickLoginWithKouLing:self.pasteboardStr] success:^(id responseObject) {
        @strongify(self);
        [self cleanPasteboardString];
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录引导" moduledesc:@"自动登录" networkdetail:@""];
        self.KouLingLoginRequesting=NO;
        
        [UleMBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [[US_LoginManager sharedManager] logInDecryptData:(NSDictionary *)responseObject];
            if (dic) {
                [[US_LoginManager sharedManager] logInToMainviewWithData:dic fromType:LogInMainViewTypeFromLogin];
            }
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        self.KouLingLoginRequesting=NO;
        [UleMBProgressHUD hideHUD];
        [self cleanPasteboardString];
    }];
}

- (void)getPasteboardString{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string.length > 0 && [pasteboard.string containsString:@"ylxd_h5_auto_register"]){
        self.pasteboardStr=pasteboard.string;
    }
}
//清空剪贴板内容
- (void)cleanPasteboardString{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if ([pasteboard.string isEqualToString:self.pasteboardStr]) {
        pasteboard.string=@"";
    }
    self.pasteboardStr = @"";
}


- (void)showBtnsAnimated{
    if (_registBtn) {
        self.registBtn.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.registBtn.hidden=NO;
        self.registBtn.alpha = 0.0;
        [UIView animateWithDuration:0.6f animations:^{
            self.registBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.registBtn.alpha=1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.registBtn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished2) {
                
            }];
        }];
    }
    if (_loginBtn) {
        self.loginBtn.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.loginBtn.hidden=NO;
        self.loginBtn.alpha = 0.0;
        [UIView animateWithDuration:0.6f animations:^{
            self.loginBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.loginBtn.alpha=1.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.loginBtn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished2) {
                
            }];
        }];
    }
}

#pragma mark - <getters>
- (UIButton *)registBtn{
    if (!_registBtn) {
        _registBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:kCommonRedColor forState:UIControlStateNormal];
        _registBtn.backgroundColor=[UIColor clearColor];
        _registBtn.layer.borderWidth=1.0;
        _registBtn.tintColor=kCommonRedColor;
        _registBtn.layer.cornerRadius=KScreenScale(40);
        [_registBtn addTarget:self action:@selector(registBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.hidden=YES;
    }
    return _registBtn;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.backgroundColor=kCommonRedColor;
        _loginBtn.layer.cornerRadius=KScreenScale(40);
        [_loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.hidden=YES;
    }
    return _loginBtn;
}

#pragma mark - <StatusBarHidden>
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
