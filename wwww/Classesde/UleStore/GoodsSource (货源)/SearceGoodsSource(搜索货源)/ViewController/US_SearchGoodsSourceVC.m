//
//  US_SearchGoodsSourceVC.m
//  UleStoreApp
//  查找货源
//  Created by chenzhuqing on 2019/3/12.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SearchGoodsSourceVC.h"
#import "US_GoodsSourceApi.h"
#import "US_SearchTextFieldBar.h"
#import "US_SearchGoodsSourceModel.h"
#import "US_StoreDetailTabView.h"
#import "UleBaseViewModel.h"
#import "US_MyGoodsListCellModel.h"
#import "US_EmptyPlaceHoldView.h"
#import "USGoodsPreviewManager.h"
@interface US_SearchGoodsSourceVC ()<US_StoreDetailTabViewDelegate>

@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mEmtpyPlaceHoldView;
@property (nonatomic, strong) NSString * sortType;
@property (nonatomic, strong) NSString * sortOrder;
@property (nonatomic, strong) NSString * storeId;
@property (nonatomic, assign) BOOL       isCityFlag;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSString * keyword;
@property (nonatomic, strong) US_SearchTextFieldBar * mSearchBarView;
@property (nonatomic, strong) US_StoreDetailTabView * mTopTab;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;

@end

@implementation US_SearchGoodsSourceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLoadUI];
    [self setLoadData];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self startSearchGoodsSource];
}
- (void)setLoadUI{
    self.uleCustemNavigationBar.titleView=self.mSearchBarView;
    [self.view sd_addSubviews:@[self.mTopTab,self.mTableView,self.mEmtpyPlaceHoldView]];
    self.mTopTab.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(49);
    
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.mTopTab, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    
    self.mEmtpyPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mEmtpyPlaceHoldView.sd_layout.topSpaceToView(self.mTopTab, 0);
}
- (void)setLoadData{
    self.storeId = self.m_Params[@"levelClassified"];
    self.isCityFlag=self.storeId?YES:NO;
    self.keyword = self.m_Params[@"searchName"]?self.m_Params[@"searchName"]:@"";
    self.sortOrder=@"2";
    self.sortType=@"3";
    self.startIndex=1;
    self.mSearchBarView.searchField.text=self.keyword;
}
#pragma mark - <上拉 下拉>
- (void)beginRefreshHeader{
    self.startIndex=1;
    [self startSearchGoodsSource];
}

- (void)beginRefreshFooter{
    [self startSearchGoodsSource];
}
#pragma mark - <http>
- (void)startSearchGoodsSource{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_GoodsSourceApi buildSearchGoodsSourceSortType:self.sortType sortOrder:self.sortOrder storeId:self.storeId keyword:self.keyword needCityFlag:self.isCityFlag andPageIndex:[NSString stringWithFormat:@"%@",@(self.startIndex)]] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchGoodsSourceDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
    }];
}

- (void)fetchGoodsSourceDicInfo:(NSDictionary *)dic{
    US_SearchGoodsSourceModel * goodsSource=[US_SearchGoodsSourceModel yy_modelWithDictionary:dic];

    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=5;
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    if (self.startIndex==1) {
        [sectionModel.cellArray removeAllObjects];
        NSString * rs=goodsSource.data.Listings.count>0?@"1":@"0";
        NSString * rc=[NSString stringWithFormat:@"%@",@(goodsSource.data.totalCount.integerValue)];
        [LogStatisticsManager onSearchInStoreLog:self.keyword s_cid:@"" s_cn:@"" s_rs:rs s_rc:rc];
    }
    for (int i=0; i<goodsSource.data.Listings.count; i++) {
        RecommendModel * detail=goodsSource.data.Listings[i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithSearchGoods:detail];
        cellModel.logPageName=kPageName_GoodsSearch;
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareChannel=@"1";
        cellModel.shareFrom=@"1";
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            /*日志*/
            NSString *cateId=[NSString isNullToString:self.storeId];
            NSString *keyword=[NSString isNullToString:self.keyword];
            BOOL isSearch=cateId.length==0||[cateId isEqualToString:@"0"];
            [LogStatisticsManager onClickSearchSourceLog:isSearch?@"search":@"category" rel_id1:isSearch?keyword:cateId  rel_id2:[NSString stringWithFormat:@"%@",@(indexPath.row+1)] rel_id3:[NSString isNullToString:detail.listId]];
            /*日志*/
            [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:detail.listId andSearchKeyword:[NSString isNullToString:self.keyword] andPreviewType:@"4" andHudVC:self];
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    self.mTableView.mj_footer.alpha=1.0;
    self.mEmtpyPlaceHoldView.hidden=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView reloadData];
    self.startIndex++;
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count>=[goodsSource.data.totalCount integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}
- (void)didSelectedSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder{
    self.sortType=sortType;
    self.sortOrder=sortOrder;
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
- (US_SearchTextFieldBar *)mSearchBarView{
    if (!_mSearchBarView) {
        @weakify(self);
        _mSearchBarView=[[US_SearchTextFieldBar alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width - 100 , 30) placeholdText:@"请输入关键字" clickReturnBlock:^(UITextField * _Nonnull textField) {
            @strongify(self);
            self.keyword=NonEmpty(textField.text);
            self.storeId=@"";
            [LogStatisticsManager onSearchLog:self.keyword tel:Search_Result];
            [self beginRefreshHeader];
        }];
    }
    return _mSearchBarView;
}
- (US_StoreDetailTabView *)mTopTab{
    if (!_mTopTab) {
        US_TopTabItem * commision=[US_TopTabItem tabItemWithTitle:@"赚取" sortType:@"1"];
        commision.canSortOrder=NO;
        US_TopTabItem * sale=[US_TopTabItem tabItemWithTitle:@"销量" sortType:@"3"];
        US_TopTabItem * price=[US_TopTabItem tabItemWithTitle:@"售价" sortType:@"2"];
        _mTopTab=[[US_StoreDetailTabView alloc] initWithItems:@[sale,commision,price]];;
        _mTopTab.delegate=self;
    }
    return _mTopTab;
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
