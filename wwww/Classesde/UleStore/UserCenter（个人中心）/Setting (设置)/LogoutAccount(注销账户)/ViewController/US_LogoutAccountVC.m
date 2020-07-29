//
//  US_LogoutAccountVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/9.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_LogoutAccountVC.h"
#import "US_LoginApi.h"
#import "LogoutModel.h"
#import "UleBaseViewModel.h"
#import "US_AccCancellationAlertView.h"
#import "US_LoginManager.h"

@interface US_LogoutAccountVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) UIButton * logoutButton;
@property (nonatomic, copy) NSString * failMsg;
@end

@implementation US_LogoutAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"注销账号"];
    
    [self.view sd_addSubviews:@[self.mTableView,self.logoutButton]];
    self.logoutButton.sd_layout
    .bottomSpaceToView(self.view, kIphoneX?KScreenScale(25)+34:KScreenScale(25))
    .centerXEqualToView(self.view)
    .widthIs(KScreenScale(530))
    .heightIs(KScreenScale(90));
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.logoutButton, KScreenScale(25));
    [self showBottomView:NO];
    [self requestUserLogOffDetail];
}

/** 是否显示底部的注销按钮 */
- (void)showBottomView:(BOOL)show {
    if (show) {
        self.view.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        self.logoutButton.hidden = NO;
    } else {
        self.view.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        self.logoutButton.hidden = YES;
    }
}

-(void)requestUserLogOffDetail{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildGetUserLogOffDetailRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showBottomView:YES];
        [self fetchLogOffDetailData:responseObject];
        
    } failure:^(UleRequestError *error) {
        [self showBottomView:NO];
        [self showErrorHUDWithError:error];
    }];
}

- (void)requestLogOff{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildUserLogOffRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [US_AccCancellationAlertView showResultAlertWithType:(AccCancellationAlertTypeSuccess) message:@"账号已注销，将跳转登录。" callback:^{
            [self cancellationSuccess];
        }];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [US_AccCancellationAlertView showResultAlertWithType:(AccCancellationAlertTypeFailed) message:errorInfo callback:^{
            [self cancellationFailed];
        }];
    }];
}

/** 账号注销成功 */
- (void)cancellationSuccess{
    [US_LoginManager logOutToLoginWithMessage:@""];
    [US_UserUtility accountCancellationSuccess];
}

/** 账号注销失败 */
- (void)cancellationFailed {
    int index = (int)[[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-2)] animated:YES];
}

- (void)fetchLogOffDetailData:(id)data{
    LogoutModel * model = [LogoutModel yy_modelWithDictionary:data];
    self.failMsg=model.data.failMsg;
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    if (model.data.top) {
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=0;
        [self.mViewModel.mDataArray addObject:sectionModel];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"LogoutViewTopCell"];
        cellModel.data=model.data.top;
        [sectionModel.cellArray addObject:cellModel];
        
    }
    if (model.data.middle) {
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=10;
        [self.mViewModel.mDataArray addObject:sectionModel];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"LogoutViewMiddleCell"];
        cellModel.data=model.data.middle;
        [sectionModel.cellArray addObject:cellModel];
    }
    if (model.data.bottom) {
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=10;
        [self.mViewModel.mDataArray addObject:sectionModel];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"LogoutViewMiddleCell"];
        cellModel.data=model.data.bottom;
        [sectionModel.cellArray addObject:cellModel];
    }
    if (model.data.tip.length > 0) {
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=0;
        [self.mViewModel.mDataArray addObject:sectionModel];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"LogoutViewBottomCell"];
        cellModel.data=model.data.tip;
        [sectionModel.cellArray addObject:cellModel];
    }
    
    [self.mTableView reloadData];
}

- (void)clickToLogout:(UIButton *)button{
    @weakify(self);
    [US_AccCancellationAlertView showAlertWithMessage:@"小店收益多多，不留下来再看看？" cancelBlock:^{
        NSLog(@"留下来，再看看");
    } confirmBlock:^{
        @strongify(self);
        if (self.failMsg.length > 0) {
            [US_AccCancellationAlertView showResultAlertWithType:(AccCancellationAlertTypeFailed) message:self.failMsg callback:^{
                [self cancellationFailed];
            }];
        } else {
            //请求账号注销接口
            [self requestLogOff];
        }
    }];
}

- (void)show{
    
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
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

- (UIButton *)logoutButton{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.layer.cornerRadius = KScreenScale(45);
        [_logoutButton setTitle:@"申请注销" forState:(UIControlStateNormal)];
        [_logoutButton setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:(UIControlStateNormal)];
        [_logoutButton setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
        [_logoutButton addTarget:self action:@selector(clickToLogout:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutButton;
}

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}
@end
