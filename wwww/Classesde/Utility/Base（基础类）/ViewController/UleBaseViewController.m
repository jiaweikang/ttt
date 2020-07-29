//
//  UleBaseViewController.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <UIViewController+UleExtension.h>
#import "US_NetworkExcuteManager.h"
#import "UserDefaultManager.h"
#import "USCustomAlertViewManager.h"
#import "USApplicationLaunchManager.h"
@interface VCRootView : UIView
@property (nonatomic, strong) UleCustemNavigationBar * naviagetionBar;
@end

@implementation VCRootView

- (void)didAddSubview:(UIView *)subview{
    [super didAddSubview:subview];
    if (self.naviagetionBar) {
        [self bringSubviewToFront:self.naviagetionBar];
    }
}

@end
@interface UleBaseViewController ()
@property (nonatomic, strong) VCRootView * containView;
@end

@implementation UleBaseViewController

- (void)dealloc{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=kViewCtrBackColor;
    self.fd_prefersNavigationBarHidden=YES;
    [self.view addSubview:self.uleCustemNavigationBar];
    if (self.navigationController.childViewControllers.count>1) {
        [self.uleCustemNavigationBar showLeftButton];
    }else if (self.presentingViewController){
        [self.uleCustemNavigationBar showLeftButton];
    }
    //设置背景颜色与图片
    [self parseNavigationBarStyleInfo];
    
    //设置cur和cti的值
    NSDictionary * cur=[FileController getAddtionCurNameDic];
    NSDictionary * cti=[FileController getAddtionCtiNameDic];
    [LogStatisticsManager loadController:self withCurDic:cur andCtiDic:cti];
}

- (void)loadView{
    [super loadView];
    VCRootView *containView=[[VCRootView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    containView.naviagetionBar=self.uleCustemNavigationBar;
    self.view=containView;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LogStatisticsManager onPageStart:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [LogStatisticsManager onPageEnd:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //只有配置的首页才需要每次viewDidAppear时调用Aletshow。
    if ([[USApplicationLaunchManager sharedManager].firstTabVCName isEqualToString:NSStringFromClass([self class])]&&[CustomAlertViewManager sharedManager].currentShowedAlertView==nil) {
        
        [[CustomAlertViewManager sharedManager] showApplicationAlertView];
    }
}

-(void)showErrorHUDWithError:(UleRequestError *)error
{
    [UleMBProgressHUD hideHUDForView:self.view];
    NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
    if ([NSString isNullToString:errorInfo].length>0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:1.5];
    }
}

#pragma mark - <Alert>
- (void)showAlertNormal:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - <uleCustemNavigationBar>
-(void)hideCustomNavigationBar{
    self.uleCustemNavigationBar.frame=CGRectMake(0, -self.uleCustemNavigationBar.height_sd, self.uleCustemNavigationBar.width_sd, self.uleCustemNavigationBar.height_sd);
}

-(void)showCustomNavigationBar{
    self.uleCustemNavigationBar.frame=CGRectMake(0, 0, self.uleCustemNavigationBar.width_sd, self.uleCustemNavigationBar.height_sd);
}

- (void)parseNavigationBarStyleInfo{
    NSString *linkStr = self.m_Params[@"link"];
    NSArray *linkArr = [linkStr componentsSeparatedByString:@"**"];
    NSString * backImageUrl;
    NSString * backgroudColor;
    if (linkArr.count > 0) {
        if (linkArr.count == 1) {
            if ([linkArr[0] rangeOfString:@"http"].location != NSNotFound) {
                backImageUrl = linkArr[0];
            } else {
                backgroudColor = linkArr[0];
            }
        } else if (linkArr.count == 2) {
            for (int i = 0; i < linkArr.count; i++) {
                if ([linkArr[i] rangeOfString:@"http"].location != NSNotFound) {
                    backImageUrl = linkArr[i];
                } else {
                    backgroudColor = linkArr[i];
                }
            }
        }
    }
    if (backgroudColor.length>0) {
        [self.uleCustemNavigationBar ule_setBackgroudColor:[UIColor convertHexToRGB:backgroudColor]];
    }
    [self.uleCustemNavigationBar ule_setBackgroudImageUrl:backImageUrl];
}

#pragma mark --<UIStatusBarStyle>
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - <setter and getter>
- (UleCustemNavigationBar *)uleCustemNavigationBar{
    if (!_uleCustemNavigationBar) {
        _uleCustemNavigationBar=[[UleCustemNavigationBar alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, floor(44+kStatusBarHeight))];
        [_uleCustemNavigationBar ule_setBackgroudColor:kNavBarBackColor];
        [_uleCustemNavigationBar ule_setTintColor:[UIColor whiteColor]];
    }
    return _uleCustemNavigationBar;
}

- (UleNetworkExcute *)networkClient_VPS{
    if (!_networkClient_VPS) {
        _networkClient_VPS=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _networkClient_VPS;
}

- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}

- (UleNetworkExcute *)networkClient_CDN{
    if (!_networkClient_CDN) {
        _networkClient_CDN=[US_NetworkExcuteManager uleCDNRequestClient];
    }
    return _networkClient_CDN;
}

- (UleNetworkExcute *)networkClient_Ule{
    if (!_networkClient_Ule) {
        _networkClient_Ule=[US_NetworkExcuteManager uleServerRequestClient];
    }
    return _networkClient_Ule;
}

- (UleNetworkExcute *)networkClient_UstaticCDN{
    if (!_networkClient_UstaticCDN) {
        _networkClient_UstaticCDN=[US_NetworkExcuteManager uleUstaticCDNRequestClient];
    }
    return _networkClient_UstaticCDN;
}

- (UleNetworkExcute *)networkClient_JsonWithoutDomain{
    if (!_networkClient_JsonWithoutDomain) {
        _networkClient_JsonWithoutDomain=[[UleNetworkExcute alloc]init];
        _networkClient_JsonWithoutDomain.tManager.requestSerializer=[AFJSONRequestSerializer serializer];
        _networkClient_JsonWithoutDomain.tManager.requestSerializer.timeoutInterval=12.0;
    }
    return _networkClient_JsonWithoutDomain;
}

- (MJRefreshGifHeader*)mRefreshHeader{
    if (!_mRefreshHeader) {
        NSData * gifData =[UserDefaultManager getLocalDataObject:kUserDefault_dropDownGifView];
        if (gifData==nil) {
            gifData=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UleStoreApp.bundle/gif_refresh_header" ofType:@"gif"]];
        }
        NSMutableArray * images=[UIImage praseGIFDataToImageArray:gifData];
        @weakify(self);
        MJRefreshGifHeader * header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            if ([self respondsToSelector:@selector(beginRefreshHeader)]) {
                 [self beginRefreshHeader];
            }
        }];
        NSMutableArray * imageScales=[[NSMutableArray alloc] init];
        for (int i=0; i<images.count; i++) {
            UIImage * image=images[i];
            image=[image imageByScalingToSize:CGSizeMake(60, 70)];
            [imageScales addObject:image];
        }
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setImages:imageScales forState:MJRefreshStateIdle];
        [header setImages:imageScales forState:MJRefreshStatePulling];
        [header setImages:imageScales forState:MJRefreshStateRefreshing];
        _mRefreshHeader=header;
        header.gifView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _mRefreshHeader;
}

- (MJRefreshFooter *)mRefreshFooter{
    if (!_mRefreshFooter) {
        @weakify(self);
        MJRefreshFooter * footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if ([self respondsToSelector:@selector(beginRefreshFooter)]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self beginRefreshFooter];
                });
            }
        }];
        _mRefreshFooter=footer;
    }

    return _mRefreshFooter;
}

@end
