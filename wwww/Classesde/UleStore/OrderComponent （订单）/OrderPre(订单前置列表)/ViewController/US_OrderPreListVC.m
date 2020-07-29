//
//  US_OrderPreListVC.m
//  u_store
//
//  Created by xulei on 2019/6/24.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_OrderPreListVC.h"
#import "US_OrderPreListViewModel.h"
#import "US_MyOrderApi.h"

@interface US_OrderPreListVC ()
@property (nonatomic, strong)US_OrderPreListViewModel   *mViewModel;
@property (nonatomic, strong)UITableView            *mTableView;

@end

@implementation US_OrderPreListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        [self.uleCustemNavigationBar customTitleLabel:[self.m_Params objectForKey:@"title"]];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"我的订单"];
    }
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    
    [self startRequestlistData];
}

- (void)startRequestlistData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    [self.networkClient_UstaticCDN beginRequest:[US_MyOrderApi buildOrderPreListRequest] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mTableView.mj_header endRefreshing];
        [self.mViewModel fetchOrderPreList:responseObject];
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <refresh>
- (void)beginRefreshHeader{
    [self startRequestlistData];
}

#pragma mark - <getters>
- (US_OrderPreListViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_OrderPreListViewModel alloc]init];
    }
    return _mViewModel;
}

- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.dataSource = self.mViewModel;
        _mTableView.delegate = self.mViewModel;
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.mj_header=self.mRefreshHeader;
    }
    return _mTableView;
}


@end
