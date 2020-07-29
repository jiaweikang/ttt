//
//  US_MyStoreDetailVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/5.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyStoreDetailVC.h"
#import "US_DynamicSearchBarView.h"
#import "US_StoreDetailHeadView.h"
#import "US_StoreDetailTabView.h"
#import "US_MyGoodsApi.h"
#import "UleTableViewCellProtocol.h"
#import "US_StoreDetailListCell.h"
#import "USStoreDetailModel.h"
#import "USGoodsPreviewManager.h"
#import "US_EmptyPlaceHoldView.h"
@interface US_MyStoreDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate,US_StoreDetailTabViewDelegate>
@property (nonatomic, strong) US_StoreDetailHeadView * mHeadView;
@property (nonatomic, strong) US_StoreDetailTabView * mTabBarView;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mEmtpyPlaceHoldView;
@property (nonatomic, strong) NSMutableArray * mDataArray;
@property (nonatomic, strong) UICollectionViewFlowLayout * mLayout;
@property (nonatomic, strong) UICollectionView * mCollectionView;
@property (nonatomic, strong) NSString * sortType;
@property (nonatomic, strong) NSString * sortOrder;
@property (nonatomic, strong) NSString * storeId;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, assign) NSInteger startIndex;
@end

@implementation US_MyStoreDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLoadData];
    [self setLoadUI];
    [self startRequestStoreDetailListInfo];
    
}

- (void)setLoadUI{
    @weakify(self);
    US_DynamicSearchBarView *searchBarView=[[US_DynamicSearchBarView alloc]initWithFrame:CGRectMake(20, 0, __MainScreen_Width - 100 , 30) tapActionBlock:^{
        @strongify(self);
        NSMutableDictionary * dic=@{@"storeId":NonEmpty(self.storeId),@"storeName":NonEmpty(self.storeName)}.mutableCopy;
        [self pushNewViewController:@"US_MyStoreDetailSearchVC" isNibPage:NO withData:dic];
    }];
    self.uleCustemNavigationBar.titleView=searchBarView;
    [self.uleCustemNavigationBar ule_setBackgroundAlpha:0.0];
    [self.view sd_addSubviews:@[self.mHeadView,self.mTabBarView,self.mCollectionView,self.mEmtpyPlaceHoldView]];
    CGFloat deltHeitht=kStatusBarHeight==20?0:24;
    self.mHeadView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(KScreenScale(300)+deltHeitht);
    self.mTabBarView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.mHeadView, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(49);
    self.mCollectionView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.mTabBarView, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    self.mEmtpyPlaceHoldView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.mTabBarView, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);
    
    self.mCollectionView.mj_header=self.mRefreshHeader;
    self.mCollectionView.mj_footer=self.mRefreshFooter;
    self.mCollectionView.mj_footer.alpha=0.0;
    
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.startIndex=1;
    [self startRequestStoreDetailListInfo];
}

- (void)beginRefreshFooter{
    [self startRequestStoreDetailListInfo];
}


- (void)setLoadData{
    self.storeId = [self.m_Params objectForKey:@"storeId"] ? [self.m_Params objectForKey:@"storeId"] : @""; //@"2540";
    self.storeName = [self.m_Params objectForKey:@"storeName"] ? [self.m_Params objectForKey:@"storeName"] : @"";
    self. startIndex=1;
    self.sortOrder=@"2";
    self.sortType=@"1";
}

- (void) startRequestStoreDetailListInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildStoreDetailListInfoSortType:self.sortType sortOrder:self.sortOrder storeId:self.storeId keyword:@"" andPageIndex:[NSString stringWithFormat:@"%@",@(self.startIndex)]] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchStoreDetailListInfoDic:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mRefreshFooter endRefreshing];
        [self.mRefreshHeader endRefreshing];
     
    }];
}

- (void)fetchStoreDetailListInfoDic:(NSDictionary *)dic{
    USStoreDetailModel * storeDetail=[USStoreDetailModel yy_modelWithDictionary:dic];
    [self.mHeadView setStoreName:self.storeName];
    [self.mHeadView setStoreInfo:storeDetail.data.storeInfo];
    if ([[storeDetail.data.storeInfo.storeState description]isEqualToString:@"4"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"店铺已关闭" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }
    if (self.startIndex==1) {
        if (self.mDataArray) {
            [self.mDataArray removeAllObjects];
        }
    }
    if (storeDetail.data.Listings.count>0) {
        [self.mDataArray addObjectsFromArray:storeDetail.data.Listings];
    }
    if (self.mDataArray.count>=[storeDetail.data.totalCount integerValue]) {
        [self.mCollectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mCollectionView.mj_footer endRefreshing];
    }
    self.mEmtpyPlaceHoldView.hidden=self.mDataArray.count<=0?NO:YES;
    self.startIndex++;
    [self.mCollectionView reloadData];
    [self.mCollectionView.mj_header endRefreshing];
}

#pragma mark - <Alert delegagte>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - <UICollection delegate and datasource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    USStoreDetailListingItem * cellModel=self.mDataArray[indexPath.row];
    UICollectionViewCell<UleTableViewCellProtocol> * cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"US_StoreDetailListCell" forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:cellModel];
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [cell setDelegate:self];
    }
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    USStoreDetailListingItem * cellModel=self.mDataArray[indexPath.row];
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:cellModel.listId andSearchKeyword:@"" andPreviewType:@"4" andHudVC:self];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"店铺列表" moduledesc:@"预览" networkdetail:@""];
}

#pragma mark - <Top tab delegate>
- (void)didSelectedSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder{
    self.sortType=sortType;
    self.sortOrder=sortOrder;
    [self beginRefreshHeader];
}


#pragma mark - <setter and getter>
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mLayout];
        _mCollectionView.dataSource=self;
        _mCollectionView.delegate=self;
        [_mCollectionView registerClass:[US_StoreDetailListCell class] forCellWithReuseIdentifier:@"US_StoreDetailListCell"];
        _mCollectionView.backgroundColor=[UIColor clearColor];
    }
    return _mCollectionView;
}

- (US_StoreDetailHeadView *)mHeadView{
    if (!_mHeadView) {
        _mHeadView = [[US_StoreDetailHeadView alloc] initWithFrame:CGRectZero];
    }
    return _mHeadView;
}
- (US_StoreDetailTabView *)mTabBarView{
    if (!_mTabBarView) {
        US_TopTabItem * commision=[US_TopTabItem tabItemWithTitle:@"按收益" sortType:@"1"];
        commision.canSortOrder=NO;
        US_TopTabItem * sale=[US_TopTabItem tabItemWithTitle:@"按销量" sortType:@"3"];
        US_TopTabItem * price=[US_TopTabItem tabItemWithTitle:@"按价格" sortType:@"2"];
        _mTabBarView=[[US_StoreDetailTabView alloc] initWithItems:@[commision,sale,price]];;
        _mTabBarView.delegate=self;
    }
    return _mTabBarView;
}
- (UICollectionViewFlowLayout *)mLayout{
    if (!_mLayout) {
        _mLayout=[[UICollectionViewFlowLayout alloc] init];
        _mLayout.itemSize= CGSizeMake((__MainScreen_Width-15)/2.0, KScreenScale(520));
        _mLayout.minimumLineSpacing=5;
        _mLayout.minimumInteritemSpacing=5;
        _mLayout.sectionInset=UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return _mLayout;
}
- (NSMutableArray *)mDataArray{
    if (!_mDataArray) {
        _mDataArray=[[NSMutableArray alloc] init];
    }
    return _mDataArray;
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
