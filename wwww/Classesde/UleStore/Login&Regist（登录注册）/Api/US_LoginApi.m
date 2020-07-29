//
//  US_LoginApi.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_LoginApi.h"
#import "US_Api.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <Ule_SecurityKit.h>
#import "DeviceInfoHelper.h"
#import "US_NetworkExcuteManager.h"

@implementation US_LoginApi

#pragma mark - <登录>
+ (UleRequest *)buildLoginSMSCodeWithAccount:(NSString *)accountStr
{
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *o_IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
  
    //参数mobile:AES加密
    NSData *data = [accountStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[o_IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    //签名
    NSString *signString = [NSString stringWithFormat:@"MOBILE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",accountStr,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"mobile":en_str}.mutableCopy;
    
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_smsCodeByLogin andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildLoginByCodeRequestWithAccount:(NSString *)accountStr smsCode:(NSString *)codeStr
{
    NSMutableDictionary *passDic = @{@"mobile":NonEmpty(accountStr),
                                     @"validateCode":NonEmpty(codeStr),
                                     @"marketID":NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),
                                     @"appKey":NonEmpty([UleStoreGlobal shareInstance].config.appKey),
                                     @"mobileCode":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceId":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceToken":[US_UserUtility sharedLogin].m_deviceToken}.mutableCopy;
    
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getLoginKeyString:token];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getLoginLvString:token];
    //
    [CalcKeyIvHelper shared].x_Emp_Key=o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv=o_Iv;
    //获取向量的byte数组
    NSData *o_IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];

    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[o_IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];

    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];

    //签名
    NSString *signString = [NSString stringWithFormat:@"MOBILE%@VALIDATECODE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",accountStr,codeStr,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];

    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
    
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_loginBySmsCode andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildLoginByPasswordRequestWithAccount:(NSString *)accountStr password:(NSString *)passwdStr
{
    NSString *token = [Ule_SecurityKit Random_Number:32];
    
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getLoginKeyString:token];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getLoginLvString:token];

    //
    [CalcKeyIvHelper shared].x_Emp_Key=o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv=o_Iv;
    
    NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
    [passDic setObject:@"mobile" forKey:@"channel"];
    [passDic setObject:NonEmpty(passwdStr) forKey:@"password"];
    [passDic setObject:NonEmpty(accountStr) forKey:@"loginName"];
    [passDic setObject:[US_UserUtility sharedLogin].openUDID forKey:@"deviceId"];
    [passDic setObject:[US_UserUtility sharedLogin].m_deviceToken forKey:@"deviceToken"];

    // 记录日志
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;

    NSString *mremarkStr = [NSString stringWithFormat:@"deviceId=%@,versionCode=%@,markId=%@,deviceType=%@,deviceModel=%@,deviceVersion_Release=%@,screenResolution=%@",[US_UserUtility sharedLogin].openUDID,NonEmpty([UleStoreGlobal shareInstance].config.versionNum),NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),@"iOS",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion],[NSString stringWithFormat:@"%.0f*%.0f",screenSize.width*scale_screen,screenSize.height*scale_screen]];
    [passDic setObject:NonEmpty(mremarkStr) forKey:@"remark"];

    //获取向量的byte数组
    NSData *randomData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];

    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[randomData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    //签名
    NSString *signString = [NSString stringWithFormat:@"LOGINNAME%@PASSWORD%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",accountStr,passwdStr,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
  
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_loginByPasswd andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildQuickLoginWithKouLing:(NSString *)kouLingString
{
    
    NSMutableDictionary *passDic = @{@"quickRegisterAuto":NonEmpty(kouLingString),
                                     @"marketID":NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),
                                     @"appKey":NonEmpty([UleStoreGlobal shareInstance].config.appKey),
                                     @"mobileCode":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceId":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceToken":[US_UserUtility sharedLogin].m_deviceToken}.mutableCopy;
    
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getLoginKeyString:token];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getLoginLvString:token];
    //
    [CalcKeyIvHelper shared].x_Emp_Key=o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv=o_Iv;
    //获取向量的byte数组
    NSData *o_IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[o_IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    //签名
    NSString *signString = [NSString stringWithFormat:@"QUICK_REGISTER_AUTO%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",kouLingString,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
    
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_quickLogin andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

#pragma mark - <注册>
+ (UleRequest *)buildRegistSMSCodeWithAccount:(NSString *)accountStr
{
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *o_IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    //参数mobile:AES加密
    NSString *passStr = accountStr;
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[o_IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    //签名
    NSString *signString = [NSString stringWithFormat:@"MOBILE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",accountStr,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"mobile":en_str}.mutableCopy;
    
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_smsCodeByRegist andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildPreRegistByCodeRequestWithAccount:(NSString *)accountStr smsCode:(NSString *)codeStr
{
    NSMutableDictionary *passDic = @{@"mobile":NonEmpty(accountStr),
                                     @"validateCode":NonEmpty(codeStr),
                                     @"marketID":NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),
                                     @"appKey":NonEmpty([UleStoreGlobal shareInstance].config.appKey),
                                     @"mobileCode":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceId":[US_UserUtility sharedLogin].openUDID,
                                     @"deviceToken":[US_UserUtility sharedLogin].m_deviceToken}.mutableCopy;
    
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getLoginKeyString:token];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getLoginLvString:token];
    //保存
    [CalcKeyIvHelper shared].x_Emp_Key = o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv = o_Iv;
    //获取向量的byte数组
    NSData *o_IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[o_IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    //签名
    NSString *signString = [NSString stringWithFormat:@"MOBILE%@VALIDATECODE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",accountStr,codeStr,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                        @"X-Emp-Signature":NonEmpty(signStr),
                                        @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
  
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_preRegist andParams:params];
    request.headParams = [NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildRegistStoreRequestWithJsonParam:(NSString *)jsonParamStr
{
    NSMutableDictionary *params = @{@"postMobileVpsInfo":jsonParamStr}.mutableCopy;
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_iv = [[CalcKeyIvHelper shared] getIvString:token];
    //保存
    [CalcKeyIvHelper shared].x_Emp_Key = o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv = o_iv;
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary * headerParams=@{@"X-Emp-Token":NonEmpty(token),
                                    @"X-Emp-Signature":NonEmpty(signStr),
                                    @"X-Emp-Timestamp":NonEmpty(m_time),}.mutableCopy;
    
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_registStore andParams:params];
    request.headParams = [NSMutableDictionary dictionaryWithDictionary:headerParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildUpdateUserInfoWithParams:(NSDictionary *)paramDic
{
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_updateUserInfo andParams:paramDic];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildPostOrganizationWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName andOrgType:(NSString *)orgType
{
    /*
     parentId 100-邮政 1000-帅康
     levelName 省/市/县/支局
     chinaPostOrgType 0-邮乐(非企业) 1-邮政 2-帅康
     */
    NSMutableDictionary *params = @{@"parentId":NonEmpty(parentId),
                                    @"levelName":NonEmpty(levelName),
                                    @"chinaPostOrgType":orgType}.mutableCopy;
    
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_postOrgUnit andParams:params];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildPostEnterpriseInfo
{
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_postEnterpriseUnit andParams:nil];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildTeamInfo{
    NSMutableDictionary *params = @{@"clientCallType":@"APP"}.mutableCopy;
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_editBeforeCheck andParams:params];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildContractSignRequest{
    
    NSString *hardInfo=[NSString stringWithFormat:@"%@##%@",[US_UserUtility sharedLogin].openUDID,[DeviceInfoHelper platformString]];
    NSMutableDictionary *params = @{@"hardInfo":NonEmpty(hardInfo)}.mutableCopy;
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_contractSign andParams:params];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

/** 请求账号注销前权益信息 */
+ (UleRequest *)buildGetUserLogOffDetailRequest{
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_getUserLoggedOffDetail andParams:nil];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

/** 账号注销 */
+ (UleRequest *)buildUserLogOffRequest{
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_UserLoggedOff andParams:nil];
    request.headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOnekeyLoginWithToken:(NSString *)onekeyToken{
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getLoginKeyString:token];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getLoginLvString:token];
    //
    [CalcKeyIvHelper shared].x_Emp_Key=o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv=o_Iv;

    NSMutableDictionary *passDic = [[NSMutableDictionary alloc] init];
    [passDic setObject:@"mobile" forKey:@"channel"];
    [passDic setObject:NonEmpty(onekeyToken) forKey:@"onekeyToken"];
    [passDic setObject:[US_UserUtility sharedLogin].openUDID forKey:@"deviceId"];
    [passDic setObject:[US_UserUtility sharedLogin].m_deviceToken forKey:@"deviceToken"];
    // 记录日志
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;

    NSString *mremarkStr = [NSString stringWithFormat:@"deviceId=%@,versionCode=%@,markId=%@,deviceType=%@,deviceModel=%@,deviceVersion_Release=%@,screenResolution=%@",[US_UserUtility sharedLogin].openUDID,NonEmpty([UleStoreGlobal shareInstance].config.versionNum),NonEmpty([UleStoreGlobal shareInstance].config.appChannelID),@"iOS",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion],[NSString stringWithFormat:@"%.0f*%.0f",screenSize.width*scale_screen,screenSize.height*scale_screen]];
    [passDic setObject:NonEmpty(mremarkStr) forKey:@"remark"];

    //获取向量的byte数组
    NSData *randomData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];

    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[randomData bytes]];
    NSString *en_str = [m_data base64EncodedString];

    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //签名
    NSString *signString = [NSString stringWithFormat:@"ONEKEYTOKEN%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",onekeyToken,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];

    NSMutableDictionary *headParams = @{@"X-Emp-Token":NonEmpty(token),
                                   @"X-Emp-Signature":NonEmpty(signStr),
                                   @"X-Emp-Timestamp":NonEmpty(m_time)}.mutableCopy;
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_oneKeyLogin andParams:params];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:headParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
@end
