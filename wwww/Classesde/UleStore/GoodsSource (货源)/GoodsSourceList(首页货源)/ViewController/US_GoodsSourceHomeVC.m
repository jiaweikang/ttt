//
//  US_GoodsSourceHomeVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceHomeVC.h"
#import "US_GoodsSourceLayout.h"
#import "US_GoodsSourceApi.h"
#import "UleBasePageViewController.h"
#import "US_MyGoodsApi.h"
#import "US_GoodsSourceSectionHeader.h"
#import "US_GoodsSourceBannerView.h"
#import "US_GoodsSourceViewModel.h"
#import "US_GoodsRecommendCell.h"
#import "HomeNewActivityGifView.h"
#import "UleRedPacketRainLocalManager.h"
#import "US_GoodsSourceScrollBarView.h"
#import "US_GoodsSourceSuspendBarView.h"
#import "US_GoodsSourceStoreyCell.h"
#import "UleNewRedPacketRainManager.h"
#import "UleRedRainNotificationManager.h"
//#import "US_DynamicSearchBarView.h"
//#import "USDragView.h"
//#import "UleModulesDataToAction.h"

@interface US_GoodsSourceHomeVC ()
//@property (nonatomic, strong) UIButton * leftButton;
//@property (nonatomic, strong) UIButton * rightButton;
//@property (nonatomic, strong) USDragView *dragView; //首页浮动窗口
//@property (nonatomic, strong) HomeBannerIndexInfo *dragIndexInfo;
@property (nonatomic, strong) UICollectionView * mCollectionView;
@property (nonatomic, strong) US_GoodsSourceLayout * mLayout;
@property (nonatomic, strong) NSMutableArray * mDataArray;
@property (nonatomic, strong) US_GoodsSourceViewModel * mViewModel;
@property (nonatomic, strong) dispatch_group_t downloadGroup;
@property (nonatomic, strong) HomeNewActivityGifView * gifView;
@property (nonatomic, strong) US_GoodsSourceSuspendBarView  * suspendBarView;
@end

@implementation US_GoodsSourceHomeVC

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_mCollectionView) {
        [_mCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _downloadGroup=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
//    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    self.downloadGroup = dispatch_group_create();
    [self setUI];
    [self loadUpdate];
    [self handleAllActivitys];
    [self.mCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeGetDragWindowInfoSuccess:) name:NOTI_DragViewShow object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeTopBgImageViewRequestDone:) name:NOTI_HomeTopBGImageDone object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue=[change objectForKey:NSKeyValueChangeNewKey];
        //是否存在滚动条
        BOOL hasScrollBar=NO;
        CGFloat scrollBarMaxY=0.0;
        for (UleSectionBaseModel *sectionModel in self.mViewModel.mDataArray) {
            //因为滚动条前只有header，所以可以这么做，可用visibleSupplementaryViewsOfKind:UICollectionElementKindSectionHeader
            scrollBarMaxY+=sectionModel.headHeight;
            scrollBarMaxY+=sectionModel.footHeight;
            if ([sectionModel.headViewName isEqualToString:@"US_GoodsSourceScrollBarView"]) {
                hasScrollBar=YES;
                break;
            }
        }
        if (newvalue.UIOffsetValue.vertical==0 || !hasScrollBar) {
            return;
        }
        BOOL isShow=newvalue.UIOffsetValue.vertical>scrollBarMaxY;
        [self isShowAdvScrollBar:isShow];
    }
}

- (void)setUI{
    [self hideCustomNavigationBar];
//    [self.uleCustemNavigationBar ule_setBackgroundAlpha:0.0];
//    self.uleCustemNavigationBar.leftBarButtonItems=@[self.leftButton];
//    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
//    @weakify(self);
//    US_DynamicSearchBarView *searchBarView=[[US_DynamicSearchBarView alloc]initWithFrame:CGRectMake(20, 0, __MainScreen_Width - 100 , 30) tapActionBlock:^{
//        @strongify(self);
//        [UleMbLogOperate addMbLogClick:@"" moduleid:@"货源" moduledesc:@"头部搜索" networkdetail:@""];
//        [self pushNewViewController:@"US_SearchGoodsRootVC" isNibPage:NO withData:nil];
//    }];
//    self.uleCustemNavigationBar.titleLayoutType=WidthStretchLayout;
//    self.uleCustemNavigationBar.titleView=searchBarView;
    [self.view addSubview:self.mCollectionView];
    self.mCollectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mCollectionView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mCollectionView.mj_header=self.mRefreshHeader;
    [self.view addSubview:self.gifView];
//    [self.view addSubview:self.dragView];
}

- (void)loadUpdate{
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        @strongify(self);
        self.mDataArray=(NSMutableArray *)returnValue;
        self.mLayout.dataArray=self.mDataArray;
        [self.mCollectionView reloadData];
    } faildBlock:^(id errorCode) {
        @strongify(self);
        [self showErrorHUDWithError:errorCode];
    }];
    self.mViewModel.gifRefreshUpdate = ^(NSData * _Nonnull refreshData, NSData * _Nonnull gifData) {
        @strongify(self);
        [self updateRefreshImage:refreshData andGIF:gifData];
    };
}

- (void)updateRefreshImage:(NSData *)refreshData andGIF:(NSData *)gifData{
    if (refreshData) {
        NSMutableArray * images=[UIImage praseGIFDataToImageArray:refreshData];
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
            image=[image imageByScalingToSize:CGSizeMake(__MainScreen_Width, KScreenScale(326))];
            [imageScales addObject:image];
        }
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setImages:imageScales forState:MJRefreshStateIdle];
        [header setImages:imageScales forState:MJRefreshStatePulling];
        [header setImages:imageScales forState:MJRefreshStateRefreshing];
        self.mCollectionView.mj_header=header;
    }else{
        self.mCollectionView.mj_header=self.mRefreshHeader;
    }
    if (gifData) {
        [self.gifView addImageGif:gifData];
        self.gifView.hidden=NO;
    }else{
        self.gifView.hidden=YES;
    }
}

#pragma mark - <悬浮框>
- (void)isShowAdvScrollBar:(BOOL)isShow{
    if (self.mViewModel.scrollBarArray.count>0) {
        if (isShow) {
            if (![self.suspendBarView.mDataArray isEqualToArray:self.mViewModel.scrollBarArray]) {
                self.suspendBarView.mDataArray=self.mViewModel.scrollBarArray;
            }
            if (self.suspendBarView.isHidden) {
                [self.suspendBarView startTimer];
                self.suspendBarView.hidden=NO;
            }
        }else {
            if (!self.suspendBarView.isHidden) {
                [self.suspendBarView stopTimer];
                self.suspendBarView.hidden=YES;
            }
        }
    }else if (_suspendBarView) {
        [_suspendBarView removeFromSuperview];
        _suspendBarView=nil;
    }
}

#pragma mark - <下拉刷新>
- (void)beginRefreshHeader{
    [self requestAPI];
    /*
     if ([UleRedPacketRainLocalManager sharedManager].isRedRainActivity) {
     //获取红包雨活动场次信息
     [UleRedPacketRainLocalManager sharedManager].isPullDownRefresh=YES;
     [[UleRedPacketRainLocalManager sharedManager] requestRedPacketRainTheme];
     }
     */
    //新红包雨活动 跳转h5活动页面
    [UleNewRedPacketRainManager sharedManager].isPullDownRefresh=YES;
    [[UleNewRedPacketRainManager sharedManager] requestRedPacketRainTheme];
}

#pragma mark - <开始请求数据>
- (void)didStartLoadData:(NSNotification *)notify{
    if (self.mViewModel.mDataArray.count<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
        [self requestAPI];
    }
}
#pragma mark - <Activity 活动相关>
- (void)handleAllActivitys{
    //先显示默认下拉图
    [self updateRefreshImage:nil andGIF:nil];
    [UleNewRedPacketRainManager sharedManager].isPullDownRefresh=NO;
    [[UleNewRedPacketRainManager sharedManager] requestRedPacketRainTheme];
    
    [UleNewRedPacketRainManager sharedManager].requestThemeFinishBlock = ^{
        if ([UleNewRedPacketRainManager sharedManager].isActivating) {
            //如果有活动 请求活动下拉图
            //活动GIF动图，下拉刷新动图
            [self didStartRequestGifRefreshActivity];
        }
        else{
            [self updateRefreshImage:nil andGIF:nil];
        }
    };
    [[UleRedRainNotificationManager sharedManager] requestRedPacketRainInfo:@""];
}

//获取活动下拉图片
- (void)didStartRequestGifRefreshActivity{
    //先取缓存图片
    NSData * refreshData=[UserDefaultManager getLocalDataObject:kUserDefault_HomeRefreshView];
    NSData * gifData =[UserDefaultManager getLocalDataObject:kUserDefault_HomeGifView];
    [self updateRefreshImage:refreshData andGIF:gifData];
    //在调用接口获取更新
    @weakify(self);
    NSString * sectionkey= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_HomeRefresh);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:sectionkey] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchHomeGIFRefreshDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)refreshActivityGif{
    if ([UleNewRedPacketRainManager sharedManager].isActivating) {
        NSData * refreshData=[UserDefaultManager getLocalDataObject:kUserDefault_HomeRefreshView];
        NSData * gifData =[UserDefaultManager getLocalDataObject:kUserDefault_HomeGifView];
        [self updateRefreshImage:refreshData andGIF:gifData];
    }else{
        [self updateRefreshImage:nil andGIF:nil];
    }
}

#pragma mark - <Data Request>
- (void)requestAPI {
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    BOOL isSelfRecommend = [[US_UserUtility homeListingFlag] isEqualToString:@"1"];
    @weakify(self);
    dispatch_apply(isSelfRecommend?6:5, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t index) {
        @strongify(self);
        switch (index) {
            case 0: {
                dispatch_group_enter(self.downloadGroup);
                [self requestCommendAPI];
                break;
            }
            case 1: {
                dispatch_group_enter(self.downloadGroup);
                [self requestYouliaoAPI];
                break;
            }
            case 2: {
                dispatch_group_enter(self.downloadGroup);
                [self requestStoreyApi];
                break;
            }
            case 3: {
                dispatch_group_enter(self.downloadGroup);
                [self requestScrollBarAPI];
                break;
            }
            case 4: {
                dispatch_group_enter(self.downloadGroup);
                [self requestBottomRecommendApi];
                break;
            }
            case 5:{
                dispatch_group_enter(self.downloadGroup);
                [self requestSelfRecommendGoodsApi];
                break;
            }
            default:
                break;
        }
    });
    dispatch_group_notify(self.downloadGroup, dispatch_get_main_queue(), ^{
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel structureCellModelsIsHomeRecommend:isSelfRecommend];
        @weakify(self);
        [self.mCollectionView.mj_header endRefreshingWithCompletionBlock:^{
            @strongify(self);
            [self refreshActivityGif];
        }];
    });
}
- (void)requestCommendAPI {
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildGoodsSourceHomeRecommendIndex3Request] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchHomeRecommendDicInfor:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
    }];
}

- (void)requestYouliaoAPI {
    @weakify(self);
    NSString * sectionKey= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_toutiao_list);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:sectionKey] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchHomeYouliaoDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
    }];
}

- (void)requestStoreyApi {
    @weakify(self);
    NSString * sectionKeyStory1= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_index_storey);
    NSString * sectionKeyStory2= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_index_storeySecond);   [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:[NSString stringWithFormat:@"%@-%@",sectionKeyStory1,sectionKeyStory2]] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchHomeStoreyDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
    }];
}

- (void)requestScrollBarAPI {
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildGoodsSourceScrollBarRequest] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchHomeScrollBarDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self.downloadGroup);
    }];
}

- (void)requestBottomRecommendApi{
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildHomeBottomRecommendRequest] success:^(id responseObject) {
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchHomeBottomRecommendDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        dispatch_group_leave(self.downloadGroup);
    }];
}

- (void)requestSelfRecommendGoodsApi{
    [self.networkClient_API beginRequest:[US_GoodsSourceApi buildSelfRecommendGoodsRequest] success:^(id responseObject) {
        dispatch_group_leave(self.downloadGroup);
        [self.mViewModel fetchSelfRecommendGoodsDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        dispatch_group_leave(self.downloadGroup);
    }];
}

#pragma mark - <通知>
//- (void)homeGetDragWindowInfoSuccess:(NSNotification *)noti {
//    HomeBannerIndexInfo *recommendData = (HomeBannerIndexInfo *)[noti object];
//    self.dragIndexInfo=recommendData;
//    //尺寸适配
//    CGFloat height = [recommendData.wh_rate floatValue]>0 ? KScreenScale(140)/[recommendData.wh_rate floatValue] : KScreenScale(140)/1;
//    CGRect frame = self.dragView.frame;
//    frame.size.width = KScreenScale(140);
//    frame.size.height = height;
//    self.dragView.frame = frame;
//    self.dragView.dragHeight = height;
//    @weakify(self);
//    [self.dragView.clickImgView yy_setImageWithURL:[NSURL URLWithString:recommendData.imgUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        @strongify(self);
//        if (error==nil) {
//            self.dragView.hidden = NO;
//        } else {
//            self.dragView.hidden = YES;
//        }
//    }];
//}
//
//- (void)homeTopBgImageViewRequestDone:(NSNotification *)noti{
//    HomeBannerIndexInfo *recommendData = (HomeBannerIndexInfo *)[noti object];
//    NSString *navigationBarColor=[NSString isNullToString:recommendData.titlecolor];
//    if (navigationBarColor.length>0) {
//        [self.uleCustemNavigationBar ule_setBackgroudColor:[UIColor convertHexToRGB:navigationBarColor]];
//    }
//}

#pragma mark - <Actions>
//- (void)leftButtonClick:(id)sender{
//    NSMutableDictionary *dic = @{@"key":kCategoryLinkUrl,
//                                 @"hasnavi":@"1",
//                                 @"title":@"分类"}.mutableCopy;
//    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
//}
//- (void)rightButtonClick:(id)sender{
//    [self pushNewViewController:@"US_QRScannerVC" isNibPage:NO withData:nil];
//}
//- (void)handle {
//    if (_dragIndexInfo) {
//        [UleMbLogOperate addMbLogClick:_dragIndexInfo._id moduleid:@"悬浮按钮" moduledesc:_dragIndexInfo.log_title networkdetail:@""];
//        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:_dragIndexInfo.ios_action];
//        [self pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
//    }
//}
#pragma mark - <setter and getter>
//- (UIButton *)leftButton{
//    if (!_leftButton) {
//        _leftButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [_leftButton setImage:[UIImage imageNamed:@"nav_btn_classfynew"] forState:UIControlStateNormal];
//        [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftButton;
//}
//- (UIButton *)rightButton{
//    if (!_rightButton) {
//        _rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [_rightButton setImage:[UIImage imageNamed:@"nav_btn_scan"] forState:UIControlStateNormal];
//        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _rightButton;
//}
//- (USDragView *)dragView {
//    if (!_dragView) {
//        _dragView = [[USDragView alloc] initWithFrame:CGRectMake(__MainScreen_Width-KScreenScale(140), 248, KScreenScale(140), KScreenScale(140)) vc:self];
//        _dragView.hidden = YES;
//        @weakify(self);
//        [_dragView setActionBlock:^{
//            @strongify(self);
//            [self handle];
//        }];
//    }
//    return _dragView;
//}
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mLayout];
        _mCollectionView.backgroundColor=[UIColor clearColor];
        _mCollectionView.showsVerticalScrollIndicator=NO;
        _mCollectionView.dataSource=self.mViewModel;
        _mCollectionView.delegate=self.mViewModel;
//        self.mViewModel.uleCustemNavigationBar=self.uleCustemNavigationBar;
        if (@available(iOS 11.0, *)) {
            _mCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets=YES;
        }
    }
    return _mCollectionView;
}


- (US_GoodsSourceLayout *)mLayout{
    if (!_mLayout) {
        _mLayout=[[US_GoodsSourceLayout alloc] init];
    }
    return _mLayout;
}

- (US_GoodsSourceViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_GoodsSourceViewModel alloc] init];
//        @weakify(self);
//        _mViewModel.collectionViewScrollBlock = ^(CGFloat offsetY) {
//            @strongify(self);
//            [UIView animateWithDuration:0.2 animations:^{
//                if (offsetY<0) {
//                    [self.gifView hideView:YES];
//                }else{
//                    [self.gifView hideView:NO];
//                }
//            }];
//        };
    }
    return _mViewModel;
}

- (HomeNewActivityGifView *)gifView{
    if (!_gifView) {
        _gifView=[[HomeNewActivityGifView alloc] initWithFrame:CGRectMake(__MainScreen_Width-45,0,40,140) gif:@""];
    }
    return _gifView;
}

- (US_GoodsSourceSuspendBarView *)suspendBarView{
    if (!_suspendBarView) {
        _suspendBarView=[[US_GoodsSourceSuspendBarView alloc]initWithFrame:CGRectMake(5, 15, KScreenScale(600), 30)];
        [self.view addSubview:_suspendBarView];
    }
    return _suspendBarView;
}

@end
