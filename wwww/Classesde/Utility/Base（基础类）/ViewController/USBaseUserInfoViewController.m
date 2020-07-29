//
//  USBaseUserInfoViewController.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USBaseUserInfoViewController.h"
#import "US_LoginApi.h"
#import "PostOrgModel.h"
#import "DeviceInfoHelper.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <Ule_SecurityKit.h>
#import "US_LoginManager.h"
#import "RegistStoreSuccessAlertView.h"
#import <UIView+ShowAnimation.h>
#import "USLocationManager.h"

@interface USBaseUserInfoViewController ()<RegisterViewDelegate>
{
    CGFloat topViewHeight;
    CGFloat centerViewHeight;
    
    //默认的省id
    NSString *defaultOrgType;
    NSString *defaultProvinceID;
    NSString *defaultProvinceName;
}
@property (nonatomic, strong)UIScrollView       *p_scrollView;//


@end

@implementation USBaseUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"用户信息"];
    topViewHeight = KScreenScale(306)+95;
    centerViewHeight = KScreenScale(530)+80;
    //设置默认值，以防接口请求不到
    defaultOrgType=@"0";
    defaultProvinceID=@"58093";
    defaultProvinceName=@"邮乐";
    orgType=defaultOrgType;
    provinceID=defaultProvinceID;//默认为非企业
    provinceName=defaultProvinceName;
    
    [self.view addSubview:self.p_bottomView];
    self.p_bottomView.sd_layout.bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(bottomViewHeight);//不签署协议为 70+KScreenScale(20)
    
    [self.view addSubview:self.p_scrollView];
    self.p_scrollView.sd_layout.topSpaceToView(self.uleCustemNavigationBar,0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, bottomViewHeight)
    .rightSpaceToView(self.view, 0);
    
    [self.p_scrollView addSubview:self.p_topView];
    self.p_topView.sd_layout.topSpaceToView(self.p_scrollView, 0)
    .leftSpaceToView(self.p_scrollView, 0)
    .rightSpaceToView(self.p_scrollView, 0)
    .heightIs(topViewHeight);
    
    //默认为非企业
    [self.p_scrollView addSubview:self.p_centerView];
    self.p_centerView.sd_layout.topSpaceToView(self.p_topView, 0)
    .leftSpaceToView(self.p_scrollView, 0)
    .rightSpaceToView(self.p_scrollView, 0)
    .heightIs(centerViewHeight);
    self.p_centerView.hidden = YES;
    
//    [self.p_scrollView addSubview:self.p_bottomView];
//    self.p_bottomView.sd_layout.bottomSpaceToView(self.p_scrollView, 0)
//    .leftSpaceToView(self.p_scrollView, 0)
//    .rightSpaceToView(self.p_scrollView, 0)
//    .heightIs(bottomViewHeight);//不签署协议为 70+KScreenScale(20)
    
    NSString *mobileNum = [self.m_Params objectForKey:@"mobilePhone"];
    [self.p_topView setMobileNum:mobileNum isUserInteractionEnabled:NO];
    [self requestDefaultEnterprise];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(enterprisePickConfirmed:) name:NOTI_EnterprisePickConfirm object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(organizePickConfirmed:) name:NOTI_OrganizePickConfirm object:nil];
}


#pragma mark - <RegisterViewDelegate>
- (void)registViewShowHudWithText:(NSString *)text delay:(NSTimeInterval)interval
{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:text afterDelay:interval];
}

- (void)registViewShiftSwitchStatusIsOn:(BOOL)isOn
{
    isUserChanged=YES;
    [self setRegistViewHidden:!isOn];
    [self clearCurrentAttributionInfo];
    if (!isOn) {
        orgType=defaultOrgType;
        provinceID=defaultProvinceID;
        provinceName=defaultProvinceName;
    }else {
        [self.p_centerView setRegistCenterRealName:[US_UserUtility sharedLogin].m_userName];
    }
}

- (void)registViewPushToPick:(NSInteger)pushType
{
    isUserChanged=YES;
    if (pushType==1) {
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"用户信息" moduledesc:@"companyType" networkdetail:@""];
        [self pushNewViewController:@"US_PickEnterpriseVC" isNibPage:NO withData:nil];
    }else if (pushType==2) {
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"用户信息" moduledesc:@"provinceID" networkdetail:@""];
        NSMutableDictionary *params = @{@"pickOrgType":orgType}.mutableCopy;
        [self pushNewViewController:@"US_PickOrganizeVC" isNibPage:NO withData:params];
    }
}

- (void)registViewProtocolDetailAction
{
    //记录
    [UleMbLogOperate addMbLogClick:[[US_UserUtility sharedLogin].m_protocolUrl urlEncodedString] moduleid:@"用户信息" moduledesc:@"protocol" networkdetail:@""];
    
    NSMutableDictionary *params = @{@"protocol":[US_UserUtility sharedLogin].m_protocolUrl,
                                    @"isNeedSign":@"0"}.mutableCopy;
    [self pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:params];
}

- (void)registViewConfirmToRegistAction
{
    if (self.p_topView.switchControl.isOn) {
        if (!self.p_centerView.realName||self.p_centerView.realName.length==0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的真实姓名" afterDelay:1.5];
            return;
        }
        if (!orgType||orgType.length==0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属企业" afterDelay:1.5];
            return;
        }
        if (!provinceID||provinceID.length==0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属机构" afterDelay:1.5];
            return;
        }
    }
//    if (self.p_bottomView.protocolSelBtn&&!self.p_bottomView.protocolSelBtn.selected) {
//        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请阅读并同意《服务协议与隐私政策》" afterDelay:1.5];
//        return;
//    }
    [self bottomBtnAction];
}

- (void)bottomBtnAction
{
}

#pragma mark - <通知回调>
- (void)enterprisePickConfirmed:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    orgType=[dic objectForKey:@"orgType"];
    enterpriseName=[dic objectForKey:@"enterpriseName"];
    
    self.p_centerView.enterprise_TF.text=enterpriseName;
    self.p_centerView.organization_TF.text=@"";
    [self clearCurrentOrgnizationInfo];
}

- (void)organizePickConfirmed:(NSNotification *)noti
{
    NSDictionary *dic = noti.userInfo;
    NSString *selectedName = dic[@"finalSelectName"];
    provinceID=[NSString isNullToString:dic[@"provinceID"]];
    cityID=[NSString isNullToString:dic[@"cityID"]];
    areaID=[NSString isNullToString:dic[@"areaID"]];
    townID=[NSString isNullToString:dic[@"townID"]];
    
    provinceName=[NSString isNullToString:dic[@"provinceName"]];
    cityName=[NSString isNullToString:dic[@"cityName"]];
    areaName=[NSString isNullToString:dic[@"areaName"]];
    townName=[NSString isNullToString:dic[@"townName"]];
    
    self.p_centerView.organization_TF.text=selectedName;
}

#pragma mark - <ACTIONS>
- (void)requestDefaultEnterprise
{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostOrganizationWithParentId:@"100" andLevelName:@"省" andOrgType:@"1"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        PostOrgModel *respModel = [PostOrgModel yy_modelWithDictionary:responseObject];
        if (respModel.data.count>0) {
            PostOrgData *defaultData=[respModel.data firstObject];
            NSString *defaultID = [NSString isNullToString:[NSString stringWithFormat:@"%ld", (long)defaultData._id]];
            NSString *defaultName = [NSString isNullToString:[NSString stringWithFormat:@"%@", defaultData.name]];
            if (defaultID.length>0) {
                  self->defaultProvinceID=defaultID;
            }
            if (defaultName.length>0) {
                self->defaultProvinceName=defaultName;
            }
          
            if (!self.p_topView.switchControl.isOn) {
                self->provinceID=self->defaultProvinceID;
            }
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        USLog(@"%@", error.responesObject);
    }];
}

- (void)setRegistViewHidden:(BOOL)isHidden
{
    self.p_centerView.hidden=isHidden;
    if (isHidden) {
        self.p_scrollView.contentSize=CGSizeMake(CGRectGetWidth(self.p_scrollView.frame), CGRectGetHeight(self.p_scrollView.frame));
//        self.p_bottomView.sd_resetLayout.bottomSpaceToView(self.p_scrollView, 0)
//        .leftSpaceToView(self.p_scrollView, 0)
//        .rightSpaceToView(self.p_scrollView, 0)
//        .heightIs(bottomViewHeight);
    }else {
        self.p_scrollView.contentSize=CGSizeMake(__MainScreen_Width, topViewHeight+centerViewHeight/*+bottomViewHeight*/);
//        self.p_bottomView.sd_resetLayout.topSpaceToView(self.p_topView, centerViewHeight)
//        .leftSpaceToView(self.p_scrollView, 0)
//        .rightSpaceToView(self.p_scrollView, 0)
//        .heightIs(bottomViewHeight);
    }
}

- (void)setSwitchViewStatus:(BOOL)isOn
{
    [self.p_topView.switchControl setOn:isOn];
    [self registViewShiftSwitchStatusIsOn:isOn];
}

- (void)clearCurrentAttributionInfo
{
    [self clearCurrentEnterpriseInfo];
    [self clearCurrentOrgnizationInfo];
}

- (void)clearCurrentEnterpriseInfo
{
    orgType=@"";
    enterpriseName=@"";
    [self.p_centerView setRegistCenterEnterpriseName:@""];
}

- (void)clearCurrentOrgnizationInfo
{
    provinceID=@"";
    cityID=@"";
    areaID=@"";
    townID=@"";
    
    provinceName=@"";
    cityName=@"";
    areaName=@"";
    townName=@"";
    [self.p_centerView setRegistCenterOrganizationName:@""];
}

#pragma mark - <GETTERS>
- (UIScrollView *)p_scrollView
{
    if (!_p_scrollView) {
        _p_scrollView = [[UIScrollView alloc]init];
        _p_scrollView.backgroundColor = [UIColor whiteColor];
        _p_scrollView.showsVerticalScrollIndicator = NO;
        _p_scrollView.bounces=NO;
    }
    return _p_scrollView;
}

-(RegisterTopView *)p_topView
{
    if (!_p_topView) {
        _p_topView = [[RegisterTopView alloc]init];
        _p_topView.registTopviewDelegate=self;
    }
    return _p_topView;
}

-(RegisterCenterView *)p_centerView
{
    if (!_p_centerView) {
        _p_centerView = [[RegisterCenterView alloc]init];
        _p_centerView.registCenterviewDelegate=self;
    }
    return _p_centerView;
}

- (RegisterBottomView *)p_bottomView
{
    if (!_p_bottomView) {
        _p_bottomView = [[RegisterBottomView alloc]init];
        _p_bottomView.backgroundColor = [UIColor whiteColor];
        _p_bottomView.registBottomViewDelegate=self;
    }
    return _p_bottomView;
}

- (BOOL)switchStatusOn
{
    return self.p_topView.switchControl.on;
}

@end

