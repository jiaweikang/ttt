//
//  US_AgreementVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/7.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_AgreementVC.h"
#import <WebKit/WebKit.h>
#import "US_LoginApi.h"
#import "ProtocolAlertView.h"
#import <CustomAlertViewManager.h>
#import <UIView+ShowAnimation.h>
@interface US_AgreementVC ()<WKNavigationDelegate>
@property (nonatomic, strong) WKWebView * wk_mWebView;
@property (nonatomic, strong) UIButton  * protocolSelBtn;
@end

@implementation US_AgreementVC

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if ([self.m_Params[@"isNeedSign"]isEqualToString:@"1"]&&![[US_UserUtility sharedLogin].m_isUserProtocol isEqualToString:@"1"]) {
        ProtocolAlertView *alertView = [ProtocolAlertView protocolAlertView:^{
            if ([US_UserUtility sharedLogin].m_protocolUrl && [US_UserUtility sharedLogin].m_protocolUrl.length>0) {
                NSMutableDictionary *dic = @{
                                             KNeedShowNav: @YES,
                                             @"title": @"服务协议与隐私政策",
                                             @"protocol": [US_UserUtility sharedLogin].m_protocolUrl,
                                             @"isNeedSign":@"1"}.mutableCopy;
                [[UIViewController currentViewController] pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:dic];
            }
        }];
        alertView.orderNum = UnitAlertOrderProtocol;
        [[CustomAlertViewManager sharedManager] addCustomAlertView:alertView identify:@"协议Alert"];
        [[CustomAlertViewManager sharedManager] sortCurrentAlertViews];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleStr = @"服务协议与隐私政策";
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        titleStr = [self.m_Params objectForKey:@"title"];
    }
    [self.uleCustemNavigationBar customTitleLabel:titleStr];
    [self setupView];
    NSString * protocol=[self.m_Params objectForKey:@"protocol"];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:protocol]];
    [self.wk_mWebView loadRequest:request];
}

- (void)setupView{
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *bottomView=[[UIView alloc]init];
    bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bottomView];
    bottomView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(KScreenScale(140)+30);
    [bottomView addSubview:self.protocolSelBtn];
    self.protocolSelBtn.sd_layout.topSpaceToView(bottomView, KScreenScale(20))
    .leftSpaceToView(bottomView, KScreenScale(30))
    .widthIs(30)
    .heightIs(30);
    UILabel *protocolLab = [[UILabel alloc]init];
    protocolLab.text = @"我已阅读并同意";
    protocolLab.textColor = [UIColor convertHexToRGB:@"666666"];
    protocolLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
    [bottomView addSubview:protocolLab];
    protocolLab.sd_layout.centerYEqualToView(self.protocolSelBtn)
    .leftSpaceToView(self.protocolSelBtn, KScreenScale(10))
    .rightSpaceToView(bottomView, 0)
    .heightIs(20);
    UIButton *signAgreementBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [signAgreementBtn setTitle:@"继续使用" forState:UIControlStateNormal];
    [signAgreementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signAgreementBtn.backgroundColor=kCommonRedColor;
    signAgreementBtn.layer.cornerRadius=5;
    [signAgreementBtn addTarget:self action:@selector(contractSign:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:signAgreementBtn];
    signAgreementBtn.sd_layout.topSpaceToView(self.protocolSelBtn, KScreenScale(20))
    .leftSpaceToView(bottomView, KScreenScale(30))
    .bottomSpaceToView(bottomView, KScreenScale(20))
    .rightSpaceToView(bottomView, KScreenScale(30));
    [self.view addSubview:self.wk_mWebView];
    if (self.m_Params[@"isNeedSign"]&&[self.m_Params[@"isNeedSign"] isEqualToString:@"1"]) {
        self.wk_mWebView.sd_layout.leftSpaceToView(self.view, 0)
        .topSpaceToView(self.uleCustemNavigationBar, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(bottomView, 0);
    }else{
        self.wk_mWebView.sd_layout.leftSpaceToView(self.view, 0)
        .topSpaceToView(self.uleCustemNavigationBar, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
    }
}

- (void)protocolSelBtnAction:(UIButton *)sender{
    sender.selected=!sender.isSelected;
}

- (void)contractSign:(id)sender{
    if (!self.protocolSelBtn.isSelected) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请阅读并勾选使用协议" afterDelay:1.5];
        return;
    }
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildContractSignRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [US_UserUtility saveIsUserProtocol:@"1"];
        [self ule_toLastViewController];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
}

#pragma mark - <WKDelegate>
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [UleMBProgressHUD hideHUDForView:self.view];
}

#pragma mark - <setter and getter>

- (WKWebView *)wk_mWebView {
    if (!_wk_mWebView) {
        _wk_mWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _wk_mWebView.backgroundColor = [UIColor whiteColor];
        _wk_mWebView.navigationDelegate = self;
        _wk_mWebView.userInteractionEnabled=YES;
        if (@available(iOS 11.0, *)) {
            _wk_mWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _wk_mWebView;
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
