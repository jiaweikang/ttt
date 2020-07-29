//
//  US_SettingPasswordVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/18.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_SettingPasswordVC.h"
#import "SettingPwdView.h"
#import "US_UserCenterApi.h"
#import "US_CartoonAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_LoginManager.h"

@interface US_SettingPasswordVC ()
@property (nonatomic, strong) SettingPwdView * pwdSetView;
@end

@implementation US_SettingPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else{
        [self.uleCustemNavigationBar customTitleLabel:@"设置新密码"];
    }
    
    [self.view addSubview:self.pwdSetView];
    self.pwdSetView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.pwdSetView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    
    NSString * phoneNumString = [self.m_Params  objectForKey:@"phoneNum"];
    if (phoneNumString.length > 0) {
        self.pwdSetView.phoneTextField.text=phoneNumString;
    }
    //登录状态修改密码 不显示手机号输入框 进入页面前已经发送短信
    if ([US_UserUtility sharedLogin].mIsLogin) {
        [self.pwdSetView.sendCodeButton startWithSecond:60];
    }
    
    @weakify(self);
    [self.pwdSetView.sendCodeButton addClickBlock:^(US_SMSCodeButton *sender) {
        @strongify(self);
        [self.view endEditing:YES];
            [self resetPwdSendSMSCodeRequest];//发送修改密码 短信验证码
    } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
        return @"获取验证码";
    }];
    
    self.pwdSetView.confirmBlock = ^{
        @strongify(self);
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"修改密码" networkdetail:@""];
        
        [self confirmSettingPwdShowAlert];
    };
}

- (void) resetPwdSendSMSCodeRequest{
    NSString * phoneNumString = self.pwdSetView.phoneTextField.text;
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildSendSMSCodeForChangePwdRequestWithPhoneNum:phoneNumString.length>0?phoneNumString:@""] success:^(id responseObject) {
        
        [UleMBProgressHUD hideHUDForView:self.view];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:showDelayTime];
        [self.pwdSetView.sendCodeButton startWithSecond:60];
        
    } failure:^(UleRequestError *error) {
        
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}

- (void) confirmSettingPwdShowAlert{
    @weakify(self);
    US_CartoonAlertView *alertView = [US_CartoonAlertView cartoonAlertViewWithMessage:@"确定提交新密码修改吗?" confirmBlock:^{
        @strongify(self);
        [self RequestSettingPwd];
    }];
    [alertView showViewWithAnimation:AniamtionPresentBottom];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"" moduledesc:@"修改密码" networkdetail:@""];
}

- (void)RequestSettingPwd{
    NSString * phoneNumString = self.pwdSetView.phoneTextField.text;
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildChangePwdRequestWithPhoneNum:phoneNumString SMSCode:self.pwdSetView.codeTextField.text NewPwd:self.pwdSetView.pwdTextField.text] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        if ([US_UserUtility sharedLogin].mIsLogin) {
            NSLog(@"重置密码成功");

            [US_LoginManager logOutToLoginWithMessage:@"请登录"];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(UleRequestError *error) {
        
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}

- (void) goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter and getter
- (SettingPwdView *)pwdSetView{
    if (!_pwdSetView) {
        _pwdSetView=[[SettingPwdView alloc]initWithWithViewType:[US_UserUtility sharedLogin].mIsLogin?SettingPwdTypeLogined:SettingPwdTypeUnlogin];
        _pwdSetView.rootViewController = self;
    }
    return _pwdSetView;
}

@end
