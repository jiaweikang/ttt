//
//  US_MyGoodsWholeSaleVC.m
//  UleStoreApp
//
//  Created by lei xu on 2020/3/19.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsWholeSaleVC.h"
#import "UleBaseViewModel.h"
#import "US_MyGoodsApi.h"
#import "MyFavoritesLists.h"
#import "US_MyGoodsListCellModel.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_MyGoodsListBottomView.h"
#import "UleTabBarViewController.h"
#import "UleControlView.h"
#import "USInviteShareManager.h"

@interface US_MyGoodsWholeSaleVC ()<US_MyGoodsListBottomViewDelegate>
@property (nonatomic, strong) UITableView       *mTableView;
@property (nonatomic, strong) UleBaseViewModel  *mViewModel;
@property (nonatomic, strong) US_MyGoodsListBottomView * mBottomView;
@property (nonatomic, strong) US_EmptyPlaceHoldView *emptyListView;
@property (nonatomic, strong) UleControlView    *rightButton;
@property (nonatomic, assign) NSInteger         currentStart;
@property (nonatomic, strong) US_MyGoodsListCellModel   * deleteCellModel;
@end

@implementation US_MyGoodsWholeSaleVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        [self.uleCustemNavigationBar customTitleLabel:[self.m_Params objectForKey:@"title"]];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"分销商品"];
    }
    self.currentStart=0;
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    [self.view sd_addSubviews:@[self.mTableView,self.mBottomView,self.emptyListView]];
    [self.mBottomView setRightButtonTitle:@"长按商品删除"];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.bottomSpaceToView(self.mBottomView, 0).topSpaceToView(self.uleCustemNavigationBar, 0);
    self.emptyListView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.emptyListView.sd_layout.bottomSpaceToView(self.mBottomView, 0);
    [self startRequestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotiAction:) name:NOTI_FenxiaoMyGoodsListRefresh object:nil];
}

- (void)startRequestData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildGoodsFenXiaoListWithStart:[NSString stringWithFormat:@"%@",@(self.currentStart)] andPageNum:@"10"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self handleRecommendInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self endHeaderFooterRefresh];
        [self showErrorHUDWithError:error];
    }];
}

- (void)beginRefreshHeader{
    self.currentStart=0;
    [self startRequestData];
}
- (void)beginRefreshFooter{
    [self startRequestData];
}

- (void)refreshNotiAction:(NSNotification *)noti{
    [self.mTableView.mj_header beginRefreshing];
}

#pragma mark - <数据处理>
- (void)handleRecommendInfo:(NSDictionary *)dic{
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
    if (self.currentStart==0) {
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
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithFenxiaoFavorites:detail andCellName:@"US_MyGoodsListCell"];
//        @weakify(self);
//        @weakify(cellModel);
//        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
//            @strongify(self);
//            @strongify(cellModel);
//            [self cellDidClickOnIndexPath:indexPath recommendInfo:cellModel];
//        };
        cellModel.logPageName=kPageName_MyWholesaleGoods;
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareChannel=@"3";
        cellModel.shareFrom=@"0";
        cellModel.myGoodsListType=US_MyGoodsFenXiao;
        cellModel.delegate=self;
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mTableView reloadData];
    self.emptyListView.hidden=sectionModel.cellArray.count>0?YES:NO;
    if (sectionModel.cellArray.count>=[favoritesData.data.totalRecords integerValue]) {
        self.mTableView.mj_footer=nil;
    }else{
        self.mTableView.mj_footer=self.mRefreshFooter;
    }
    [self endHeaderFooterRefresh];
    self.currentStart=sectionModel.cellArray.count;
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
#pragma mark - <US_MyGoodsListBottomViewDelegate>
- (void)addNewProductClick{
    [self pushNewViewController:@"US_EnterpeiseWholeSaleVC" isNibPage:NO withData:nil];
//    BOOL canSelect=NO;
//    UleTabBarViewController *tabVC=(UleTabBarViewController*)self.tabBarController;
//    if (tabVC) {
//        for (int i=0;i<self.tabBarController.viewControllers.count;i++) {
//            UINavigationController *navVC=self.tabBarController.viewControllers[i];
//            UIViewController *rootVC=[navVC.viewControllers firstObject];
//            if ([rootVC isKindOfClass:NSClassFromString(@"US_EnterpriseRootVC")]) {
//                canSelect=YES;
//                [rootVC.m_Params setObject:@"1" forKey:@"index"];
//                [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_ReloadEnterpriseRoot object:nil];
//                [tabVC selectTabBarItemAtIndex:i animated:YES];
//                [self.navigationController popToRootViewControllerAnimated:NO];
//                break;
//            }
//        }
//    }
//    if (!canSelect) {
//        if ([US_UserUtility sharedLogin].hasCSqy && [UserDefaultManager getLocalDataBoolen:@"hadEnterprice"]) {
//            //企业模块有数据
//            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请把掌柜切换至企业" afterDelay:1.5];
//        }else [UleMBProgressHUD showHUDAddedTo:self.view withText:@"暂时没有可添加商品哦" afterDelay:1.5];
//    }
}
#pragma mark - <action>
//删除单个商品
- (void)startRequestDeleteGood{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"删除中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildFenxiaoFavListDeleteWithListId:[NSString isNullToString:self.deleteCellModel.listId] andZoneId:[NSString isNullToString:self.deleteCellModel.zoneId]] success:^(id responseObject) {
        @strongify(self);
        UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
        NSInteger newTotalCount=[sectionModel.sectionData integerValue]-1;
        NSUInteger rowNum=[sectionModel.cellArray indexOfObject:self.deleteCellModel];
        if (rowNum<sectionModel.cellArray.count) {
            [sectionModel.cellArray removeObjectAtIndex:rowNum];
            [self.mTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowNum inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        //补全
        self.currentStart=sectionModel.cellArray.count;
        if (sectionModel.cellArray.count<newTotalCount) {
            [self startRequestData];
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

//- (void)cellDidClickOnIndexPath:(NSIndexPath *)indexPath recommendInfo:(US_MyGoodsListCellModel *)detail{
//    NSString *listID=[NSString stringWithFormat:@"%@", detail.listId];
//    NSString *zoneID=[NSString stringWithFormat:@"%@", detail.zoneId];
//    NSString *urlStr=[NSString stringWithFormat:@"http://wholesale-static.beta.ule.com/yxd/vi/%@?storeid=%@&zoneId=%@", listID, [US_UserUtility sharedLogin].m_userId, zoneID];
//    NSMutableDictionary *params=@{@"key":urlStr,
//                                  KNeedShowNav:@"1",
//                                  @"title":@"预览"
//                                  }.mutableCopy;
//    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
//    [UleMbLogOperate addMbLogClick:detail.listId moduleid:@"我的分销商品" moduledesc:@"预览" networkdetail:nil];
//}

- (void)endHeaderFooterRefresh{
    [self.mTableView.mj_header endRefreshing];
    if (self.mTableView.mj_footer) {
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)rightButtonAction{
    [[USInviteShareManager sharedManager] shareFenxiaoMyStore];
}
#pragma mark - <getters>
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
        _mTableView.mj_header = self.mRefreshHeader;
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc]init];
    }
    return _mViewModel;
}

- (UleControlView *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UleControlView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        [_rightButton.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_share"]];
        _rightButton.mTitleLabel.text=@"分销店铺";
        _rightButton.mTitleLabel.textColor=[UIColor whiteColor];
        _rightButton.mTitleLabel.font=[UIFont systemFontOfSize:11];
        [_rightButton addTouchTarget:self action:@selector(rightButtonAction)];
        _rightButton.mImageView.sd_layout.centerXEqualToView(_rightButton)
        .topSpaceToView(_rightButton, 0)
        .widthIs(25)
        .heightIs(25);
        _rightButton.mTitleLabel.sd_layout.topSpaceToView(_rightButton.mImageView, 0)
        .leftSpaceToView(_rightButton, 0)
        .rightSpaceToView(_rightButton, 0)
        .bottomSpaceToView(_rightButton, 0);
    }
    return _rightButton;
}

- (US_MyGoodsListBottomView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[[US_MyGoodsListBottomView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kStatusBarHeight==20?49:83)];
        _mBottomView.addNewGoods=YES;
        _mBottomView.delegate=self;
    }
    return _mBottomView;
}

- (US_EmptyPlaceHoldView *)emptyListView{
    if (!_emptyListView) {
        _emptyListView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _emptyListView.iconImageView.image=[UIImage bundleImageNamed:@"myGoods_icon_empty"];
        _emptyListView.titleLabel.text=@"啊哦！您还没有添加商品哦";
//        _emptyListView.describe=@"点击\'找商品\'到货源添加到小店";
        _emptyListView.hidden = YES;
    }
    return _emptyListView;
}
@end
