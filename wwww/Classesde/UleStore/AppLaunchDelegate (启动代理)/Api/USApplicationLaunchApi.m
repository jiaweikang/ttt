//
//  USApplicationLaunchApi.m
//  UleStoreApp
//
//  Created by xulei on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USApplicationLaunchApi.h"
#import "US_Api.h"
#import "CalcKeyIvHelper.h"
#import <Ule_SecurityKit.h>
#import "US_NetworkExcuteManager.h"
#import "DeviceInfoHelper.h"
#import "USLocationManager.h"
#import "DeviceInfoHelper.h"

@implementation USApplicationLaunchApi

+ (UleRequest *)buildRequestUserInfo{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //保存
    [CalcKeyIvHelper shared].x_Emp_Key = o_key;
    [CalcKeyIvHelper shared].x_Emp_Iv = o_Iv;
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *params = @{@"X-Emp-Token":token,
                                    @"X-Emp-Signature":signStr,
                                    @"X-Emp-Timestamp":m_time
                                    }.mutableCopy;
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_getUserInfo andParams:nil];
    request.headParams=[NSMutableDictionary dictionaryWithDictionary:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildRequestAdvertise
{
//    NSDictionary *params = @{@"sectionKeys":kSectionKey_GuidePage};
    NSString * sectionKey= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_GuidePage);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildRequestTabbar
{
//    NSDictionary *params = @{@"sectionKeys":kSectionKey_Tabbar};
    NSString * sectionKey = NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_Tabbar);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
     request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildRequestHomeActivityDialog{
//    NSDictionary *params = @{@"sectionKeys":kSectionKey_ActivityDialog,
//                             @"webp":@"1"};
    NSString * sectionKey =NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_Dialog);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildGetReferrerInfoRequest{
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_searchReferrer andParams:nil];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildUploadLanchInfoRequest{
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:NonEmpty([UleStoreGlobal shareInstance].config.clientType) forKey:@"clientType"];
    [params setObject:@"ios" forKey:@"osType"];
    [params setObject:[US_UserUtility sharedLogin].open_userId forKey:@"userID"];
    [params setObject:NonEmpty([UleStoreGlobal shareInstance].config.versionNum) forKey:@"appVersion"];
    [params setObject:NonEmpty([UleStoreGlobal shareInstance].config.appChannelID) forKey:@"marketId"];
    [params setObject:[US_NetworkExcuteManager netWorkType] forKey:@"network"];
    [params setObject:[US_UserUtility sharedLogin].openUDID forKey:@"deviceId"];
    [params setObject:@"Apple" forKey:@"mobileBrand"];
    [params setObject:[DeviceInfoHelper platformString] forKey:@"mobileModel"];
    [params setObject:[UIDevice currentDevice].systemVersion forKey:@"osVersion"];
    [params setObject:[US_UserUtility sharedLogin].m_provinceCode forKey:@"province"];
    [params setObject:[US_UserUtility sharedLogin].m_cityCode forKey:@"city"];
    [params setObject:[US_UserUtility sharedLogin].m_areaCode forKey:@"area"];
    [params setObject:[US_UserUtility sharedLogin].m_townCode forKey:@"town"];
    [params setObject:NonEmpty([UleStoreGlobal shareInstance].config.appKey) forKey:@"appkey"];
    [params setObject:[DeviceInfoHelper getScreenPix] forKey:@"resolution"];
    [params setObject:NonEmpty([US_UserUtility sharedLogin].m_orgCode) forKey:@"org"];
    [params setObject:NonEmpty([US_UserUtility sharedLogin].oldVersion) forKey:@"oldVersion"];
    NSString * latLon=[NSString stringWithFormat:@"%@,%@",NonEmpty([USLocationManager sharedLocation].lastLatitude),NonEmpty([USLocationManager sharedLocation].lastLongitude)];
    [params setObject:latLon forKey:@"latLon"];
    UleRequest * request=[[UleRequest alloc] initWithApiName:[NSString stringWithFormat:API_apiLogLaunch, [UleStoreGlobal shareInstance].config.appName] andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.trackDomain;
    return request;
}

+ (UleRequest *)buildPushRegist{
    BOOL isFirstLogin=[US_UserUtility sharedLogin].m_userId.length>0&&[US_UserUtility sharedLogin].isUserFirstLogin;
    NSMutableDictionary *parameDic=[[NSMutableDictionary alloc] initWithCapacity:1];
    [parameDic setObject:[US_UserUtility sharedLogin].m_deviceToken  forKey:@"deviceToken"];
    [parameDic setObject:[NSNumber numberWithBool:YES] forKey:@"pushFlag"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_userId forKey:@"userId"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_orgCode forKey:@"userCode"];
    [parameDic setObject:[US_UserUtility sharedLogin].openUDID forKey:@"uuid"];
    [parameDic setObject:NonEmpty([UleStoreGlobal shareInstance].config.appName)   forKey:@"deviceType"];
    [parameDic setObject:NonEmpty([UleStoreGlobal shareInstance].config.versionNum)   forKey:@"version"];
    [parameDic setObject:@"ios" forKey:@"os"];
    [parameDic setObject:@"1" forKey:@"pushSdk"];
    [parameDic setObject:[DeviceInfoHelper platformString] forKey:@"mobileModel"];
    [parameDic setObject:@"Apple" forKey:@"mobileBrand"];
    [parameDic setObject:[UIDevice currentDevice].systemVersion forKey:@"osVersion"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_provinceCode forKey:@"province"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_cityCode forKey:@"city"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_areaCode forKey:@"area"];
    [parameDic setObject:[US_UserUtility sharedLogin].m_townCode forKey:@"town"];
    [parameDic setObject:isFirstLogin?@"1":@"0" forKey:@"newUserFlag"];
    UleRequest *request = [[UleRequest alloc]initWithApiName:kAPIPushSwitch andParams:parameDic];
    request.baseUrl=[UleStoreGlobal shareInstance].config.trackDomain;
    return request;
}

+ (UleRequest *)buildPushMsgClickRequestWithBatchId:(NSString *)batchId{
    NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    NonEmpty(batchId), @"batchId",
                                    [US_UserUtility sharedLogin].m_userId, @"userID", nil];
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_PushmsgClick andParams:mParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.trackDomain;
    return request;
}

+ (UleRequest *)buildServerTimeRequest{
    UleRequest *request = [[UleRequest alloc] initWithApiName:API_getSysTime andParams:nil];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
@end
