//
//  US_MyGoodsSyncVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/13.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsSyncVC.h"
#import "US_EmptyPlaceHoldView.h"
#import "UleBaseViewModel.h"
#import "US_MyGoodsApi.h"
#import "WebFavoriteModel.h"
#import "US_MyGoodsListCellModel.h"
#import "US_MyGoodsSyncBottomView.h"
#import "US_SyncGoodsAlert.h"
@interface US_MyGoodsSyncVC ()<US_MyGoodsSyncDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mEmtpyPlaceHoldView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) US_MyGoodsSyncBottomView * mBottomView;
@property (nonatomic, assign) BOOL isAllSelected;
@end

@implementation US_MyGoodsSyncVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"邮乐网收藏夹"];
    [self.view sd_addSubviews:@[self.mTableView,self.mEmtpyPlaceHoldView,self.mBottomView]];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.mBottomView, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    [self beginRefreshHeader];
}

#pragma mark - <上拉 下拉>
- (void)beginRefreshHeader{
    [self.mBottomView setAllSelected:NO];
    self.startIndex=1;
    [self startRequestUleSyncGoodsListInfo];
}

- (void)beginRefreshFooter{
     [self startRequestUleSyncGoodsListInfo];
}

#pragma mark - <http>
- (void)startRequestUleSyncGoodsListInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildGetUleFavoriteListAtStart:[NSString stringWithFormat:@"%@",@(self.startIndex)] andPageNum:@"20"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchUleSyncGoodsDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)startSyncFavoriteListIds:(NSString *)listIds{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在同步"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildSyncFavoriteLists:listIds] success:^(id responseObject) {
        @strongify(self);
        [self handleSyncGoodeSuccess];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        @weakify(self);
        US_SyncGoodsAlert * alert=[US_SyncGoodsAlert alertWithType:US_SyncGoodsAlertTypeFail clickBlock:^{
            @strongify(self);
             NSString * selectList=[self filtSelectedLists];
            if (selectList.length>0) {
                [self startSyncFavoriteListIds:selectList];
            }
        }];
        [alert showViewWithAnimation:AniamtionAlert];
    }];
}


- (void)fetchUleSyncGoodsDicInfo:(NSDictionary *)dic{
    WebFavoriteModel * syncInfo=[WebFavoriteModel yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=5;
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    if (self.startIndex==1) {
        [sectionModel.cellArray removeAllObjects];
    }
    for (int i=0; i<syncInfo.data.favsListingListInfo.count; i++) {
        WebFavoriteList * detail=syncInfo.data.favsListingListInfo[i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithUleSyncWebFavorite:detail];
        cellModel.isSelected=self.isAllSelected==YES?YES:NO;
        [sectionModel.cellArray addObject:cellModel];
    }
    self.mTableView.mj_footer.alpha=1.0;
    self.mEmtpyPlaceHoldView.hidden=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView reloadData];
    self.startIndex++;
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count>=[syncInfo.data.total integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)handleSyncGoodeSuccess{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (US_MyGoodsListCellModel * cellModel in sectionModel.cellArray) {
            if (cellModel.isSelected) {
                cellModel.isSelected=NO;
                cellModel.synced=@"0";
                cellModel.listingState=@"0";
            }
        }
    }
    [self.mTableView reloadData];
    [UleMBProgressHUD hideHUDForView:self.view];
    US_SyncGoodsAlert * alert=[US_SyncGoodsAlert alertWithType:US_SyncGoodsAlertTypeSuccess clickBlock:nil];
    [alert showViewWithAnimation:AniamtionAlert];
}
#pragma private
- (NSMutableString *)filtSelectedLists{
    NSMutableString * selectedIds=[[NSMutableString alloc] initWithString:@""];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
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
#pragma mark - <cell delegate>
- (void)didSelectedListCellForModel:(US_MyGoodsListCellModel *)model{
    BOOL isAllSelected=YES;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (US_MyGoodsListCellModel * cellModel in sectionModel.cellArray) {
            if (cellModel.synced.length>0&&[cellModel.listingState isEqualToString:@"0"]) {
                //已同步
            }else{
                if (cellModel.isSelected==NO) {
                    isAllSelected=NO;
                }
            }
        }
    }
    self.isAllSelected=isAllSelected;
    [self.mBottomView setAllSelected:isAllSelected];
}
#pragma mark - <bottom delegate>
- (void)seletAllGoods:(BOOL)isSelected{
    self.isAllSelected=isSelected;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (US_MyGoodsListCellModel * cellModel in sectionModel.cellArray) {
            if (cellModel.synced.length>0&&[cellModel.listingState isEqualToString:@"0"]) {
                
            }else{
                cellModel.isSelected=isSelected;
            }
        }
    }
    [self.mTableView reloadData];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"邮乐网收藏夹" moduledesc:@"全部选中" networkdetail:nil];
}

- (void)syncSeletedGoods{
    NSString * selectList=[self filtSelectedLists];
    if (selectList.length>0) {
        [self startSyncFavoriteListIds:selectList];
    }else{
        [UleMBProgressHUD showHUDWithText:@"选择需要同步的商品" afterDelay:1.5];
    }
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"邮乐网收藏夹" moduledesc:@"同步到小店" networkdetail:nil];
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
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
        _mViewModel.rootVC=self;
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
- (US_MyGoodsSyncBottomView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[[US_MyGoodsSyncBottomView alloc] initWithFrame:CGRectZero];
        _mBottomView.delegate=self;
    }
    return _mBottomView;
}
@end
