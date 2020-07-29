//
//  LoginTopView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/5.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "LoginTopView.h"
#import <SDAutoLayout.h>
#import "US_SMSCodeButton.h"
#import "NSString+Utility.h"

@interface LoginTopView ()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger p_loginType;//0-验证码登录 1-密码登录
@property (nonatomic, strong) UIImageView * topIconImg;
@property (strong, nonatomic) UIButton      *codeLoginBtn;//验证码登录
@property (strong, nonatomic) UIButton      *passwdLoginBtn;//密码登录
@property (strong, nonatomic) UIImageView   *arrowImg;//更换登录方式的箭头

@property (strong, nonatomic) UITextField   *accountTF;      //账号输入框
@property (strong, nonatomic) UITextField   *passwordTF;     //密码输入框
@property (strong, nonatomic) UIButton      *accountClearBtn;  //账号输入框的清除按钮
@property (strong, nonatomic) UIButton      *passwdClearBtn; //密码输入框的清除按钮
@property (strong, nonatomic) US_SMSCodeButton *loginSmsCodeBtn;//登录的获取验证码按钮
@property (strong, nonatomic) UIButton      *eyeBtn;//眼睛按钮

@property (strong, nonatomic) UIButton *forgetPassBtn;//忘记密码
@property (strong, nonatomic) UIButton *loginButton;       //登录按钮
@property (strong, nonatomic) UIButton *protocolSelBtn;

@end

@implementation LoginTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    //上方背景图
    UIImageView *topBgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"login_img_topBg"]];
    topBgView.frame=CGRectMake(0, 0, CGRectGetWidth(self.frame), KScreenScale(400));
    topBgView.userInteractionEnabled=YES;
    [self addSubview:topBgView];
    [topBgView sd_addSubviews:@[self.codeLoginBtn,self.passwdLoginBtn,self.topIconImg,self.arrowImg]];
    self.codeLoginBtn.sd_layout.leftSpaceToView(topBgView, 0)
    .rightSpaceToView(topBgView, __MainScreen_Width*0.5)
    .bottomSpaceToView(topBgView, KScreenScale(20))
    .heightIs(KScreenScale(60));
    self.passwdLoginBtn.sd_layout.topEqualToView(self.codeLoginBtn)
    .bottomEqualToView(self.codeLoginBtn)
    .rightSpaceToView(topBgView,0)
    .leftSpaceToView(self.codeLoginBtn, 0);
    
    self.topIconImg.sd_layout.centerXEqualToView(topBgView)
    .bottomSpaceToView(topBgView, KScreenScale(120))
    .heightIs(KScreenScale(160))
    .widthEqualToHeight();

    self.arrowImg.center=CGPointMake(__MainScreen_Width*0.25, self.arrowImg.center.y);
    self.codeLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(35)];
    self.passwdLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];

    UIView *accountBg=[[UIView alloc]init];
    accountBg.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    [self addSubview:accountBg];
    accountBg.sd_layout.topSpaceToView(topBgView, KScreenScale(30))
    .leftSpaceToView(self, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(50);
    [accountBg addSubview:self.accountTF];
    [self showAccountTFClearBtn:NO];
    self.accountTF.text=[US_UserUtility sharedLogin].m_loginName;
    self.accountTF.sd_layout.topSpaceToView(accountBg, 0)
    .bottomSpaceToView(accountBg,0)
    .rightSpaceToView(accountBg,0)
    .leftSpaceToView(accountBg, KScreenScale(30));

    UIView *passwdBg=[[UIView alloc]init];
    passwdBg.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    [self addSubview:passwdBg];
    passwdBg.sd_layout.topSpaceToView(accountBg, KScreenScale(30))
    .leftEqualToView(accountBg)
    .rightEqualToView(accountBg)
    .heightRatioToView(accountBg, 1.0);

    [passwdBg addSubview:self.loginSmsCodeBtn];
    self.loginSmsCodeBtn.sd_layout.topSpaceToView(passwdBg, 0)
    .rightSpaceToView(passwdBg,0)
    .bottomSpaceToView(passwdBg, 0)
    .widthIs(KScreenScale(230));

    [passwdBg addSubview:self.passwordTF];
    self.passwordTF.sd_layout.topSpaceToView(passwdBg, 0)
    .bottomSpaceToView(passwdBg, 0)
    .leftSpaceToView(passwdBg, KScreenScale(30))
    .rightSpaceToView(self.loginSmsCodeBtn, 0);

    _passwordTF.keyboardType=UIKeyboardTypeNumberPad;
    _passwordTF.placeholder=@"请输入验证码";
    _passwordTF.secureTextEntry=NO;

    //忘记密码
    [self addSubview:self.forgetPassBtn];
    self.forgetPassBtn.sd_layout.topSpaceToView(passwdBg, KScreenScale(36))
    .rightSpaceToView(self, KScreenScale(30))
    .widthIs(80)
    .heightIs(25);
    self.forgetPassBtn.hidden=YES;

    [self addSubview:self.protocolSelBtn];
    UILabel *protocolLab = [[UILabel alloc]init];
    protocolLab.text = @"我已阅读并同意";
    protocolLab.textColor = [UIColor convertHexToRGB:@"666666"];
    protocolLab.font = [UIFont systemFontOfSize:15];
    [self addSubview:protocolLab];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"《服务协议与隐私政策》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attributedStr.length)];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
    [detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    [detailBtn addTarget:self action:@selector(protocolDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    //约束
    CGFloat proLabW = [protocolLab.text widthForFont:protocolLab.font]+2;
    CGFloat detailBtnW = [detailBtn.titleLabel.text widthForFont:detailBtn.titleLabel.font]+5;
    self.protocolSelBtn.sd_layout.topSpaceToView(_forgetPassBtn, KScreenScale(40))
    .leftEqualToView(passwdBg)
    .widthIs(30)
    .heightIs(30);
    protocolLab.sd_layout.centerYEqualToView(self.protocolSelBtn)
    .leftSpaceToView(self.protocolSelBtn, 2.0)
    .widthIs(proLabW)
    .heightIs(20);
    detailBtn.sd_layout.centerYEqualToView(protocolLab)
    .leftSpaceToView(protocolLab, 2.0)
    .heightIs(20)
    .widthIs(detailBtnW);
    [self addSubview:self.loginButton];
    self.loginButton.sd_layout.topSpaceToView(self.protocolSelBtn, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(45);
}

- (void)stopSMSCodeCounting
{
    [self.loginSmsCodeBtn stop];
}

- (void)protocolSelBtnAction:(UIButton *)sender
{
    self.protocolSelBtn.selected=!self.protocolSelBtn.isSelected;
}

- (void)protocolDetailBtnAction:(UIButton *)sender
{
    NSMutableDictionary *params=@{@"protocol":[UleStoreGlobal shareInstance].config.serverProtocol}.mutableCopy;
    [[UIViewController currentViewController] pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:params];
}

#pragma mark - Actions
//获取验证码
- (void)getLoginSMSCode
{
    if (self.accountTF.text.length == 0) {
        [self.loginSmsCodeBtn stop];
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请输入您的手机号" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:_accountTF.text]) {
        [self.loginSmsCodeBtn stop];
        [UleMBProgressHUD showHUDAddedTo:self withText:@"手机号码格式错误" afterDelay:1.5];
        return;
    };
    [self endEditing:YES];
    if (self.p_delegate&&[self.p_delegate respondsToSelector:@selector(loginTopViewGetSMSCodeByAccountNum:)]) {
        [self.p_delegate loginTopViewGetSMSCodeByAccountNum:[NSString stringWithFormat:@"%@", self.accountTF.text]];
    }
}

//忘记密码跳转
- (void)forgetPasswdAction {
    NSMutableDictionary *params = @{@"isModify":@"0"}.mutableCopy;
    if (_accountTF.text.length>0&&[NSString isMobileNum:_accountTF.text]) {
        [params setObject:[NSString stringWithFormat:@"%@",_accountTF.text] forKey:@"phoneNum"];
    }
    if (self.p_delegate&&[self.p_delegate respondsToSelector:@selector(loginTopViewGoToSettingPasswordVCByAccountNum:)]) {
        [self.p_delegate loginTopViewGoToSettingPasswordVCByAccountNum:[NSString stringWithFormat:@"%@", self.accountTF.text]];
    }
}

//登录
- (void)loginBtnAction{
    [self endEditing:YES];
    if (self.p_loginType==0) {//验证码登录
        [self clickToLoginByCode];
    }else if (self.p_loginType==1) {//密码登录
        [self clickToLoginByPasswd];
    }
}

/**
 *  使用验证码登录
 */
- (void)clickToLoginByCode{
    
    if (_accountTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请输入您的手机号" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:_accountTF.text]) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"手机号码格式错误" afterDelay:1.5];
        return;
    };
    if (_passwordTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请输入验证码" afterDelay:1.5];
        return;
    }
    if (!self.protocolSelBtn.isSelected) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请阅读并同意《服务协议与隐私政策》" afterDelay:1.5];
        return;
    }
    if (self.p_delegate&&[self.p_delegate respondsToSelector:@selector(loginTopViewLoginByAccountNum:smsCode:)]) {
        [self.p_delegate loginTopViewLoginByAccountNum:[NSString stringWithFormat:@"%@", self.accountTF.text] smsCode:[NSString stringWithFormat:@"%@", self.passwordTF.text]];
    }
}

/**
 *  使用密码登录
 */
- (void)clickToLoginByPasswd {
    if (_accountTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请输入您的手机号" afterDelay:1.5];
        return;
    }
    if (_passwordTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请输入密码" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:_accountTF.text]) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"手机号码格式错误" afterDelay:1.5];
        return;
    }
    if (!self.protocolSelBtn.isSelected) {
        [UleMBProgressHUD showHUDAddedTo:self withText:@"请阅读并同意《服务协议与隐私政策》" afterDelay:1.5];
        return;
    }
    if (self.p_delegate&&[self.p_delegate respondsToSelector:@selector(loginTopViewLoginByAccountNum:passWord:)]) {
        [self.p_delegate loginTopViewLoginByAccountNum:[NSString stringWithFormat:@"%@", self.accountTF.text] passWord:[NSString stringWithFormat:@"%@", self.passwordTF.text]];
    }
}

//是否隐藏密码输入
- (void)securityEnter:(id)sender{
    UIButton *btn=sender;
    if (_passwordTF.secureTextEntry) {
        [btn setImage:[UIImage bundleImageNamed:@"login_btn_eye_open"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry=NO;
    }else{
        [btn setImage:[UIImage bundleImageNamed:@"login_btn_eye_close"] forState:UIControlStateNormal];
        _passwordTF.secureTextEntry=YES;
    }
    //为了去除密文切换明文后的空格
    NSString *text=_passwordTF.text;
    self.passwordTF.text=@" ";
    self.passwordTF.text=text;
}

- (void)passClearAction {
    _passwordTF.text=@"";
    [self showPasswdTFClearBtn:NO];
}

- (void)accClearAction {
    _accountTF.text=@"";
    [self showAccountTFClearBtn:NO];
}
- (void)showAccountTFClearBtn:(BOOL)isShow {
    self.accountClearBtn.hidden=!isShow;
}

//密码输入框清除按钮
- (void)showPasswdTFClearBtn:(BOOL)isShow {
    if (isShow) {//显示
        if (self.passwdClearBtn.hidden==NO) {//已经显示
            return;
        }
        self.passwdClearBtn.hidden=NO;
        CGRect rightFrame = _passwordTF.rightView.frame;
        rightFrame.size.width=75;
        _passwordTF.rightView.frame=rightFrame;
        CGRect eyeRect=self.eyeBtn.frame;
        eyeRect.origin.x=30;
        self.eyeBtn.frame=eyeRect;
        
    }else {//隐藏
        if (self.passwdClearBtn.hidden==YES) {//已经隐藏
            return;
        }
        self.passwdClearBtn.hidden=YES;
        CGRect rightFrame = _passwordTF.rightView.frame;
        rightFrame.size.width=45;
        _passwordTF.rightView.frame=rightFrame;
        CGRect eyeRect=self.eyeBtn.frame;
        eyeRect.origin.x=0;
        self.eyeBtn.frame=eyeRect;
    }
}

- (void)shiftLoginType:(UIButton *)sender
{
    [self endEditing:YES];
    @weakify(self);
    if (_p_loginType==0) {
        //验证码登录
        if (sender==self.codeLoginBtn) return;
        CGPoint arrowCenter=self.arrowImg.center;
        arrowCenter.x=__MainScreen_Width*0.75;
        [UIView animateWithDuration:0.1 animations:^{
            @strongify(self);
            self.arrowImg.center=arrowCenter;
        } completion:^(BOOL finished) {
            @strongify(self);
            self.p_loginType=1;
            self.codeLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];
            self.passwdLoginBtn.titleLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(35)];
            self.passwordTF.text=@"";
            self.passwordTF.placeholder=@"请输入密码";
            self.passwordTF.keyboardType=UIKeyboardTypeASCIICapable;
            self.loginSmsCodeBtn.sd_layout.widthIs(0);
            [self.passwordTF updateLayout];

            UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 40)];
            [rightView addSubview:self.passwdClearBtn];
            [self.eyeBtn setImage:[UIImage bundleImageNamed:@"login_btn_eye_close"] forState:UIControlStateNormal];
            self.eyeBtn.frame=CGRectMake(0, 0, 40, 40);
            [rightView addSubview:weak_self.eyeBtn];
            self.passwordTF.rightView=rightView;
            self.passwordTF.rightViewMode=UITextFieldViewModeAlways;
            self.passwordTF.secureTextEntry=YES;
            [self showPasswdTFClearBtn:NO];//隐藏
            self.forgetPassBtn.hidden=NO;
        }];

    }else if (_p_loginType==1) {
        //密码登录
        if (sender==self.passwdLoginBtn) return;
        CGPoint arrowCenter=self.arrowImg.center;
        arrowCenter.x=__MainScreen_Width*0.25;
        [UIView animateWithDuration:0.1 animations:^{
            @strongify(self);
            self.arrowImg.center=arrowCenter;
        } completion:^(BOOL finished) {
            @strongify(self);
            self.p_loginType=0;
            self.codeLoginBtn.titleLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(35)];
            self.passwdLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];
            self.passwordTF.text=@"";
            self.passwordTF.placeholder=@"请输入验证码";
            self.passwordTF.keyboardType=UIKeyboardTypeNumberPad;
            self.loginSmsCodeBtn.sd_layout.widthIs(KScreenScale(230));
            [self.passwordTF updateLayout];
            self.passwordTF.rightView=nil;
            self.passwordTF.secureTextEntry=NO;
            self.forgetPassBtn.hidden=YES;
        }];
    }
}

#pragma mark - textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==_accountTF) {
        if (_accountTF.text.length>0) {
            [self showAccountTFClearBtn:YES];
        }else [self showAccountTFClearBtn:NO];
    }else if (textField==_passwordTF) {
        if (_passwordTF.text.length>0) {
            [self showPasswdTFClearBtn:YES];
        }else [self showPasswdTFClearBtn:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    
    if (textField == _accountTF)
    {
        return length<=11;
    }
    else if (textField == _passwordTF) {
        if (_p_loginType==0) return length<=6;
        else if (_p_loginType==1) return length<=20;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self showAccountTFClearBtn:NO];
    [self showPasswdTFClearBtn:NO];
}

//输入完的通知方法
- (void)textFiledEditChanged:(NSNotification *)not {
    UITextField *textField = not.object;
    if (textField==_accountTF) {
        if (_accountTF.text.length>0) {
            [self showAccountTFClearBtn:YES];
        }else [self showAccountTFClearBtn:NO];
    }else if (textField==_passwordTF) {
        if (_passwordTF.text.length>0) {
            [self showPasswdTFClearBtn:YES];
        }else [self showPasswdTFClearBtn:NO];
    }
}

#pragma mark - getters
- (UIButton *)codeLoginBtn
{
    if (!_codeLoginBtn) {
        _codeLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _codeLoginBtn.backgroundColor=[UIColor clearColor];
        [_codeLoginBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_codeLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(35)];
        [_codeLoginBtn addTarget:self action:@selector(shiftLoginType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeLoginBtn;
}

- (UIButton *)passwdLoginBtn
{
    if (!_passwdLoginBtn) {
        _passwdLoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _passwdLoginBtn.backgroundColor=[UIColor clearColor];
        [_passwdLoginBtn setTitle:@"密码登录" forState:UIControlStateNormal];
        [_passwdLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _passwdLoginBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(35)];
        [_passwdLoginBtn addTarget:self action:@selector(shiftLoginType:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwdLoginBtn;
}

- (UIImageView *)arrowImg
{
    if (!_arrowImg) {
        _arrowImg=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"login_img_arrow"]];
        _arrowImg.frame=CGRectMake(0, KScreenScale(400)-KScreenScale(16), KScreenScale(22), KScreenScale(16));
    }
    return _arrowImg;
}

- (UITextField *)accountTF
{
    if (!_accountTF) {
        _accountTF = [[UITextField alloc]init];
        _accountTF.backgroundColor=[UIColor clearColor];
        _accountTF.keyboardType=UIKeyboardTypeNumberPad;
        _accountTF.font=[UIFont systemFontOfSize:16];
        _accountTF.textColor=[UIColor convertHexToRGB:@"333333"];
        _accountTF.delegate = self;
        _accountTF.placeholder=@"请输入您的手机号";
        _accountTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_accountTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_accountTF];
        UIView *rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 45, 40)];
        [rightView addSubview:self.accountClearBtn];
        _accountTF.rightView=rightView;
        _accountTF.rightViewMode=UITextFieldViewModeAlways;
    }
    return _accountTF;
}

- (UIButton *)accountClearBtn
{
    if (!_accountClearBtn) {
        _accountClearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _accountClearBtn.frame=CGRectMake(0, 0, 40, 40);
        [_accountClearBtn setImage:[UIImage bundleImageNamed:@"login_btn_accountClear"] forState:UIControlStateNormal];
        [_accountClearBtn addTarget:self action:@selector(accClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountClearBtn;
}

- (US_SMSCodeButton *)loginSmsCodeBtn
{
    if (!_loginSmsCodeBtn) {
        _loginSmsCodeBtn = [US_SMSCodeButton buttonWithType:UIButtonTypeCustom];
        _loginSmsCodeBtn.btnNormalColor=[UIColor convertHexToRGB:@"2da4f1"];
        _loginSmsCodeBtn.btnCountDownColor=[UIColor convertHexToRGB:@"b9b9b9"];
        [_loginSmsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _loginSmsCodeBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _loginSmsCodeBtn.normalColor=[UIColor convertHexToRGB:@"ffffff"];
        _loginSmsCodeBtn.countDownColor=[UIColor convertHexToRGB:@"ffffff"];
        @weakify(self);
        [_loginSmsCodeBtn addClickBlock:^(US_SMSCodeButton *sender) {
            [sender startWithSecond:60];
            [weak_self getLoginSMSCode];
        } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
            return @"获取验证码";
        }];
    }
    return _loginSmsCodeBtn;
}

- (UITextField *)passwordTF
{
    if (!_passwordTF) {
        _passwordTF=[[UITextField alloc]init];
        _passwordTF.backgroundColor=[UIColor clearColor];
        _passwordTF.font=[UIFont systemFontOfSize:16];
        _accountTF.textColor=[UIColor convertHexToRGB:@"333333"];
        _passwordTF.delegate = self;
        _passwordTF.placeholder=@"请输入验证码";
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_passwordTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_passwordTF];
    }
    return _passwordTF;
}

- (UIButton *)passwdClearBtn
{
    if (!_passwdClearBtn) {
        _passwdClearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_passwdClearBtn setImage:[UIImage bundleImageNamed:@"login_btn_accountClear"] forState:UIControlStateNormal];
        _passwdClearBtn.frame=CGRectMake(0, 0, 30, 40);
        [_passwdClearBtn addTarget:self action:@selector(passClearAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwdClearBtn;
}

- (UIButton *)eyeBtn
{
    if (!_eyeBtn) {
        _eyeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeBtn setImageEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
        [_eyeBtn addTarget:self action:@selector(securityEnter:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn;
}

- (UIButton *)forgetPassBtn
{
    if (!_forgetPassBtn) {
        self.forgetPassBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.forgetPassBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [self.forgetPassBtn setTitleColor:[UIColor convertHexToRGB:@"36a4f1"] forState:UIControlStateNormal];
        self.forgetPassBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.forgetPassBtn addTarget:self action:@selector(forgetPasswdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPassBtn;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font=[UIFont systemFontOfSize:17];
        [_loginButton setBackgroundImage:[UIImage bundleImageNamed:@"login_btn_login_normal"] forState:UIControlStateNormal];
        [_loginButton setBackgroundImage:[UIImage bundleImageNamed:@"login_btn_login_pressed"] forState:UIControlStateHighlighted];
        [_loginButton addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
- (UIButton *)protocolSelBtn{
    if (!_protocolSelBtn) {
        _protocolSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolSelBtn setImage:[UIImage bundleImageNamed:@"regist_btn_protocol_normal"] forState:UIControlStateNormal];
        [_protocolSelBtn setImage:[UIImage bundleImageNamed:@"regist_btn_protocol_selected"] forState:UIControlStateSelected];
        [_protocolSelBtn addTarget:self action:@selector(protocolSelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolSelBtn;
}
- (UIImageView *)topIconImg{
    if (!_topIconImg) {
        _topIconImg=[[UIImageView alloc] init];
        _topIconImg.image=[UIImage imageNamed:@"US_icon"];
        _topIconImg.layer.cornerRadius=KScreenScale(10);
        _topIconImg.clipsToBounds=YES;
    }
    return _topIconImg;
}
@end
