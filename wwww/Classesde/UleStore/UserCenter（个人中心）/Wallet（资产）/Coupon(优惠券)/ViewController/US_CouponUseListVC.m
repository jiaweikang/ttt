//
//  US_CouponUseListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CouponUseListVC.h"
#import "US_StoreDetailTabView.h"
#import "UleBaseViewModel.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_UserCenterApi.h"
#import "US_SearchGoodsSourceModel.h"
#import "US_MyGoodsListCellModel.h"
#import "USGoodsPreviewManager.h"

@interface US_CouponUseListVC ()<US_StoreDetailTabViewDelegate>
@property (nonatomic, strong) US_StoreDetailTabView * mTopTabBar;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mEmtpyPlaceHoldView;
@property (nonatomic, copy) NSString * sortType;
@property (nonatomic, copy) NSString * sortOrder;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, copy) NSString * batchId;
@end

@implementation US_CouponUseListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLoadUI];
    [self setLoadData];
}

- (void)setLoadUI{
    [self.view sd_addSubviews:@[self.mTopTabBar,self.mTableView,self.mEmtpyPlaceHoldView]];
    
    self.mTopTabBar.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(49);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.mTopTabBar, 0);
    self.mEmtpyPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mEmtpyPlaceHoldView.sd_layout.topSpaceToView(self.mTopTabBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
}

- (void)setLoadData{
    NSString *title = [self.m_Params objectForKey:@"title"];
    if (title && title.length>0) [self.uleCustemNavigationBar customTitleLabel:title];
    else [self.uleCustemNavigationBar customTitleLabel:@"该优惠券适用商品"];
    self.sortOrder=@"2";
    self.sortType=@"3";
    self.startIndex=1;
    self.batchId= self.m_Params[@"batchId"];
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
}
#pragma mark - <上拉 下拉>
- (void)beginRefreshHeader{
    self.startIndex=1;
    [self startRequestCanUseConponList];
}

- (void)beginRefreshFooter{
    [self startRequestCanUseConponList];
}

- (void)startRequestCanUseConponList{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildCouponUseListWithId:self.batchId pageIndex:[NSString stringWithFormat:@"%@",@(self.startIndex)] sortType:self.sortType andSortOrder:self.sortOrder] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchUseCouponListDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)fetchUseCouponListDicInfo:(NSDictionary *)dic{
    US_SearchGoodsSourceModel * sourceData=[US_SearchGoodsSourceModel yy_modelWithDictionary:dic];

    
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=5;
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    if (self.startIndex==1) {
        [sectionModel.cellArray removeAllObjects];
    }
    for (int i=0; i<sourceData.data.Listings.count; i++) {
        RecommendModel * detail=sourceData.data.Listings[i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithSearchGoods:detail];
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:detail.listId andSearchKeyword:@"" andPreviewType:@"4" andHudVC:self];
            [UleMbLogOperate addMbLogClick:detail.listId moduleid:@"优惠券商品" moduledesc:@"预览" networkdetail:@""];
        };
        cellModel.logShareFrom=@"商品列表";
        cellModel.logPageName=@"优惠券商品";
        cellModel.shareFrom=@"1";
        cellModel.shareChannel=@"1";
        [sectionModel.cellArray addObject:cellModel];
    }
    self.mTableView.mj_footer.alpha=1.0;
    self.mEmtpyPlaceHoldView.hidden=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView reloadData];
    self.startIndex++;
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count>=[sourceData.data.totalCount integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}
#pragma mark - <TopTabBar delegate>
- (void)didSelectedSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder{
    self.sortType=sortType;
    self.sortOrder=sortOrder;
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
}
#pragma mark - <setter and getter>

- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (US_StoreDetailTabView *)mTopTabBar{
    if (!_mTopTabBar) {
        US_TopTabItem * commision=[US_TopTabItem tabItemWithTitle:@"赚取" sortType:@"1"];
        commision.canSortOrder=NO;
        US_TopTabItem * sale=[US_TopTabItem tabItemWithTitle:@"销量" sortType:@"3"];
        US_TopTabItem * price=[US_TopTabItem tabItemWithTitle:@"售价" sortType:@"2"];
        _mTopTabBar=[[US_StoreDetailTabView alloc] initWithItems:@[sale,commision,price]];;
        _mTopTabBar.delegate=self;;
    }
    return _mTopTabBar;
}
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}
- (US_EmptyPlaceHoldView *)mEmtpyPlaceHoldView{
    if (!_mEmtpyPlaceHoldView) {
        _mEmtpyPlaceHoldView=[[US_EmptyPlaceHoldView alloc] init];
        _mEmtpyPlaceHoldView.iconImageView.image=[UIImage bundleImageNamed:@"myGoods_icon_empty"];
        _mEmtpyPlaceHoldView.titleLabel.text=@"暂时没有搜索到商品哦";
        _mEmtpyPlaceHoldView.describe=@"请重试";
        _mEmtpyPlaceHoldView.hidden=YES;
    }
    return _mEmtpyPlaceHoldView;
}


@end
