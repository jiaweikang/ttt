//
//  US_ShareApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_ShareApi.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <Ule_SecurityKit.h>
#import "DeviceInfoHelper.h"
#import "NSString+Addition.h"
@implementation US_ShareApi

+ (UleRequest *)buildGetShareJsonInfoRequest:(NSString *)listId{
    NSMutableDictionary *params = @{@"listingId":NonEmpty(listId)}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_getJsonItem andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildActShareListingUrlRequest:(NSString *)jsonString{
    NSMutableDictionary *params = @{@"data":NonEmpty(jsonString)}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_shareActListingURL andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetShareListingUrlRequest:(NSString *)shareChannel from:(NSString *)shareFrom andListId:(NSString *)listId{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic setObject:NonEmpty(shareChannel) forKey:@"shareChannel"];
    [dic setObject:NonEmpty(shareFrom) forKey:@"shareFrom"];
    [dic setObject:@[@{@"listId":NonEmpty(listId)}] forKey:@"listInfo"];
    NSString *jsonString = [NSString jsonStringWithDictionary:dic];
    NSMutableDictionary *params = @{@"data":NonEmpty(jsonString)}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_shareListingURL andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetFenXiaoShareListingUrlRequest:(NSString *)listId andZoneId:(NSString *)zoneId andShareChannel:(NSString *)shareChannel andShareFrom:(NSString *)shareFrom{
    NSDictionary *params=@{@"subType":@"3",
                           @"shareType":@"60",
                           @"listId":NonEmpty(listId),
                           @"zoneId":NonEmpty(zoneId),
                           @"shareChannel":shareChannel,
                           @"shareFrom":NonEmpty(shareFrom)};
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_fx_shareListingURL andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildInsuranceShareLinkRequest:(NSString *)shareChannel from:(NSString *)shareFrom andListId:(NSArray *)listInfo{
    NSMutableDictionary* dic=[[NSMutableDictionary alloc] init];
    [dic setObject:NonEmpty(shareChannel) forKey:@"shareChannel"];
    [dic setObject:NonEmpty(shareFrom) forKey:@"shareFrom"];
    [dic setObject:listInfo forKey:@"listInfo"];
    NSString *jsonString = [NSString jsonStringWithDictionary:dic];
    NSMutableDictionary *params = @{@"data":NonEmpty(jsonString)}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_insuranceShareURL andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildShareTemplateListRequest{
//    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:@"poststore_share_image" forKey:@"sectionKeys"];
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_ShareImage)];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildShareRecordWithKeyword:(NSString *)keyword andStart:(NSString *)start{
    NSMutableDictionary *params = @{@"startIndex":NonEmpty(start),
                                    @"pageSize":@"10"}.mutableCopy;
    if (keyword&&keyword.length>0) {
        [params setObject:NonEmpty(keyword) forKey:@"keyword"];
    }
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_FindMyShare andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
@end
