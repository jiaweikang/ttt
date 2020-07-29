//
//  IncomeVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/19.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_IncomeManageVC.h"
#import "IncomeManageViewModel.h"
#import "US_UserCenterApi.h"

@interface US_IncomeManageVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) IncomeManageViewModel * mViewModel;
@end

@implementation US_IncomeManageVC
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"分享赚取"];
    }
    
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    
    [self requestIncomeInfo];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestIncomeInfo) name:NOTI_RefreshIncomeData object:nil];
}

#pragma mark - <上拉下拉刷新>
- (void)beginRefreshHeader{
    [self requestIncomeInfo];
}

//查询收益
-(void)requestIncomeInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetIncomeRequestWithAccTypeId:@""] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mTableView.mj_header endRefreshing];
        [self.mViewModel fetchValueWithData:responseObject];
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _mTableView.backgroundColor=[UIColor clearColor];
    }
    return _mTableView;
}

- (IncomeManageViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[IncomeManageViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}

@end
