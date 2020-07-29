//
//  UleNativePayManager.m
//  UleApp
//
//  Created by chenzhuqing on 2018/6/4.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleNativePayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UleWeixinSDK/WXApi.h>
#import <UleSecurityKit/Ule_SecurityKit.h>
#import <NSData+Base64.h>
#import "UPAPayPlugin.h"
#import "UPPaymentControl.h"
#import "UPAPayPluginDelegate.h"
#import <PassKit/PKPaymentAuthorizationViewController.h>
#import "US_UserUtility.h"
static NSString * const NativePaySuccess= @"0000"; //支付成功
static NSString * const NativePayCancel=  @"0001"; //支付取消
static NSString * const NativePayFailed=  @"0002"; //支付失败
static NSString * const NativePayOther=   @"0003"; //其他原因
static NSString * const NativePayWXUnInstalled=   @"0004"; //微信未安装
static NSString * const NativePayUPPayUnInstalled=   @"0005"; //云闪付未安装

static NSString * const WeixinPayCode=    @"SDKWechatPay";
static NSString * const AliPayCode=       @"SDKAliPay";
static NSString * const ApplePayCode=     @"SDKApplePay";
static NSString * const UnionPayCode=     @"SDKUnionPay";

typedef void(^PayMentReslutBlock)(NSString * _Nullable result,BOOL complete);

@interface UleNativePayManager ()<WXApiDelegate,UPAPayPluginDelegate>

@property (nonatomic, strong) PayMentReslutBlock resultCallBack;

@end

@implementation UleNativePayManager

+ (instancetype) shareInstance{
    static UleNativePayManager * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[UleNativePayManager alloc] init];
    });
    return manager;
}

- (void) startNativePayWithParams:(NSDictionary *)params result:(void (^)(NSString * _Nullable result,BOOL complete))completionHandler{
    NSString * type=params[@"payModelCode"];
    NSString *payInfo=params[@"payInfo"];
    NSString * secretKey=params[@"secretKey"];
    NSString * oringinKey=[secretKey mutableCopy];
    secretKey=[secretKey substringToIndex:16];
    //通过秘钥获取向量；
    NSString * ivStr=[Ule_SecurityKit getIV:oringinKey];
    NSData * IV2Data = [ivStr dataUsingEncoding:NSUTF8StringEncoding];
    //用秘钥和向量对数据进行AES128解密。
    NSData * data=[NSData base64DataFromString:payInfo];
    NSData * payInfoDec=[Ule_SecurityKit M_DecryptWithData:data WithKey:secretKey WithIV:[IV2Data bytes]];
    self.resultCallBack = [completionHandler copy];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:payInfoDec options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"JS调起支付 支付类型%@ \n%@", type, dic);
    if ([type isEqualToString:AliPayCode]) {
        [self startAliPay:dic[@"orderInfo"]];
    }else if ([type isEqualToString:WeixinPayCode]){
        if ([WXApi isWXAppInstalled]) {
            [self startWeixinPay:dic withAppId:[UleStoreGlobal shareInstance].config.wxAppKeyPay];
        }else{
            if (self.resultCallBack) {
                self.resultCallBack(NativePayWXUnInstalled, YES);
            }
        }
    }
    else if ([type isEqualToString:ApplePayCode]){
        [self startApplePayWithTN:dic[@"tn"] andMerchantID:@"merchant.com.uleapp.ule"];
    }else if ([type isEqualToString:UnionPayCode]){
        [self startUnionPayWithTN:dic[@"tn"]];
    }
}

- (BOOL)UleNativePayOpenUrl:(NSURL *)url{
    if ([url.scheme isEqualToString:[UleStoreGlobal shareInstance].config.wxAppKeyPay]) {
        return [self weiXinPayOpenUrl:url];
    }else if([url.scheme isEqualToString:[UleStoreGlobal shareInstance].config.alipayScheme]){
        return [self aliPayOpenUrl:url];
    }
    else if ([url.scheme isEqualToString:[UleStoreGlobal shareInstance].config.unionScheme]){
        return [self unionPayOpenUrl:url];
    }
    return YES;
}

#pragma mark - 支付宝支付
-(BOOL) startAliPay:(NSString *)OrderStr {
    @weakify(self);
    if (OrderStr != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[AlipaySDK defaultService] payOrder:OrderStr fromScheme:[UleStoreGlobal shareInstance].config.alipayScheme callback:^(NSDictionary *resultDic) {
                @strongify(self);
                NSString * resultStatus=[resultDic objectForKey:@"resultStatus"];
                NSLog(@"resultStatus##=%@",resultDic);
                NSString * returnCode=NativePaySuccess;
                if ([resultStatus isEqualToString:@"9000"]) {
                    returnCode=NativePaySuccess;
                }else{
                    if ([resultStatus isEqualToString:@"6001"]) {
                        returnCode=NativePayCancel;
                    }else{
                        returnCode=NativePayFailed;
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.resultCallBack) {
                        self.resultCallBack(returnCode, YES);
                    }
                });
            }];
        });
    }
    return YES;
}

-(BOOL) aliPayOpenUrl:(NSURL *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        @weakify(self);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            @strongify(self);
            NSString * resultStatus=[resultDic objectForKey:@"resultStatus"];
            NSLog(@"resultStatus##=%@",resultDic);
            NSString * returnCode=NativePaySuccess;
            if ([resultStatus isEqualToString:@"9000"]) {
                returnCode=NativePaySuccess;
            }else{
                if ([resultStatus isEqualToString:@"6001"]) {
                    returnCode=NativePayCancel;
                }else{
                    returnCode=NativePayFailed;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.resultCallBack) {
                    self.resultCallBack(returnCode, YES);
                }
            });
        }];
    });
    return YES;
}

#pragma mark - 微信支付
-(void) startWeixinPay:(NSDictionary *)order withAppId:(NSString *)appId{
    [WXApi registerApp:appId universalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [self startWeixiPay:order];
}

-(void) startWeixiPay:(NSDictionary *)order{
    if (order) {
        PayReq * req =[[PayReq alloc] init];
        req.openID=order[@"appId"];
        req.partnerId=order[@"partnerid"];
        req.prepayId=order[@"prepayid"];
        req.nonceStr=order[@"noncestr"];
        req.timeStamp=[order[@"timestamp"] intValue];
        req.package=order[@"packages"];
        req.sign=order[@"sign"];
        [WXApi sendReq:req completion:^(BOOL success) {
        }];
    }
}

#pragma mark - weixin Delegate
-(void) onResp:(BaseResp *) resp{
    
    NSString * returnCode=NativePaySuccess;
    if ([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:{
                NSLog(@"支付成功");
                returnCode=NativePaySuccess;
            }break;
            case WXErrCodeUserCancel:{
                NSLog(@"支付取消");
                returnCode=NativePayCancel;
            }break;
            default:{
                NSLog(@"支付失败");
                returnCode=NativePayFailed;
            }break;
        }
        if(self.resultCallBack){
            self.resultCallBack(returnCode, YES);
        }
    }
}

//微信支付完成后返回
-(BOOL) weiXinPayOpenUrl:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}


#pragma mark - <Apple pay and Union Pay>
- (void)startApplePayWithTN:(NSString *)tn andMerchantID:(NSString *)merchentId{
    if (@available(iOS 9.2, *)) {
        if(![PKPaymentAuthorizationViewController canMakePayments]||![PKPaymentAuthorizationViewController class]){
            //支付需iOS9.2以上支持
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备暂时不支持ApplePay，手机为iphone6以上的设备且系统升级至9.2以上版本才可正常使用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSArray * supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay];
        if(![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您还没有绑定银行卡，请前往wallet添加银行卡" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSString* unionEnv=@"00";//只有生产环境所以写死00
        [UPAPayPlugin startPay:tn mode:unionEnv viewController:[UIViewController currentViewController] delegate:self andAPMechantID:merchentId];
    }else{
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备暂时不支持ApplePay，手机为iphone6以上的设备且系统升级至9.2以上版本才可正常使用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)startUnionPayWithTN:(NSString *)tn{
    BOOL isinstall=[[UPPaymentControl defaultControl] isPaymentAppInstalled];
    NSLog(@"install==%@",@(isinstall));
    if (isinstall) {
        NSString* unionEnv=@"00";//只有生产环境所以写死00
        [[UPPaymentControl defaultControl] startPay:tn  fromScheme:[UleStoreGlobal shareInstance].config.unionScheme mode:unionEnv viewController:[UIViewController currentViewController]];
    }else{
        if (self.resultCallBack) {
            self.resultCallBack(NativePayUPPayUnInstalled, YES);
        }
    }
}

-(void) UPAPayPluginResult:(UPPayResult *) payResult{
    NSString * returnCode=NativePaySuccess;
    switch (payResult.paymentResultStatus) {
        case UPPaymentResultStatusSuccess:{
            NSLog(@"Apple Pay Success");
            returnCode=NativePaySuccess;
        }
            break;
        case UPPaymentResultStatusCancel:{
            NSLog(@"Apple Pay Cancel");
            returnCode=NativePayCancel;
        }
            break;
        case UPPaymentResultStatusFailure:{
            NSLog(@"Apple Pay Failue==%@",payResult.errorDescription);
            returnCode=NativePayFailed;
        }
            break;
        default:
            break;
    }
    if(self.resultCallBack){
        self.resultCallBack(returnCode, YES);
    }
}

- (BOOL)unionPayOpenUrl:(NSURL *)url{
    [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
        NSString * returnCode=NativePaySuccess;
        if([code isEqualToString:@"success"]) {
            //结果code为成功时，去商户后台查询一下确保交易是成功的再展示成功
            returnCode=NativePaySuccess;
        }
        else if([code isEqualToString:@"fail"]) {
            //交易失败
            returnCode=NativePayFailed;
        }
        else if([code isEqualToString:@"cancel"]) {
            //交易取消
            returnCode=NativePayCancel;
        }
        if(self.resultCallBack){
            self.resultCallBack(returnCode, YES);
        }
    }];
    return YES;
}

@end

