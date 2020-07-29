//
//  US_GoodsSourceVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceVC.h"
#import "US_GoodsSourceApi.h"
#import "US_HomeBtnData.h"
#import "UleModulesDataToAction.h"
#import "FileController.h"
#import "US_GoodsSourceListVC.h"
#import "US_GoodsSourceHomeVC.h"
#import "WebDetailViewController.h"
#import "US_DynamicSearchBarView.h"
#import "US_HomeSecureVC.h"
#import "US_MyGoodsListVC.h"
#import "USDragView.h"
#import "FeatureModel_HomeBanner.h"
#import "UleModulesDataToAction.h"
#import "US_GoodsDropDownView.h"
#import "UleControlView.h"
#import "US_EmptyPlaceHoldView.h"
#import "UIView+Shade.h"

@interface US_GoodsSourceVC ()<UleBasePageViewControllerDelegate>
@property (nonatomic, strong) YYAnimatedImageView   *mTopBgImgView;
@property (nonatomic, strong) UleControlView * leftButton;
@property (nonatomic, strong) UleControlView * rightButton_message;
@property (nonatomic, strong) UleControlView * rightButton_scanner;
@property (nonatomic, strong) USDragView *dragView; //首页浮动窗口
@property (nonatomic, strong) HomeBannerIndexInfo *dragIndexInfo;
@property (nonatomic, strong) UIButton * tabRightButton;
@property (nonatomic, strong) US_GoodsDropDownView * dropDownView;
@property (nonatomic, assign) BOOL showDropDownView;
@property (nonatomic, strong) NSMutableArray * titleItemArray;
@property (nonatomic, strong) UIView * homeTabHeadView;
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyPlaceHoldView;
@property (nonatomic, assign) BOOL isInitializeDragView;
@end

@implementation US_GoodsSourceVC

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hiddenUnderLine=YES;
        self.hasNaviBar=YES;
        self.hasTabBar=YES;
        self.titleLayoutType=PageVCTitleAutoWidth;
        self.titleMarin=15;
        self.customUnderLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 13, 3)];
        self.customUnderLine.backgroundColor=[UIColor whiteColor];
        self.customUnderLine.layer.cornerRadius=1.5;
        self.customUnderLine.layer.masksToBounds=YES;
        CAGradientLayer * layer=[UIView setGradualSizeChangingColor:self.customUnderLine.bounds.size fromColor:[UIColor convertHexToRGB:@"FF7D43"] toColor:[UIColor convertHexToRGB:@"FE3247"] gradualType:GradualTypeHorizontal];
        layer.zPosition=-1;
        [self.customUnderLine.layer addSublayer:layer];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    self.offsetY=kIphoneX?KScreenScale(176):KScreenScale(128);
    [self.view addSubview:self.mTopBgImgView];
    self.mTopBgImgView.sd_layout.topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kIphoneX?KScreenScale(220):KScreenScale(172));
    [self.mTopBgImgView addSubview:self.titleView];
    self.titleView.backgroundColor=[UIColor clearColor];
    self.titleView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.mTopBgImgView, 0)
    .rightSpaceToView(self.mTopBgImgView, 0)
    .heightIs(KScreenScale(44));
    [self.titleView addSubview:self.tabRightButton];
    self.tabRightButton.sd_layout.rightSpaceToView(self.titleView, 0)
    .centerYEqualToView(self.titleView)
    .widthIs(KScreenScale(60))
    .heightIs(KScreenScale(44));
    [self.titleView addSubview:self.homeTabHeadView];
    self.homeTabHeadView.sd_layout.leftSpaceToView(self.titleView, 0)
    .topSpaceToView(self.titleView, 0)
    .rightSpaceToView(self.tabRightButton, 0)
    .bottomSpaceToView(self.titleView, 0);
    self.titleScrollView.sd_closeAutoLayout=YES;
    self.titleScrollView.frame=CGRectMake(0, 0, __MainScreen_Width-KScreenScale(60), KScreenScale(44));
    self.separateLine.hidden=YES;
    [self scrollViewToHiddenNavigationBar:self.uleCustemNavigationBar.top_sd>0];
    [self setTitleNormalColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:KScreenScale(28)>14?14:KScreenScale(28)] andNormalALpha:@"0.7" andSelectedAlpha:@"1.0"];
    [self.view addSubview:self.emptyPlaceHoldView];
    self.emptyPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self startRequestGoodsSourceTabData];
    self.uleCustemNavigationBar.leftBarButtonItems=@[self.leftButton];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton_scanner ,self.rightButton_message];
    self.leftButton.sd_layout.leftSpaceToView(self.uleCustemNavigationBar, 0);
    self.rightButton_message.sd_layout.rightSpaceToView(self.uleCustemNavigationBar, 5);
    self.rightButton_scanner.sd_layout.rightSpaceToView(self.rightButton_message, 0);
    @weakify(self);
    US_DynamicSearchBarView *searchBarView=[[US_DynamicSearchBarView alloc]initWithFrame:CGRectZero tapActionBlock:^{
        @strongify(self);
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"货源" moduledesc:@"头部搜索" networkdetail:@""];
        [self pushNewViewController:@"US_SearchGoodsRootVC" isNibPage:NO withData:nil];
    }];
    self.uleCustemNavigationBar.titleLayoutType=WidthStretchLayout;
    self.uleCustemNavigationBar.titleView=searchBarView;
    CGFloat searchBarHeight=KScreenScale(70)>36?36:KScreenScale(70);
    searchBarView.sd_layout.bottomSpaceToView(self.uleCustemNavigationBar,(self.uleCustemNavigationBar.height-kStatusBarHeight-searchBarHeight)*0.5)
    .leftSpaceToView(self.leftButton, 2)
    .rightSpaceToView(self.rightButton_scanner, 2)
    .heightIs(searchBarHeight);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeGetDragWindowInfoSuccess:) name:NOTI_DragViewShow object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeStoreySelectAction:) name:NOTI_HomeStoreyAction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeNaviBgRequestDone:) name:NOTI_HomeNaviBGImageDone object:nil];
    [self.view addSubview:self.dragView];
    self.ignorePageLog=NO;
}

- (void)startRequestGoodsSourceTabData{
    //再请求网络数据
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildGoodsSourceTabList] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        US_HomeBtnData *model = [US_HomeBtnData yy_modelWithDictionary:responseObject];
        NSMutableArray *homeTabArray = [NSMutableArray array];
        for (int i=0; i<model.indexInfo.count; i++) {
            HomeBtnItem *item=model.indexInfo[i];
            //过滤
            if ([UleModulesDataToAction canInputDataMin:item.min_version withMax:item.max_version withDevice:item.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]]) {
                [homeTabArray addObject:item];
            }
        }
        if (homeTabArray.count>1) {
            //排序
            [homeTabArray sortUsingComparator:^NSComparisonResult(HomeBtnItem *obj1, HomeBtnItem *obj2) {
                NSInteger num1 = [obj1.priority integerValue];
                NSInteger num2 = [obj2.priority integerValue];
                if (num1 <= num2) {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
            }];
            //保存本地
            [NSKeyedArchiver archiveRootObject:homeTabArray toFile:[FileController fullpathOfFilename:kCacheFile_GoodsSourceTab]];
            self.emptyPlaceHoldView.hidden=YES;
            [self initPageScrollViewWithTabArray:homeTabArray];
        }else{
            //取缓存数据
            NSArray *goodsSourceTabCacheArray=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_GoodsSourceTab]]];
            if (goodsSourceTabCacheArray.count>0) {
                self.emptyPlaceHoldView.hidden=YES;
                [self initPageScrollViewWithTabArray:goodsSourceTabCacheArray];
            }else {
                NSArray *localData=[HomeBtnItem mj_objectArrayWithKeyValuesArray:[FileController loadArrayListProduct:kCacheFile_HomeTabIndex]];
                if (localData.count>0) {
                    self.emptyPlaceHoldView.hidden=YES;
                    [self initPageScrollViewWithTabArray:localData];
                }else self.emptyPlaceHoldView.hidden=NO;
            }
        }
    } failure:^(UleRequestError *error) {
//        [self showErrorHUDWithError:error];
        [UleMBProgressHUD hideHUDForView:self.view];
        //取缓存数据
        NSArray *goodsSourceTabCacheArray=[NSArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_GoodsSourceTab]]];
        if (goodsSourceTabCacheArray.count>0) {
            self.emptyPlaceHoldView.hidden=YES;
            [self initPageScrollViewWithTabArray:goodsSourceTabCacheArray];
        }else {
            NSArray *localData=[HomeBtnItem mj_objectArrayWithKeyValuesArray:[FileController loadArrayListProduct:kCacheFile_HomeTabIndex]];
            if (localData.count>0) {
                self.emptyPlaceHoldView.hidden=YES;
                [self initPageScrollViewWithTabArray:localData];
            }else self.emptyPlaceHoldView.hidden=NO;
        }
    }];

}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
//            [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    for (HomeBtnItem * tabItem in tabArray) {
        if ([tabItem.ios_action isEqualToString:@"INDEX"]) {
            Class class=[UIViewController getClassMapViewController:@"US_GoodsSourceHomeVC"];
            UleBaseViewController *goodsHomeVC=[[class alloc] init];
            goodsHomeVC.title=tabItem.title;
            goodsHomeVC.ignorePageLog=YES;
            [self addChildViewController:goodsHomeVC];
        }else if ([tabItem.ios_action hasPrefix:@"SEARCHID"]){
            Class class=[UIViewController getClassMapViewController:@"US_GoodsSourceListVC"];
            UleBaseViewController *goodslistVC=[[class alloc] init];
            NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
            if (tabItem) {
                [dic setObject:tabItem forKey:@"homeTabItem"];
            }
            [goodslistVC setM_Params:dic];
            goodslistVC.title=tabItem.title;
            goodslistVC.ignorePageLog=YES;
            [self addChildViewController:goodslistVC];
        }else if ([tabItem.ios_action hasPrefix:@"H5"]){
            Class class=[UIViewController getClassMapViewController:@"WebDetailViewController"];
            UleBaseViewController *web=[[class alloc] init];
            web.title=tabItem.title;
            web.ignorePageLog=YES;
            [web hideCustomNavigationBar];
            //传递数据
            NSMutableDictionary * dic=[NSMutableDictionary dictionary];
            /*184版本开始支持::分割*/
            if ([tabItem.ios_action containsString:@"::"]) {
                NSString *iosActionStr=[tabItem.ios_action stringByReplacingOccurrencesOfString:@"H5##" withString:@"key::"];
                dic=[UleModulesDataToAction parseWebKey_Value:iosActionStr withOuter:@"##" withInner:@"::"];
            }else {
                NSArray *sepArr=[tabItem.ios_action componentsSeparatedByString:@"##"];
                if (sepArr.count>1) {
                    NSString *sourceString=[NSString stringWithFormat:@"key:%@", sepArr[1]];
                    dic=[UleModulesDataToAction parseWebKey_Value:sourceString withOuter:@"#" withInner:@":"];
                }
            }
            [dic setObject:@"0" forKey:KNeedShowNav];
            [dic setObject:@"0" forKey:@"isOffsetStatus"];
            [web setM_Params:dic];
            [self addChildViewController:web];
        }else if ([tabItem.ios_action isEqualToString:@"INSURANCE"]){
            //全民保险
            Class class=[UIViewController getClassMapViewController:@"US_HomeSecureVC"];
            UleBaseViewController *secureVC = [[class alloc]init];
            NSMutableDictionary *dic =[[NSMutableDictionary alloc] init];
            [dic setObject:@"1" forKey:@"hasTab"];
            [secureVC setM_Params:dic];
            [secureVC hideCustomNavigationBar];
            secureVC.title=tabItem.title;
            secureVC.ignorePageLog=YES;
            [self addChildViewController:secureVC];
        }
    }
    [self resetTabListVCAtCurrentPageIndex:0];;
    //**重新布局tab 添加一个按键以及一个固定title**//
    [self relayoutTitleView:tabArray];
}

- (void)relayoutTitleView:(NSArray *)itemArray{
    self.titleItemArray=[itemArray mutableCopy];
    HomeBtnItem * itme=itemArray.firstObject;
    self.dropDownView=[[US_GoodsDropDownView alloc] initWithTitles:itemArray andSelectedTitle:itme.title];
    @weakify(self);
    self.dropDownView.selectBlock = ^(id obj) {
        @strongify(self);
        NSInteger index=[obj integerValue];
        if (self.lablesArray.count>index) {
            [self pageSelect:index];
            HomeBtnItem * item=[self.titleItemArray objectAt:index];
            [LogStatisticsManager onClickLog:Home_IndexTab andTev:NonEmpty(item.title)];
        }
    };
    self.dropDownView.hiddenClick = ^{
        @strongify(self);
        self.showDropDownView=NO;
        self.tabRightButton.selected=NO;
        self.homeTabHeadView.hidden=YES;
    };
}


- (void)leftButtonClick:(id)sender{
    NSString * categoryLinkUrl=[NSString stringWithFormat:@"%@/ulewap/category_v2.html",[UleStoreGlobal shareInstance].config.ulecomDomain];
    NSMutableDictionary *dic = @{@"key":categoryLinkUrl,
                                 @"hasnavi":@"1",
                                 @"title":@"分类"}.mutableCopy;
    [self pushNewViewController:@"WebView" isNibPage:NO withData:dic];
}
- (void)rightButtonClick:(id)sender{
    if (sender == _rightButton_scanner) {
        [LogStatisticsManager onClickLog:Home_IndexScan andTev:@""];
        [self pushNewViewController:@"US_QRScannerVC" isNibPage:NO withData:nil];
    } else if (sender == _rightButton_message) {
        [LogStatisticsManager onClickLog:Home_IndexMsg andTev:@""];
        NSString *msgUrl=[NSString stringWithFormat:@"%@/imweb/messageCenter?channel=%@&userType=%@",[UleStoreGlobal shareInstance].config.livechatDomain,[UleStoreGlobal shareInstance].config.messageChannel,[UleStoreGlobal shareInstance].config.messageType];
        NSMutableDictionary *dic = @{@"key":msgUrl,
                                     @"hasnavi":@"0"}.mutableCopy;
        [self pushNewViewController:@"WebView" isNibPage:NO withData:dic];
    }
}
- (void)handle {
    if (_dragIndexInfo) {
        [UleMbLogOperate addMbLogClick:_dragIndexInfo._id moduleid:@"悬浮按钮" moduledesc:_dragIndexInfo.log_title networkdetail:@""];
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:_dragIndexInfo.ios_action];
        [self pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
    }
}
- (void)showDropDownViewClick:(UITapGestureRecognizer *)ges{
    UIButton *sender=(UIButton*)ges.view;
    self.homeTabHeadView.hidden=NO;
    self.dropDownView.top_sd=self.titleView.bottom_sd;
    self.dropDownView.selectedTitle=[self currentPageTitle];
    if (self.showDropDownView==NO) {
        sender.selected=YES;
        [self.dropDownView showAtView:self.view belowView:self.mTopBgImgView];
        self.showDropDownView=YES;
    }else{
        [self.dropDownView hiddenView:nil];
    }
}

- (NSString *) currentPageTitle{
    if (self.titleItemArray.count>0) {
        if (self.titleItemArray.count>self.currentPageIndex) {
            HomeBtnItem * item=self.titleItemArray[self.currentPageIndex];
            return item.title;
        }
    }
    return @"";
}
- (void)titleClickEventAtIndex:(NSInteger)index{
    [self.dropDownView hiddenView:nil];
    HomeBtnItem * item=[self.titleItemArray objectAt:index];
    [LogStatisticsManager onClickLog:Home_IndexTab andTev:NonEmpty(item.title)];
}

#pragma mark - <通知>
#pragma mark - 悬浮窗位置
- (void)homeGetDragWindowInfoSuccess:(NSNotification *)noti {
    HomeBannerIndexInfo *recommendData = (HomeBannerIndexInfo *)[noti object];
    self.dragIndexInfo=recommendData;
    @weakify(self);
    [self.dragView.clickImgView yy_setImageWithURL:[NSURL URLWithString:recommendData.imgUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        @strongify(self);
        if (error==nil) {
            self.dragView.hidden = NO;
        } else {
            self.dragView.hidden = YES;
        }
    }];
    if (!self.isInitializeDragView) {
        self.isInitializeDragView = YES;
        //尺寸适配
        CGFloat height = [recommendData.wh_rate floatValue]>0 ? KScreenScale(140)/[recommendData.wh_rate floatValue] : KScreenScale(140)/1;
        CGRect frame = self.dragView.frame;
        frame.size.width = KScreenScale(140);
        frame.size.height = height;
        frame.origin = [self fetchDragViewFrame:recommendData.drag_position height:height].origin;
        self.dragView.frame = frame;
        self.dragView.dragHeight = height;
    }
}

- (CGRect)fetchDragViewFrame:(NSString *)directionAndScale height:(CGFloat)dragViewHeight
{
    //directionAndScale 例1:40 (1上 2左 3下 4右 40为比例)
    CGRect frame;
    CGFloat viewWidth = __MainScreen_Width;
    
    NSArray *directionArr = [directionAndScale componentsSeparatedByString:@"&"];
    if (directionArr.count > 1) {
        NSString *direction = directionArr[0];
        float dragViewScale = [directionArr[1] floatValue] / 100;
        if (dragViewScale < 0) {
            dragViewScale = 0;
        } else if (dragViewScale > 1) {
            dragViewScale = 1;
        }
        CGFloat pointY = dragViewScale == 0 ? self.mTopBgImgView.height_sd : (__MainScreen_Height - kTabBarHeight - self.mTopBgImgView.height_sd) * dragViewScale + self.mTopBgImgView.height_sd - dragViewHeight;

        
        if ([direction isEqualToString:@"1"]) {
            frame.origin = CGPointMake(viewWidth * dragViewScale - KScreenScale(140), self.mTopBgImgView.height_sd);
        } else if ([direction isEqualToString:@"2"]) {
            frame.origin = CGPointMake(0, pointY);
        } else if ([direction isEqualToString:@"3"]) {
            frame.origin = CGPointMake(viewWidth * dragViewScale - KScreenScale(140), __MainScreen_Height - kTabBarHeight - KScreenScale(140));
        } else if ([direction isEqualToString:@"4"]) {
            frame.origin = CGPointMake(__MainScreen_Width-KScreenScale(140), pointY);
        } else frame = self.dragView.frame;
    } else frame = self.dragView.frame;
    
    return frame;
}

- (void)homeStoreySelectAction:(NSNotification *)noti{
    NSString *selectPageNum=[noti.userInfo objectForKey:@"selectPageNum"];
    NSInteger pageNum=[selectPageNum integerValue]-1;
    if (pageNum>=self.lablesArray.count) {
        pageNum=self.lablesArray.count-1;
    }
    [self pageSelect:pageNum];
}

- (void)homeNaviBgRequestDone:(NSNotification *)noti{
    HomeBannerIndexInfo *recommendData = (HomeBannerIndexInfo *)[noti object];
    NSString *navigationBarImgStr=kIphoneX?[NSString isNullToString:recommendData.background_url_new]:[NSString isNullToString:recommendData.background_url];
    if (navigationBarImgStr.length>0) {
        [self.mTopBgImgView yy_setImageWithURL:[NSURL URLWithString:navigationBarImgStr] placeholder:nil];
    }

}

#pragma mark - <setter and getter>
- (YYAnimatedImageView *)mTopBgImgView{
    if (!_mTopBgImgView) {
        _mTopBgImgView=[[YYAnimatedImageView alloc]init];
        _mTopBgImgView.backgroundColor=[UIColor convertHexToRGB:@"ec3d3f"];
        _mTopBgImgView.userInteractionEnabled=YES;
        [_mTopBgImgView addSubview:self.uleCustemNavigationBar];
        self.uleCustemNavigationBar.height=kIphoneX?KScreenScale(176):KScreenScale(128);
        [self.uleCustemNavigationBar ule_setBackgroundAlpha:0.0];
    }
    return _mTopBgImgView;
}
- (UleControlView *)leftButton{
    if (!_leftButton) {
        _leftButton=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_leftButton.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_classfynew"]];
        _leftButton.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _leftButton.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _leftButton.mTitleLabel.textColor=[UIColor whiteColor];
        _leftButton.mTitleLabel.text=@"分类";
        [_leftButton addTouchTarget:self action:@selector(leftButtonClick:)];
        _leftButton.mImageView.sd_layout.centerXEqualToView(_leftButton)
        .topSpaceToView(_leftButton, 5)
        .widthIs(20)
        .heightEqualToWidth();
        _leftButton.mTitleLabel.sd_layout.topSpaceToView(_leftButton.mImageView, 0)
        .bottomEqualToView(_leftButton)
        .leftEqualToView(_leftButton)
        .rightEqualToView(_leftButton);
    }
    return _leftButton;
}

- (UleControlView *)rightButton_scanner{
    if (!_rightButton_scanner) {
        _rightButton_scanner=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rightButton_scanner.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_scan"]];
        _rightButton_scanner.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _rightButton_scanner.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _rightButton_scanner.mTitleLabel.textColor=[UIColor whiteColor];
        _rightButton_scanner.mTitleLabel.text=@"扫一扫";
        [_rightButton_scanner addTouchTarget:self action:@selector(rightButtonClick:)];
        _rightButton_scanner.mImageView.sd_layout.centerXEqualToView(_rightButton_scanner)
        .topSpaceToView(_rightButton_scanner, 5)
        .widthIs(20)
        .heightEqualToWidth();
        _rightButton_scanner.mTitleLabel.sd_layout.topSpaceToView(_rightButton_scanner.mImageView, 0)
        .bottomEqualToView(_rightButton_scanner)
        .leftEqualToView(_rightButton_scanner)
        .rightEqualToView(_rightButton_scanner);
    }
    return _rightButton_scanner;
}

- (UleControlView *)rightButton_message{
    if (!_rightButton_message) {
        _rightButton_message=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rightButton_message.mImageView setImage:[UIImage bundleImageNamed:@"goods_navi_newMessage"]];
        _rightButton_message.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _rightButton_message.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _rightButton_message.mTitleLabel.textColor=[UIColor whiteColor];
        _rightButton_message.mTitleLabel.text=@"消息";
        [_rightButton_message addTouchTarget:self action:@selector(rightButtonClick:)];
        _rightButton_message.mImageView.sd_layout.centerXEqualToView(_rightButton_message)
        .topSpaceToView(_rightButton_message, 5)
        .widthIs(20)
        .heightEqualToWidth();
        _rightButton_message.mTitleLabel.sd_layout.topSpaceToView(_rightButton_message.mImageView, 0)
        .bottomEqualToView(_rightButton_message)
        .leftEqualToView(_rightButton_message)
        .rightEqualToView(_rightButton_message);
    }
    return _rightButton_message;
}

- (USDragView *)dragView {
    if (!_dragView) {
        _dragView = [[USDragView alloc] initWithFrame:CGRectMake(__MainScreen_Width-KScreenScale(140), 248, KScreenScale(140), KScreenScale(140)) vc:self];
        _dragView.hidden = YES;
        @weakify(self);
        [_dragView setActionBlock:^{
            @strongify(self);
            [self handle];
        }];
    }
    return _dragView;
}

- (UIButton *)tabRightButton{
    if (!_tabRightButton) {
        _tabRightButton=[[UIButton alloc] initWithFrame:CGRectZero];
        _tabRightButton.backgroundColor=[UIColor  clearColor];
        _tabRightButton.adjustsImageWhenHighlighted=NO;
        _tabRightButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [_tabRightButton setImage:[UIImage bundleImageNamed:@"myGoods_btn_down_new"] forState:UIControlStateNormal];
        [_tabRightButton setImage:[UIImage bundleImageNamed:@"myGoods_btn_up_new"] forState:UIControlStateSelected];
        [_tabRightButton setBackgroundImage:[UIColor createImageWithColor:[UIColor clearColor] withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
        [_tabRightButton setBackgroundImage:[UIColor createImageWithColor:[UIColor convertHexToRGB:@"ec3d3f"] withFrame:CGRectMake(0, 0, 1, 1)] forState:UIControlStateSelected];
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showDropDownViewClick:)];
        [_tabRightButton addGestureRecognizer:tapGes];
//        [_tabRightButton addTarget:self action:@selector(showDropDownViewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tabRightButton;
}

- (UIView *)homeTabHeadView{
    if (!_homeTabHeadView) {
        _homeTabHeadView=[UIView new];
        _homeTabHeadView.backgroundColor=[UIColor convertHexToRGB:@"ec3d3f"];
        UILabel *homeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        homeHeaderLabel.backgroundColor = [UIColor clearColor];
        homeHeaderLabel.text = @"频道分类";
        homeHeaderLabel.font = [UIFont systemFontOfSize:15];
        homeHeaderLabel.textAlignment = NSTextAlignmentRight;
        homeHeaderLabel.textColor = [UIColor whiteColor];
        [_homeTabHeadView addSubview:homeHeaderLabel];
        homeHeaderLabel.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        homeHeaderLabel.sd_layout.rightSpaceToView(_homeTabHeadView, 10);
        _homeTabHeadView.hidden=YES;
    }
    return _homeTabHeadView;
}
- (US_EmptyPlaceHoldView *)emptyPlaceHoldView{
    if (!_emptyPlaceHoldView) {
        _emptyPlaceHoldView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _emptyPlaceHoldView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_NoNetwork"];
        _emptyPlaceHoldView.titleLabel.text=@"OMG! 网络不给力";
        _emptyPlaceHoldView.describe=@"请点击重试";
        @weakify(self);
        _emptyPlaceHoldView.clickEvent = ^{
            @strongify(self);
            [self startRequestGoodsSourceTabData];
        };
        _emptyPlaceHoldView.hidden=YES;
    }
    return _emptyPlaceHoldView;
}
@end
