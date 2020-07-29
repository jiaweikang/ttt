//
//  US_MyGoodsRecommendVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsRecommendVC.h"
#import "US_MyGoodsApi.h"
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"
#import "UleBaseViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "UIImage+USAddition.h"
#import "US_MyGoodsListCellModel.h"
#import "USGoodsPreviewManager.h"
#import "US_MyGoodsRecommend.h"


@interface US_MyGoodsRecommendVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@end

@implementation US_MyGoodsRecommendVC
#pragma mark - <LifeCycel>
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title==nil||[title isEqualToString:@"(null)"]||title.length<=0) {
        title=@"我要扶贫";
    }
    self.mTableView.mj_header=self.mRefreshHeader;
    [self.uleCustemNavigationBar customTitleLabel:title];
    [self beginRequestRecommandListInfo];
}

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - <下拉刷新>
- (void)beginRefreshHeader{
    [self beginRequestRecommandListInfo];
}

#pragma mark - <http>
- (void)beginRequestRecommandListInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildGoodsRecommandRequest] success:^(id responseObject) {
        @strongify(self);
        [self handleRecommendInfo:responseObject];
        [self.mTableView.mj_header endRefreshing];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
    }];
}

- (void)handleRecommendInfo:(NSDictionary *)dic{
    US_MyGoodsRecommend * recommend=[US_MyGoodsRecommend yy_modelWithDictionary:dic];
    [self.mViewModel.mDataArray removeAllObjects];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    sectionModel.headHeight=5;
    for (int i=0; i<recommend.data.event_ulestorepoor_dt.count; i++) {
        US_MyGoodsRecommendDetail * detail=recommend.data.event_ulestorepoor_dt[i];
        US_MyGoodsListCellModel * cellModel=[[US_MyGoodsListCellModel alloc] initWithRecommendData:detail andCellName:@"US_MyGoodsListCell"];
        cellModel.logPageName=@"我要扶贫";
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareChannel=@"1";
        cellModel.shareFrom=@"1";
        cellModel.srcid=Srcid_LoveHelp_Prd;
        @weakify(self);
        @weakify(detail);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(detail);
            [self cellDidClickOnIndexPath:indexPath recommendInfo:detail];
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mTableView reloadData];
}

#pragma mark - <Cell Click>
- (void)cellDidClickOnIndexPath:(NSIndexPath *)indexPath recommendInfo:(US_MyGoodsRecommendDetail *)detail{
    [LogStatisticsManager shareInstance].srcid=Srcid_LoveHelp_Prd;
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:detail.listingId andSearchKeyword:@"" andPreviewType:@"2" andHudVC:self];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor=[UIColor clearColor];
    }
    return _mTableView;
}
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}
@end
