//
//  US_PayPassWordManageVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/11.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_PayPassWordManageVC.h"
#import "US_UserCenterApi.h"
#import "US_SmsCodeAlertView.h"
#import <UIView+ShowAnimation.h>

static const NSArray *K_Titles;

@interface US_PayPassWordManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation US_PayPassWordManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"支付密码管理"];
    K_Titles = @[@"修改支付密码", @"手机找回支付密码"];
    [self.view addSubview:self.tableView];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.tableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
}

#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PayPasswordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 50)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 3000 + 1;
        titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:titleLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, __MainScreen_Width, 1)];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        [cell.contentView addSubview:lineView];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UILabel *titlelabel = (UILabel*)[cell.contentView viewWithTag:3000 + 1];
    titlelabel.text = K_Titles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"支付密码修改" networkdetail:@""];
        
        NSString *isModify = @"1";
        NSString *titleStr = @"修改支付密码";
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:isModify, @"isModify", titleStr, @"title", nil];
        [self pushNewViewController:@"US_SettingPayPasswordVC" isNibPage:NO withData:param];
        
    } else if (indexPath.row == 1) {
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"支付密码重置" networkdetail:@""];
        @weakify(self);
        US_SmsCodeAlertView *alertView = [US_SmsCodeAlertView smsCodeAlertViewWithPhoneNum:[US_UserUtility sharedLogin].m_mobileNumber confirmAction:^{
            @strongify(self);
            [self requestSMSCode];
        }];
        [alertView showViewWithAnimation:AniamtionPresentBottom];
    }
}

//重置支付密码 获取短信验证码
- (void) requestSMSCode{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在获取"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildSendResetPayPwdSMSCodeRequest] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        //跳转到修改密码并开始倒计时
        NSMutableDictionary *params = @{@"isModify":@"0",
                                        @"phoneNum":[US_UserUtility sharedLogin].m_mobileNumber,
                                        @"title": @"找回支付密码"
                                        }.mutableCopy;
        [self pushNewViewController:@"US_SettingPayPasswordVC" isNibPage:NO withData:params];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}
    
#pragma mark - getters
- (UITableView *) tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    }
    return _tableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
