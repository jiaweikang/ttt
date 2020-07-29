
//
//  US_MystoreApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_MystoreApi.h"
#import "CalcKeyIvHelper.h"
#import <Ule_SecurityKit.h>
#import <UleDateFormatter.h>

@implementation US_MystoreApi

+ (UleRequest *) buildGetCommisionRequest{
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getCanCarryAmount andParams:nil];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//+ (UleRequest *)buildGetShareInfoRequest{
//    NSMutableDictionary * params= @{@"date":[UleDateFormatter GetCurrentDate5:[NSDate date]],}.mutableCopy;
//    UleRequest * request=[[UleRequest alloc] initWithApiName:API_shareInfo andParams:params];
//    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
//    request.baseUrl=KAPIServiceUrl;
//    return request;
//}

+ (UleRequest *)buildGetShareInfoVisitCountRequest{
    NSMutableDictionary * params= @{@"date":[UleDateFormatter GetCurrentDate5:[NSDate date]],}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_shareInfoVisitCount andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetShareInfoOrderCountRequest{
    NSMutableDictionary * params= @{@"date":[UleDateFormatter GetCurrentDate5:[NSDate date]],}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_shareInfoOrderCount andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetNewPushMessageNumRequest{
    //获取时间戳
    NSString *lastm_time = [[NSUserDefaults standardUserDefaults]objectForKey:@"messageUpdateTime"];
    
    NSMutableDictionary *params=@{@"clientType":NonEmpty([UleStoreGlobal shareInstance].config.clientType),
                                  @"userId":NonEmpty([US_UserUtility sharedLogin].m_userId),
                                  @"mark":@"1",
                                  @"lastUpdateTime":NonEmpty(lastm_time)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_newPushMessageNumber andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetButtonListRequest{
//     NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:kSectionKey_StoreButtonList,@"sectionKeys" , nil];
    NSString * sectionKey=NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_StoreButtonList);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

@end
