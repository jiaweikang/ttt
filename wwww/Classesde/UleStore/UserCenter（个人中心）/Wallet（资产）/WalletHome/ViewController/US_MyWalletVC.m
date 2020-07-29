//
//  US_MyWalletVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MyWalletVC.h"
#import "MyWalletViewModel.h"
#import <UICountingLabel.h>
#import "US_UserCenterApi.h"
#import "US_QueryAuthInfo.h"

@interface US_MyWalletVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) MyWalletViewModel * mViewModel;
@property (nonatomic, strong) UIView * tableHearderView;
@property (nonatomic, strong) UICountingLabel * amountLabel;
@property (nonatomic, assign) BOOL Loaded;
@end

@implementation US_MyWalletVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([US_UserUtility isUserRealNameAuthorized]) {
        [self.mViewModel refeashUserRealNameAuthorization];
    }
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"资产"];
    }
    
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    
    //加载本地资产列表数据
    [self.mViewModel loadLocalData:nil];
    [self.mViewModel prepareLayoutDataArray];
    //请求资产列表数据(推荐位)
    [self getWalletList];
    if (self.mViewModel.headerTitleStr.length>0) {
        _mTableView.tableHeaderView=self.tableHearderView;
    }
}

#pragma mark - <上拉下拉刷新>
- (void)beginRefreshHeader{
    [self getWalletList];
}

//请求资产页列表 配置推荐位
-(void)getWalletList{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_UserCenterApi buildGetWalletListDataRequest] success:^(id responseObject) {
        @strongify(self);
        
        [self.mViewModel fetchWalletListWithData:responseObject];
        [self requestData];
        
        } failure:^(UleRequestError *error) {
            [self requestData];
        }];
}

-(void)requestData{
    [self getWalletInfo];
    if (![US_UserUtility isUserRealNameAuthorized]) {
        [self getCertificationInfo];
    }
}

//请求我的钱包数据
- (void)getWalletInfo{
    if (!self.Loaded) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    }
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildWalletInfoRequest] success:^(id responseObject) {
        @strongify(self);
        self.Loaded=YES;
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mTableView.mj_header endRefreshing];
        NSDecimalNumber *totalAmount = [self.mViewModel fetchWalletInfoValueWithData:responseObject];
        if ([totalAmount doubleValue]<0) {
            totalAmount=[NSDecimalNumber decimalNumberWithString:@"0.00"];
        }
        [self.mTableView reloadData];
        @weakify(self);
        self.amountLabel.completionBlock = ^{
            @strongify(self);
            self.amountLabel.text = [NSString stringWithFormat:@"%.2lf",[totalAmount doubleValue]];
        };
        [self.amountLabel countFrom:0.00 to:[totalAmount doubleValue] withDuration:1.0];

    } failure:^(UleRequestError *error) {
        self.Loaded=YES;
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
    }];
}

//查询实名认证信息
- (void)getCertificationInfo{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildQueryCertificationInfoRequest] success:^(id responseObject) {
        @strongify(self);
        US_QueryAuthInfo * authInfo = [US_QueryAuthInfo yy_modelWithDictionary:responseObject];
        if ([authInfo.returnCode isEqualToString:@"0000"]) {
            if (authInfo.data) {
                if (authInfo.data.certificationInfo) {
                    [US_UserUtility setUserRealNameAuthorization:YES];
                } else {
                    [US_UserUtility setUserRealNameAuthorization:NO];
                }
            }
        }
        [self.mViewModel refeashUserRealNameAuthorization];
        [self.mTableView reloadData];
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

- (MyWalletViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[MyWalletViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}

- (UIView *)tableHearderView{
    if (!_tableHearderView) {
        _tableHearderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 90)];
        _tableHearderView.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 150, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = self.mViewModel.headerTitleStr;
        titleLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:16];
        [_tableHearderView addSubview:titleLabel];
        UILabel *coinLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame) + 10, 18, 30)];
        coinLabel.text = @"￥";
        coinLabel.textAlignment = NSTextAlignmentLeft;
        coinLabel.font = [UIFont systemFontOfSize:16];
        coinLabel.adjustsFontSizeToFitWidth = YES;
        coinLabel.backgroundColor = [UIColor clearColor];
        coinLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        [_tableHearderView addSubview:coinLabel];
        
        _amountLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(coinLabel.frame), CGRectGetMaxY(titleLabel.frame)+5, __MainScreen_Width-30, 35)];
        _amountLabel.font = [UIFont systemFontOfSize:36];
        _amountLabel.adjustsFontSizeToFitWidth = YES;
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        [_tableHearderView addSubview:_amountLabel];
        _amountLabel.format = @"%.2f";
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 89, __MainScreen_Width, 1)];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
        [_tableHearderView addSubview:lineView];
    }
    return _tableHearderView;
}

@end
