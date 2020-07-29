//
//  US_AuthorizeRealNameVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_AuthorizeRealNameVC.h"
#import "US_UserCenterApi.h"
#import "US_SMSCodeButton.h"
#import "US_WalletBindingCardModel.h"
#import "US_AuthorizeAlertView.h"
#import <UIView+ShowAnimation.h>
#import "AuthorizeRealNameMainView.h"

@interface US_AuthorizeRealNameVC ()
@property (nonatomic, assign) BOOL          isFromWithDraw;
@property (nonatomic, strong) UIView        *bottomView;
@property (nonatomic, strong) UIButton      *confirmBtn;
@property (nonatomic, strong) UIScrollView  *mScrollView;
@property (nonatomic, assign) BOOL          isChooseBankCard;
@property (nonatomic, copy)   NSString      *chooseBankCardCipher;

@property (nonatomic, copy)NSString     *userNameStr;
@property (nonatomic, copy)NSString     *idCardStr;
@property (nonatomic, copy)NSString     *bankCardStr;
@property (nonatomic, copy)NSString     *mobileStr;
@property (nonatomic, copy)NSString     *smsCodeStr;

@property (nonatomic, strong)AuthorizeRealNameTopView     *mTopView;
@property (nonatomic, strong)AuthorizeRealNameCenterView  *mCenterView;
@property (nonatomic, strong)AuthorizeRealNameBootomView  *mBottomView;


@end

@implementation US_AuthorizeRealNameVC

- (void)dealloc
{
    [self.mTopView removeObserver:self forKeyPath:@"userNameTF.text"];
    [self.mTopView removeObserver:self forKeyPath:@"idCardTF.text"];
    [self.mCenterView removeObserver:self forKeyPath:@"bankCardTF.text"];
    [self.mBottomView removeObserver:self forKeyPath:@"mobileTF.text"];
    [self.mBottomView removeObserver:self forKeyPath:@"smsCodeTF.text"];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFromWithDraw = [[self.m_Params objectForKey:@"isFromWithdraw"] isEqualToString:@"1"];
    [self.uleCustemNavigationBar customTitleLabel:@"实名认证"];
    [self setUI];
    [self startRequestProceedInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBankCardDone:) name:NOTI_SelectBankcardDone object:nil];
}

- (void)setUI{
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout.bottomEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kIphoneX?70+24:70);
    [self.view addSubview:self.mScrollView];
    self.mScrollView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.bottomView, 0);
    
    [self.mScrollView addSubview:self.mTopView];
    [self.mScrollView addSubview:self.mCenterView];
    [self.mScrollView addSubview:self.mBottomView];
    self.mScrollView.contentSize = CGSizeMake(__MainScreen_Width, CGRectGetMaxY(self.mBottomView.frame));
    @weakify(self);
    self.mCenterView.choosenBtnBlock = ^{
        @strongify(self);
        NSMutableDictionary *params = @{@"isFromAuthorize":@"1"}.mutableCopy;
        [self pushNewViewController:@"US_WalletBankCardListVC" isNibPage:NO withData:params];
    };
    self.mBottomView.smsCodeBtnBlock = ^{
        @strongify(self);
        [self.view endEditing:YES];
        if ([self checkSMSCodeData]) {
            [self requestSMSCode];
        }
    };
    //没有银行卡，不显示选择按钮
    if ([[self.m_Params objectForKey:@"bankCardCount"] integerValue] <= 0) {
        [self.mCenterView setBankCardChoosenBtnHidden:YES];
    }
    
    [self.mTopView addObserver:self forKeyPath:@"userNameTF.text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.mTopView addObserver:self forKeyPath:@"idCardTF.text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.mCenterView addObserver:self forKeyPath:@"bankCardTF.text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.mBottomView addObserver:self forKeyPath:@"mobileTF.text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.mBottomView addObserver:self forKeyPath:@"smsCodeTF.text" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    //设置手机号
    [self.mBottomView setMobileNum:[US_UserUtility sharedLogin].m_mobileNumber];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    USLog(@"%@ %@ %@",keyPath, [change objectForKey:NSKeyValueChangeOldKey], [change objectForKey:NSKeyValueChangeNewKey]);
    NSString *newValue = [NSString isNullToString:[change objectForKey:NSKeyValueChangeNewKey]];
    if ([keyPath isEqualToString:@"userNameTF.text"]) {
        self.userNameStr = newValue;
    }else if ([keyPath isEqualToString:@"idCardTF.text"]) {
        self.idCardStr = newValue;
    }else if ([keyPath isEqualToString:@"bankCardTF.text"]) {
        if (![self.bankCardStr isEqualToString:newValue]) {
            self.bankCardStr = newValue;
            self.isChooseBankCard = NO;
        }
    }else if ([keyPath isEqualToString:@"mobileTF.text"]) {
        self.mobileStr = newValue;
    }else if ([keyPath isEqualToString:@"smsCodeTF.text"]) {
        self.smsCodeStr = newValue;
    }
    BOOL confirmBtnInteracted = self.userNameStr.length>0&&self.idCardStr.length>0&&self.bankCardStr.length>0&&self.mobileStr.length>0&&self.smsCodeStr.length>0;
    [self setAllowAuthorize:confirmBtnInteracted];
}

- (void)startRequestProceedInfo{
    [self.networkClient_Ule beginRequest:[US_UserCenterApi buildWithdrawProcessInfo] success:^(id responseObject) {
        NSDictionary *responseDic = responseObject;
        NSArray *array = [responseDic objectForKey:@"indexInfo"];
        NSDictionary *dataDic = [array firstObject];
        NSString *instructionText = [NSString isNullToString:[dataDic objectForKey:@"attribute1"]];
        UIView *promoteView = [AuthorizeRealNameMainView getPromoteViewWithStr:instructionText];
        CGRect proFrame = promoteView.frame;
        proFrame.origin.y = CGRectGetMaxY(self.mBottomView.frame);
        promoteView.frame = proFrame;
        [self.mScrollView addSubview:promoteView];
        CGSize orgiSize = self.mScrollView.contentSize;
        CGFloat newHeight = orgiSize.height+CGRectGetHeight(promoteView.frame)+10;
        self.mScrollView.contentSize = CGSizeMake(orgiSize.width, newHeight);
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)requestSMSCode{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"获取中..."];
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildAuthSmsCodeWithUserName:self.userNameStr idCardNum:self.idCardStr bankCardNum:self.isChooseBankCard?self.chooseBankCardCipher:self.bankCardStr mobileNum:self.mobileStr bankChooseType:self.isChooseBankCard?@"1":@"0"] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"短信验证码发送成功" afterDelay:1.5];
        [self.mBottomView.smsCodeBtn startWithSecond:60];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

- (void)startRequestAuthority{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"认证中..."];
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildAuthorizeRealWithUserName:self.userNameStr idCardNum:self.idCardStr bankCardNum:self.isChooseBankCard?self.chooseBankCardCipher:self.bankCardStr mobileNum:self.mobileStr smsCodeNum:self.smsCodeStr bankChooseType:self.isChooseBankCard?@"1":@"0"] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [US_UserUtility setUserRealNameAuthorization:YES];
        US_AuthorizeAlertView *alertView = [[US_AuthorizeAlertView alloc]initWithType:AuthorizeViewTypeSuccess andMessage:@"您的信息认证成功" isContinuePush:self.isFromWithDraw];
        alertView.confirmBlock = ^{
            if (self.isFromWithDraw) {
                [self pushNewViewController:@"US_WithdrawVC" isNibPage:NO withData:nil];
            }else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
        [alertView showViewWithAnimation:AniamtionPresentBottom];
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        US_AuthorizeAlertView *alertView = [[US_AuthorizeAlertView alloc]initWithType:AuthorizeViewTypeFail andMessage:[NSString isNullToString:[error.error.userInfo objectForKey:NSLocalizedDescriptionKey]] isContinuePush:NO];
        [alertView showViewWithAnimation:AniamtionPresentBottom];
    }];
}


#pragma mark - <ACTIONS>
- (void)confirmAction:(UIButton *)sender{
    [self.view endEditing:YES];
    [self startRequestAuthority];
}

- (void)selectBankCardDone:(NSNotification *)noti{
    US_WalletBindingCardInfo *bankcardInfo = [noti.userInfo objectForKey:@"bankCardInfo"];
    //此处注意调用顺序
    [self.mCenterView setBankCardNum:bankcardInfo.cardNo];
    self.chooseBankCardCipher = bankcardInfo.cardNoCipher;
    self.isChooseBankCard = YES;
}

-(BOOL)checkSMSCodeData{
    if (self.userNameStr.length<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的姓名" afterDelay:1.5]; return NO;}
    
    if (self.idCardStr.length<=0){
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的身份证号" afterDelay:1.5]; return NO;}
    
    if (![NSString isIDNumber:[self.idCardStr stringByReplacingOccurrencesOfString:@" " withString:@""]]){
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的身份证号" afterDelay:1.5]; return NO;}
    
    if (self.mobileStr.length<=0){
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的手机号码" afterDelay:1.5]; return NO;}
    
    if (![NSString isMobileNum:self.mobileStr]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号码" afterDelay:1.5]; return NO;}
    
    if (self.bankCardStr.length<=0){
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的银行卡号" afterDelay:1.5]; return NO;}
    
    return YES;
}

// 配置确定认证按钮是否可点击和外观
- (void)setAllowAuthorize:(BOOL)isAllow {
    if (isAllow)
    {
        self.confirmBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
        self.confirmBtn.userInteractionEnabled = YES;
    }
    else
    {
        self.confirmBtn.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
        self.confirmBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - <GETTERS>
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = kViewCtrBackColor;
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setBackgroundColor:[UIColor convertHexToRGB:@"cccccc"]];
        [_confirmBtn setTitle:@"确定认证" forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5.0;
        [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setUserInteractionEnabled:NO];
        [_bottomView addSubview:_confirmBtn];
        _confirmBtn.sd_layout.topSpaceToView(_bottomView, 10)
        .leftSpaceToView(_bottomView, 15)
        .rightSpaceToView(_bottomView, 15)
        .heightIs(50);
    }
    return _bottomView;
}

- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc]init];
        _mScrollView.backgroundColor = kViewCtrBackColor;
    }
    return _mScrollView;
}

- (AuthorizeRealNameTopView *)mTopView
{
    if (!_mTopView) {
        _mTopView = [[AuthorizeRealNameTopView alloc]initWithFrame:CGRectMake(0, KScreenScale(10), __MainScreen_Width, 101.6)];
    }
    return _mTopView;
}

- (AuthorizeRealNameCenterView *)mCenterView
{
    if (!_mCenterView) {
        _mCenterView = [[AuthorizeRealNameCenterView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mTopView.frame)+KScreenScale(10), __MainScreen_Width, KScreenScale(260))];
    }
    return _mCenterView;
}

- (AuthorizeRealNameBootomView *)mBottomView
{
    if (!_mBottomView) {
        _mBottomView = [[AuthorizeRealNameBootomView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mCenterView.frame)+KScreenScale(10), __MainScreen_Width, 101.6)];
    }
    return _mBottomView;
}
@end
