//
//  US_UpdateUserInfoVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UpdateUserInfoVC.h"
#import "UpdateUserViewModel.h"
#import "US_LoginApi.h"
#import "US_MystoreManangerApi.h"
#import "UpdateUserHeaderModel.h"
#import "USApplicationLaunchManager.h"
#import "UIView+Shade.h"
#import "US_WarningAlertView.h"
#import <UIView+ShowAnimation.h>
#import "NSString+Addition.h"

@interface US_UpdateUserInfoVC ()
{
    BOOL    isFromH5Team;//是否从h5战队页面跳转过来的。
}
@property (nonatomic, strong) NSString * jsFunction;
@property (nonatomic, strong) UITableView   *mTableView;
@property (nonatomic, strong) UpdateUserViewModel   *mViewModel;
@property (nonatomic, strong) UIButton  *mApplyBtn;
@end

@implementation US_UpdateUserInfoVC
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startRequestTeamInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"店主信息"];
    isFromH5Team=[[self.m_Params objectForKey:@"isFromH5Team"] boolValue];
    self.jsFunction=[self.m_Params objectForKey:@"jsFunction"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    if ([[US_UserUtility sharedLogin].identifiedFlag isEqualToString:@"1"]) {
        [self.view addSubview:self.mApplyBtn];
        self.mApplyBtn.sd_layout.centerXEqualToView(self.view)
        .bottomSpaceToView(self.view, KScreenScale(20))
        .widthIs(KScreenScale(640))
        .heightIs(KScreenScale(80));
        self.mTableView.sd_layout.bottomSpaceToView(self.mApplyBtn, 0);
    }
    @weakify(self);
    self.mViewModel.sucessBlock = ^(id returnValue) {
        @strongify(self);
        [self.mTableView reloadData];
    };
    [self requestDefaultEnterprise];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storeInfoChanged:) name:Notify_EditStoreInfo object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(attributionInfoChanged:) name:NOTI_UpdateUserPickConfirm object:nil];
}

- (void)storeInfoChanged:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        [self.mViewModel refreshViewWithUserInfo:userInfo];
        [self.mTableView reloadData];
    });
}

- (void)attributionInfoChanged:(NSNotification *)notification{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *userInfo = [notification userInfo];
        NSString *enterpriseID=[NSString isNullToString:[userInfo objectForKey:@"enterpriseID"]];
        if ([enterpriseID isEqualToString:@"1000"]) {
            //选择帅康
            @weakify(self);
            US_WarningAlertView *alertView=[[US_WarningAlertView alloc]init];
            alertView.confirmBlock = ^{
                @strongify(self);
                [self.mViewModel refreshAttributionViewWithUserInfo:userInfo];
            };
            [alertView showViewWithAnimation:AniamtionAlert];
        }else {
            [self.mViewModel refreshAttributionViewWithUserInfo:userInfo];
        }
    });
}

#pragma mark - <网络请求>
//非企业信息
- (void)requestDefaultEnterprise
{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostOrganizationWithParentId:@"100" andLevelName:@"省" andOrgType:@"1"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel fetchDefaultEnterprise:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
    }];
}

//是否加入战队
- (void)startRequestTeamInfo{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildTeamInfo] success:^(id responseObject) {
        @strongify(self);
        UserInfoTeamModel *teamModel=[UserInfoTeamModel yy_modelWithDictionary:responseObject];
        UpdateUserHeaderModel *secondSectionModel=self.mViewModel.secondSectionModel;
        if (!teamModel.data.canEdit) {
            //有战队
            secondSectionModel.headHeight=70;
            secondSectionModel.userType=UpdateUserTypeTeam;
            secondSectionModel.contentStr=@"请先退出战队再修改机构信息";
            if (self.mApplyBtn.superview) {
                [self.mApplyBtn removeFromSuperview];
                self.mTableView.sd_layout.bottomSpaceToView(self.view, 0);
            }
        }else if ([[US_UserUtility sharedLogin].identifiedFlag isEqualToString:@"1"]) {
            //认证用户
            secondSectionModel.headHeight=70;
            secondSectionModel.userType=UpdateUserTypeAuth;
            secondSectionModel.contentStr=@"您是邮乐认证员工，若想修改机构信息需经过审核";
            self.mViewModel.identifierTips=teamModel.data.context;
            if ([NSString isNullToString:teamModel.data.auditText].length>0) {
                //认证用户修改审核中
                secondSectionModel.headHeight=70;
                secondSectionModel.userType=UpdateUserTypeAuthInReview;
                secondSectionModel.contentStr=[NSString isNullToString:teamModel.data.auditText];
            }
            if ([NSString isNullToString:teamModel.data.context2].length>0) {
                self.mTableView.tableFooterView = [self getTableFootView:teamModel.data.context2];
            }
        }else if ([[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"]) {
            secondSectionModel.headHeight=50;
            secondSectionModel.userType=UpdateUserTypeShuaiKang;
            secondSectionModel.contentStr=@"";
        }else {
            secondSectionModel.headHeight=50;
            secondSectionModel.userType=UpdateUserTypeNone;
            secondSectionModel.contentStr=@"";
        }
        [self.mViewModel refreshSecondSectionCells];
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        UpdateUserHeaderModel *secondSectionModel=self.mViewModel.secondSectionModel;
        if ([[US_UserUtility sharedLogin].identifiedFlag isEqualToString:@"1"]) {
            //认证用户
            secondSectionModel.headHeight=70;
            secondSectionModel.userType=UpdateUserTypeAuth;
            secondSectionModel.contentStr=@"您是邮乐认证员工，若想修改机构信息需经过审核";
        }else if ([[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"]) {
            secondSectionModel.headHeight=50;
            secondSectionModel.userType=UpdateUserTypeShuaiKang;
            secondSectionModel.contentStr=@"";
        }else {
            secondSectionModel.headHeight=50;
            secondSectionModel.userType=UpdateUserTypeNone;
            secondSectionModel.contentStr=@"";
        }
        [self.mViewModel refreshSecondSectionCells];
        [self.mTableView reloadData];
    }];
}

//修改企业 机构
- (void)startRequestModifyUserInfo:(NSDictionary *)dic{
    //点击记录
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"用户信息" moduledesc:@"updateUserInfo" networkdetail:@""];
    
    NSDictionary *paramDic=[NSDictionary dictionary];
    if (dic&&dic.allKeys.count>0) {
        paramDic=@{@"orgType":[NSString isNullToString:[dic objectForKey:@"orgType"]],
                                 @"orgProvince":[NSString isNullToString:[dic objectForKey:@"orgProvince"]],
                                 @"orgCity":[NSString isNullToString:[dic objectForKey:@"orgCity"]],
                                 @"orgArea":[NSString isNullToString:[dic objectForKey:@"orgArea"]],
                                 @"orgTown":[NSString isNullToString:[dic objectForKey:@"orgTown"]],
                   @"identified":[US_UserUtility sharedLogin].identifiedFlag.length>0?[US_UserUtility sharedLogin].identifiedFlag:@"0"
                                 };
    }else {
        paramDic = @{@"orgType":[NSString isNullToString:self.mViewModel.enterpriseId],
                                   @"orgProvince":[NSString isNullToString:self.mViewModel.provinceID],
                                   @"orgCity":[NSString isNullToString:self.mViewModel.cityID],
                                   @"orgArea":[NSString isNullToString:self.mViewModel.countryID],
                                   @"orgTown":[NSString isNullToString:self.mViewModel.substationID],
                                   @"identified":[US_UserUtility sharedLogin].identifiedFlag.length>0?[US_UserUtility sharedLogin].identifiedFlag:@"0"
                                   };
    }
    UpdateUserSwitchStatus switchStatus=[[dic objectForKey:@"orgSwitchStatus"] integerValue];
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildUpdateUserInfoWithParams:paramDic] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        UpdateUserHeaderModel *secondSectionModel=self.mViewModel.secondSectionModel;
        if (dic&&dic.allKeys.count>0) {
            if (switchStatus==UpdateUserSwitchStatusOff) {
                secondSectionModel.switchStatus=switchStatus;
            }
            self.mViewModel.enterpriseId=paramDic[@"orgType"];
            self.mViewModel.provinceID=paramDic[@"orgProvince"];
            self.mViewModel.cityID=paramDic[@"orgCity"];
            self.mViewModel.countryID=paramDic[@"orgArea"];
            self.mViewModel.substationID=paramDic[@"orgTown"];
            self.mViewModel.enterpriseName=[NSString isNullToString:[dic objectForKey:@"orgName"]];
            self.mViewModel.provinceName=[NSString isNullToString:[dic objectForKey:@"orgProvinceName"]];
            self.mViewModel.cityName=[NSString isNullToString:[dic objectForKey:@"orgCityName"]];
            self.mViewModel.countryName=[NSString isNullToString:[dic objectForKey:@"orgAreaName"]];
            self.mViewModel.substationName=[NSString isNullToString:[dic objectForKey:@"orgTownName"]];
            [self.mViewModel refreshOrganizeViewAfterRequestSuccess];
        }
        //修改成功
        if (![[US_UserUtility sharedLogin].identifiedFlag isEqualToString:@"1"]) {
            //非认证用户才主动修改缓存
            //本地保存店主信息
            [US_UserUtility saveOrgType:[NSString isNullToString:self.mViewModel.enterpriseId] orgCode:[US_UserUtility sharedLogin].m_orgCode orgName:[NSString isNullToString:self.mViewModel.enterpriseName] orgProvinceCode:[NSString isNullToString:self.mViewModel.provinceID] orgProvinceName:[NSString isNullToString:self.mViewModel.provinceName] orgCityCode:[NSString isNullToString:self.mViewModel.cityID] orgCityName:[NSString isNullToString:self.mViewModel.cityName] orgAreaCode:[NSString isNullToString:self.mViewModel.countryID] orgAreaName:[NSString isNullToString:self.mViewModel.countryName] orgTownCode:[NSString isNullToString:self.mViewModel.substationID] orgTownName:[NSString isNullToString:self.mViewModel.substationName] enterpriseOrgFlag:secondSectionModel.switchStatus==UpdateUserSwitchStatusOn?@"1":@"0"];
            //更新注册通知
            [[USApplicationLaunchManager sharedManager] startRequestPushRegist];
            [LogStatisticsManager onClickLog:User_ModifyOrg andTev:@""];
        }
        //跳转
        [self updateUserInfoSuccess];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
     

- (void)updateUserInfoSuccess{
    if (isFromH5Team) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateUserInfo object:nil userInfo:@{@"jsFunction":NonEmpty(self.jsFunction)}.mutableCopy];
        [[USApplicationLaunchManager sharedManager] startRequestUserInfoInGroup:NO isSelectedAtLast:NO];
        [self ule_toLastViewController];
    }else{
        [[USApplicationLaunchManager sharedManager] startRequestUserInfoInGroup:NO isSelectedAtLast:YES];
    }
}

- (void)applyBtnAction{
    [self startRequestModifyUserInfo:@{}];
}

- (UILabel *)getTableFootView:(NSString *)footText
{
    footText = [footText stringByReplacingOccurrencesOfString:@"##" withString:@"\n"];
    CGFloat footHeight = [footText heightForFont:[UIFont systemFontOfSize:KScreenScale(24)] width:__MainScreen_Width] + 20;
    UILabel *footLbl = [[UILabel alloc] initWithFrame:CGRectMake(KScreenScale(32), 0, __MainScreen_Width - KScreenScale(32), footHeight)];
    footLbl.font = [UIFont systemFontOfSize:KScreenScale(24)];
    footLbl.textColor = [UIColor convertHexToRGB:@"ef3b39"];
    footLbl.numberOfLines = 0;
    footLbl.text = footText;
    return footLbl;
}

#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _mTableView;
}
- (UpdateUserViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UpdateUserViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.storeNameStandardUrl=[self.m_Params objectForKey:@"storeNameStandard"];
    }
    return _mViewModel;
}
- (UIButton *)mApplyBtn{
    if (!_mApplyBtn) {
        _mApplyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_mApplyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_mApplyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mApplyBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _mApplyBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        CAGradientLayer * layer=[UIView setGradualSizeChangingColor:CGSizeMake(KScreenScale(640), KScreenScale(80)) fromColor:[UIColor convertHexToRGB:@"FD2448"] toColor:[UIColor convertHexToRGB:@"FE5F45"] gradualType:GradualTypeHorizontal];
        [_mApplyBtn.layer addSublayer:layer];
        layer.zPosition=-1;
        [_mApplyBtn addTarget:self action:@selector(applyBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mApplyBtn;
}
@end
