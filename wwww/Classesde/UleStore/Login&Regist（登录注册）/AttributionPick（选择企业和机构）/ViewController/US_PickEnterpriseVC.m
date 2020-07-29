//
//  US_PickEnterpriseVC.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_PickEnterpriseVC.h"
#import "AttributionPickViewModel.h"
#import "EnterprisePickAlertView.h"
#import "UIView+ShowAnimation.h"

@interface US_PickEnterpriseVC ()
{
    NSString    *selOrgType;
    NSString    *selEnterpriseName;
    
}
@property (nonatomic, strong)UITableView                 *mTableView;
@property (nonatomic, strong)AttributionPickViewModel    *mViewModel;
@property (nonatomic, strong)EnterprisePickAlertView     *bottomAlertView;

@end

@implementation US_PickEnterpriseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"所属企业"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    
    [self startRequestEnterpriseInfo];
}




#pragma mark - <request>
- (void)startRequestEnterpriseInfo {
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        [UleMBProgressHUD hideHUDForView:self.view];
        @strongify(self);
        [self.mTableView reloadData];
    } faildBlock:^(id errorCode) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:errorCode];
#warning 展示占位图，点击重新获取
        
    }];
    self.mViewModel.didSelectCellBlock = ^(NSString * _Nonnull name, NSString * _Nonnull code) {
        @strongify(self);
        [self.mTableView reloadData];
        
        self->selOrgType=code;
        self->selEnterpriseName=name;
        
        if (!self->_bottomAlertView) {
            self.bottomAlertView.titleLab.text=name;
            [self.view addSubview:self.bottomAlertView];
            [self.bottomAlertView show];
        }else {
            self.bottomAlertView.titleLab.text=name;
        }
    };
    [self.mViewModel loadEnterpriseInfo];
}


#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mTableView.delegate = self.mViewModel;
        _mTableView.dataSource = self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = NO;
    }
    return _mTableView;
}

- (AttributionPickViewModel *)mViewModel
{
    if (!_mViewModel) {
        _mViewModel=[[AttributionPickViewModel alloc]init];
    }
    return _mViewModel;
}

-(EnterprisePickAlertView *)bottomAlertView
{
    if (!_bottomAlertView) {
        _bottomAlertView=[[EnterprisePickAlertView alloc]init];
        @weakify(self);
        _bottomAlertView.actionBlock = ^(NSInteger type) {
            @strongify(self);
            if (type==0) {
                [self->_bottomAlertView dismiss];
                self->_bottomAlertView=nil;
            }else if (type==1) {
                NSDictionary *dic = @{@"orgType":self->selOrgType,
                                      @"enterpriseName":self->selEnterpriseName};
                [[NSNotificationCenter defaultCenter]  postNotificationName:NOTI_EnterprisePickConfirm object:self userInfo:dic];
                [self.navigationController popViewControllerAnimated:YES];
            }
        };
    }
    return _bottomAlertView;
}

@end
