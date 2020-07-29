//
//  US_PreRegisterVC.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_PreRegisterVC.h"
#import "US_SMSCodeButton.h"
#import "NSString+Utility.h"
#import "US_LoginApi.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <Ule_SecurityKit.h>

@interface US_PreRegisterVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField       *phoneNumberTF;
@property (nonatomic, strong) UITextField       *smsCodeTF;
@property (nonatomic, strong) US_SMSCodeButton  *smsCodeBtn;
@property (nonatomic, strong) UIButton          *regisBtn;
@property (nonatomic, strong) UIButton          *protocolSelBtn;
@end

@implementation US_PreRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.uleCustemNavigationBar customTitleLabel:@"快速开店"];
    [self setUI];
}


#pragma mark - Action
/**
 *  快速开店点击获取验证码
 */
- (void)getSMSCode {
    if (self.phoneNumberTF.text.length == 0) {
        [self.smsCodeBtn stop];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的手机号" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:self.phoneNumberTF.text]) {
        [self.smsCodeBtn stop];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"手机号码格式错误" afterDelay:1.5];
        return;
    }
    //记录
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"快速开店" moduledesc:@"获取验证码" networkdetail:@""];
    [self.view endEditing:YES];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildRegistSMSCodeWithAccount:[NSString stringWithFormat:@"%@",self.phoneNumberTF.text]] success:^(id responseObject) {
        @strongify(self);
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"快速开店" moduledesc:@"获取验证码成功" networkdetail:@""];
        [UleMBProgressHUD hideHUDForView:self.view];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:1.5];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
        [self.smsCodeBtn stop];
    }];
}

-(void)preRegistAction {

    if (self.phoneNumberTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的手机号" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:self.phoneNumberTF.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"手机号码格式错误" afterDelay:1.5];
        return;
    };
    if (self.smsCodeTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入验证码" afterDelay:1.5];
        return;
    }
    if (!self.protocolSelBtn.isSelected) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请阅读并同意《服务协议与隐私政策》" afterDelay:1.5];
        return;
    }
    //记录
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"快速开店" moduledesc:@"ylxdapp_zc_ljkd" networkdetail:@""];
    [self.view endEditing:YES];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildPreRegistByCodeRequestWithAccount:[NSString stringWithFormat:@"%@", self.phoneNumberTF.text] smsCode:[NSString stringWithFormat:@"%@", self.smsCodeTF.text]] success:^(id responseObject) {
        @strongify(self);
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"快速开店" moduledesc:@"立即开店成功" networkdetail:@""];
        
        [UleMBProgressHUD hideHUDForView:self.view];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSString *encryptStr = [responseDic objectForKey:@"data"];
            if ([NSString isNullToString:encryptStr].length==0) return;
            //获取key
            NSString *o_key = [CalcKeyIvHelper shared].x_Emp_Key;
            //获取向量
            NSString *o_Iv = [CalcKeyIvHelper shared].x_Emp_Iv;
            NSData *o_ivData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
            //解密
            NSData *decryptData = [Ule_SecurityKit M_DecryptWithData:[NSData dataFromBase64String:encryptStr] WithKey:o_key WithIV:[o_ivData bytes]];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:decryptData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers  error:nil];
            //返回值为X-Emp-Token orgCode protocolId protocolUrl usrOnlyid为长整型  websiteType为a
            NSString *userToken=[NSString stringWithFormat:@"%@", [dic objectForKey:@"X-Emp-Token"]];
            NSString *userID=[NSString stringWithFormat:@"%@", [dic objectForKey:@"usrOnlyid"]];
            NSString *protocolUrl=[NSString stringWithFormat:@"%@", [dic objectForKey:@"protocolUrl"]];
            //保存
            [US_UserUtility saveUserToken:userToken];
            [US_UserUtility saveUserId:userID];
            [US_UserUtility saveProtocolUrl:protocolUrl];
            //跳转
            NSMutableDictionary *params=@{@"mobilePhone":self.phoneNumberTF.text}.mutableCopy;
            [self pushNewViewController:@"US_RegisterVC" isNibPage:NO withData:params];
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger length = textField.text.length - range.length + string.length;
    
    if (textField == self.phoneNumberTF)
    {
        return length<=11;
    }
    else if (textField == self.smsCodeTF) {
        return length<=6;
    }
    
    return YES;
}

//输入完的通知方法
-(void)textFiledEditChanged:(NSNotification *)not {
    if (self.phoneNumberTF.text.length>0&&self.smsCodeTF.text.length>0) {
        self.regisBtn.backgroundColor=kCommonRedColor;
    }else {
        self.regisBtn.backgroundColor=[UIColor convertHexToRGB:@"999999"];
    }
}

#pragma mark - <SetUI>
-(void)setUI{
    UIView *accountBg=[[UIView alloc]init];
    accountBg.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    [self.view addSubview:accountBg];
    accountBg.sd_layout.topSpaceToView(self.uleCustemNavigationBar, KScreenScale(30))
    .leftSpaceToView(self.view, KScreenScale(30))
    .rightSpaceToView(self.view, KScreenScale(30))
    .heightIs(45);
    [accountBg addSubview:self.phoneNumberTF];
    self.phoneNumberTF.sd_layout.topSpaceToView(accountBg, 0)
    .bottomSpaceToView(accountBg, 0)
    .rightSpaceToView(accountBg, 0)
    .bottomSpaceToView(accountBg, 0)
    .leftSpaceToView(accountBg, KScreenScale(30));
    
    UIView *passwdBg=[[UIView alloc]init];
    passwdBg.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    [self.view addSubview:passwdBg];
    passwdBg.sd_layout.topSpaceToView(accountBg, KScreenScale(30))
    .leftEqualToView(accountBg)
    .rightEqualToView(accountBg)
    .heightRatioToView(accountBg, 1.0);
    [passwdBg addSubview:self.smsCodeBtn];
    self.smsCodeBtn.sd_layout.topSpaceToView(passwdBg, 0)
    .bottomSpaceToView(passwdBg, 0)
    .rightSpaceToView(passwdBg, 0)
    .widthIs(KScreenScale(230));
    [passwdBg addSubview:self.smsCodeTF];
    self.smsCodeTF.sd_layout.topSpaceToView(passwdBg, 0)
    .bottomSpaceToView(passwdBg, 0)
    .leftSpaceToView(passwdBg, KScreenScale(30))
    .rightSpaceToView(_smsCodeBtn, 0);
    
    [self.view addSubview:self.protocolSelBtn];
    UILabel *protocolLab = [[UILabel alloc]init];
    protocolLab.text = @"我已阅读并同意";
    protocolLab.textColor = [UIColor convertHexToRGB:@"666666"];
    protocolLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
    [self.view addSubview:protocolLab];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"《服务协议与隐私政策》"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributedStr.length)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(30)] range:NSMakeRange(0, attributedStr.length)];
    UIButton *detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [detailBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
    [detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
    [detailBtn addTarget:self action:@selector(protocolDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailBtn];
    //约束
    CGFloat proLabW = [protocolLab.text widthForFont:protocolLab.font]+2;
    CGFloat detailBtnW = [detailBtn.titleLabel.text widthForFont:detailBtn.titleLabel.font]+5;
    self.protocolSelBtn.sd_layout.topSpaceToView(passwdBg, KScreenScale(60))
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
    
    [self.view addSubview:self.regisBtn];
    self.regisBtn.sd_layout.topSpaceToView(self.protocolSelBtn, KScreenScale(20))
    .leftSpaceToView(self.view, KScreenScale(30))
    .rightSpaceToView(self.view, KScreenScale(30))
    .heightIs(45);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_phoneNumberTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_smsCodeTF];
}

#pragma mark - <ACTIONS>
- (void)protocolSelBtnAction:(UIButton *)sender
{
    self.protocolSelBtn.selected=!self.protocolSelBtn.isSelected;
}

- (void)protocolDetailBtnAction:(UIButton *)sender
{
    NSMutableDictionary *params=@{@"protocol":[UleStoreGlobal shareInstance].config.serverProtocol}.mutableCopy;
    [self pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:params];
}
#pragma mark - getters
-(UITextField *)phoneNumberTF
{
    if (!_phoneNumberTF) {
        _phoneNumberTF = [[UITextField alloc]init];
        _phoneNumberTF.backgroundColor=[UIColor clearColor];
        _phoneNumberTF.keyboardType=UIKeyboardTypeNumberPad;
        _phoneNumberTF.font=[UIFont systemFontOfSize:16];
        _phoneNumberTF.textColor=[UIColor convertHexToRGB:@"333333"];
        _phoneNumberTF.delegate = self;
        _phoneNumberTF.placeholder=@"请输入您的手机号";
        _phoneNumberTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_phoneNumberTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        _phoneNumberTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    }
    return _phoneNumberTF;
}

-(US_SMSCodeButton *)smsCodeBtn
{
    if (!_smsCodeBtn) {
        _smsCodeBtn = [US_SMSCodeButton buttonWithType:UIButtonTypeCustom];
        _smsCodeBtn.btnNormalColor=[UIColor convertHexToRGB:@"2da4f1"];
        _smsCodeBtn.btnCountDownColor=[UIColor convertHexToRGB:@"b9b9b9"];
        [_smsCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _smsCodeBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _smsCodeBtn.normalColor=[UIColor convertHexToRGB:@"ffffff"];
        _smsCodeBtn.countDownColor=[UIColor convertHexToRGB:@"ffffff"];
        @weakify(self);
        [_smsCodeBtn addClickBlock:^(US_SMSCodeButton *sender) {
            @strongify(self);
            [sender startWithSecond:60];
            [self getSMSCode];
        } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
            return @"获取验证码";
        }];
    }
    return _smsCodeBtn;
}

-(UITextField *)smsCodeTF
{
    if (!_smsCodeTF) {
        _smsCodeTF=[[UITextField alloc]init];
        _smsCodeTF.backgroundColor=[UIColor clearColor];
        _smsCodeTF.keyboardType=UIKeyboardTypeNumberPad;
        _smsCodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _smsCodeTF.font=[UIFont systemFontOfSize:16];
        _smsCodeTF.textColor=[UIColor convertHexToRGB:@"333333"];
        _smsCodeTF.delegate = self;
        _smsCodeTF.placeholder=@"请输入验证码";
        _smsCodeTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_smsCodeTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    }
    return _smsCodeTF;
}

-(UIButton *)regisBtn
{
    if (!_regisBtn) {
        _regisBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_regisBtn setTitle:@"立即开店" forState:UIControlStateNormal];
        [_regisBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
        _regisBtn.titleLabel.font=[UIFont systemFontOfSize:18];
        _regisBtn.backgroundColor=[UIColor convertHexToRGB:@"999999"];
        _regisBtn.layer.cornerRadius=3.0;
        [_regisBtn addTarget:self action:@selector(preRegistAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _regisBtn;
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
@end
