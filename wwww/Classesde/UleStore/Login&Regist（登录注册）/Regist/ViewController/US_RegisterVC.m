//
//  US_RegisterVC.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_RegisterVC.h"
#import "US_LoginApi.h"
#import "DeviceInfoHelper.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <Ule_SecurityKit.h>
#import "US_LoginManager.h"
#import "RegistStoreSuccessAlertView.h"
#import <UIView+ShowAnimation.h>
#import "USLocationManager.h"

@interface US_RegisterVC ()<RegisterViewDelegate>
@property (nonatomic, strong)UIButton           *p_popBtn;//返回

@end

@implementation US_RegisterVC

- (void)viewDidLoad {
    bottomViewHeight = KScreenScale(120);
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"用户信息"];
    self.uleCustemNavigationBar.leftBarButtonItems=nil;
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.p_popBtn];
    
}


#pragma mark - <ACTIONS>
- (void)p_popBtnAction {
    if (self.navigationController.childViewControllers>0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//重写父类
- (void)bottomBtnAction
{
    [self.view endEditing:YES];
    if (self.p_topView.phoneNum_TF.text.length<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的手机号码" afterDelay:1.5];
        return;
    }
    if (![NSString isMobileNum:[NSString stringWithFormat:@"%@", self.p_topView.phoneNum_TF.text]]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确的手机号码" afterDelay:1.5];
        return;
    }
    
    [self startRequestRegistAction];
}

- (void)startRequestRegistAction
{
    //点击记录
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"用户信息" moduledesc:@"setUpStore" networkdetail:@""];
    
    NSString *hardInfo=[NSString stringWithFormat:@"%@##%@",[US_UserUtility sharedLogin].openUDID,[DeviceInfoHelper platformString]];
    NSDictionary *paramDic = @{@"hardInfo":hardInfo,
                               @"mobile":[NSString isNullToString:self.p_topView.phoneNum_TF.text],
                               @"storeName":[NSString isNullToString:self.p_topView.storeName],
                               @"usrName":[NSString isNullToString:self.p_centerView.realName],
                               @"orgType":[NSString isNullToString:orgType],
                               @"orgProvince":[NSString isNullToString:provinceID],
                               @"orgCity":[NSString isNullToString:cityID],
                               @"orgArea":[NSString isNullToString:areaID],
                               @"orgTown":[NSString isNullToString:townID],
                               @"currentProvince":[USLocationManager sharedLocation].lastProvince,
                               @"currentCity":[USLocationManager sharedLocation].lastCity,
                               @"longitude":[USLocationManager sharedLocation].lastLongitude,
                               @"latitude":[USLocationManager sharedLocation].lastLatitude};
    //转成json串
    NSString *jsonParam= [paramDic yy_modelToJSONString];
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildRegistStoreRequestWithJsonParam:jsonParam] success:^(id responseObject) {
        @strongify(self);
        //记录
        [UleMbLogOperate addMbLogClick:[USLocationManager sharedLocation].lastProDetail moduleid:@"注册成功" moduledesc:@"省市区" networkdetail:@""];
        [UleMBProgressHUD hideHUDForView:self.view];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDic = responseObject;
            NSString *encryptStr = [responseDic objectForKey:@"data"];
            if ([NSString isNullToString:encryptStr].length==0) return;
            //获取key
            NSString *o_key = [CalcKeyIvHelper shared].x_Emp_Key;
            //获取向量
            NSString *o_Iv = [CalcKeyIvHelper shared].x_Emp_Iv;
            NSData *o_ivData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
            
            NSData *decryptData = [Ule_SecurityKit M_DecryptWithData:[NSData dataFromBase64String:encryptStr] WithKey:o_key WithIV:[o_ivData bytes]];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:decryptData options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers  error:nil];
            NSMutableDictionary *compleDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            if (dic.allKeys.count>0) {
                //注册接口未返回token
                [compleDic setObject:[US_UserUtility sharedLogin].m_userToken forKey:@"X-Emp-Token"];
            }
            RegistStoreSuccessAlertView *registSucView = [[RegistStoreSuccessAlertView alloc]init];
            registSucView.confirmBlock = ^{
                [[US_LoginManager sharedManager] logInToMainviewWithData:compleDic fromType:LogInMainViewTypeFromRegist];
            };
            [registSucView showViewWithAnimation:AniamtionPresentBottom];
        }
        
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <GETTERS>
- (UIButton *)p_popBtn
{
    if (!_p_popBtn) {
        _p_popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _p_popBtn.frame = CGRectMake(0, 0, 40, 30);
        [_p_popBtn setBackgroundColor:[UIColor clearColor]];
        [_p_popBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_p_popBtn addTarget:self action:@selector(p_popBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _p_popBtn;
}

@end
