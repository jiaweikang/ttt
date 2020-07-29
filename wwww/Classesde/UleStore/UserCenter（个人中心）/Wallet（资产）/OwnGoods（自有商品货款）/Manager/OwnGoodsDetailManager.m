//
//  OwnGoodsDetailManager.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "OwnGoodsDetailManager.h"
#import <UleNetworkExcute.h>
#import "US_NetworkExcuteManager.h"
#import "US_UserCenterApi.h"
#import "US_QueryAuthInfo.h"
#import "US_WalletBindingCardModel.h"
#import "WithdrawCashPromoteView.h"
#import <UIView+ShowAnimation.h>

@interface OwnGoodsDetailManager ()

@property (nonatomic, strong) UleNetworkExcute * networkClient_VPS;

@end

@implementation OwnGoodsDetailManager

+ (instancetype)shareManager
{
    static OwnGoodsDetailManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[OwnGoodsDetailManager alloc] init];
    });
    return manager;
}

- (void)withDrawAction
{
    //是否签署协议
    if (![[US_UserUtility sharedLogin].m_isUserProtocol isEqualToString:@"1"]){
        NSMutableDictionary *dic = @{@"isNeedSign":@"1",
                                     @"protocol":[US_UserUtility sharedLogin].m_protocolUrl}.mutableCopy;
        [self.rootVC pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:dic];
        return;
    }
    [self getCertificationInfo];
}

#pragma mark - 请求
//查询实名认证信息
- (void)getCertificationInfo{
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildQueryCertificationInfoRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        US_QueryAuthInfo * authInfo = [US_QueryAuthInfo yy_modelWithDictionary:responseObject];
        if ([authInfo.returnCode isEqualToString:@"0000"]) {
            if (authInfo.data) {
                if (authInfo.data.certificationInfo) {
                    [US_UserUtility setUserRealNameAuthorization:YES];
                    //请求接口看是否有银行卡
                    [self requestBindingCardInfo];
                } else {
                    //弹框提示实名认证 并跳往实名认证页
                    [US_UserUtility setUserRealNameAuthorization:NO];
                    [self gotoAuthorizeVC];
                }
            }
            else{
                [self gotoAuthorizeVC];
            }
        }
        else{
            [self gotoAuthorizeVC];
        }
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"提现通道被挤爆～正在抢修中，请稍后再试" afterDelay:1.5];
    }];
}

//请求接口看是否有银行卡
- (void)requestBindingCardInfo{
    
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetBindCardListRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        US_WalletBindingCardModel   *model=[US_WalletBindingCardModel yy_modelWithDictionary:responseObject];
        if (model.data.cardList.count > 0) {
            //存在银行卡 去提现页
            NSMutableDictionary *params = @{@"accTypeId":@"A010"}.mutableCopy;
            [self.rootVC pushNewViewController:@"US_WithdrawVC" isNibPage:NO withData:params];
        }
        else{
            //无银行卡 需要绑定银行卡
            WithdrawCashPromoteView * promoteView = [WithdrawCashPromoteView withdrawCashPromoteViewWithType:WithdrawCashPromoteTypeBindcard andNum:@"" confirmBlock:^(WithdrawCashPromoteType type) {
                //                [Ule_Global shared].isJumpToWithdraw=YES;
                [self.rootVC pushNewViewController:@"US_WalletBankCardListVC" isNibPage:NO withData:nil];
            }];
            [promoteView showViewWithAnimation:AniamtionAlert];
        }
    } failure:^(UleRequestError *error) {
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if ([NSString isNullToString:errorInfo].length>0) {
            [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:errorInfo afterDelay:1.5];
        }
    }];
}

//弹框提示实名认证 并跳往实名认证页
- (void)gotoAuthorizeVC{
    WithdrawCashPromoteView * promoteView = [WithdrawCashPromoteView withdrawCashPromoteViewWithType:WithdrawCashPromoteTypeRealname andNum:@"" confirmBlock:^(WithdrawCashPromoteType type) {
        NSMutableDictionary *params = @{@"isFromWithdraw":@"1",@"bankCardCount":[NSString isNullToString:[US_UserUtility sharedLogin].bankCardCount]}.mutableCopy;
        [self.rootVC pushNewViewController:@"US_AuthorizeRealNameVC" isNibPage:NO withData:params];
    }];
    [promoteView showViewWithAnimation:AniamtionAlert];
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)networkClient_VPS{
    if (!_networkClient_VPS) {
        _networkClient_VPS=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _networkClient_VPS;
}

@end
