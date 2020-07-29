//
//  US_ShareRecordVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_ShareRecordVC.h"
#import "US_ShareApi.h"
#import "UleBaseViewModel.h"
#import "US_ShareRecordModel.h"
#import "US_EmptyPlaceHoldView.h"
#import "USGoodsPreviewManager.h"
#import "US_SearchTextFieldBar.h"
@interface US_ShareRecordVC ()

@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyPlaceHoldView;
@property (nonatomic, strong) US_SearchTextFieldBar * mSearchBarView;
@property (nonatomic, strong) NSString * keyword;
@end

@implementation US_ShareRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.uleCustemNavigationBar.titleView=self.mSearchBarView;
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.emptyPlaceHoldView];
    self.emptyPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.emptyPlaceHoldView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    self.keyword=@"";
    [self beginRefreshHeader];
    
}

#pragma mark - <上拉 下拉>
- (void)beginRefreshHeader{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    self.startIndex=0;
    [self startRequestShareRecordList];
}

- (void)beginRefreshFooter{
    self.startIndex= self.mViewModel.mDataArray.count;
    [self startRequestShareRecordList];
}

#pragma mark - <http>
- (void)startRequestShareRecordList{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_ShareApi buildShareRecordWithKeyword:self.keyword andStart:[NSString stringWithFormat:@"%@",@(self.startIndex)]] success:^(id responseObject) {
        @strongify(self);
        [self fretchShareRecordInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        [self showErrorHUDWithError:error];
    }];
}

- (void)fretchShareRecordInfo:(NSDictionary *)dic{
    [UleMBProgressHUD hideHUDForView:self.view];
    if (self.startIndex==0) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    US_ShareRecordModel * shareRecord=[US_ShareRecordModel yy_modelWithDictionary:dic];
    for (int i=0 ; i<shareRecord.data.result.count; i++) {
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=5;
        sectionModel.footHeight=5;
        ShareDetailInfo * recordDetail=shareRecord.data.result[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"US_ShareRecordCell"];
        cellModel.data=recordDetail;
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            if ([recordDetail.shareType isEqualToString:@"5"] || [recordDetail.shareType isEqualToString:@"8"] || [recordDetail.shareType isEqualToString:@"10"] || [recordDetail.shareType isEqualToString:@"11"] || [recordDetail.shareType isEqualToString:@"13"] || [recordDetail.shareType isEqualToString:@"15"] || [recordDetail.shareType isEqualToString:@"18"] || [recordDetail.shareType isEqualToString:@"50"]) {
                return;
            }
            [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString stringWithFormat:@"%@",recordDetail.listingId] andSearchKeyword:@"" andPreviewType:@"3" andHudVC:self];
        };
        [sectionModel.cellArray addObject:cellModel];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    [self.mTableView reloadData];
    self.mTableView.mj_footer.alpha=self.mViewModel.mDataArray.count>0?1.0:0.0;
    [self.mTableView.mj_header endRefreshing];
    NSInteger totoalCount=[shareRecord.data.totalRecords integerValue];
    if (self.mViewModel.mDataArray.count<totoalCount) {
        [self.mTableView.mj_footer endRefreshing];
    }else{
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }
    self.emptyPlaceHoldView.hidden=self.mViewModel.mDataArray.count>0?YES:NO;
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
- (US_EmptyPlaceHoldView *)emptyPlaceHoldView{
    if (!_emptyPlaceHoldView) {
        _emptyPlaceHoldView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _emptyPlaceHoldView.titleLabel.text=@"暂无分享记录";
        _emptyPlaceHoldView.hidden=YES;
    }
    return _emptyPlaceHoldView;
}
- (US_SearchTextFieldBar *)mSearchBarView{
    if (!_mSearchBarView) {
        @weakify(self);
        _mSearchBarView=[[US_SearchTextFieldBar alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width - 100 , 30) placeholdText:@"请输入商品名进行搜索" clickReturnBlock:^(UITextField * _Nonnull textField) {
            @strongify(self);
            self.keyword=textField.text;
            [self beginRefreshHeader];
        } ];
    }
    return _mSearchBarView;
}
@end
