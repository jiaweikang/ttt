//
//  US_LoginVC.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_LoginVC.h"
#import "LoginTopView.h"
#import "US_LoginApi.h"
#import "US_LoginManager.h"
#import <UMAnalytics/MobClick.h>

@interface US_LoginVC ()<LoginTopViewDelegate>

@end

@implementation US_LoginVC

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self.uleCustemNavigationBar ule_setBackgroundAlpha:0];
    [self setUI];
}

- (void)setUI{
    
    [self.view addSubview:self.topView];
    
}


#pragma mark - <Actions>


#pragma mark - <LoginTopViewDelegate>
//获取登录验证码
-(void)loginTopViewGetSMSCodeByAccountNum:(NSString *)accountNum
{
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录" moduledesc:@"获取验证码" networkdetail:@""];
    
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildLoginSMSCodeWithAccount:accountNum] success:^(id responseObject) {
        @strongify(self);
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录" moduledesc:@"获取验证码成功" networkdetail:@""];
        
        [UleMBProgressHUD hideHUDForView:self.view];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"验证码发送成功" afterDelay:1.5];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
        [self.topView stopSMSCodeCounting];
    }];
}

//验证码登录
- (void)loginTopViewLoginByAccountNum:(NSString *)accountNum smsCode:(NSString *)codeNum
{
    [UleMBProgressHUD showHUDWithText:@"正在登录..."];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_LoginApi buildLoginByCodeRequestWithAccount:accountNum smsCode:codeNum] success:^(id responseObject) {
        //记录
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录" moduledesc:@"验证码登录成功" networkdetail:@""];
        
        [UleMBProgressHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [[US_LoginManager sharedManager] logInDecryptData:(NSDictionary *)responseObject];
            if (dic) {
                [[US_LoginManager sharedManager] logInToMainviewWithData:dic fromType:LogInMainViewTypeFromLogin];
            }else [UleMBProgressHUD hideHUD];
        }else [UleMBProgressHUD hideHUD];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        [self showErrorHUDWithError:error];
    }];
}

//密码登录
- (void)loginTopViewLoginByAccountNum:(NSString *)accountNum passWord:(NSString *)passWdNum
{
    [UleMBProgressHUD showHUDWithText:@"正在登录..."];
    @weakify(self);
    //记录
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录" moduledesc:@"密码登录成功" networkdetail:@""];
    
    [self.networkClient_API beginRequest:[US_LoginApi buildLoginByPasswordRequestWithAccount:accountNum password:passWdNum] success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [[US_LoginManager sharedManager] logInDecryptData:(NSDictionary *)responseObject];
            if (dic) {
            [[US_LoginManager sharedManager] logInToMainviewWithData:dic fromType:LogInMainViewTypeFromLogin];
            }else [UleMBProgressHUD hideHUD];
        }else [UleMBProgressHUD hideHUD];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUD];
        [self showErrorHUDWithError:error];
    }];
}

//忘记密码 跳转重设密码页
- (void)loginTopViewGoToSettingPasswordVCByAccountNum:(NSString *)accountNum{
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"登录" moduledesc:@"忘记密码" networkdetail:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (accountNum.length>0&&[NSString isMobileNum:accountNum]) {
        [params setObject:accountNum forKey:@"phoneNum"];
    }
    [self pushNewViewController:@"US_SettingPasswordVC" isNibPage:NO withData:params];
}


#pragma mark - <getter>
- (LoginTopView *)topView
{
    if (!_topView) {
        _topView=[[LoginTopView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(556)+200)];
        _topView.p_delegate=self;
    }
    return _topView;
}

@end
