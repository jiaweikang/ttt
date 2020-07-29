//
//  SettingViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "SettingViewModel.h"
#import "UleSectionBaseModel.h"
#import "SettingCellModel.h"
#import <WebKit/WKWebsiteDataStore.h>
#import "USApplicationLaunchManager.h"
#import "US_NetworkExcuteManager.h"
#import "US_UserCenterApi.h"
#import "PaySecurityModel.h"
#import "Ule_LockPasswordFile.h"
#import <UIView+ShowAnimation.h>
#import "US_SmsCodeAlertView.h"
#import "US_PresentBottomAlertView.h"
#import "USAuthorizetionHelper.h"
#import "US_SettingPasswordVC.h"
#import "Ule_SetLockFirst.h"
#import "Ule_SetLockSecond.h"
#import "US_LogoutAccountVC.h"
#import "US_FeedbackVC.h"
#import "US_AboutVC.h"
#import "USKeychainLocalData.h"
#import "USCookieHelper.h"
#import "DeviceInfoHelper.h"
@interface SettingViewModel ()
@property (nonatomic, strong) UleNetworkExcute * networkClient_API;
@end


@implementation SettingViewModel
- (instancetype) init{
    self = [super init];
    if (self) {
        [self prepareLayoutDataArray];
        //后台进入前台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeAction) name:AppWillEnterForeground object:nil];
    }
    return self;
}

- (void) dealloc{
    NSLog(@"--%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) applicationEnterForeAction{
    NSString * notifyRightStr=[USAuthorizetionHelper currentNotificationAllowed]?@"已开启":@"未开启";
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mDataArray.count>0) {
            UleSectionBaseModel * sectionModel=self.mDataArray.firstObject;
            if ([sectionModel.cellArray count]>0) {
                SettingCellModel * model=sectionModel.cellArray.firstObject;
                if ([model.rightTitleStr isEqualToString:@"未开启"]&&[notifyRightStr isEqualToString:@"已开启"]) {
                    [[USApplicationLaunchManager sharedManager] startRequestPushRegist];
                }
                model.rightTitleStr=notifyRightStr;//修改model的值，
            }
        }
        [self.rootTableView reloadData];
    });
    
}

- (void) prepareLayoutDataArray{
    self.mDataArray=[[NSMutableArray alloc] init];
    NSArray * leftTitles = @[@[@"消息通知",@"消息提示音"],@[@"修改密码",@"手势密码设置",@"支付密码管理",@"注销账号"],@[@"清除缓存"],@[@"问题反馈",[NSString stringWithFormat:@"关于%@", [DeviceInfoHelper getAppName]]]];
    NSArray * imgNames = @[@[@"setting_img_notify",@"setting_img_sound"],@[@"setting_img_password",@"setting_img_gesture",@"setting_img_payPwIcon",@"setting_img_logout"],@[@"setting_img_cache"],@[@"setting_img_help",@"setting_img_about"]];
    
    NSString * notifyRightStr=[USAuthorizetionHelper currentNotificationAllowed]?@"已开启":@"未开启";
    NSString * soundLeftStr=@"客户下单后将以语音形式通知";
    NSString * cacheRightStr=[self getNSCaceSize];
    NSString * helpRightStr=@"有问题记得点这儿";
    NSString * aboutRightStr=NonEmpty([UleStoreGlobal shareInstance].config.appVersion);
    for (int i=0; i<leftTitles.count; i++) {
        UleSectionBaseModel * seconModel=[[UleSectionBaseModel alloc] init];
        seconModel.footHeight=10;
        NSArray * cellTitles=leftTitles[i];
        for (int j=0; j<cellTitles.count; j++) {
            SettingCellModel * cellModel=[[SettingCellModel alloc] init];
            cellModel.leftTitleStr=cellTitles[j];
            cellModel.iconStr=imgNames[i][j];
            cellModel.cellName=@"SettingTableViewCell";
            if ([cellModel.leftTitleStr isEqualToString:@"消息通知"]) {
                cellModel.rightTitleStr=notifyRightStr;
            }
            if ([cellModel.leftTitleStr isEqualToString:@"清除缓存"]) {
                cellModel.rightTitleStr=cacheRightStr;
            }
            if ([cellModel.leftTitleStr isEqualToString:@"问题反馈"]) {
                cellModel.rightTitleStr=helpRightStr;
            }
            if ([cellModel.leftTitleStr isEqualToString:[NSString stringWithFormat:@"关于%@", [DeviceInfoHelper getAppName]]]) {
                cellModel.rightTitleStr=aboutRightStr;
            }
            if ([cellModel.leftTitleStr isEqualToString:@"清除缓存"]) {
                cellModel.showRightArrow=NO;
            }
            else{
                cellModel.showRightArrow=YES;
            }
            if ([cellModel.leftTitleStr isEqualToString:@"消息提示音"]) {
                cellModel.leftSubTitleStr = soundLeftStr;
                cellModel.showRightArrow = NO;
                if (@available(iOS 10.0, *)) {
                    cellModel.switchState = [USKeychainLocalData data].isVoicePromptOn ? @"1" : @"0";
                }else {
                    cellModel.rightTitleStr=@"已开启";
                }
            }
            @weakify(self);
            cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                @strongify(self);
                [self tableCellClicAt:indexPath];
            };
            [seconModel.cellArray addObject:cellModel];
        }
        [self.mDataArray addObject:seconModel];
    }
    [self getNSCaceSize];
}

- (void) tableCellClicAt:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {//消息通知
        if (indexPath.row == 0) {
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"消息通知" networkdetail:@""];
            [self openThePushNotification];
        }else if (indexPath.row == 1) {
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"消息提示音" networkdetail:@""];
        }
   
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {//修改密码
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"修改密码" networkdetail:@""];
            
            [self showSendSMSCodeForChangePwdAlert];
        }
        else if (indexPath.row == 1) {//手势密码设置
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"手势密码设置" networkdetail:@""];
            
            NSString *string = [Ule_LockPasswordFile readLockPassword];
            // 此账号已创建
            if (string && string.length != 0) {
                [self.rootViewController pushNewViewController:@"Ule_SetLockSecond" isNibPage:NO withData:nil];
            }
            // 此账号未创建
            else {
                [self.rootViewController pushNewViewController:@"Ule_SetLockFirst" isNibPage:NO withData:nil];
            }
        }
        else if (indexPath.row == 2) {//支付密码管理
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"支付密码管理" networkdetail:@""];
            //如果设置过支付密码
            if ([[US_UserUtility sharedLogin].payPwdStatus isEqualToString:@"1"]) {
                [self.rootViewController pushNewViewController:@"US_PayPassWordManageVC" isNibPage:NO withData:nil];
            }
            else{//查询是否设置过支付密码
                [self chackpayPwdStatusRequest];
            }
        }
        else if (indexPath.row == 3) {//注销账号
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"注销账号" networkdetail:@""];
            [self.rootViewController pushNewViewController:@"US_LogoutAccountVC" isNibPage:NO withData:nil];
        }
    }
    else if (indexPath.section == 2) {//清除缓存
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"清除缓存" networkdetail:@""];
        
        [self showCleanCacheAlert];
    }
    else if (indexPath.section == 3) {
        if (indexPath.row == 0) {//问题反馈
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:@"问题反馈" networkdetail:@""];
            
            [self.rootViewController pushNewViewController:@"US_FeedbackVC" isNibPage:NO withData:nil];
        }
        else if (indexPath.row == 1){//关于小店
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"设置" moduledesc:[NSString stringWithFormat:@"关于%@", [DeviceInfoHelper getAppName]] networkdetail:@""];
            
            [self.rootViewController pushNewViewController:@"US_AboutVC" isNibPage:NO withData:nil];
        }
    }
}

//弹框 是否要发送短信验证码
- (void) showSendSMSCodeForChangePwdAlert{
    @weakify(self);
    US_SmsCodeAlertView *alertView = [US_SmsCodeAlertView smsCodeAlertViewWithPhoneNum:[US_UserUtility sharedLogin].m_mobileNumber confirmAction:^{
        @strongify(self);
        [self sendSMSCodeForChangePwdRequest];
    }];
    [alertView showViewWithAnimation:AniamtionPresentBottom];
}

#pragma mark - 网络请求
- (void) sendSMSCodeForChangePwdRequest{
    NSString * phoneNumString = [US_UserUtility sharedLogin].m_mobileNumber;
    if (phoneNumString.length == 0 && [US_UserUtility sharedLogin].m_userName.length > 0) {
        phoneNumString = [US_UserUtility sharedLogin].m_loginName;
    }
    [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:@"正在获取"];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildSendSMSCodeForChangePwdRequestWithPhoneNum:phoneNumString.length>0?phoneNumString:@""] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.rootViewController.view];
        
        //跳转到修改密码并开始倒计时
        NSMutableDictionary *params = @{@"isLogined":@"1",
                                        @"phoneNum":phoneNumString}.mutableCopy;
        [self.rootViewController pushNewViewController:@"US_SettingPasswordVC" isNibPage:NO withData:params];

    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.rootViewController.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}
//查询是否设置过支付密码
- (void) chackpayPwdStatusRequest{
    [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:nil];
    [self.networkClient_API beginRequest:[US_UserCenterApi buildChackPayPwdStatusRequest] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.rootViewController.view];
        PaySecurityModel * paySecurityModel = [PaySecurityModel yy_modelWithDictionary:responseObject];
        if (paySecurityModel.data) {
            [US_UserUtility savePayPwdStatus:paySecurityModel.data.status];
            if ([paySecurityModel.data.status isEqualToString:@"1"]) {
                [self.rootViewController pushNewViewController:@"US_PayPassWordManageVC" isNibPage:NO withData:nil];
            }
            else{
                [self showSetPayPwdAlert];
            }
        }
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.rootViewController.view];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.rootViewController.view withText:errorInfo afterDelay:showDelayTime];
        }
    }];
}

- (void) showSetPayPwdAlert{
    US_PresentBottomAlertView * alert=[US_PresentBottomAlertView presentBottomAlertViewWithTitle:@"" message:@"当前账户没有设置支付密码，请前往ule.com设置支付密码" cancelButtonTitle:@"" confirmButtonTitle:@"确定"];
    
    [alert show];
}

//跳转到应用设置界面（iOS8以后）
- (void) openThePushNotification{
    if (kSystemVersion>=8) {
        NSString * state=[USAuthorizetionHelper currentNotificationAllowed]?@"true":@"false";
        [LogStatisticsManager onClickLog:Setting_ClosePush andTev:state];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void) showCleanCacheAlert{
    US_PresentBottomAlertView * alert=[US_PresentBottomAlertView presentBottomAlertViewWithTitle:@"确定清除本地缓存？" message:@"" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    
    [alert show];
    @weakify(self);
    alert.confirmBlock = ^{
        @strongify(self);
        [self cleanCaChe];
    };
}

- (void) cleanCaChe{
    //清除YYWebImage的图片缓存
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    //清除cookie
    [[USCookieHelper sharedHelper] removeDiskCache];
    //清除WebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            NSLog(@"清除缓存完毕");
            [self getNSCaceSize];
            [self.rootTableView reloadData];
        }];
    } else {
        // Fallback on earlier versions
        [self getNSCaceSize];
        [self.rootTableView reloadData];
    }
    [LogStatisticsManager onClickLog:Setting_CleanCache andTev:@""];
}

//获取缓存的大小
- (NSString *) getNSCaceSize{
    NSString * caceSize = @"0B";
    NSUInteger intYYDiskCache = [YYWebImageManager sharedManager].cache.diskCache.totalCost;
    NSInteger cacheAll = intYYDiskCache;
    caceSize = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:cacheAll]];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.mDataArray.count>2) {
            UleSectionBaseModel * sectionModel=self.mDataArray[2];
            if ([sectionModel.cellArray count]>0) {
                SettingCellModel * model=sectionModel.cellArray[0];
                model.rightTitleStr=caceSize;//修改model的值，
            }
        }
    });
    return caceSize;
}

//计算出大小
- (NSString *) fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

-(UleNetworkExcute *)networkClient_API
{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}

@end
