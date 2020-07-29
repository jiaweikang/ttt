//
//  US_TakeSelfVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_TakeSelfVC.h"
#import "US_MyGoodsApi.h"
#import "UleBaseViewModel.h"
#import "US_EmptyPlaceHoldView.h"
#import "TakeSelfModel.h"
#import "US_MyGoodsListCellModel.h"
#import "USGoodsPreviewManager.h"
@interface US_TakeSelfVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mPlaceHoldView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger totoalGoods;
@end

@implementation US_TakeSelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadData];
}

- (void)setUI{
    [self.uleCustemNavigationBar customTitleLabel:@"自提专区"];
    [self.view sd_addSubviews:@[self.mTableView,self.mPlaceHoldView]];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mPlaceHoldView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
}

- (void)loadData{
    self.pageIndex=1;
    self.totoalGoods=0;
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
}
#pragma mark - <上拉>
- (void)beginRefreshHeader{
    self.pageIndex=1;
    [self startRequestTakeSelfList];
}

- (void)beginRefreshFooter{
    [self startRequestTakeSelfList];
}
#pragma mark - <http>
- (void)startRequestTakeSelfList{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_MyGoodsApi buildTakeSelfListWithPageSize:@"20" andPageIndex:[NSString stringWithFormat:@"%@", @(self.pageIndex)]] success:^(id responseObject) {
        @strongify(self);
        [self fetchTakeselfListDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self endRefreshAnimation];
    }];
}

- (void)fetchTakeselfListDicInfo:(NSDictionary *)dic{
    [UleMBProgressHUD hideHUDForView:self.view];
    TakeSelfModel * takeself=[TakeSelfModel yy_modelWithDictionary:dic];
    if (self.pageIndex == 1) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<takeself.data.result.count; i++) {
        TakeSelfIndexInfo * indexInfo=[takeself.data.result objectAt:i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithTakeSelfData:indexInfo];
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self cellDidClickAt:indexPath];
        };
        cellModel.logPageName=@"自提专区";
        cellModel.logShareFrom=@"商品列表";
        [sectionModel.cellArray addObject:cellModel];
        
    }
    self.mPlaceHoldView.hidden=self.mViewModel.mDataArray.count>0?YES:NO;
    self.pageIndex++;
    [self.mTableView reloadData];
    self.totoalGoods=[takeself.data.totalRecords integerValue];
    [self endRefreshAnimation];
}

- (void)endRefreshAnimation{
    [self.mTableView.mj_header endRefreshing];
//    if([self.mViewModel.mDataArray firstObject].cellArray.count>=self.totoalGoods){
//        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
//    }else{
        [self.mTableView.mj_footer endRefreshing];
//    }
}

- (void)cellDidClickAt:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionModel=[self.mViewModel.mDataArray objectAt:indexPath.section];
    if (sectionModel) {
        US_MyGoodsListCellModel * cellMode=[sectionModel.cellArray objectAt:indexPath.row];
        [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:cellMode.listId andSearchKeyword:@"" andPreviewType:@"2" andHudVC:self];
        [UleMbLogOperate addMbLogClick:cellMode.listId moduleid:@"自提专区" moduledesc:@"预览" networkdetail:nil];
    }
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
- (US_EmptyPlaceHoldView *)mPlaceHoldView{
    if (!_mPlaceHoldView) {
        _mPlaceHoldView=[[US_EmptyPlaceHoldView alloc] init];
        _mPlaceHoldView.titleLabel.text=@"现在没有自提商品哦";
        _mPlaceHoldView.describe=@"请点击重试";
    }
    return _mPlaceHoldView;
}
@end
