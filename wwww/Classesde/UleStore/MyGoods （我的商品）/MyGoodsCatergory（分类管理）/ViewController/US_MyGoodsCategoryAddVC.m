//
//  US_MyGoodsCategoryAddVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/31.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsCategoryAddVC.h"
#import "US_MyGoodsApi.h"
#import "MyFavoritesLists.h"
#import "UleSectionBaseModel.h"
#import "US_MyGoodsListCellModel.h"
#import "UIImage+USAddition.h"
#import "UleBaseViewModel.h"
#import "UleControlView.h"
#import "US_SegmentBarView.h"
@interface US_MyGoodsCategoryAddVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * mContainerView;
@property (nonatomic, strong) NSMutableArray * tableViewArray;
@property (nonatomic, strong) UIView * mBottomView;
@property (nonatomic, strong) NSMutableArray * viewModelArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL requestMoreData;//加载更多
@property (nonatomic, strong) US_SegmentBarView * topSegmentView;
@property (nonatomic, copy) NSString * categoryId;
@end

@implementation US_MyGoodsCategoryAddVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar setTitleView:self.topSegmentView];
    [self.view sd_addSubviews:@[self.mContainerView,self.mBottomView]];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    self.mContainerView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mContainerView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.mBottomView, 0);
    self.categoryId=[self.m_Params objectForKey:@"categoryId"];
    self.currentPage=0;
    [self creatScrollViewContent];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRequestData];
}

- (void)creatScrollViewContent{
    _viewModelArray=[[NSMutableArray alloc] init];
    _tableViewArray=[[NSMutableArray alloc] init];
    for (int i=0; i<2; i++) {
        UITableView * tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor=[UIColor clearColor];
        tableView.showsVerticalScrollIndicator = NO;
        tableView.tag=i;
        tableView.mj_header=[self getRefreshHeader];
        tableView.mj_footer=[self getRefreshFooter];
        tableView.mj_footer.alpha=0.0;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
         UleBaseViewModel * viewModel=[[UleBaseViewModel alloc] init];
        tableView.dataSource=viewModel;
        tableView.delegate=viewModel;
        [self.tableViewArray addObject:tableView];
        [self.mContainerView addSubview:tableView];
        [self.viewModelArray addObject:viewModel];
        tableView.sd_layout.leftSpaceToView(self.mContainerView, __MainScreen_Width*i)
        .topSpaceToView(self.mContainerView, 0)
        .bottomSpaceToView(self.mContainerView, 0)
        .widthIs(__MainScreen_Width);
    }
    self.mContainerView.contentSize=CGSizeMake(__MainScreen_Width*2, __MainScreen_Height-self.uleCustemNavigationBar.height_sd-49);
}

#pragma mark - <http 数据请求>
- (void)beginRequestData{
    NSString * start=@"0";
    UleBaseViewModel * viewModel=self.viewModelArray[self.currentPage];
    UleSectionBaseModel * sectionModel=viewModel.mDataArray.firstObject;
    if (sectionModel&&self.requestMoreData) {
        start=[NSString stringWithFormat:@"%@",@(sectionModel.cellArray.count)];
    }
    if (self.currentPage==0) {
        [self getAllCatoryListWithStartIndex:start andPageSize:@"10"];
    }else{
        [self getNoCatoryProductListStartIndex:start andPageSize:@"10"];
    }
}

- (void)getAllCatoryListWithStartIndex:(NSString *)startIndex andPageSize:(NSString *)pageSize{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:@"" flag:@"" listingType:@"" start:startIndex andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        UITableView * tableView=self.tableViewArray[self.currentPage];
        [tableView.mj_header endRefreshing];
    }];
}

- (void)getNoCatoryProductListStartIndex:(NSString *)startIndex andPageSize:(NSString *)pageSize{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildNoCategoryListAtStart:startIndex andPageSize:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        UITableView * tableView=self.tableViewArray[self.currentPage];
        [tableView.mj_header endRefreshing];
    }];
}
- (void)startAddNewGoodsWithListIds:(NSString *)listIds{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildAddGoodsForListingIds:listIds andCategoryId:NonEmpty(self.categoryId)] success:^(id responseObject) {
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CategoryUpdate object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MyGoodsListRefresh object:nil];
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
#pragma mark - <private function>
- (NSMutableString *)filtSelectedLists{
    UleBaseViewModel * viewModel=self.viewModelArray[self.currentPage];
    NSMutableString * selectedIds=[[NSMutableString alloc] initWithString:@""];
    UleSectionBaseModel * sectionModel=viewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (int i=0;i<sectionModel.cellArray.count;i++) {
            US_MyGoodsListCellModel * cellModel=sectionModel.cellArray[i];
            if (cellModel.isSelected) {
                [selectedIds appendString:[NSString stringWithFormat:@"%@,",cellModel.listId]];;
            }
        }
        if (selectedIds.length>0) {
            [selectedIds deleteCharactersInRange:NSMakeRange(selectedIds.length-1, 1)];
        }
    }
    return selectedIds;
}
- (void)handleRecommendInfo:(NSDictionary *)dic{
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
    UleBaseViewModel * viewModel=self.viewModelArray[self.currentPage];
    if (!self.requestMoreData) {
        [viewModel.mDataArray removeAllObjects];
    }
    UleSectionBaseModel * sectionModel=viewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [viewModel.mDataArray addObject:sectionModel];
    }
    sectionModel.headHeight=0;
    for (int i=0; i<favoritesData.data.result.count; i++) {
        Favorites * detail=favoritesData.data.result[i];
        NSString * categorys=detail.categoryIds;
        NSArray * array=[categorys componentsSeparatedByString:@","];
        
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithFavorites:detail andCellName:@"US_MyGoodsListCell"];
        cellModel.isEditStatus=YES;
        if ([array containsObject:self.categoryId]) {
            cellModel.isSelected=YES;
            cellModel.isAdded=YES;
        }
        [sectionModel.cellArray addObject:cellModel];
    }
    UITableView * tableView=self.tableViewArray[self.currentPage];
    [tableView.mj_header endRefreshing];
    tableView.mj_footer.alpha=1.0;
    if (sectionModel.cellArray.count>=[favoritesData.data.totalRecords integerValue]) {
        [tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [tableView.mj_footer endRefreshing];
    }
    [tableView reloadData];
}
#pragma mark - <>
- (MJRefreshGifHeader * )getRefreshHeader{
    NSMutableArray * images=[UIImage praseGIFDataToImageArray:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"UleStoreApp.bundle/gif_refresh_header" ofType:@"gif"]]];
    @weakify(self);
    MJRefreshGifHeader * header=[MJRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.requestMoreData=NO;
        [self beginRequestData];
    }];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:images forState:MJRefreshStateIdle];
    [header setImages:images forState:MJRefreshStatePulling];
    [header setImages:images forState:MJRefreshStateRefreshing];
    return header;
}
- (MJRefreshFooter *)getRefreshFooter{
    @weakify(self);
    MJRefreshFooter * footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.requestMoreData=YES;
        [self beginRequestData];
    }];
    return footer;
}
- (UleControlView *)buildRoundButtonWithTitle:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] init];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mImageView.sd_layout.leftSpaceToView(button, 0)
    .centerYEqualToView(button)
    .widthIs(18)
    .heightIs(17);
    button.mTitleLabel.sd_layout.leftSpaceToView(button.mImageView, 10)
    .topSpaceToView(button, 0)
    .bottomSpaceToView(button, 0)
    .autoWidthRatio(0);
    button.mTitleLabel.textColor=[UIColor whiteColor];
    button.mTitleLabel.font=[UIFont systemFontOfSize:14];
    [button.mTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [button setupAutoWidthWithRightView:button.mTitleLabel rightMargin:0];
    return button;
}
#pragma mark - <scrollView delegate>
//滑动页面接收后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidChangePage:scrollView];
}
//点击按键页面切换后
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidChangePage:scrollView];
}
- (void)scrollViewDidChangePage:(UIScrollView *)scrollView{
    if (scrollView.tag==1000) {
        CGFloat offsetX = scrollView.contentOffset.x;
        // 获取角标
        NSInteger i = offsetX / __MainScreen_Width;
        self.currentPage=i;
        UleBaseViewModel * viewModel=self.viewModelArray[self.currentPage];
        UleSectionBaseModel * sectionModel=viewModel.mDataArray.firstObject;
        if (sectionModel==nil||sectionModel.cellArray.count<=0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
            [self beginRequestData];
        }
    }
}
#pragma mark - <action>
- (void)addNewProducts:(id)sender{
    NSString * lists=[self filtSelectedLists];
    if (lists.length>0) {
         [self startAddNewGoodsWithListIds: [self filtSelectedLists]];
    }
}
#pragma mark - <setter and getter>
- (UIScrollView *) mContainerView{
    if (!_mContainerView) {
        _mContainerView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _mContainerView.tag=1000;
        _mContainerView.pagingEnabled=YES;
        _mContainerView.showsHorizontalScrollIndicator=NO;
        _mContainerView.delegate=self;
        _mContainerView.bounces=NO;
    }
    return _mContainerView;
}
- (UIView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[UIView new];
        _mBottomView.backgroundColor=kNavBarBackColor;
        UleControlView * button=[self buildRoundButtonWithTitle:@"确认添加" andImage:@"myGoods_btn_addPrd"];
        [button addTouchTarget:self action:@selector(addNewProducts:)];
        [_mBottomView addSubview:button];
        button.sd_layout.centerXEqualToView(_mBottomView)
        .topSpaceToView(_mBottomView, 0)
        .heightIs(49).autoWidthRatio(0);
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addNewProducts:)];
        [_mBottomView addGestureRecognizer:tap];
        _mBottomView.userInteractionEnabled=YES;
    }
    return _mBottomView;
}
- (US_SegmentBarView *)topSegmentView{
    if (!_topSegmentView) {
        _topSegmentView=[[US_SegmentBarView alloc] initWithItmes:@[@"全部商品",@"未分类"] obserScrollView:self.mContainerView];
        _topSegmentView.obserScrollView=self.mContainerView;
    }
    return _topSegmentView;
}
@end
