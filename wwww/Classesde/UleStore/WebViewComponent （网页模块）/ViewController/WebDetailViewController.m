//
//  WebDetailViewController.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "WebDetailViewController.h"
#import "USWebDetailHeader.h"
#import "US_DynamicSearchBarView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NSData+Base64.h"
#import "USRedPacketCashManager.h"
#import "UleControlView.h"
#import <USAuthorizetionHelper.h>
#import "USImageDownloadManager.h"

@interface WebDetailViewController ()<WKNavigationDelegate,UleWebViewBridgeDelegate,UIAlertViewDelegate,WKUIDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UleWebViewApiBridge * webBridge;
@property (nonatomic, strong) UleWebProgressLayer *mWebProgressLayer;
@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * offButton;
@property (nonatomic, strong) UIButton * shareButton;
@property (nonatomic, strong) UleControlView * enterpriseChangeBtn;
@property (nonatomic, assign) BOOL backToRoot;  //是否返回根视图
@property (nonatomic, copy) NSString * urlString;//加载网络链接
@property (nonatomic, assign) BOOL showShareButton;//是否显示分享按键
@property (nonatomic, assign) BOOL isUserInfoConnected;//是否和用户信息相关，用户信息更改后主动刷新
@property (nonatomic, assign) BOOL isHiddenNavigationBar;//是否显示导航栏
@property (nonatomic, assign) BOOL isOffsetStatus;//是否重状态栏开始显示
@property (nonatomic, strong) UleWebViewLinkUrlParser * mWebViewParser;
@property (nonatomic, strong) UleUCiOSAction * leftBtnAction;
@property (nonatomic, strong) UILongPressGestureRecognizer  *mLongPressGes;
@end

@implementation WebDetailViewController
#pragma mark - <Lifycyle>
- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    self.view.backgroundColor = kCommonRedColor;
    [self addSubViews];
    [self parseParamsData];
    [self registNotifycation];
}

- (void)dealloc{
    @try {
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [_wk_mWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    } @catch (NSException *exception) {
        NSLog(@"");
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[USCookieHelper sharedHelper] setCookie];
}

#pragma mark - <prepare data and UI>
/** 添加webView */
- (void) addSubViews {
    [self.view addSubview:self.wk_mWebView];
    self.wk_mWebView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    // 进度条
    [self.wk_mWebView.layer addSublayer:self.mWebProgressLayer];
    self.mWebProgressLayer.frame = CGRectMake(0.0, -1.0, __MainScreen_Width, 2.0);
    [self.mWebProgressLayer startLoad];
    [self refreshNavigationBar];
}
- (void)addSearchBarView {
    @weakify(self);
    US_DynamicSearchBarView *searchBarView=[[US_DynamicSearchBarView alloc]initWithFrame:CGRectMake(20, 0, __MainScreen_Width - 100 , 30) tapActionBlock:^{
        @strongify(self);
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"货源" moduledesc:@"头部搜索" networkdetail:@""];
        [self pushNewViewController:@"US_SearchCategoryVC" isNibPage:NO withData:nil];
    }];
    self.uleCustemNavigationBar.titleLayoutType=WidthStretchLayout;
    self.uleCustemNavigationBar.titleView=searchBarView;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:[UIImage bundleImageNamed:@"goods_btn_classfy_nav"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchBtnAcion) forControlEvents:UIControlEventTouchUpInside];
    self.uleCustemNavigationBar.leftBarButtonItems=@[button];
}


- (void) refreshNavigationBar {
    if (self.wk_mWebView.canGoBack) {
        self.uleCustemNavigationBar.leftBarButtonItems=@[self.backButton,self.offButton];
    } else {
        if (self.navigationController.childViewControllers.count>1) {
            if ([self isEqual:[self.navigationController.viewControllers firstObject]]) {
                self.uleCustemNavigationBar.leftBarButtonItems=nil;
            }else {
                self.uleCustemNavigationBar.leftBarButtonItems=@[self.backButton];
            }
        }else{
            self.uleCustemNavigationBar.leftBarButtonItems=nil;
        }
    }
    //是否显示右上角分享按钮
    if (self.showShareButton) {
        self.uleCustemNavigationBar.rightBarButtonItems=@[self.shareButton];
    } else if ([self.m_Params[@"needChange"] isEqualToString:@"1"] && [US_UserUtility sharedLogin].hasCSqy && [UserDefaultManager getLocalDataBoolen:@"hadEnterprice"]) {
        [US_UserUtility sharedLogin].enterpriseMark = @"1";
        [self.enterpriseChangeBtn.mImageView setImage:[UIImage bundleImageNamed:@"storeChangeIcon"]];
        self.uleCustemNavigationBar.rightBarButtonItems=@[self.enterpriseChangeBtn];
    } else self.uleCustemNavigationBar.rightBarButtonItems=nil;
}

- (void) parseParamsData{
    self.ignorePageLog=YES;
    if (self.m_Params[KNeedShowNav]) {
        self.isHiddenNavigationBar=![self.m_Params[KNeedShowNav] boolValue];
    }
    //默认从状态栏下开始显示
    self.isOffsetStatus = ![[NSString isNullToString:[self.m_Params objectForKey:@"isOffsetStatus"]] isEqualToString:@"0"];
    // 设置title
    NSString *titleStr=self.m_Params[@"title"];
    if (!titleStr) {
        titleStr=self.m_Params[@"TT"];
    }
    [self.uleCustemNavigationBar customTitleLabel:titleStr];
    [self hiddenNavigationBar:self.isHiddenNavigationBar offSetStatus:self.isOffsetStatus animated:NO];
    
    if ([self.m_Params[isNeedSearch] boolValue]) {
        [self addSearchBarView];
    }
    //是否直接返回的首页
    if ([self.m_Params[@"key_backToRoot"] isEqualToString:@"1"]) {
        self.backToRoot = YES;
    }
    //是否显示分享按键
    self.showShareButton=[self.m_Params[@"FX"] boolValue];
    //设置加载链接
    self.urlString=self.m_Params[@"key"];
    self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"@@" withString:@"://"];
    if (self.urlString.length==0||self.urlString==nil) {
        [self showCustemAlert];
    }
    NSString * srcid=self.m_Params[SRCIDKEY];
    srcid=srcid.length>0?srcid:[LogStatisticsManager shareInstance].srcid;
    NSString * refid=[LogStatisticsManager shareInstance].ref;
    if (![self.urlString containsString:@"http://ule.cn/"]) {
        NSMutableDictionary * urlDic=[[NSMutableDictionary alloc] init];
        [urlDic setObject:NonEmpty(srcid) forKey:@"srcid"];
        [urlDic setObject:NonEmpty(refid) forKey:@"refid"];
        self.urlString =[NSString appandHtmlStr:self.urlString WithParams:urlDic];
    }
    //页面是否与用户信息相关（修改后刷新页面）
    self.isUserInfoConnected=[self.m_Params[@"isUser"] boolValue];
    //普通cookie
    [[USCookieHelper sharedHelper] setCookie];
    BOOL isSlidePopDisabled = [self.m_Params[@"slidePopDisabled"] boolValue];
    if (isSlidePopDisabled) {
        // 禁止滑动返回
        self.fd_interactivePopDisabled=YES;
    }
    //设置mall_cookie；
    @weakify(self);
    [[USCookieHelper sharedHelper] setMall_cookieComplete:^{
        @strongify(self);
        [self loadRequest];
    }];
}

- (void)hiddenNavigationBar:(BOOL)isHidden offSetStatus:(BOOL)offsetStatus animated:(BOOL)isAnimated{
    NSLog(@"hiddenNavieBar==%@===%@",@(isHidden),@(isAnimated));
    self.isHiddenNavigationBar=isHidden;
    self.isOffsetStatus=offsetStatus;
    CGFloat animateTime=isAnimated ? 0.3 : 0.0;
    if(self.isHiddenNavigationBar){
        [UIView animateWithDuration:animateTime animations:^{
            self.uleCustemNavigationBar.frame=CGRectMake(0, -self.uleCustemNavigationBar.height_sd, self.uleCustemNavigationBar.width_sd, self.uleCustemNavigationBar.height_sd);
            if (offsetStatus) {
                self.wk_mWebView.sd_layout.topSpaceToView(self.view, kStatusBarHeight);
            }else{
                self.wk_mWebView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
            }
            [self.wk_mWebView updateLayout];
        }];
    }else{
        [UIView animateWithDuration:animateTime animations:^{
            self.uleCustemNavigationBar.frame=CGRectMake(0, 0, self.uleCustemNavigationBar.width_sd, self.uleCustemNavigationBar.height_sd);
            self.wk_mWebView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
            [self.wk_mWebView updateLayout];
        }];
    }
}

#pragma mark - <注册通知>
- (void)registNotifycation{
    //网络切换通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"NetWorkChange" object:nil];
    //用户信息更新完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:NOTI_UpdateUserInfo object:nil];
    //程序挂起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:AppWillResignActive object:nil];
}
#pragma mark - <private>
- (void)loadRequest{
    NSString *encodeRequest = @"";
    if ([self.urlString containsString:@"#/"]) {
        encodeRequest = [self.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!@$^%*+,;'\"`<>()[]{}\\| "].invertedSet];
    }else{
        encodeRequest = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURL *url = [NSURL URLWithString:encodeRequest];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:40.0];
    [request setValue:[[USCookieHelper sharedHelper] appendCookieString] forHTTPHeaderField:@"Cookie"];
    [self.wk_mWebView loadRequest:request];
    
    //#warning test 本地html测试
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test-3" ofType:@"html"];
    //            NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //            NSURL *url = [[NSURL alloc] initWithString:filePath];
    //            [self.wk_mWebView loadHTMLString:htmlString baseURL:url];
    //            [self.wk_mWebView setJavascriptCloseWindowListener:^{
    //                NSLog(@"window.close called");
    //            } ];
}


-(void)refresh:(NSNotification *)notify{
    if ([UleReachability sharedManager].reachable &&self.urlString) {//有网
        NSLog(@"webdetailView刷新");
        NSDictionary * userInfo=notify.userInfo;
        NSString * jsFuntion=[userInfo objectForKey:@"jsFuction"];
        if (jsFuntion&&jsFuntion.length>0) {
            [self runJsFunction:jsFuntion andParams:@[]];
        }
        [self loadRequest];
    }
}

//通知h5程序挂起
- (void)appWillResignActive{
    [self.wk_mWebView evaluateJavaScript:US_ResignActive completionHandler:^(id _Nullable value, NSError * _Nullable error) {
    }];
}

- (void)startLongPress:(UIGestureRecognizer *)ges{
    if (ges.state!=UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [ges locationInView:ges.view];
    NSString *jsString = [NSString stringWithFormat:@"function getiOSNativeCurrentURL(){\
                            var ele=document.elementFromPoint(%f, %f);\
                            var url=ele.src;\
                            var jsonString= `{\"url\":\"${url}\"}`;\
                            return(jsonString)} getiOSNativeCurrentURL()", touchPoint.x, touchPoint.y];
    @weakify(self);
    [self.wk_mWebView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        @strongify(self);
        NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSString *imageURL = [NSString isNullToString:resultDic[@"url"]];
        if (imageURL.length == 0 || [imageURL isEqualToString:@"undefined"]) {
            return;
        }
        NSData *imageData=nil;
        if (([imageURL hasPrefix:@"http"])) {
            [[USImageDownloadManager sharedManager]asyncDownloadWithLink:imageURL success:^(NSData * _Nullable data) {
                [self checkLongPressWithImageData:data];
            } fail:^(NSError * _Nullable error) {
            }];
        }else {
            NSString *dataString=[[imageURL componentsSeparatedByString:@","]lastObject];
            imageData=[NSData dataFromBase64String:dataString];
            [self checkLongPressWithImageData:imageData];
        }
    }];
}

- (void)checkLongPressWithImageData:(NSData *)imageData{
    UIImage *image=[UIImage imageWithData:imageData];
    if (image) {
        if (imageData.length>9*1024*1024) {
            imageData=UIImageJPEGRepresentation(image, 0.8);
        }
        [self handleWebViewLongPressWithImageData:imageData];
    }
}

- (void)handleWebViewLongPressWithImageData:(NSData *)imageData{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveAction=[UIAlertAction actionWithTitle:@"保存到本地相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self downloadImageWithImage:[UIImage imageWithData:imageData]];
    }];
    UIAlertAction *shareAction=[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (imageData&&imageData.length>0) {
            Ule_ShareModel *shareModel = [[Ule_ShareModel alloc]init];
            shareModel.shareType=@"110";
            shareModel.singleImgData=imageData;
            [[Ule_ShareView shareViewManager] registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
            [[Ule_ShareView shareViewManager] shareWithModel:shareModel withViewController:[UIViewController currentViewController].tabBarController viewTitle:@"通过社交软件分享才能获得更多客流哟" resultBlock:^(NSString *name, NSString *result) {
                if ([result isEqualToString:SV_Success]) {
                    //抽奖
                    [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
                }
            }];
        }
    }];
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:saveAction];
    [alertController addAction:shareAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)downloadImageWithImage:(UIImage *)image{
    if ([USAuthorizetionHelper photoLibaryAuth]) {
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在保存"];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }else{
        //弹alert
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存失败" message:@"需要获取相册权限" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
//    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@",self.shareModel.listId] moduleid:@"商品分享" moduledesc:@"下载图片" networkdetail:@""];
}
#pragma mark - <图片成功保存回调>
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
    if (!error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:@"您可到相册查看图片" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }else {
        [UleMBProgressHUD showHUDWithText:@"保存失败" afterDelay:2.0];
    }
}
#pragma mark - <button action>

- (void)popToUp{
    if (self.leftBtnAction) {//如果有action事件，则直接pop到rootViewController。
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if (self.wk_mWebView.canGoBack) {
        [self.wk_mWebView goBack];
    }else{
        if (self.backToRoot) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)buttonAction_back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonAction_changeEnterprise
{
    [US_UserUtility sharedLogin].enterpriseMark = @"2";
    NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@YES forKey:@"hadEnterprice"];
    [userInfo setObject:@"1" forKey:@"isEnterpriseChange"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
}

- (void)buttonAction_share{
    //第一个原生webview 交互获取分享数据
    dispatch_async(dispatch_get_main_queue(), ^{
        @weakify(self);
        [self.wk_mWebView evaluateJavaScript:@"shareCall()" completionHandler:^(id response, NSError * error) {
            @strongify(self);
            if (response) {
                [self handleShareInfor:response];
            }
        }];
    });
    //    //第二个通过dsbridge 方式交互获取分享数据（可异步获取数据返回）
    //    @weakify(self);
    //    [self runJsFunction:@"shareCall2" andParams:nil completion:^(id value) {
    //        @strongify(self);
    //        if (value) {
    //            [self handleShareInfor:value];
    //        }
    //    }];
}

- (void)handleShareInfor:(NSString *)shareInfo{
    if (shareInfo) {
        NSString * infoStr=(NSString *)shareInfo;
        if ([NSString isNullToString:infoStr].length<=0) {
            return;
        }
        //开始分享
        [self.mWebViewParser shareWithShareInfo:infoStr];
    }
}

-(void)searchBtnAcion {
    NSString * categoryLinkUrl=[NSString stringWithFormat:@"%@/ulewap/category_v2.html",[UleStoreGlobal shareInstance].config.ulecomDomain];
    NSMutableDictionary *dic = @{@"key":categoryLinkUrl,
                                 @"hasnavi":@"1",
                                 @"title":@"分类"}.mutableCopy;
    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
}
#pragma mark - <Alert delegate>
- (void) showCustemAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"系统提示" message:@"未获取到相关详细信息，请您稍后尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.delegate=self;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self popToUp];
}

#pragma mark - <WKWebView delegate>
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [self.mWebProgressLayer startLoad];
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [UleMBProgressHUD hideHUDForView:self.view];
    [self.mWebProgressLayer finishedLoad];
    [self refreshNavigationBar];
    //调用JS方法
    NSString *jsFunction=[self.m_Params objectForKey:@"JSFuncName"];
    if (jsFunction&&jsFunction.length>0) {
        [self.wk_mWebView evaluateJavaScript:jsFunction completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        }];
        [self.m_Params removeObjectForKey:@"JSFuncName"];
    }
    /*在完全加载完成后需要重新给WKWebView设置Cookie，如果你不这样做的话很有可能因为a标签跳转，导致下一次跳转的时候Cookie丢失。*/
    [[USCookieHelper sharedHelper] resetCookieToWebView:webView];
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [webView evaluateJavaScript:[[USCookieHelper sharedHelper] cookieJavaScriptString] completionHandler:nil];
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    NSString *absoluteString = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSLog(@"URLSTRING: %@", absoluteString);
    //微信H5支付
    static NSString *endPayRedirectURL = nil;
    if ([absoluteString hasPrefix:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb"]) {
        NSString *appendingScheme=@"";
        NSString *fupinH5Pay_domain_prd=[UleStoreGlobal shareInstance].config.fupinDomain;
        if ([absoluteString containsString:fupinH5Pay_domain_prd]) {
            appendingScheme=[NSString stringWithFormat:@"%@.%@", [UleStoreGlobal shareInstance].config.storeScheme, fupinH5Pay_domain_prd];
        }
        if (appendingScheme.length>0 && ![absoluteString hasSuffix:[NSString stringWithFormat:@"redirect_url=%@://",appendingScheme]]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            NSString *redirectUrl = nil;
            if ([absoluteString containsString:@"redirect_url="]) {
                NSRange redirectRange = [absoluteString rangeOfString:@"redirect_url"];
                endPayRedirectURL =  [absoluteString substringFromIndex:redirectRange.location+redirectRange.length+1];
                redirectUrl = [[absoluteString substringToIndex:redirectRange.location] stringByAppendingString:[NSString stringWithFormat:@"redirect_url=%@://",appendingScheme]];
            }else {
                redirectUrl = [absoluteString stringByAppendingString:[NSString stringWithFormat:@"&redirect_url=%@://",appendingScheme]];
            }
            
            NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:redirectUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40];
            newRequest.allHTTPHeaderFields = navigationAction.request.allHTTPHeaderFields;
            newRequest.URL = [NSURL URLWithString:redirectUrl];
            [webView loadRequest:newRequest];
            return;
        }
    }
    
//    if (![scheme isEqualToString:@"https"] && ![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"ulemobile"] && ![scheme isEqualToString:@"ulebuy"] && ![scheme isEqualToString:@"objc"]) {
//        decisionHandler(WKNavigationActionPolicyCancel);
        NSURL *openUrl=navigationAction.request.URL;
        if ([scheme isEqualToString:@"weixin"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            if (endPayRedirectURL) {
                self.urlString=endPayRedirectURL;
                [self loadRequest];
            }
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:openUrl];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
            return;
        }else if ([scheme isEqualToString:@"tel"]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            //打电话
            NSString *resourceSpecifier = [URL resourceSpecifier];
            openUrl = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", resourceSpecifier]];
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:openUrl];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
            return;
        }else if([[navigationAction.request.URL host] isEqualToString:@"itunes.apple.com"]){
            //处理跳转App Store链接
            decisionHandler(WKNavigationActionPolicyCancel);
            BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:openUrl];
            if (canOpen) {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
            return;
        }
        
//        return;
//    }
    if (!navigationAction.targetFrame.isMainFrame) {
        //非mainFrame不拦截
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    if ([self us_parseRequestURLString:absoluteString]) {
        decisionHandler(WKNavigationActionPolicyAllow);
    }else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}
#pragma mark - WKUIDelegate
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
#pragma mark - <UleWebViewBridgeDelegate>
- (void)loadNavigationBarWithTitle:(NSString *)title andRightButtons:(NSArray *)btns{
    if (title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
        self.uleCustemNavigationBar.rightBarButtonItems=btns;
        [self hiddenNavigationBar:NO offSetStatus:NO animated:NO];
    }else{
        [self hiddenNavigationBar:YES offSetStatus:YES animated:NO];
    }
}

//调用JS方法（带参数）
- (void)runJsFunction:(NSString *)functionName andParams:(NSArray *)params {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wk_mWebView callHandler:functionName
                            arguments:params
                    completionHandler:^(id  _Nullable value) {
            
        }];
    });
}

- (void)runJsFunction:(NSString *)functionName andParams:(NSArray *)params completion:(void(^)(id value))complete{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.wk_mWebView callHandler:functionName
                            arguments:params
                    completionHandler:^(id  _Nullable value) {
            if (complete) {
                complete(value);
            }
        }];
    });
}

-(void)handleRequestUrl:(NSString *)actionUrl{
    [self us_parseRequestURLString:actionUrl];
}

-(void)jsFunctionShareInWebview:(NSString *)shareJson{
    if (shareJson.length<=0) {
        return;
    }
    USShareModel * shareModel= [USShareModel yy_modelWithJSON:shareJson];
    if (shareModel) {
        [self.mWebViewParser webShareWithShareModel:shareModel];
    }
}
//导航栏上添加搜索条
- (void)loadNavigationSearchBar{
    [self addSearchBarView];
    [self hiddenNavigationBar:NO offSetStatus:NO animated:NO];
}
- (void)setLeftBackButtonAction:(UleUCiOSAction *)action{
    self.leftBtnAction=action;
}
- (void)popToHomeAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - <parse Url>
- (BOOL)us_parseRequestURLString:(NSString *)urlString{
    if ([urlString containsString:uleNeedShare]) {
        self.showShareButton=YES;
    }else {
        self.showShareButton=NO;
    }
    if ([urlString rangeOfString:US_orderPaySuccess].location!=NSNotFound) {
        self.uleCustemNavigationBar.leftBarButtonItems=@[self.offButton];
    }
    //页面内跳转是否隐藏导航栏
    if (urlString.length > 0 && [[urlString lowercaseString] rangeOfString:uleNeedNavBar].location != NSNotFound) {
        self.isHiddenNavigationBar = NO;
        self.isOffsetStatus = NO;
    }
    else if (urlString.length > 0 && [[urlString lowercaseString] rangeOfString:uleNotNeedNavBar].location != NSNotFound){
        self.isHiddenNavigationBar = YES;
        self.isOffsetStatus = YES;
    }
    [self hiddenNavigationBar:self.isHiddenNavigationBar offSetStatus:self.isOffsetStatus animated:YES];
    
    if ([[urlString lowercaseString] rangeOfString:ule_Mobile].location != NSNotFound) {
        NSString *outMobile = [urlString substringFromIndex:[[urlString lowercaseString] rangeOfString:ule_Mobile].location+ule_Mobile.length];
        return  [self ule_parseUle_MobileRequestURLString:outMobile];
    }
    if([[urlString lowercaseString] hasPrefix:ule_buy]){
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",ule_buy]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",ule_buy]]];
            NSString *js = [NSString stringWithFormat:@"historyBack()"];
            [self.wk_mWebView evaluateJavaScript:js completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            }];
        }
        return NO;
    }
    return YES;
}

// 解析请求
- (BOOL)ule_parseUle_MobileRequestURLString:(NSString *)urlstr {
    NSString *outMobile = urlstr;
    NSArray * array=[outMobile componentsSeparatedByString:@"_"];
    if (array.count>0) {
        NSString *action=[array[0] lowercaseString];
        NSString * method=kUleWebActionDic[action];
        SEL actionSEL=NSSelectorFromString(method);
        if ([self.mWebViewParser respondsToSelector:actionSEL]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return  (BOOL)[self.mWebViewParser performSelector:actionSEL withObject:outMobile];
#pragma clang diagnostic pop
        }else if ([[urlstr lowercaseString] rangeOfString:US_jumpVC].location!=NSNotFound){
            NSString * method=kUleWebActionDic[US_jumpVC];
            SEL actionSEL=NSSelectorFromString(method);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return (BOOL)[self.mWebViewParser performSelector:actionSEL withObject:urlstr];
#pragma clang diagnostic pop
        }
        return YES;
    }
    return YES;
}
#pragma mark - <WKWebview progress>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.wk_mWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        self.mWebProgressLayer.strokeEnd=newprogress;
        if (newprogress>=1) {
            [self.mWebProgressLayer finishedLoad];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - <UIGestureRecognizerDelegate>
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - <setter and getter>
- (DWKWebView *)wk_mWebView {
    if (!_wk_mWebView) {
        _wk_mWebView = [[DWKWebView alloc] initWithFrame:CGRectZero configuration:[self getWebConfig]];
        _wk_mWebView.navigationDelegate = self;
        _wk_mWebView.userInteractionEnabled = YES;
        _wk_mWebView.DSUIDelegate = self;
        _wk_mWebView.backgroundColor = [UIColor whiteColor];
        [_wk_mWebView addJavascriptObject:self.webBridge namespace:nil];
        if (@available(iOS 11.0, *)) {
            _wk_mWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_wk_mWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_wk_mWebView setJavascriptCloseWindowListener:^{
            NSLog(@"window.close called");
        } ];
        [_wk_mWebView addGestureRecognizer:self.mLongPressGes];
    }
    return _wk_mWebView;
}

- (WKWebViewConfiguration *) getWebConfig{
    WKUserContentController* userContentController = WKUserContentController.new;
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:[[USCookieHelper sharedHelper] cookieJavaScriptString] injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [userContentController addUserScript:cookieScript];
    [userContentController addUserScript:noneSelectScript];
    WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
    webViewConfig.userContentController = userContentController;
    webViewConfig.preferences.javaScriptCanOpenWindowsAutomatically=true;
    webViewConfig.processPool = [USCookieHelper sharedHelper].processPool;
    webViewConfig.allowsInlineMediaPlayback=YES;
    if (@available(iOS 10.0, *)) {
        webViewConfig.mediaTypesRequiringUserActionForPlayback=WKAudiovisualMediaTypeNone;
    }else if (@available(iOS 9.0, *)) {
        webViewConfig.requiresUserActionForMediaPlayback=false;
    }else{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        webViewConfig.mediaPlaybackRequiresUserAction=false;
#pragma clang diagnostic pop
    }
    return webViewConfig;
}

- (UleWebViewApiBridge *)webBridge{
    if (!_webBridge) {
        _webBridge=[[UleWebViewApiBridge alloc] init];
        _webBridge.delegate=self;
    }
    return _webBridge;
}
- (UleWebProgressLayer *)mWebProgressLayer {
    
    if (!_mWebProgressLayer) {
        _mWebProgressLayer = [UleWebProgressLayer new];
    }
    return _mWebProgressLayer;
}

- (UIButton *) getNativButtonWithImage:(NSString *)imagePath{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 9, 40, 40);
    btn.tintColor=kNavTitleColor;
    btn.imageEdgeInsets = UIEdgeInsetsMake(9, 9, 9,9);
    [btn setImage:[[UIImage bundleImageNamed:imagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    return btn;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [self getNativButtonWithImage:@"nav_btn_back"];
        [_backButton addTarget:self action:@selector(popToUp) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIButton *)offButton {
    if (!_offButton) {
        _offButton = [self getNativButtonWithImage:@"nav_btn_close"];
        [_offButton addTarget:self action:@selector(buttonAction_back:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _offButton;
}
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton=[self getNativButtonWithImage:@""];
        [_shareButton setBackgroundImage:[[UIImage bundleImageNamed:@"nav_btn_share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(buttonAction_share) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
- (UleControlView *)enterpriseChangeBtn{
    if (!_enterpriseChangeBtn) {
        _enterpriseChangeBtn=[[UleControlView alloc] initWithFrame:CGRectMake(10, 10, KScreenScale(66), KScreenScale(106))];
        _enterpriseChangeBtn.mTitleLabel.text = @"切换";
        _enterpriseChangeBtn.mTitleLabel.font = [UIFont systemFontOfSize:KScreenScale(20)];
        _enterpriseChangeBtn.mTitleLabel.textColor = [UIColor whiteColor];
        [_enterpriseChangeBtn addTouchTarget:self action:@selector(buttonAction_changeEnterprise)];
        _enterpriseChangeBtn.mImageView.sd_layout.centerXEqualToView(_enterpriseChangeBtn)
        .topSpaceToView(_enterpriseChangeBtn, 2)
        .widthIs(23)
        .heightEqualToWidth();
        _enterpriseChangeBtn.mTitleLabel.sd_layout.topSpaceToView(_enterpriseChangeBtn.mImageView, 0)
        .bottomEqualToView(_enterpriseChangeBtn)
        .leftEqualToView(_enterpriseChangeBtn)
        .rightEqualToView(_enterpriseChangeBtn);
    }
    return _enterpriseChangeBtn;
}
- (UleWebViewLinkUrlParser *)mWebViewParser{
    if (!_mWebViewParser) {
        _mWebViewParser=[[UleWebViewLinkUrlParser alloc] init];
        _mWebViewParser.webViewController=self;
    }
    return _mWebViewParser;
}
-(UILongPressGestureRecognizer *)mLongPressGes{
    if (!_mLongPressGes) {
        _mLongPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(startLongPress:)];
        _mLongPressGes.delegate = self;

        _mLongPressGes.minimumPressDuration = 0.4f;
        _mLongPressGes.numberOfTouchesRequired = 1;
        _mLongPressGes.cancelsTouchesInView = YES;
    }
    return _mLongPressGes;
}


@end
