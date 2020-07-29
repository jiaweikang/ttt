//
//  US_SettingPayPasswordVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/11.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_SettingPayPasswordVC.h"
#import "SettingPayPwdView.h"
#import <NSString+Utility.h>
#import "US_UserCenterApi.h"
#import "US_CartoonAlertView.h"
#import <UIView+ShowAnimation.h>

@interface US_SettingPayPasswordVC ()
@property (nonatomic, strong) SettingPayPwdView * payPwdSetView;
@property (nonatomic, assign) BOOL isModify;     //判断是忘记密码还是修改密码  0-忘记 重设密码  1-修改密码

@end

@implementation US_SettingPayPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
    [self.uleCustemNavigationBar customTitleLabel:title];
    }
    else{
        [self.uleCustemNavigationBar customTitleLabel:@"设置新支付密码"];
    }
    self.isModify = [[self.m_Params objectForKey:@"isModify"] boolValue];
    [self setUI];
    if (!self.isModify) {//如果是修改密码
        [self.payPwdSetView.sendCodeButton startWithSecond:60];
    }
    @weakify(self);
    [self.payPwdSetView.sendCodeButton addClickBlock:^(US_SMSCodeButton *sender) {
        @strongify(self);
        [self.view endEditing:YES];
        if (self.isModify) {
            [self requestReplacePayPwdSMSCode];//发送修改密码 短信验证码
        }
        else{
            [self requestResetPayPwdSMSCode];//发送重设密码 短信验证码
        }
    } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
        return @"获取验证码";
    }];
    
    self.payPwdSetView.confirmBlock = ^{
        @strongify(self);
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"支付密码修改" networkdetail:@""];
        [self confirmSettingPayPwdRequest];
    };
}

- (void) setUI{
    UILabel * phoneTitleLab = [UILabel new];
    phoneTitleLab.text = @"手机号";
    phoneTitleLab.textColor = [UIColor convertHexToRGB:@"333333"];
    phoneTitleLab.font = [UIFont systemFontOfSize:14];
    UILabel * phoneLab = [UILabel new];
    if ([US_UserUtility sharedLogin].m_mobileNumber .length>10) {
        phoneLab.text = [NSString replaceStringWithAsterisk:[US_UserUtility sharedLogin].m_mobileNumber startLocation:3 lenght:4];
    }
    phoneLab.textColor = [UIColor convertHexToRGB:@"333333"];
    phoneLab.font = [UIFont systemFontOfSize:14];
    [self.view sd_addSubviews:@[phoneTitleLab,phoneLab,self.payPwdSetView]];
    phoneTitleLab.sd_layout
    .leftSpaceToView(self.view, 15)
    .topSpaceToView(self.uleCustemNavigationBar, 30)
    .heightIs(44)
    .widthIs(75);
    phoneLab.sd_layout
    .topEqualToView(phoneTitleLab)
    .leftSpaceToView(phoneTitleLab, 10)
    .rightSpaceToView(self.view, 15)
    .heightRatioToView(phoneTitleLab, 1);
    self.payPwdSetView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(phoneLab, 10)
    .bottomSpaceToView(self.view, 0);
}

- (void) confirmSettingPayPwdRequest{
    @weakify(self);
    US_CartoonAlertView *alertView = [US_CartoonAlertView cartoonAlertViewWithMessage:@"确定提交新密码修改吗?" confirmBlock:^{
         @strongify(self);
        if (self.isModify) {
            //修改密码
            [self requestReplacePayPwd];
        }
        else{
            //重置密码
            [self requestResetPayPwd];
        }
    }];
    [alertView showViewWithAnimation:AniamtionPresentBottom];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"" moduledesc:@"支付密码修改" networkdetail:@""];
}

#pragma mark 网络请求
//获取短信验证码（修改密码）
- (void)requestReplacePayPwdSMSCode{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildSendReplacePayPwdSMSCodeRequest] success:^(id responseObject) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:showDelayTime];
        [self.payPwdSetView.sendCodeButton startWithSecond:60];
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.payPwdSetView.sendCodeButton stop];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}

//修改支付密码请求
- (void) requestReplacePayPwd{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildReplacePayPwdRequestWithSMSCode:self.payPwdSetView.codeTextField.text NewPwd:self.payPwdSetView.pwdTextField.text OldPwd:self.payPwdSetView.oldPwdTextField.text] success:^(id responseObject) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"支付密码修改成功" afterDelay:showDelayTime withTarget:self dothing:@selector(goBack)];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}


//获取短信验证码（重设密码）
- (void) requestResetPayPwdSMSCode{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildSendResetPayPwdSMSCodeRequest] success:^(id responseObject) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:showDelayTime];
        [self.payPwdSetView.sendCodeButton startWithSecond:60];
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.payPwdSetView.sendCodeButton stop];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}

//重置支付密码请求
- (void) requestResetPayPwd{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildResetPayPwdRequestWithSMSCode:self.payPwdSetView.codeTextField.text NewPwd:self.payPwdSetView.pwdTextField.text] success:^(id responseObject) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"支付密码重置成功" afterDelay:showDelayTime withTarget:self dothing:@selector(goBack)];
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
- (SettingPayPwdView *)payPwdSetView{
    if (!_payPwdSetView) {
        _payPwdSetView=[[SettingPayPwdView alloc]initWithWithViewType:self.isModify?SettingPayPwdTypeModify:SettingPayPwdTypeSettingNew];
        _payPwdSetView.rootViewController = self;
    }
    return _payPwdSetView;
}

@end
