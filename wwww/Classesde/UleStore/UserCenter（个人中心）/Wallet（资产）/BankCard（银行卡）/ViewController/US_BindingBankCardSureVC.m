//
//  US_BindingBankCardSureVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_BindingBankCardSureVC.h"
#import "US_SMSCodeButton.h"
#import <YYText/YYText.h>
#import "US_UserCenterApi.h"
#import <NSString+Utility.h>

@interface US_BindingBankCardSureVC ()<UITextFieldDelegate>
{
    
}
@property (nonatomic, strong) UILabel * topPromptView;      //顶部提示View
@property (nonatomic, strong) UIView * topUserNameView;     //顶部显示用户名 卡号View
@property (nonatomic, strong) UITextField * idNumberTF;
@property (nonatomic, strong) UITextField * phoneNumberTF;
@property (nonatomic, strong) UITextField * captchaTF;
@property (nonatomic, strong) US_SMSCodeButton * sendCodeButton;

@property (nonatomic, strong) UIButton * agreeBtn; //协议按钮
@property (nonatomic, strong) YYLabel * descriptionLabel;//协议
@property (nonatomic, strong) UIButton * bindingButton;

@property (nonatomic, strong) NSString * accountName;
@property (nonatomic, strong) NSString * accountNumber;

@property (nonatomic, assign) BOOL getSMSCodeSuccess;        //标记是否成功获取验证码
@end

@implementation US_BindingBankCardSureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"绑定银行卡"];
    }
    self.accountName = [self.m_Params objectForKey:@"accountName"];
    self.accountNumber = [self.m_Params objectForKey:@"accountNumber"];
    [self setUI];
    
    @weakify(self);
    [self.sendCodeButton addClickBlock:^(US_SMSCodeButton *sender) {
        @strongify(self);
        if ([self isAllowNextStep]) {
            [sender startWithSecond:60];
            [self requestCodeSMS];
        }
    } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
        return @"获取验证码";
    }];
}

/**
 *  判断是否允许下一步操作
 */
- (BOOL)isAllowNextStep {
    if (![NSString isIDNumber:self.idNumberTF.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请正确输入身份证号码" afterDelay:2.0f];
        return NO;
    }
    if (![NSString isMobileNum:self.phoneNumberTF.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请正确输入手机号码" afterDelay:2.0f];
        return NO;
    }
    return YES;
}

/**
 *  请求邮储短信验证码
 */
- (void)requestCodeSMS{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetBindingCardSMSCodeRequestWithAccountName:self.accountName CardNumber:self.accountNumber IDCardNum:self.idNumberTF.text MobileNum:self.phoneNumberTF.text] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:1.5];
        self.getSMSCodeSuccess = YES;
        [self textFiledEditChanged:nil];
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

/**
 *  绑定邮储卡
 */
- (void)requestToBindingBankCard{
    [self.view endEditing:YES];
    if (![self isAllowNextStep]) {
        return;
    }
    if (self.captchaTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入验证码" afterDelay:2.0f];
        return;
    }
    //统计
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"银行卡" moduledesc:@"确认绑定银行卡" networkdetail:@""];

    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildBindingCardRequestWithAccountName:self.accountName CardNumber:self.accountNumber IDCardNum:self.idNumberTF.text MobileNum:self.phoneNumberTF.text ValidateCode:self.captchaTF.text] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"银行卡绑定成功" afterDelay:1.5 withTarget:self dothing:@selector(backToBankCardListVC)];
        
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

- (void)backToBankCardListVC{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"US_WalletBankCardListVC"]) {
            [self.navigationController popToViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"bindingBankCardSucessBack" object:nil];
            return;
        }
    }
}

- (void)gotoH5WithTitle:(NSString *)title Url:(NSString *)url{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
    [dic setObject:url forKey:@"key"];
    [dic setObject:title forKey:@"title"];
    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSString *tmpTxt = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSInteger Length = tmpTxt.length - range.length + string.length;
    
    if (textField == self.idNumberTF) {
        NSUInteger length = textField.text.length;
        if (length >= 18 && string.length > 0)
        {
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789Xx"]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    else if (textField == self.phoneNumberTF)
    {
        NSUInteger length = textField.text.length;
        if (length >= 11 && string.length > 0)
        {
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    else if (textField == self.captchaTF)
    {
        if (textField.text.length >= 10 && string.length > 0)
        {
            return NO;
        }
    }
    return YES;
}

-(void)textFiledEditChanged:(NSNotification *)obj
{
    if (self.idNumberTF.text.length>0 && self.phoneNumberTF.text.length>0 && self.captchaTF.text.length>0 && self.getSMSCodeSuccess && self.agreeBtn.selected) {
        [self setAllowBinding:YES];
    }
    else{
        [self setAllowBinding:NO];
    }
}

- (void)agreeBtnClick:(UIButton *)button{
    button.selected=!button.selected;
    [self textFiledEditChanged:nil];
}

- (void)setUI{
    [self.view sd_addSubviews:@[self.topPromptView,self.topUserNameView]];
    self.topPromptView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(47);
    self.topUserNameView.sd_layout
    .topSpaceToView(self.topPromptView, 10)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(60);
    
    UIView * textFieldBackView = [UIView new];
    textFieldBackView.backgroundColor = [UIColor whiteColor];
    UILabel * idNumberTitleLab = [self createLabel:@"身份证"];
    
    UILabel * phoneNumberTitleLab = [self createLabel:@"手机号"];
    
    UILabel * captchaTitleLab = [self createLabel:@"验证码"];

    UIView * line1 = [UIView new];
    line1.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    UIView * line2 = [UIView new];
    line2.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    UIView * verticalLine = [UIView new];
    verticalLine.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    [self.view addSubview:textFieldBackView];
    textFieldBackView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.topUserNameView, 10)
    .rightSpaceToView(self.view, 0)
    .heightIs(182);
    [textFieldBackView sd_addSubviews:@[idNumberTitleLab,self.idNumberTF,phoneNumberTitleLab,self.phoneNumberTF,captchaTitleLab,self.captchaTF,self.sendCodeButton,line1,line2,verticalLine]];
    idNumberTitleLab.sd_layout
    .leftSpaceToView(textFieldBackView, 10)
    .topSpaceToView(textFieldBackView, 0)
    .widthIs(60)
    .heightIs(60);
    self.idNumberTF.sd_layout
    .leftSpaceToView(idNumberTitleLab, 0)
    .rightSpaceToView(textFieldBackView, 10)
    .centerYEqualToView(idNumberTitleLab)
    .heightIs(40);
    line1.sd_layout
    .leftSpaceToView(textFieldBackView, 0)
    .rightSpaceToView(textFieldBackView, 0)
    .topSpaceToView(idNumberTitleLab, 0)
    .heightIs(1);
    phoneNumberTitleLab.sd_layout
    .leftSpaceToView(textFieldBackView, 10)
    .topSpaceToView(line1, 0)
    .widthIs(60)
    .heightIs(60);
    self.phoneNumberTF.sd_layout
    .leftSpaceToView(phoneNumberTitleLab, 0)
    .rightSpaceToView(textFieldBackView, 10)
    .centerYEqualToView(phoneNumberTitleLab)
    .heightIs(40);
    line2.sd_layout
    .leftSpaceToView(textFieldBackView, 0)
    .rightSpaceToView(textFieldBackView, 0)
    .topSpaceToView(phoneNumberTitleLab, 0)
    .heightIs(1);
    captchaTitleLab.sd_layout
    .leftSpaceToView(textFieldBackView, 10)
    .topSpaceToView(phoneNumberTitleLab, 0)
    .widthIs(60)
    .heightIs(60);
    self.sendCodeButton.sd_layout
    .rightSpaceToView(textFieldBackView, 10)
    .centerYEqualToView(captchaTitleLab)
    .widthIs(80)
    .heightIs(40);
    verticalLine.sd_layout
    .topSpaceToView(line2, 10)
    .bottomSpaceToView(textFieldBackView, 10)
    .rightSpaceToView(self.sendCodeButton, 10)
    .widthIs(1);
    self.captchaTF.sd_layout
    .leftSpaceToView(captchaTitleLab, 0)
    .rightSpaceToView(verticalLine, 10)
    .centerYEqualToView(captchaTitleLab)
    .heightIs(40);
    
    [self.view sd_addSubviews:@[self.agreeBtn,self.descriptionLabel,self.bindingButton]];
    self.descriptionLabel.sd_layout
    .leftSpaceToView(self.view, 50)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(textFieldBackView, 5)
    .heightIs(90);
    self.agreeBtn.sd_layout
    .leftSpaceToView(self.view, 0)
    .centerYEqualToView(self.descriptionLabel)
    .widthIs(50)
    .heightIs(50);
    self.bindingButton.sd_layout
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.descriptionLabel, 5)
    .heightIs(50);
    [self setAllowBinding:NO];
}

/**
 *  配置绑定卡按钮是否可点击和外观
 */
- (void)setAllowBinding:(BOOL)isAllow {
        if (isAllow)
        {
            self.bindingButton.backgroundColor = [UIColor convertHexToRGB:@"c60a1e"];
            [self.bindingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.bindingButton.userInteractionEnabled = YES;
        }
        else
        {
            [self.bindingButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
            self.bindingButton.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
            self.bindingButton.userInteractionEnabled = NO;
        }
}

- (UILabel *)createLabel:(NSString *)title{
    UILabel * textLabel = [[UILabel alloc]init];
    textLabel.text = title;
    textLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    textLabel.font = [UIFont systemFontOfSize:16];
    return textLabel;
}
- (UITextField *)createTextFieldWithPlaceholderText:(NSString *)placeholderText KeyboardType:(UIKeyboardType )KeyboardType{
    UITextField * textField = [[UITextField alloc]init];
    textField.font = [UIFont boldSystemFontOfSize:15];
    textField.placeholder = placeholderText;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = KeyboardType;
    textField.backgroundColor = [UIColor whiteColor];
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:textField];
    return textField;
}

#pragma mark - <setter and getter>
- (UILabel *)topPromptView{
    if (!_topPromptView) {
        _topPromptView = [UILabel new];
        _topPromptView.text = @"首次使用邮储银行卡支付功能绑定卡号，以便能下次快速支付";
        _topPromptView.textColor = [UIColor whiteColor];
        _topPromptView.font = [UIFont systemFontOfSize:14];
        _topPromptView.backgroundColor = [UIColor convertHexToRGB:@"444444"];
        _topPromptView.numberOfLines = 0;
    }
    return _topPromptView;
}

- (UIView *)topUserNameView{
    if (!_topUserNameView) {
        _topUserNameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 60)];
        _topUserNameView.backgroundColor = [UIColor whiteColor];
        UILabel * userNameLab = [UILabel new];
        userNameLab.font = [UIFont systemFontOfSize:16];
        UILabel * cardNumLab = [UILabel new];
        cardNumLab.font = [UIFont systemFontOfSize:16];
        cardNumLab.textAlignment = NSTextAlignmentRight;
        [_topUserNameView sd_addSubviews:@[userNameLab,cardNumLab]];
        userNameLab.sd_layout
        .leftSpaceToView(_topUserNameView, 10)
        .topSpaceToView(_topUserNameView, 0)
        .bottomSpaceToView(_topUserNameView, 0)
        .widthIs(__MainScreen_Width/2-10);
        cardNumLab.sd_layout
        .rightSpaceToView(_topUserNameView, 10)
        .topEqualToView(userNameLab)
        .bottomEqualToView(userNameLab)
        .widthIs(__MainScreen_Width/2-10);
        
       NSString * userName = self.m_Params[@"accountName"];
        if (userName) {
            if (userName.length > 2) {
                userNameLab.text = [NSString stringWithFormat:@"**%@",[userName substringFromIndex:2]];
            } else {
                userNameLab.text = [NSString stringWithFormat:@"*%@",[userName substringFromIndex:1]];
            }
        }
       NSString * cardNumber = self.m_Params[@"accountNumber"];
        if (cardNumber && cardNumber.length > 7) {
            cardNumber = [cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
            cardNumLab.text = [NSString stringWithFormat:@"%@******%@",[cardNumber substringToIndex:3],[cardNumber substringFromIndex:cardNumber.length - 4]];
        } else {
            cardNumLab.text = cardNumber;
        }
    }
    return _topUserNameView;
}

- (UITextField *)idNumberTF{
    if (!_idNumberTF) {
        _idNumberTF = [self createTextFieldWithPlaceholderText:@"请填写身份证号码" KeyboardType:UIKeyboardTypeAlphabet];
    }
    return _idNumberTF;
}

- (UITextField *)phoneNumberTF{
    if (!_phoneNumberTF) {
        _phoneNumberTF = [self createTextFieldWithPlaceholderText:@"请填写手机号码" KeyboardType:UIKeyboardTypeNumberPad];
    }
    return _phoneNumberTF;
}

- (UITextField *)captchaTF{
    if (!_captchaTF) {
        _captchaTF = [self createTextFieldWithPlaceholderText:@"请填写验证码" KeyboardType:UIKeyboardTypeNumberPad];
    }
    return _captchaTF;
}

- (US_SMSCodeButton *)sendCodeButton{
    if (!_sendCodeButton) {
        _sendCodeButton = [[US_SMSCodeButton alloc]init];
        [_sendCodeButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sendCodeButton;
}

- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setImage:[UIImage bundleImageNamed:@"choiseboxNormal"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage bundleImageNamed:@"choiseboxSelected"] forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

- (YYLabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel = [YYLabel new];
        _descriptionLabel.textColor=[UIColor lightGrayColor];
        _descriptionLabel.numberOfLines=0;
        _descriptionLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _descriptionLabel.userInteractionEnabled=YES;
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:@"我接受《邮乐快捷支付服务及相关协议》、《中国邮政储蓄银行借记卡快捷支付业务线上服务协议》并开通快捷支付，下次可凭手机动态验证码快速付款"];
        text.yy_lineSpacing = 5;
        text.yy_font = [UIFont systemFontOfSize:KScreenScale(30)];
        text.yy_color = [UIColor lightGrayColor];
        [text yy_setTextHighlightRange:NSMakeRange(3, 15) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"《邮乐快捷支付服务及相关协议》被点击了");
            [self gotoH5WithTitle:@"快捷支付" Url:uleQuickPayServicePolicyUrl];
        }];
        [text yy_setTextHighlightRange:NSMakeRange(19, 25) color:[UIColor blueColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"《中国邮政储蓄银行借记卡快捷支付业务线上服务协议》被点击了");
            [self gotoH5WithTitle:@"快捷支付" Url:psbcQuickPayServicePolicyUrl];
        }];
        [text yy_setTextHighlightRange:NSMakeRange(45, 6) color:[UIColor redColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"开通快捷支付被点击了");
        }];
        _descriptionLabel.preferredMaxLayoutWidth = __MainScreen_Width - 60; //设置最大的宽度
        _descriptionLabel.attributedText = text;  //设置富文本
    }
    return _descriptionLabel;
}

- (UIButton *)bindingButton{
    if (!_bindingButton) {
        _bindingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bindingButton setTitle:@"绑定邮储卡" forState:UIControlStateNormal];
        _bindingButton.layer.cornerRadius = 5;
        _bindingButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_bindingButton addTarget:self action:@selector(requestToBindingBankCard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindingButton;
}
@end
