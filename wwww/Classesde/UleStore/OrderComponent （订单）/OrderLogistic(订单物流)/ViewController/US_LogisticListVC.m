//
//  US_LogisticListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticListVC.h"
#import "MyWaybillOrderInfo.h"
#import "UleBaseViewModel.h"

@interface US_LogisticListVC ()
@property (nonatomic, strong) WaybillOrder * billOrder;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@end

@implementation US_LogisticListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"查看物流"];
    self.billOrder=self.m_Params[@"waybillOrder"];
 
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self handleBillOrderInfo];
}

- (void)handleBillOrderInfo{
    
    UleSectionBaseModel * section=[[UleSectionBaseModel alloc] init];
    for (int i=0; i<self.billOrder.delevery.count; i++) {
        DeleveryInfo * delvery=self.billOrder.delevery[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"US_LogisticListCell"];
        cellModel.data=delvery;
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            NSMutableDictionary * dic=@{@"logisticsId":NonEmpty(delvery.logisticsId),@"logisticsCode":NonEmpty(delvery.logisticsCode),@"package_id":NonEmpty(delvery.package_id)}.mutableCopy;
            [self pushNewViewController:@"US_LogisticDetailVC" isNibPage:NO withData:dic];
        };
        [section.cellArray addObject:cellModel];
    }
    [self.mViewModel.mDataArray addObject:section];
    [self.mTableView reloadData];
    
}

- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
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

@end
