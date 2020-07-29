//
//  SettingPayPwdView.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/13.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "SettingPayPwdView.h"
#import <UIView+SDAutoLayout.h>

@interface SettingPayPwdView ()<UITextFieldDelegate>
@property (nonatomic) SettingPayPwdType viewType;
//验证码
@property (nonatomic, strong) UILabel * codeLabel;
//旧密码
@property (nonatomic, strong) UILabel * oldPwdLabel;
@property (nonatomic, strong) UIImageView * oldPwdCorrectIcon;//右边输入正确或者错误提示icon
//新密码
@property (nonatomic, strong) UILabel * pwdLabel;
@property (nonatomic, strong) UIImageView * pwdCorrectIcon;
//确认密码
@property (nonatomic, strong) UILabel * confirmPwdLabel;
@property (nonatomic, strong) UIImageView * confirmPwdIcon;
//确认密码输入框底部提示文字
@property (nonatomic, strong) UILabel * tipsLabel;
//提交按钮
@property (nonatomic, strong) UIButton * submitButton;
@end

@implementation SettingPayPwdView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype) initWithWithViewType:(SettingPayPwdType )viewType{
    self= [super init];
    if (self) {
        self.viewType = viewType;
        
        [self setupView];
    }
    return self;
    
}

- (void) setupView{
    self.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
    [self sd_addSubviews:@[self.codeLabel,self.codeTextField,self.sendCodeButton,self.oldPwdLabel,self.oldPwdTextField,self.pwdLabel,self.pwdTextField,self.confirmPwdLabel,self.confirmPwdTextField,self.tipsLabel,self.submitButton]];
    self.codeLabel.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 0)
    .heightIs(40)
    .widthIs(75);
    self.sendCodeButton.sd_layout
    .rightSpaceToView(self, 15)
    .topEqualToView(self.codeLabel)
    .widthIs(110)
    .heightIs(40);
    self.codeTextField.sd_layout
    .leftSpaceToView(self.codeLabel, 0)
    .rightSpaceToView(self.sendCodeButton, 0)
    .topEqualToView(self.codeLabel)
    .bottomEqualToView(self.sendCodeButton);
    
    self.oldPwdLabel.sd_layout
    .leftEqualToView(self.codeLabel)
    .topSpaceToView(self.codeLabel, 30)
    .heightRatioToView(self.codeLabel, 1)
    .widthRatioToView(self.codeLabel, 1);
    self.oldPwdTextField.sd_layout
    .leftEqualToView(self.codeTextField)
    .rightSpaceToView(self, 15)
    .topEqualToView(self.oldPwdLabel)
    .bottomEqualToView(self.oldPwdLabel);
    
    self.pwdLabel.sd_layout
    .leftEqualToView(self.oldPwdLabel)
    .topSpaceToView(self.oldPwdLabel, 10)
    .heightRatioToView(self.codeTextField, 1)
    .widthRatioToView(self.oldPwdLabel, 1);
    self.pwdTextField.sd_layout
    .leftEqualToView(self.oldPwdTextField)
    .topEqualToView(self.pwdLabel)
    .heightRatioToView(self.codeTextField, 1)
    .widthRatioToView(self.oldPwdTextField, 1);
    
    self.confirmPwdLabel.sd_layout
    .leftEqualToView(self.pwdLabel)
    .topSpaceToView(self.pwdLabel, 10)
    .heightRatioToView(self.pwdLabel, 1)
    .widthRatioToView(self.pwdLabel, 1);
    self.confirmPwdTextField.sd_layout
    .leftEqualToView(self.pwdTextField)
    .topEqualToView(self.confirmPwdLabel)
    .heightRatioToView(self.pwdTextField, 1)
    .widthRatioToView(self.pwdTextField, 1);
    
    self.tipsLabel.sd_layout
    .leftEqualToView(self.confirmPwdTextField)
    .topSpaceToView(self.confirmPwdTextField, 10)
    .widthRatioToView(self.confirmPwdTextField, 1)
    .heightIs(20);
    
    self.submitButton.sd_layout
    .leftSpaceToView(self, 15)
    .bottomSpaceToView(self, 45)
    .rightSpaceToView(self, 15)
    .heightIs(45);
    
    if (self.viewType == SettingPayPwdTypeSettingNew) {//找回密码 不显示 旧密码输入框
        self.oldPwdLabel.sd_layout.heightIs(0);
        self.oldPwdTextField.sd_layout.heightIs(0);
    }
    
    
}

#pragma mark - 提交按钮点击
- (void)submitButtonClick:(UIButton *)button{
    if ([self.pwdTextField.text isEqualToString:self.oldPwdTextField.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:@"新旧密码不可相同" afterDelay:showDelayTime];
        return;
    }
    if (self.pwdTextField.text.length<6 || self.pwdTextField.text.length>20 ) {
        [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:@"请输入6-20位字母和数字组合" afterDelay:showDelayTime];
        return;
    }
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self setAllowAuthorize:NO];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tmpTxt = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger Length = tmpTxt.length - range.length + string.length;
    
    if (textField == self.codeTextField) {
        return Length<=6;
    } else if (textField == self.pwdTextField) {
        return Length<=20;
    } else if (textField == self.confirmPwdTextField) {
        return Length<=20;
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    if (textField == self.oldPwdTextField) {
        if (toBeString.length>=6) {
            [self.oldPwdCorrectIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_right"]];
        }
        else if (toBeString.length == 0){
            [self.oldPwdCorrectIcon setImage:nil];
        }
        else{
            [self.oldPwdCorrectIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_wong"]];
        }
    }
    if (textField == self.pwdTextField) {
        if (toBeString.length>=6 && toBeString.length<=20) {
            [self.pwdCorrectIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_right"]];
        }
        else if (toBeString.length == 0){
            [self.pwdCorrectIcon setImage:nil];
        }
        else{
            [self.pwdCorrectIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_wong"]];
        }
        if (self.confirmPwdTextField.text.length > 0) {
            if (toBeString.length >= 6 && ![toBeString isEqualToString:self.confirmPwdTextField.text]) {
                self.tipsLabel.text=@"两次输入的密码不一致";
            }else{
                self.tipsLabel.text=@"";
            }
        }
    }
    if (textField == self.confirmPwdTextField) {
        if (toBeString.length>=6 && toBeString.length<=20 && [toBeString isEqualToString:self.pwdTextField.text]) {
            [self.confirmPwdIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_right"]];
        }
        else if (toBeString.length == 0){
            [self.confirmPwdIcon setImage:nil];
        }
        else{
            [self.confirmPwdIcon setImage:[UIImage bundleImageNamed:@"settingPayPassword_img_wong"]];
        }
        if (self.pwdTextField.text.length > 0) {
            if (toBeString.length >= 6 && ![toBeString isEqualToString:self.pwdTextField.text]) {
                self.tipsLabel.text=@"两次输入的密码不一致";
            }else{
                self.tipsLabel.text=@"";
            }
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.viewType == SettingPayPwdTypeSettingNew) {//找回 重设支付密码
        if (self.codeTextField.text.length > 0 && self.pwdTextField.text.length >=6&&self.pwdTextField.text.length <=20 && [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
            [self setAllowAuthorize:YES];
        }
        else{
            [self setAllowAuthorize:NO];
        }
    }
    else if (self.viewType == SettingPayPwdTypeModify) {//修改密码
        if (self.codeTextField.text.length > 0 && self.oldPwdTextField.text.length >=6 && self.pwdTextField.text.length >= 6 && self.pwdTextField.text.length <=20 && [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]) {
            [self setAllowAuthorize:YES];
        }
        else{
            [self setAllowAuthorize:NO];
        }
    }
}

/**
 *  配置确定认证按钮是否可点击和外观
 */
- (void)setAllowAuthorize:(BOOL)isAllow {
    
    if (isAllow)
    {
        self.submitButton.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
        self.submitButton.userInteractionEnabled = YES;
    }
    else
    {
        self.submitButton.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
        self.submitButton.userInteractionEnabled = NO;
    }
}

- (UILabel *)createLabel:(NSString *)title{
    UILabel * textLabel = [[UILabel alloc]init];
    textLabel.text = title;
    textLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    textLabel.font = [UIFont systemFontOfSize:14];
    return textLabel;
}
- (UITextField *)createTextFieldWithPlaceholderText:(NSString *)placeholderText KeyboardType:(UIKeyboardType )KeyboardType{
   UITextField * textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:14];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = KeyboardType;
    textField.backgroundColor = [UIColor convertHexToRGB:@"f1f1f1"];
    textField.returnKeyType = UIReturnKeyDone;
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:textField];
    return textField;
}

#pragma mark - setter and getter
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel=[self createLabel:@"验证码"];
    }
    return _codeLabel;
}
- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField=[self createTextFieldWithPlaceholderText:@"请输入验证码" KeyboardType:UIKeyboardTypeNumberPad];
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _codeTextField;
}
- (US_SMSCodeButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [[US_SMSCodeButton alloc]init];
        [_sendCodeButton setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _sendCodeButton.btnNormalColor = [UIColor convertHexToRGB:@"2da1f4"];
        _sendCodeButton.btnCountDownColor = [UIColor convertHexToRGB:@"b9b9b9"];
        _sendCodeButton.preTitle = @"60秒后重新获取";
    }
    return _sendCodeButton;
}

- (UILabel *)oldPwdLabel{
    if (!_oldPwdLabel) {
        _oldPwdLabel=[self createLabel:@"旧密码"];
    }
    return _oldPwdLabel;
}
- (UITextField *)oldPwdTextField{
    if (!_oldPwdTextField) {
        _oldPwdTextField=[self createTextFieldWithPlaceholderText:@"请输入6-20位字母和数字组合" KeyboardType:UIKeyboardTypeAlphabet];
        _oldPwdTextField.secureTextEntry=YES;
        _oldPwdTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _oldPwdCorrectIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _oldPwdTextField.rightView=_oldPwdCorrectIcon;
        _oldPwdTextField.rightViewMode=UITextFieldViewModeAlways;
    }
    return _oldPwdTextField;
}

- (UILabel *)pwdLabel{
    if (!_pwdLabel) {
        _pwdLabel=[self createLabel:@"新密码"];
    }
    return _pwdLabel;
}
- (UITextField *)pwdTextField{
    if (!_pwdTextField) {
        _pwdTextField=[self createTextFieldWithPlaceholderText:@"请输入6-20位字母和数字组合" KeyboardType:UIKeyboardTypeAlphabet];
        _pwdTextField.secureTextEntry=YES;
        _pwdTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _pwdCorrectIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _pwdTextField.rightView=_pwdCorrectIcon;
        _pwdTextField.rightViewMode=UITextFieldViewModeAlways;
    }
    return _pwdTextField;
}

- (UILabel *)confirmPwdLabel{
    if (!_confirmPwdLabel) {
        _confirmPwdLabel=[self createLabel:@"确认密码"];
    }
    return _confirmPwdLabel;
}
- (UITextField *)confirmPwdTextField{
    if (!_confirmPwdTextField) {
        _confirmPwdTextField=[self createTextFieldWithPlaceholderText:@"请重复一遍新密码" KeyboardType:UIKeyboardTypeAlphabet];
        _confirmPwdTextField.secureTextEntry=YES;
        _confirmPwdTextField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        _confirmPwdIcon=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        _confirmPwdTextField.rightView=_confirmPwdIcon;
        _confirmPwdTextField.rightViewMode=UITextFieldViewModeAlways;
    }
    return _confirmPwdTextField;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel=[self createLabel:@""];
        _tipsLabel.textColor=[UIColor convertHexToRGB:@"ef3c38"];
    }
    return _tipsLabel;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
        [_submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        _submitButton.userInteractionEnabled=NO;
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
@end
