//
//  US_EnterpriseList.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseList.h"
#import "EnterpriseViewModel.h"
#import "US_EnterpriseApi.h"
#import "US_EnterpriseDataModel.h"
#import "US_EnterprisePlaceholderView.h"
#import "USGoodsPreviewManager.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "UleModulesDataToAction.h"
#import "UleControlView.h"

@interface US_EnterpriseList ()<SDCycleScrollViewDelegate>
{
    NSInteger   currentPage;
}
@property (nonatomic, strong)UITableView                 *mTableView;
@property (nonatomic, strong)EnterpriseViewModel         *mViewModel;
@property (nonatomic, strong)US_EnterprisePlaceholderView   *mPlaceHolderVeiw;
@property (nonatomic, strong)SDCycleScrollView           *bannerCycleView;
@property (nonatomic, strong)NSMutableArray              *mBannerData;
@property (nonatomic, strong) dispatch_group_t  enterpriseApiRequestGroup;
//@property (nonatomic, strong) UleControlView * enterpriseChangeBtn;

@end

@implementation US_EnterpriseList

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    currentPage=1;
    [self.uleCustemNavigationBar customTitleLabel:[US_UserUtility getLowestOrganizationName]];
    [self setUI];
    self.mViewModel.rootScrollView = self.mTableView;
    @weakify(self);
    
    self.mViewModel.recommendCellClickBlock = ^(NSString *listId, NSString *zoneId) {
        @strongify(self);
        [LogStatisticsManager shareInstance].srcid=Srcid_Enterprise_Prd;
        [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:listId andSearchKeyword:@"" andPreviewType:@"2" andHudVC:self];
    };
    [self startRequestSourceData];
}


- (void)setUI{
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.mPlaceHolderVeiw];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header = self.mRefreshHeader;
    self.mPlaceHolderVeiw.sd_layout.centerYEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kImageHeight+kLabelHeight+kButtonHeight+60);
    
//    if ([US_UserUtility sharedLogin].hasCSzg && [[US_UserUtility sharedLogin].m_yzgFlag isEqualToString:@"1"] && self.navigationController.childViewControllers.count<=1) {
//        [US_UserUtility sharedLogin].enterpriseMark = @"2";
//        [self.enterpriseChangeBtn.mImageView setImage:[UIImage bundleImageNamed:@"enterpriseChangeIcon"]];
//        self.uleCustemNavigationBar.rightBarButtonItems=@[self.enterpriseChangeBtn];
//    }
}

#pragma mark - <MJRefresh>
- (void)beginRefreshHeader{
    currentPage=1;
    [self startRequestSourceData];
}

- (void)beginRefreshFooter{
    [self startRequestEnterpriseRecommend];
}

#pragma mark - <网络请求>
- (void)startRequestSourceData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    if (!self.enterpriseApiRequestGroup) {
        self.enterpriseApiRequestGroup = dispatch_group_create();
    }
    dispatch_apply(2, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        dispatch_group_enter(self.enterpriseApiRequestGroup);
        if (i==0) {
            [self startRequestEnterpriseBanner];
        }else if (i==1) {
            [self startRequestEnterpriseRecommend];
        }
    });
    dispatch_group_notify(self.enterpriseApiRequestGroup, dispatch_get_main_queue(), ^{
        [UleMBProgressHUD hideHUDForView:self.view];
        [self endHeaderFooterRefresh];
        [self showPlaceHolderView];
        self.enterpriseApiRequestGroup = nil;
    });
}

- (void)leaveEnterpriseRequestGroup{
    if (self.enterpriseApiRequestGroup) {
        dispatch_group_leave(self.enterpriseApiRequestGroup);
    }
}

- (void)startRequestEnterpriseBanner{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildEnterpriseBanner] success:^(id responseObject) {
        @strongify(self);
        US_EnterpriseBanner *bannerModel = [US_EnterpriseBanner yy_modelWithDictionary:responseObject];
        if (bannerModel.data&&bannerModel.data.count>0) {
            CGFloat height = __MainScreen_Width/2.14;
            US_EnterpriseBannerData *firstObj = [bannerModel.data firstObject];
            if (firstObj&&[firstObj.wh_rate floatValue]>0) {
                height = __MainScreen_Width/[firstObj.wh_rate floatValue];
            }
            NSMutableArray *imgsArr = [NSMutableArray array];
            for (US_EnterpriseBannerData *bannerItem in bannerModel.data) {
                if (bannerItem.customImgUrl&&bannerItem.customImgUrl.length>0) {
                    [imgsArr addObject:bannerItem.customImgUrl];
                    [self.mBannerData addObject:bannerItem];
                }
            }
            [self.bannerCycleView setImageURLStringsGroup:imgsArr];
            [self.bannerCycleView setFrame:CGRectMake(0, 0, __MainScreen_Width, height)];
            self.mTableView.tableHeaderView = self.bannerCycleView;
        }else{
            self.mTableView.tableHeaderView=nil;
        }
        [self leaveEnterpriseRequestGroup];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self leaveEnterpriseRequestGroup];
        [self showErrorHUDWithError:error];
    }];
}

- (void)startRequestEnterpriseRecommend{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildEnterpriseRecommendWithPageIndex:currentPage] success:^(id responseObject) {
        @strongify(self);
        US_EnterpriseRecommend *recommendModel = [US_EnterpriseRecommend yy_modelWithDictionary:responseObject];
        [self.mViewModel handleEnterpriseRecommendData:recommendModel.data isFirstPage:self->currentPage==1];
        [self.mTableView reloadData];
        
        UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
        if (sectionModel.cellArray.count>=[recommendModel.data.totalCount integerValue]) {
            self.mTableView.mj_footer=nil;
        }else {
            self.mTableView.mj_footer=self.mRefreshFooter;
        }
        [self leaveEnterpriseRequestGroup];
        self->currentPage++;
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self leaveEnterpriseRequestGroup];
        [self showErrorHUDWithError:error];
    }];
}


#pragma mark - <ACTION>
- (void)endHeaderFooterRefresh{
    [self.mTableView.mj_header endRefreshing];
    if (self.mTableView.mj_footer) {
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)showPlaceHolderView{
    if (self.mViewModel.mDataArray.count<=0&&self.mTableView.tableHeaderView==nil) {
        self.mPlaceHolderVeiw.hidden=NO;
    }else self.mPlaceHolderVeiw.hidden=YES;
}

//- (void)buttonAction_changeEnterprise
//{
//    [US_UserUtility sharedLogin].enterpriseMark = @"1";
//    NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
//    [userInfo setObject:@YES forKey:@"hadEnterprice"];
//    [userInfo setObject:@"1" forKey:@"isEnterpriseChange"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
//}

#pragma mark - <SDCycleScrollViewDelegate>
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.mBannerData.count>index) {
        US_EnterpriseBannerData *bannerItem = self.mBannerData[index];
        UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:bannerItem.ios_action];
        [LogStatisticsManager onClickLog:Enterprise_Banner andTev:bannerItem.ios_action];
        [self pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
    }
}

#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mTableView.delegate = self.mViewModel;
        _mTableView.dataSource = self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = NO;
    }
    return _mTableView;
}

- (EnterpriseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel = [[EnterpriseViewModel alloc]init];
    }
    return _mViewModel;
}

- (US_EnterprisePlaceholderView *)mPlaceHolderVeiw{
    if (!_mPlaceHolderVeiw) {
        _mPlaceHolderVeiw = [[US_EnterprisePlaceholderView alloc] initWithFrame:CGRectZero];
        _mPlaceHolderVeiw.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _mPlaceHolderVeiw.hidden=YES;
        @weakify(self);
        _mPlaceHolderVeiw.callback = ^{
            @strongify(self);
            [self.mTableView.mj_header beginRefreshing];
        };
    }
    return _mPlaceHolderVeiw;
}

- (SDCycleScrollView *)bannerCycleView{
    if (!_bannerCycleView) {
        _bannerCycleView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];;
        _bannerCycleView.autoScrollTimeInterval=3.0;
        _bannerCycleView.pageControlAliment=SDCycleScrollViewPageContolAlimentRight;
        _bannerCycleView.currentPageDotImage=[UIImage bundleImageNamed:@"goods_icon_page_select"];
        _bannerCycleView.pageDotImage=[UIImage bundleImageNamed:@"goods_icon_page_normal"];
    }
    return _bannerCycleView;
}

- (NSMutableArray *)mBannerData{
    if (!_mBannerData) {
        _mBannerData = [NSMutableArray array];
    }
    return _mBannerData;
}

//- (UleControlView *)enterpriseChangeBtn{
//    if (!_enterpriseChangeBtn) {
//        _enterpriseChangeBtn=[[UleControlView alloc] initWithFrame:CGRectMake(10, 10, KScreenScale(66), KScreenScale(106))];
//        _enterpriseChangeBtn.mTitleLabel.text = @"切换";
//        _enterpriseChangeBtn.mTitleLabel.font = [UIFont systemFontOfSize:KScreenScale(20)];
//        _enterpriseChangeBtn.mTitleLabel.textColor = [UIColor whiteColor];
//        [_enterpriseChangeBtn addTouchTarget:self action:@selector(buttonAction_changeEnterprise)];
//        
//        _enterpriseChangeBtn.mImageView.sd_layout.centerXEqualToView(_enterpriseChangeBtn)
//        .topSpaceToView(_enterpriseChangeBtn, 2)
//        .widthIs(23)
//        .heightEqualToWidth();
//        _enterpriseChangeBtn.mTitleLabel.sd_layout.topSpaceToView(_enterpriseChangeBtn.mImageView, 0)
//        .bottomEqualToView(_enterpriseChangeBtn)
//        .leftEqualToView(_enterpriseChangeBtn)
//        .rightEqualToView(_enterpriseChangeBtn);
//    }
//    return _enterpriseChangeBtn;
//}
@end
