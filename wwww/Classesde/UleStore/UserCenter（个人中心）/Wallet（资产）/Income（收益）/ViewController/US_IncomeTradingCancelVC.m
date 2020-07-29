//
//  US_IncomeTradingCancelVC.m
//  UleStore
//
//  Created by lei xu on 2020/5/26.
//  Copyright © 2020 lei xu. All rights reserved.
//

#import "US_IncomeTradingCancelVC.h"
#import <UleBaseViewModel.h>
#import <US_EmptyPlaceHoldView.h>
#import <US_UserCenterApi.h>
#import <IncomeTradeCancelModel.h>

@interface US_IncomeTradingCancelVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, assign) NSInteger start;
@end

@implementation US_IncomeTradingCancelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"当日取消收益"];
    }
    
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    [self.mTableView addSubview:self.mNoItemsBgView];
    //请求收支明细列表数据
    [self beginRefreshHeader];
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.start=1;
    [self beginRequestIncomeTradingFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRefreshFooter{
    
    [self beginRequestIncomeTradingFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRequestIncomeTradingFromStartPage:(NSString *)startPage{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetCancelIncomeTradingRequestWithStartPage:startPage] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchIncomeTradingWithData:responseObject];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
    }];
}

- (void)fetchIncomeTradingWithData:(NSDictionary *)dic{
    //首次加载要先清空数据
    if (self.start == 1) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    
    IncomeTradeCancelModel * incomeData=[IncomeTradeCancelModel yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<incomeData.data.result.list.count; i++) {
        IncomeTradeCancelList * detail=incomeData.data.result.list[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"IncomeTradingListCell"];
        cellModel.data=detail;
        
        [sectionModel.cellArray addObject:cellModel];
    }
    
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count == [incomeData.data.result.total integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
        self.mTableView.mj_footer.alpha=0.0;
    }else{
        self.mTableView.mj_footer.alpha=1.0;
        [self.mTableView.mj_footer endRefreshing];
    }
    self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
//    _totalCountLab.text = [NSString stringWithFormat:@"共%@条",incomeData.data.result.Total];
    self.start++;
//    NSString *sumIncome = incomeData.data.result.unIssueCms;
//    self.incomeAmount.text = [NSString stringWithFormat:@"￥%.2lf",sumIncome.doubleValue?sumIncome.doubleValue:0.00];
//    [self setAttributedIncomeNum:self.incomeAmount];
//    [self.mTableView setTableHeaderView:self.headerView];
    [self.mTableView reloadData];
//    self.hintStrleft = [NSString isNullToString:incomeData.data.incomeTransactionswenanHint];
//    self.hintStrMiddle = [NSString isNullToString:incomeData.data.virutalTransactionswenanHint];
//    self.hintStrRight = [NSString isNullToString:incomeData.data.multipleComissionHint];
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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

- (US_EmptyPlaceHoldView *)mNoItemsBgView{
    if (!_mNoItemsBgView) {
        _mNoItemsBgView=[[US_EmptyPlaceHoldView alloc] init];
        _mNoItemsBgView.hidden=YES;
        _mNoItemsBgView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_bgNew"];
        _mNoItemsBgView.titleLabel.text=@"暂无当日取消收益明细";
        _mNoItemsBgView.frame=CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height-self.uleCustemNavigationBar.height_sd);
    }
    return _mNoItemsBgView;
}

@end
