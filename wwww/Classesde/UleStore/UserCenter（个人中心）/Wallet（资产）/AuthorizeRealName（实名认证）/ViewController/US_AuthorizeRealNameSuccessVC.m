//
//  US_AuthorizeRealNameSuccessVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_AuthorizeRealNameSuccessVC.h"
#import "AuthorizeRealViewModel.h"
#import "US_UserCenterApi.h"
#import "US_QueryAuthInfo.h"

@interface US_AuthorizeRealNameSuccessVC ()
@property (nonatomic, strong) UITableView        *mTableView;
@property (nonatomic, strong) AuthorizeRealViewModel   *mViewModel;

@end

@implementation US_AuthorizeRealNameSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"实名认证"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self getCertificationInfo];
}

//查询实名认证信息
- (void)getCertificationInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildQueryCertificationInfoRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        US_QueryAuthInfo * authInfo = [US_QueryAuthInfo yy_modelWithDictionary:responseObject];
        if ([authInfo.returnCode isEqualToString:@"0000"]) {
            if (authInfo.data) {
                if (authInfo.data.certificationInfo) {
                    [self.mViewModel handleAuthorizeInfo:authInfo.data.certificationInfo];
                    [self.mTableView reloadData];
                    self.mTableView.tableFooterView = [self getTableFooterView];
                }
            }
        }
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <getters>
- (UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.backgroundColor = kViewCtrBackColor;
        _mTableView.dataSource = self.mViewModel;
        _mTableView.delegate = self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}

- (AuthorizeRealViewModel *)mViewModel
{
    if (!_mViewModel) {
        _mViewModel = [[AuthorizeRealViewModel alloc]init];
    }
    return _mViewModel;
}

- (UIView *)getTableFooterView{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 100)];
    footerView.backgroundColor = kViewCtrBackColor;
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 100, 20)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.text = @"＊说明";
    tipLabel.textColor = [UIColor redColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:tipLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tipLabel.frame), __MainScreen_Width - 30, 60)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.text = @"填写真实的信息资料，才能提现收益；\n仅支持中国邮政储蓄卡，请不要填写信用卡。";
    contentLabel.textColor = [UIColor convertHexToRGB:kBlackTextColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 2;
    [footerView addSubview:contentLabel];
    
    return footerView;
}

@end
