//
//  US_MyGoodsBatchManangerVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsBatchManangerVC.h"
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"
#import "UleBaseViewModel.h"
#import "MyFavoritesLists.h"
#import "US_MyGoodsListCellModel.h"
#import "US_MyGoodsApi.h"
#import "US_MyGoodsManagerBottomView.h"
#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_EmptyPlaceHoldView.h"
#import "US_MyGoodsBatchDeleteVC.h"
#import "US_GoodsCatergory.h"
#import "US_MyGoodsListCell.h"
#import "USGoodsPreviewManager.h"
@interface US_MyGoodsBatchManangerVC ()<US_MyGoodsManagerBottomDelegate,US_MyGoodsBatchDeleteVCDelegate,US_MyGoodsListCellDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray *favorArrays;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) NSString * startIndex;
@property (nonatomic, strong) US_MyGoodsManagerBottomView * mBottomView;
@property (nonatomic, assign) BOOL isAllSelected;//是否处于全选状态
@property (nonatomic, strong) NSMutableString * listIds;
@property (nonatomic, strong) NSMutableArray * mDeletedIndexeArray;
@property (nonatomic, strong) NSMutableArray * mSelectedArray;
@property (nonatomic, assign) NSInteger totoalCount;
@property (nonatomic, strong) US_EmptyPlaceHoldView * noItemsBgView;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, assign) BOOL didChanged;//是否有修改（删除、置顶）
@property (nonatomic, strong) CategroyItem * item;
@property (nonatomic, assign) US_MyGoodsBatchListType listType;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, strong) NSString * oldKeywords;
@property (nonatomic, assign) BOOL isListRefresh;
@end

@implementation US_MyGoodsBatchManangerVC

#pragma mark - <Life Cycle>
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    self.item=[self.m_Params objectForKey:@"CategoryItem"];
    self.keywords=[self.m_Params objectForKey:@"keyword"];
    self.oldKeywords=self.keywords;
    self.listType = (BOOL)[self.m_Params objectForKey:@"isSearchListVC"] ? US_MyGoodsBatchListSearch : US_MyGoodsBatchListAllGoods;
    if (self.item) {
        self.mBottomView.onlyDeleteGoods=YES;
        self.uleCustemNavigationBar.rightBarButtonItems=nil;
    }
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    if (self.listType == US_MyGoodsBatchListAllGoods) {
        [self beginRefreshHeader];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.didChanged) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MyGoodsListRefresh object:nil];
    }
}

- (void)setUI{
    [self.uleCustemNavigationBar customTitleLabel:@"批量管理"];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.mBottomView];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0).bottomSpaceToView(self.mBottomView, 0);
    [self.view addSubview:self.noItemsBgView];
    self.noItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.noItemsBgView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mRefreshFooter.alpha=0.0;
}

#pragma mark - <搜索>
- (void)startSearchCategoryWithKeyWord:(NSString *)keyword{
    self.startIndex=@"0";
    self.keywords=keyword;
    [self beginStoreItemsSearchListInfoAtStart:self.startIndex];
}

#pragma mark - <上拉下拉刷新>
- (void)beginRefreshHeader{
    self.startIndex=@"0";
    self.isListRefresh=YES;
    if (self.listType == US_MyGoodsBatchListAllGoods) {
        if (self.item) {
            [self beginRequestCategoryListAtStart:self.startIndex andPageSize:@"10"];
        }else{
            [self beginStoreItemsListInfoAtStart:self.startIndex andPageSize:@"10"];
        }
    } else {
        [self beginStoreItemsSearchListInfoAtStart:self.startIndex];
    }
}

- (void)beginRefreshFooter{
    self.isListRefresh=YES;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        NSInteger cellCount=sectionModel.cellArray.count;
        if (cellCount>0) {
            self.startIndex=[NSString stringWithFormat:@"%@",@(cellCount)];
        }
    }
    if (self.listType == US_MyGoodsBatchListAllGoods) {
        if (self.item) {
            [self beginRequestCategoryListAtStart:self.startIndex andPageSize:@"10"];
        }else{
            [self beginStoreItemsListInfoAtStart:self.startIndex andPageSize:@"10"];
        }
    } else {
        [self beginStoreItemsSearchListInfoAtStart:self.startIndex];
    }
   
}

#pragma mark - <http 网络请求>
//请求搜索列表数据
- (void)beginStoreItemsSearchListInfoAtStart:(NSString *)start{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:self.keywords flag:@"" listingType:@"" start:start andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)beginStoreItemsListInfoAtStart:(NSString *)start andPageSize:(NSString *)pageSize{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:@"" flag:@"" listingType:@"" start:start andPageNum:pageSize] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)beginRequestCategoryListAtStart:(NSString *)start andPageSize:(NSString *)pageSize{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildCatergoryListWithId:self.item.idForCate start:start andPageNum:pageSize] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}


- (void)startBatchDeleteSelectedList{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在删除"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildBatchDeleteWithListIds:self.listIds] success:^(id responseObject) {
        @strongify(self);
        [self handleBatchDeleteInfo];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)startBatchRemoveSelectedList{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在删除"];
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildBatchRemoveWithListIds:self.listIds andCategoryId:self.item.idForCate] success:^(id responseObject) {
        [self handleBatchDeleteInfo];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

- (void)startBatchStickListIds{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"置顶中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildBatchStickListIds:self.listIds] success:^(id responseObject) {
        @strongify(self);
        self.didChanged=YES;
        UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
        [sectionModel.cellArray removeObjectsInArray:self.mSelectedArray];
        //再插入
        for (int i=0; i<self.mSelectedArray.count; i++) {
            [sectionModel.cellArray insertObject:self.mSelectedArray[i] atIndex:i];
        }
        //将已置顶的商品选中状态去除
        for (US_MyGoodsListCellModel *model in self.mSelectedArray) {
            model.isSelected=NO;
        }
        [self.mTableView reloadData];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <数据处理>
- (void)handleRecommendInfo:(NSDictionary *)dic{
    if (self.listType == US_MyGoodsBatchListSearch && ![self.oldKeywords isEqualToString:self.keywords]) {
        self.oldKeywords = self.keywords;
        self.isListRefresh = NO;
    }
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
    self.totoalCount=[favoritesData.data.totalRecords integerValue];
    if ([self.startIndex isEqualToString:@"0"]) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    sectionModel.sectionData=[NSString stringWithFormat:@"%@",favoritesData.data.totalRecords];
    sectionModel.headViewName=@"US_MyGoodsListHeaderView";
    sectionModel.headHeight=22;
    for (int i=0; i<favoritesData.data.result.count; i++) {
        Favorites * detail=favoritesData.data.result[i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithFavorites:detail andCellName:@"US_MyGoodsListCell"];
        cellModel.delegate=self;
        cellModel.isEditStatus=YES;
        if (self.listType==US_MyGoodsBatchListSearch) {
            cellModel.isMyGoodsSearch=YES;
            cellModel.hiddenShareBtn=NO;
            cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString stringWithFormat:@"%@", detail.listId] andSearchKeyword:@"" andPreviewType:@"1" andHudVC:self];
            };
        } else {
            cellModel.hiddenShareBtn=YES;
        }
        if (self.isListRefresh && self.isAllSelected) {
            cellModel.isSelected=self.isAllSelected;
        } else {
            cellModel.isSelected=NO;
            [self.mBottomView setAllSelected:NO];
        }
        [sectionModel.cellArray addObject:cellModel];
    }
    self.noItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView reloadData];
    [self.mTableView.mj_header endRefreshing];
    if ([self.startIndex isEqualToString:@"0"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mTableView setContentOffset:CGPointZero animated:YES];
        });
    }
    self.mRefreshFooter.alpha=1.0;
    if (sectionModel.cellArray.count>=[favoritesData.data.totalRecords integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
    
}

- (void)handleBatchDeleteInfo{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    NSInteger unloads=self.totoalCount-sectionModel.cellArray.count;
    [sectionModel.cellArray removeObjectsInArray:self.mSelectedArray];
    [self.mTableView reloadData];
    self.didChanged=YES;
    //剩余未加载的商品
    if (sectionModel.cellArray.count<=0&&unloads==0) {
        //显示已经没有可以删除的商品了。
        self.noItemsBgView.hidden=NO;
    }else if(unloads>=self.mDeletedIndexeArray.count) {
        self.startIndex=[NSString stringWithFormat:@"%@",@(sectionModel.cellArray.count)];
        
        if (self.listType == US_MyGoodsBatchListAllGoods) {
            if (self.item) {
                [self beginRequestCategoryListAtStart:self.startIndex andPageSize:@"10"];
            }else{
                [self beginStoreItemsListInfoAtStart:self.startIndex andPageSize:@"10"];
            }
        } else {
            [self beginRefreshHeader];
//            [self beginStoreItemsSearchListInfoAtStart:self.startIndex];
        }
    }else if (unloads<self.mDeletedIndexeArray.count){
        self.startIndex=[NSString stringWithFormat:@"%@",@(sectionModel.cellArray.count)];
        if (self.listType == US_MyGoodsBatchListAllGoods) {
            if (self.item) {
                [self beginRequestCategoryListAtStart:self.startIndex andPageSize:@"10"];
            }else{
                [self beginStoreItemsListInfoAtStart:self.startIndex andPageSize:@"10"];
            }
        } else {
            [self beginRefreshHeader];
//            [self beginStoreItemsSearchListInfoAtStart:self.startIndex];
        }
    }
    [UleMBProgressHUD hideHUDForView:self.view];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CategoryUpdate object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MyGoodsListRefresh object:nil];
}
#pragma mark - <bottom delegate>
- (void)seletAllGoods:(BOOL)isSelected{
    self.isAllSelected=isSelected;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (US_MyGoodsListCellModel * cellModel in sectionModel.cellArray) {
            cellModel.isSelected=isSelected;
        }
    }
    [self.mTableView reloadData];
    NSString * logDesc=self.isAllSelected?@"全部选中":@"全部取消";
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"批量管理" moduledesc:logDesc networkdetail:@""];
}

- (void)deleteSeletedGoods{
    [self.mDeletedIndexeArray removeAllObjects];
    self.listIds=[self filtSelectedLists];
    if (_listIds.length<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择要删除的商品" afterDelay:2];
    }else{
        US_MyGoodsDeleteAlertView * alert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"确定删除选中的商品吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        [alert showViewWithAnimation:AniamtionPresentBottom];
    }
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"批量管理" moduledesc:@"删除" networkdetail:@""];
}

- (void)removeSeletedGoods{
    [self.mDeletedIndexeArray removeAllObjects];
    self.listIds=[self filtSelectedLists];
    if (_listIds.length<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择要删除的商品" afterDelay:2];
    }else{
        US_MyGoodsDeleteAlertView * alert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"确定删除选中的商品吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        alert.tag=100;
        [alert showViewWithAnimation:AniamtionPresentBottom];
    }
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"批量管理" moduledesc:@"移除" networkdetail:@""];
}

- (void)upTopSelectedGoods{
    [self.mDeletedIndexeArray removeAllObjects];
    self.listIds=[self filtSelectedLists];
    if (self.mSelectedArray.count<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择要置顶的商品" afterDelay:2];
    }else if(self.mSelectedArray.count>10){
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"一次最多选择10个商品进行置顶" afterDelay:2];
    }else{
        if ([self isHadStickedTotop]) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"当前选中的商品已经置顶" afterDelay:2];
        }else{
            [self startBatchStickListIds];
        }
    }
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"批量管理" moduledesc:@"置顶" networkdetail:@""];
}
#pragma mark - <private Function>
- (BOOL)isHadStickedTotop{
    BOOL hadSticted=YES;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    for (int i=0; i<self.mSelectedArray.count; i++) {
        US_MyGoodsListCellModel * selectedModel=self.mSelectedArray[i];
        US_MyGoodsListCellModel * orginModel=sectionModel.cellArray[i];
        if (![selectedModel.listId isEqualToString:orginModel.listId]) {
            hadSticted=NO;
            break;
        }
    }
    return hadSticted;
}

- (NSMutableString *)filtSelectedLists{
    if (self.mSelectedArray) {
        [self.mSelectedArray removeAllObjects];
    }
    NSMutableString * selectedIds=[[NSMutableString alloc] initWithString:@""];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        for (int i=0;i<sectionModel.cellArray.count;i++) {
            US_MyGoodsListCellModel * cellModel=sectionModel.cellArray[i];
            if (cellModel.isSelected) {
                [self.mSelectedArray addObject:cellModel];
                [self.mDeletedIndexeArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
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
            if (cellModel.isSelected==NO) {
                isAllSelected=NO;
            }
        }
    }
    self.isAllSelected=isAllSelected;
    [self.mBottomView setAllSelected:self.isAllSelected];
}
#pragma mark - <Alert delegate>
- (void)alertView:(US_MyGoodsDeleteAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView.tag==100) {
            [self startBatchRemoveSelectedList];
        }else{
            [self startBatchDeleteSelectedList];
        }
    }else{
        [self.mDeletedIndexeArray removeAllObjects];
    }
}
#pragma mark - <Button Click>
- (void)rightClick:(id)sender{
    US_MyGoodsBatchDeleteVC * deletVC=[[US_MyGoodsBatchDeleteVC alloc] init];
    deletVC.delegate=self;
    [self presentViewController:deletVC animated:YES completion:nil];
}

- (void)didDismissed{
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
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
        _mViewModel.rootVC=self;
    }
    return _mViewModel;
}
- (US_MyGoodsManagerBottomView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[[US_MyGoodsManagerBottomView alloc] init];
        _mBottomView.delegate=self;
    }
    return _mBottomView;
}
- (NSMutableArray *)mDeletedIndexeArray{
    if (!_mDeletedIndexeArray) {
        _mDeletedIndexeArray=[[NSMutableArray alloc] init];
    }
    return _mDeletedIndexeArray;
}
- (NSMutableArray *)mSelectedArray{
    if (!_mSelectedArray) {
        _mSelectedArray=[[NSMutableArray alloc] init];;
    }
    return _mSelectedArray;
}
- (US_EmptyPlaceHoldView *)noItemsBgView{
    if (!_noItemsBgView) {
        _noItemsBgView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _noItemsBgView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_empty"];
        _noItemsBgView.titleLabel.text=@"这里什么也没有哦~";
        _noItemsBgView.hidden=YES;
    }
    return _noItemsBgView;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        UIButton * btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 35)];
        [btn setTitle:@"失效商品" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment=NSTextAlignmentRight;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton=btn;
    }
    return _rightButton;
}
@end
