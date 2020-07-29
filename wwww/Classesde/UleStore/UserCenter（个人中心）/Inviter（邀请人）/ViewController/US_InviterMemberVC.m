//
//  US_InviterMemberVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_InviterMemberVC.h"
#import "InviterViewModel.h"
#import "US_UserCenterApi.h"
#import <MJRefresh/MJRefresh.h>

@interface US_InviterMemberVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) InviterViewModel * mViewModel;
@end

@implementation US_InviterMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleStr=@"邀请人";
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        titleStr=[NSString isNullToString:[self.m_Params objectForKey:@"title"]];
    }
    [self.uleCustemNavigationBar customTitleLabel:titleStr];
    [self.uleCustemNavigationBar ule_setBackgroudColor:[UIColor whiteColor]];
    [self.uleCustemNavigationBar ule_setTintColor:[UIColor blackColor]];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    
    [self getInviterCount];
    
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.hidden=YES;
}

#pragma mark - <上拉下拉刷新>
- (void)beginRefreshHeader{
    self.mViewModel.startPage=1;
    [self getInviterCount];
}

- (void)beginRefreshFooter{
    [self getInviterCount];
}

//获取邀请人数量
- (void)getInviterCount{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
     @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetInviterListRequestWithStartPage:[NSString stringWithFormat:@"%ld",(long)self.mViewModel.startPage] PageSize:@"10"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel fetchInviterValueWithModel:responseObject];
         [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
    }];
}

#pragma mark - <重写状态栏颜色>
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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

- (InviterViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[InviterViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}

@end
