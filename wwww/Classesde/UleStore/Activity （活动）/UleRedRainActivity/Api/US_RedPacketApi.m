//
//  US_RedRainApi.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_RedPacketApi.h"
#import "UleRedPacketConfig.h"
#import <UleSecurityKit/Ule_SecurityKit.h>

@implementation US_RedPacketApi


+ (UleRequest *)buildLotteryRequestWithActivityCode:(NSString *)activityCode andFieldId:(NSString *)fieldId{
    activityCode = [NSString isNullToString:activityCode];
    fieldId = [NSString isNullToString:fieldId];
    
    NSMutableDictionary * params=[[NSMutableDictionary alloc] init];
    NSString *usrId_key = @"userOnlyId";
    NSString *encryptUsrId = [[US_NetworkExcuteManager getEncryptedParamsWithDic:@{usrId_key:[US_UserUtility sharedLogin].m_userId} andKey:SECRET_KEY andIV:SECRET_IV] objectForKey:usrId_key];
    [params setObject:encryptUsrId forKey:usrId_key];
    [params setObject:activityCode forKey:@"activityCode"];
    [params setObject:UleRedPacketRainChannel forKey:@"channel"];
    [params setObject:[US_UserUtility sharedLogin].openUDID forKey:@"deviceId"];
    [params setObject:activityCode forKey:@"activityCode"];
    [params setObject:fieldId forKey:@"fieldId"];
    
    NSString * signStr=[NSString stringWithFormat:@"%@%@%@%@%@",activityCode,fieldId,UleRedPacketRainChannel,[US_UserUtility sharedLogin].m_userId,[US_UserUtility sharedLogin].openUDID];
    NSMutableDictionary * headDic=[[NSMutableDictionary alloc] init];
    if (signStr.length>0) {
        NSString *sha1 = [Ule_SecurityKit encodeHash:SECRET_IV text:signStr];
        [headDic setObject:sha1 forKey:@"sign"];
    }
    UleRequest *request = [[UleRequest alloc]initWithApiName:klotterydrawApi andParams:params];
    request.headParams = headDic;
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

//新红包雨 获取主题
+ (UleRequest *)buildNewRedPacketTheme{
    UleRequest *request = [[UleRequest alloc]initWithApiName:[NSString stringWithFormat:@"%@/%@",API_NewRedPacketRain_GetTheme,UleRedPacketRainChannel] andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}
//新红包雨 获取场次
+ (UleRequest *)buildNewRedPacketInfoRainWithTheme:(NSString *)rainTheme{
    UleRequest *request = [[UleRequest alloc]initWithApiName:[NSString stringWithFormat:@"%@/%@/%@", API_NewRedPacketRain_GetActivityInfo,UleRedPacketRainChannel,rainTheme] andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

@end
