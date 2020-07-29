//
//  US_MyGoodsListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsListVC.h"
#import "US_MyGoodsApi.h"
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"
#import "UleBaseViewModel.h"
#import "US_MyGoodsListCellModel.h"
#import "USGoodsPreviewManager.h"
#import "MyFavoritesLists.h"
#import "US_MyGoodsListBottomView.h"
#import "US_GoodsCatergory.h"
#import "US_MyGoodsSearchAlertView.h"
#import "US_MyGoodsBatchDeleteVC.h"
#import "UserDefaultManager.h"
#import "NSDate+USAddtion.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_MyGoodsListCell.h"
#import "US_MyGoodsApi.h"

@interface US_MyGoodsListVC ()<US_MyGoodsListBottomViewDelegate,US_MyGoodsBatchDeleteVCDelegate,US_MyGoodsListCellDelegate,US_MyGoodsDeleteAlertViewDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_MyGoodsListBottomView * mBottomView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, weak)  id<US_MyGoodsListRootVCDelegate> delegate;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, assign) BOOL hasGoodsList;
@property (nonatomic, strong) CategroyItem * item;
@property (nonatomic, strong) NSString * startIndex;
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyListView;
@property (nonatomic, assign) BOOL addNewGoods;//是否可以添加新商品
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) US_MyGoodsListType listType;
@property (nonatomic, strong) NSString * allGoodsType;//@""全部商品  1自录商品  2代理商品
@property (nonatomic, strong) US_MyGoodsListCellModel   * deleteCellModel;
@end

@implementation US_MyGoodsListVC
#pragma mark - <LifeCycel>
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    self.delegate=[self.m_Params objectForKey:@"Delegate"];
    self.keywords=[self.m_Params objectForKey:@"keyword"];
    self.item=[self.m_Params objectForKey:@"CategoryItem"];
    self.addNewGoods=[[self.m_Params objectForKey:@"AddNewGoods"] boolValue];
    self.allGoodsType=@"";//默认全部商品 传空
    [self.uleCustemNavigationBar customTitleLabel:self.item.categoryName.length>0?self.item.categoryName:@""];
    [self handleCatergoryType];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    if (self.listType!=US_MyGoodsListSearch) {
        [self startRequestGoodsList];
        if (self.listType==US_MyGoodsListAllGoods) {
            [self startRequestBatchDeleltList];
            [self getUleFavoriteList];
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allMyCategoryListSelect:) name:@"allMyCategoryListSelect" object:nil];
}
- (void)setUI{
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight|UIRectEdgeBottom;
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self.view addSubview:self.mBottomView];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0).topSpaceToView(self.uleCustemNavigationBar, 0);
    
    [self.mTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mRefreshFooter.alpha=0.0;
    self.startIndex=@"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginRefreshHeader) name:NOTI_MyGoodsListRefresh object:nil];
    [self.view addSubview:self.emptyListView];
    self.emptyListView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.emptyListView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
}


- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [_mTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - <下拉、上拉刷新>
- (void)beginRefreshHeader{
    self.startIndex=@"0";
    if (self.item&&self.item.idForCate.length>0) {
        [self beginCategoryListInfoAtStart:self.startIndex];
    }else{
        [self beginStoreItemsListInfoAtStart:self.startIndex];
    }
}

- (void)beginRefreshFooter{

    [self startRequestGoodsList];
}

- (void)startSearchCategoryWithKeyWord:(NSString *)keyword{
    self.keywords=keyword;
    [self beginRefreshHeader];
}

#pragma mark - 左边 全部商品 自录商品 代理商品 切换
- (void)allMyCategoryListSelect:(NSNotification *)notification{
    NSDictionary * infoDic = [notification object];
    NSString * selectTitle = [infoDic objectForKey:@"selectTitle"];
    NSLog(@"selectTitle:%@",selectTitle);
    self.allGoodsType=@"";//默认全部商品 传空
    if ([selectTitle isEqualToString:@"自录商品"]) {
        self.allGoodsType=@"1";
    }
    else if ([selectTitle isEqualToString:@"代理商品"]){
        self.allGoodsType=@"2";
    }
    [self.mBottomView setRightButtonCanClick:[selectTitle isEqualToString:@"全部商品"]];
    //刷新列表
    [self beginRefreshHeader];
}

#pragma mark - <http 网络请求>
- (void)startRequestGoodsList{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel) {
        NSInteger cellCount=sectionModel.cellArray.count;
        if (cellCount>0) {
            self.startIndex=[NSString stringWithFormat:@"%@",@(cellCount)];
        }
    }
    if (self.listType==US_MyGoodsListCategory) {
        [self beginCategoryListInfoAtStart:self.startIndex];
    }else{
        [self beginStoreItemsListInfoAtStart:self.startIndex];
        
    }
}
//请求全部商品列表数据
- (void)beginStoreItemsListInfoAtStart:(NSString *)start{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:self.keywords flag:@"" listingType:self.allGoodsType start:start andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

//请求分类商品列表数据
- (void)beginCategoryListInfoAtStart:(NSString *)start{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildCatergoryListWithId:self.item.idForCate start:start andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
         [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}
//请求邮乐网收藏商品列表
- (void)getUleFavoriteList{
    //一天只调用一次
    if (![NSDate todayHadRequestForKey:kUserDefault_UleFavaritList]) {
        [self.networkClient_API beginRequest:[US_MyGoodsApi buildGetUleFavoriteListAtStart:@"1" andPageNum:@"20"] success:^(id responseObject) {
            [NSDate saveDate:[NSDate date] Forkey:kUserDefault_UleFavaritList];
            NSDictionary * data=responseObject[@"data"];
            if (data) {
                NSArray * array=data[@"favsListingListInfo"];
                if (array&&array.count>0) {
                    [US_UserUtility setIsNeedGetUleFavoritList:YES];
                }else{
                    [US_UserUtility setIsNeedGetUleFavoritList:NO];;
                }
            }
        } failure:^(UleRequestError *error) {
            
        }];
    }
}
//获取已失效商品数量并进行弹框提示
- (void)startRequestBatchDeleltList{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:@"" flag:@"1" listingType:@"" start:@"0" andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [self handelBatchDeleteList:responseObject];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}
//删除单个商品
- (void)startRequestDeleteGood{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"删除中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildBatchDeleteWithListIds:[NSString isNullToString:self.deleteCellModel.listId]] success:^(id responseObject) {
        @strongify(self);
        UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
        NSInteger newTotalCount=[sectionModel.sectionData integerValue]-1;
        NSUInteger rowNum=[sectionModel.cellArray indexOfObject:self.deleteCellModel];
        if (rowNum<sectionModel.cellArray.count) {
            [sectionModel.cellArray removeObjectAtIndex:rowNum];
            [self.mTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        //补全
        if (sectionModel.cellArray.count<newTotalCount) {
            [self startRequestGoodsList];
        }else {
            [UleMBProgressHUD hideHUDForView:self.view];
            sectionModel.sectionData=[NSString stringWithFormat:@"%@",@(newTotalCount)];
            [self.mTableView reloadData];
        }
        self.deleteCellModel=nil;
    } failure:^(UleRequestError *error) {
        self.deleteCellModel=nil;
        [self showErrorHUDWithError:error];
    }];
}
#pragma mark - <数据处理>
- (void)handleRecommendInfo:(NSDictionary *)dic{
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
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
        @weakify(self);
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(cellModel);
            [self cellDidClickOnIndexPath:indexPath recommendInfo:cellModel];
        };
        cellModel.logPageName=kPageName_MyGoods;
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareFrom=@"0";
        cellModel.myGoodsListType=self.listType;
        cellModel.delegate=self;
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mTableView reloadData];
    self.emptyListView.hidden=sectionModel.cellArray.count>0?YES:NO;
    self.hasGoodsList=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView.mj_header endRefreshing];
    self.mRefreshFooter.alpha=1.0;
    if (sectionModel.cellArray.count>=[favoritesData.data.totalRecords integerValue]) {
        self.mTableView.mj_footer.hidden = YES;
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.mTableView.mj_footer.hidden = NO;
        [self.mTableView.mj_footer endRefreshing];
    }
}
- (void)handelBatchDeleteList:(NSDictionary *)dic{
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
    if ([favoritesData.data.totalRecords integerValue]>50&&![NSDate todayHadRequestForKey:kUserDefault_ShowBatchDeletView]) {
        //超过50个无效商品，每天提示一次
        US_MyGoodsBatchDeleteVC * batchDelte=[[US_MyGoodsBatchDeleteVC alloc] init];
        batchDelte.delegate=self;
        [self presentViewController:batchDelte animated:YES completion:nil];
        [NSDate saveDate:[NSDate date] Forkey:kUserDefault_ShowBatchDeletView];
    }else if ([favoritesData.data.totalRecords integerValue]>3&&![NSDate todayHadRequestForKey:kUserDefault_ShowBatchDeletView]&&![self isSameWeek]){
        //超过3个无效商品每周提示一次
        US_MyGoodsBatchDeleteVC * batchDelte=[[US_MyGoodsBatchDeleteVC alloc] init];
        batchDelte.delegate=self;
        [self presentViewController:batchDelte animated:YES completion:nil];
        [NSDate saveDate:[NSDate date] Forkey:kUserDefault_ShowBatchDeletView];
    }
    self.mBottomView.redDotView.hidden=[favoritesData.data.totalRecords integerValue]>0?NO:YES;
    
}

#pragma mark - <private function>
//判断页面显示的类型（全部商品/分类商品）
- (void)handleCatergoryType{
    BOOL isSearchListVC=[[self.m_Params objectForKey:@"isSearchListVC"] boolValue];
    if (isSearchListVC) {
        self.listType=US_MyGoodsListSearch;
        self.mBottomView.hidden=YES;
        self.mTableView.sd_layout.bottomSpaceToView(self.view, 0);
        self.emptyListView.describe=@"";
        return;
    }
    if (self.item&&self.item.idForCate.length>0) {
        //如果可以添加新商品，则需要显示底部按键，否则隐藏
        if (self.addNewGoods) {
            self.mBottomView.hidden=NO;
            self.mBottomView.addNewGoods=self.addNewGoods;
            self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
            self.emptyListView.titleLabel.text=@"啊哦！您还没有添加商品哦";
        }else{
            self.mBottomView.hidden=YES;
            self.mTableView.sd_layout.bottomSpaceToView(self.view, 0);
        }
        self.emptyListView.describe=@"";
        self.listType=US_MyGoodsListCategory;
    }else{
        self.listType=US_MyGoodsListAllGoods;
        self.mBottomView.hidden=NO;
        self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
    }
    [self.mTableView updateLayout];
}
//判断是否是在一周内
- (BOOL)isSameWeek{
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",[US_UserUtility sharedLogin].m_userId,kUserDefault_ShowBatchDeletView]] timeIntervalSinceDate:[NSDate date]];
    //计算天数、时、分、秒
    int days = ((int)time)/(3600*24);
    return days < 7;
}

#pragma mark - <Cell Click>
- (void)cellDidClickOnIndexPath:(NSIndexPath *)indexPath recommendInfo:(US_MyGoodsListCellModel *)detail{
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:detail.listId andSearchKeyword:@"" andPreviewType:@"2" andHudVC:self];
    [UleMbLogOperate addMbLogClick:detail.listId moduleid:@"我的商品" moduledesc:@"预览" networkdetail:nil];
}
#pragma mark - <UISrollView KVO>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat newoffset_y = newvalue.UIOffsetValue.vertical;
        if (self.listType==US_MyGoodsListAllGoods) {
            self.mBottomView.hidden=YES;
            if (self.mTableView.dragging==NO) {
                self.mBottomView.hidden=NO;
                self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
            }else{
                self.mTableView.sd_layout.bottomSpaceToView(self.view, 0);
            }
        }else{
            if (self.mBottomView.isHidden==NO) {
                self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
            }else{
                self.mTableView.sd_layout.bottomSpaceToView(self.view, 0);
            }
        }
        if (self.delegate&& [self.delegate respondsToSelector:@selector(didScrollOlderOffset:newOffset:)]) {
            [self.delegate didScrollOlderOffset:self.lastOffsetY newOffset:newoffset_y];
        }
        self.lastOffsetY=newoffset_y;
    }
}
#pragma mark - <bottom click delegate>
- (void)searchProductClick{
    US_MyGoodsSearchAlertView * alert=[[US_MyGoodsSearchAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds RightButtonCanClick:self.allGoodsType.length==0];
    [alert show];
    @weakify(self)
    alert.dismissFinish = ^{
        @strongify(self);
        [self.mBottomView.leftButton setBackgroundColor:[UIColor whiteColor]];
        self.mBottomView.leftButton.mTitleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        
    };
    alert.rightButtonClick = ^{
        @strongify(self);
        [self batchManagerClick];
    };
}
- (void)addNewProductClick{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:self.item.idForCate.length>0?self.item.idForCate:@"" forKey:@"categoryId"];
    [self pushNewViewController:@"US_MyGoodsCategoryAddVC" isNibPage:NO withData:dic];
}
- (void)batchManagerClick{
    //如果没有选择全部商品 不能点击跳转
    if (self.allGoodsType.length > 0) {
        [UleMBProgressHUD showHUDWithText:@"请选择“全部商品”后操作" afterDelay:2.0];
        return;
    }
    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
    if (self.item&&self.item.idForCate.length>0) {
        [dic setObject:self.item forKey:@"CategoryItem"];
    }
    [self pushNewViewController:@"US_MyGoodsBatchManangerVC" isNibPage:NO withData:dic];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的商品" moduledesc:@"批量管理" networkdetail:nil];
}


#pragma mark - <BatchDelegateVC Dismiss>
- (void)didDismissed{
    [self.mBottomView showPopView];
}
#pragma mark - <US_MyGoodsListCellDelegate>
- (void)didLongPressedForModel:(US_MyGoodsListCellModel*)model{
    if (self.deleteCellModel) {
        return;
    }
    self.deleteCellModel=model;
    US_MyGoodsDeleteAlertView * alert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"确定删除选中的商品吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    [alert showViewWithAnimation:AniamtionPresentBottom];
}
#pragma mark - <US_MyGoodsDeleteAlertViewDelegate>
- (void)alertView:(US_MyGoodsDeleteAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self startRequestDeleteGood];
    }else {
        self.deleteCellModel=nil;
    }
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
    }
    return _mViewModel;
}
- (US_MyGoodsListBottomView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[[US_MyGoodsListBottomView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kStatusBarHeight==20?49:83)];
        _mBottomView.delegate=self;
    }
    return _mBottomView;
}
- (US_EmptyPlaceHoldView *)emptyListView{
    if (!_emptyListView) {
        _emptyListView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _emptyListView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_noSearch"];
        _emptyListView.titleLabel.text=@"未能搜到您查找的信息";
        _emptyListView.hidden = YES;
    }
    return _emptyListView;
}
@end
