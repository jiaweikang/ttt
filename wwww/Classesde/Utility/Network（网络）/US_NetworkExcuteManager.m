//
//  US_NetwordExcuteManager.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_NetworkExcuteManager.h"
#import "US_Const.h"
#import "US_LoginManager.h"
#import "CalcKeyIvHelper.h"
#import "Ule_SecurityKit.h"
#import "NSData+Base64.h"

@implementation US_NetworkExcuteManager

+ (NSString *) netWorkType{
    switch ([UleReachability manager].mReachabilityStatus) {
        case 0:     return @"NONET";
            break;
        case 1:     return @"2G/3G";
            break;
        case 2:     return @"WiFi";
            break;
        default:    return @"UNKNOW";
            break;
    }
    return @"";
}
+ (UleNetworkExcute *) buildNetworkExcuteWithBaseUrl:(NSString *)baseUrl{
    UleRequestConfigure * config=[[UleRequestConfigure alloc] init];
    NSMutableDictionary *tHeadDic = [@{ @"appkey":NonEmpty([UleStoreGlobal shareInstance].config.appKey),
                                        @"app_version":NonEmpty([UleStoreGlobal shareInstance].config.versionNum),
                                        @"version_no":@"apr_2010_build01",
                                        @"session_id":[US_UserUtility sharedLogin].openUDID,
                                        @"user_token":[US_UserUtility sharedLogin].m_userToken,
                                        @"uuid":[US_UserUtility sharedLogin].openUDID,
                                        @"client_type":NonEmpty([UleStoreGlobal shareInstance].config.clientType),
                                        @"market_id":NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),
                                        @"Accept-Encoding":@"gzip",
                                        @"type":@"ios"} mutableCopy];
    config.mheadParams=tHeadDic;
    config.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    UleNetworkExcute * client= [UleNetworkExcute shareInstanceWithConfig:config];
    if (client) {
        client.configure=config;
        client.tokenBlock = ^{
            //TODO:token失效回调
            NSLog(@"token失效回调");
            [US_UserUtility setPoststore_my_update:@""];
            [US_LoginManager logOutToLoginWithMessage:@"获取用户信息失败，请重新登录"];
        };
    }
    return client;
}

//vps.ule.com/yzgApiWAR 替换为api.ule.com域名 2019.08.14
+ (UleNetworkExcute *) uleVPSRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.apiDomain];
}

+ (UleNetworkExcute *) uleAPIRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.apiDomain];
}

+ (UleNetworkExcute *) uleCDNRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.cdnServerDomain];
}

+ (UleNetworkExcute *) uleServerRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.serverDomain];
}

+ (UleNetworkExcute *) uleTrackRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.trackDomain];
}

+ (UleNetworkExcute *) uleUstaticCDNRequestClient{
    return [self buildNetworkExcuteWithBaseUrl:[UleStoreGlobal shareInstance].config.cdnServerDomain];
}

+ (NSMutableDictionary *)getRequestHeaderNormalSignParams{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary * headers=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    return headers;
}
+ (NSMutableDictionary *)getRequestHeaderUploadImageSignParams:(NSString *) imageName{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"IMAGENAME%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",imageName,m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary * headers=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    return headers;
}
+ (NSMutableDictionary *)getRequestHeaderStoreListSignParms:(NSString *)pageSize pageIndex:(NSString *)pageIndex andStoreId:(NSString *)storeId{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"PAGEINDEX%@PAGESIZE%@ULESTOREIDS%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",  [NSString stringWithFormat:@"%@",pageIndex], pageSize,storeId, m_time, token, [US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary * headers=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    return headers;
}
+ (NSMutableDictionary *)getRequestHeaderSearchGoodsSourceSignParms:(NSString *)keyword pageIndex:(NSString *)pageIndex andPageSize:(NSString*)pageSize{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"KEYWORD%@PAGEINDEX%@PAGESIZE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",keyword?keyword:@"",[NSString stringWithFormat:@"%@",pageIndex],pageSize,m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary * headers=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    return headers;
}
+ (NSMutableDictionary *)getRequestCouponBacthId:(NSString *)batchId pageIndex:(NSString * )pageIndex andPageSize:(NSString *)pageSize{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"COUPONBATCHID%@PAGEINDEX%@PAGESIZE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@", batchId?batchId:@"",pageIndex, pageSize, m_time,token, [US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    NSMutableDictionary * headers=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    return headers;
}

+ (NSMutableDictionary *)getEncryptedParamsWithDic:(NSDictionary *)dic andKey:(NSString *)encryptKey andIV:(NSString *)encryptIV {
    NSMutableDictionary *encryptDic = [NSMutableDictionary dictionary];
    for (NSString *key in dic.allKeys) {
        NSString *valueStr = [dic objectForKey:key];
        //AES加密
        NSData *encryptData = [Ule_SecurityKit M_EncryptWithData:[valueStr dataUsingEncoding:NSUTF8StringEncoding] WithKey:encryptKey WithIV:[[encryptIV dataUsingEncoding:NSUTF8StringEncoding] bytes]];
        NSString *encryptStr = [encryptData base64EncodedString];
        [encryptDic setObject:encryptStr forKey:key];
    }
    return encryptDic;
}

@end
