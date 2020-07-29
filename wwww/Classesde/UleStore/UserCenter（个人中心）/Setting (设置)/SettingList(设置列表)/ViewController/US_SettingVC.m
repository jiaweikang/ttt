//
//  US_SettingVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_SettingVC.h"
#import "SettingViewModel.h"
#import "US_LoginManager.h"

@interface US_SettingVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) SettingViewModel * mViewModel;
@end

@implementation US_SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"设置"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
}

#pragma mark - Action
- (void)clickToQuit:(UIButton *)sender {
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"退出账号" networkdetail:@""];
    [US_LoginManager logOutToLoginWithMessage:@""];
    NSLog(@"退出账号");
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        
        UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 80)];
        footerView.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
        UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        quitBtn.frame = CGRectMake(0, 15, __MainScreen_Width, 50);
        quitBtn.backgroundColor = [UIColor whiteColor];
        [quitBtn setTitle:@"退出账号" forState:UIControlStateNormal];
        [quitBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        [quitBtn addTarget:self action:@selector(clickToQuit:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:quitBtn];
        _mTableView.tableFooterView=footerView;
    }
    return _mTableView;
}

- (SettingViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[SettingViewModel alloc] init];
        _mViewModel.rootViewController=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}



@end
