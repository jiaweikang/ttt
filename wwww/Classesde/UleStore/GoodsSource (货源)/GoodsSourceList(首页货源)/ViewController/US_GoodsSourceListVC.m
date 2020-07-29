//
//  US_GoodsSourceListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceListVC.h"
#import "US_GoodsSourceLayout.h"
#import "UleTableViewCellProtocol.h"
#import "US_GoodsSourceApi.h"
#import "UleModulesDataToAction.h"
#import "UleBasePageViewController.h"
#import "UIImage+USAddition.h"
#import "USGoodsPreviewManager.h"
#import "US_GoodsSourceListCell.h"
#import "US_GoodsSourceViewModel.h"
#import "US_MyGoodsApi.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_GoodsSourceBannerView.h"
@interface US_GoodsSourceListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,US_GoodsSourceListCellDelegate>
@property (nonatomic, strong) UICollectionView * mCollectionView;
@property (nonatomic, strong) US_GoodsSourceLayout * mLayout;
@property (nonatomic, strong) NSMutableArray * mDataArray;
@property (nonatomic, strong) US_GoodsSourceViewModel * mViewModel;
@property (nonatomic, strong) NSString * catergoryId;
@property (nonatomic, strong) US_EmptyPlaceHoldView * placeHoldView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSString * banner_key;
@property (nonatomic, strong) dispatch_group_t downloadGroup;
@end

@implementation US_GoodsSourceListVC

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
    self.pageIndex=1;
    [self setUI];
    [self loadParams];
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        @strongify(self);
        self.mDataArray=(NSMutableArray *)returnValue;
        self.mLayout.dataArray=self.mDataArray;
        [self.mCollectionView reloadData];
        self.placeHoldView.hidden=self.mDataArray.count>0?YES:NO;
    } faildBlock:^(id errorCode) {
        [self showErrorHUDWithError:errorCode];
    }];
//    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
//    [self requestAPI];
}

- (void)setUI{
    [self hideCustomNavigationBar];
    [self.view sd_addSubviews:@[self.mCollectionView,self.placeHoldView]];
    self.mCollectionView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mCollectionView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mCollectionView.mj_header=self.mRefreshHeader;
    self.mCollectionView.mj_footer=self.mRefreshFooter;
    self.mRefreshFooter.alpha=0.0;
    self.placeHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.placeHoldView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
}

- (void)loadParams{
    HomeBtnItem * item = self.m_Params[@"homeTabItem"];
    if (item) {
        NSString *iosAction=[NSString stringWithFormat:@"%@",item.ios_action];
        if (iosAction&&iosAction.length>0) {
            NSArray *sepArr=[iosAction componentsSeparatedByString:@"##"];
            if (sepArr.count>1) {
                self.catergoryId=sepArr[1];
            }
        }
        self.banner_key=item.banner_key;
    }
//    self.catergoryId=[NSString isNullToString:self.m_Params[@"categoryId"]];
//    self.banner_key=[NSString isNullToString:self.m_Params[@"bannerKey"]];
//    [self.uleCustemNavigationBar customTitleLabel:[NSString isNullToString:self.m_Params[@"title"]]];
}
#pragma mark - <下拉,上拉刷新>
- (void)beginRefreshHeader{
    self.pageIndex=1;
    [self requestAPI];
}

- (void)beginRefreshFooter{
    [self startLoadGoodsSourceCatergoryListData];
}

- (void)requestAPI {
    [self startRequestBanner];
    [self startLoadGoodsSourceCatergoryListData];
}

- (void)didStartLoadData:(NSNotification *)notify{
    if (self.mViewModel.mDataArray.count<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
        [self requestAPI];
    }
}
//分类商品列表
- (void)startLoadGoodsSourceCatergoryListData{
    if (self.catergoryId.length>0) {
        @weakify(self);
        [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildGoodsSourCecategoryWithId:self.catergoryId pageSize:@"20" andPageIndex:[NSString stringWithFormat:@"%@",@(self.pageIndex)]] success:^(id responseObject) {
            @strongify(self);
            [UleMBProgressHUD hideHUDForView:self.view];
            US_GoodsCatergoryListData* catergroyList=[US_GoodsCatergoryListData yy_modelWithDictionary:responseObject];
            [self.mViewModel handleCatergoryListData:catergroyList refreshData:self.pageIndex==1?YES:NO];
            [self.mCollectionView.mj_header endRefreshing];
            if (catergroyList.data.result.count<20) {
                self.mCollectionView.mj_footer.hidden = YES;
            } else {
                self.mCollectionView.mj_footer.hidden = NO;
            }
            [self.mCollectionView.mj_footer endRefreshing];
            self.pageIndex++;
            self.mRefreshFooter.alpha=1.0;
        } failure:^(UleRequestError *error) {
            @strongify(self);
//            [self showErrorHUDWithError:error];
            [self.mCollectionView.mj_header endRefreshing];
            [self.mCollectionView.mj_footer endRefreshing];
        }];
    }
}

- (void)startRequestBanner {
    if (self.banner_key.length<=0) {
        return;
    }
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:self.banner_key] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchCatergoryBannerDicInfo:responseObject bannerKey:self.banner_key];
    } failure:^(UleRequestError *error) {
        
    }];
}


#pragma mark - <UICollection delegate and datasource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    US_GoodsSectionModel * sectionModel=self.mDataArray[section];
    return sectionModel.cellArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    US_GoodsSectionModel * sectionModel=self.mDataArray[indexPath.section];
    UleCellBaseModel * cellModel=sectionModel.cellArray[indexPath.row];
    UICollectionViewCell<UleTableViewCellProtocol> * cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellModel.cellName forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:cellModel];
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [cell setDelegate:self];
    }
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        US_GoodsSectionModel * sectionModel=self.mDataArray[indexPath.section];
        if (sectionModel.headViewName.length>0) {
            UICollectionReusableView<UleTableViewCellProtocol> * headerView= [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionModel.headViewName forIndexPath:indexPath];
            [headerView setModel:sectionModel.sectionData];
            if ([headerView respondsToSelector:@selector(setDelegate:)]) {
                [headerView setDelegate:self];
            }
            return headerView;
        }
        return nil;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    US_GoodsSectionModel * sectionModel=self.mDataArray[indexPath.section];
    UleCellBaseModel * cellModel=sectionModel.cellArray[indexPath.row];
    US_GoodsCatergoryListItem * item=cellModel.data;
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:item.listingId andSearchKeyword:@"" andPreviewType:@"4" andHudVC:self];
    [LogStatisticsManager shareInstance].srcid=Srcid_Index_TabPrd;
    [UleMbLogOperate addMbLogClick:NonEmpty(item.listingId) moduleid:NonEmpty(self.title) moduledesc:@"预览" networkdetail:@""];
}

#pragma mark - <cell Delegate>
- (void)didAddGoodswithListId:(NSString *)listId{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在添加"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAddFavorProductWithListId:NonEmpty(listId)] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [UleMBProgressHUD showHUDWithImage:[UIImage bundleImageNamed:@"myGoods_img_savesuccess"] afterDelay:1.5];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
    [UleMbLogOperate addMbLogClick:listId moduleid:self.title moduledesc:@"添加到小店" networkdetail:nil];
}
- (void)didShareGoodsWithListId:(NSString *)listId{
    [UleMbLogOperate addMbLogClick:listId moduleid:self.title moduledesc:@"分享" networkdetail:nil];
}

#pragma mark - <setter and getter>
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mLayout];
        _mCollectionView.backgroundColor=kViewCtrBackColor;
        [_mCollectionView registerClass:[US_GoodsSourceListCell class] forCellWithReuseIdentifier:@"US_GoodsSourceListCell"];
        [_mCollectionView registerClass:[US_GoodsSourceBannerView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"US_GoodsSourceBannerView"];
        _mCollectionView.dataSource=self;
        _mCollectionView.delegate=self;
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
    }
    return _mViewModel;
}
- (US_EmptyPlaceHoldView *)placeHoldView{
    if (!_placeHoldView) {
        _placeHoldView=[[US_EmptyPlaceHoldView alloc] init];
        _placeHoldView.hidden=YES;
    }
    return _placeHoldView;
}
@end
