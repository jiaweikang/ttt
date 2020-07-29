//
//  US_GoodsSourceApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceApi.h"
#import "US_Api.h"
#import "USLocationManager.h"


@implementation US_GoodsSourceApi

+ (UleRequest *)buildGoodsSourceTabList{
//    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:kSectionKey_GoodsSourceTab forKey:@"sectionKeys"];
    NSString * sectionKey = NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_GoodsSourceTab);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildGoodsSourceHomeRecommendIndex3Request{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params = @{
//               @"pageIndex":@"1",
//               @"pageSize":@"15",
//               @"orgType":[US_UserUtility sharedLogin].m_orgType,
//               @"province":[US_UserUtility sharedLogin].m_provinceCode,
//               @"city":[US_UserUtility sharedLogin].m_cityCode,
//               @"county": [US_UserUtility sharedLogin].m_areaCode,
//               @"versionFlag":@"1",//用于区分新老版本高佣和拼团顺序
//               @"webp":@"1"
//               }.mutableCopy;
    //https://ustatic.ulecdn.com/yxdcdn/v2/recommend/ylxdRecommends3/{accessType}/{orgType}/{pageIndex}/{pageSize}/{province}/{city}/{county}/{town}/{versionFlag}
    NSString * urlString=[NSString stringWithFormat:@"%@/%@/1/15/%@/%@/%@/%@/%@/1",
                          API_ylxdIndexRecommend4,
                          [US_UserUtility sharedLogin].m_orgType.length>0?[US_UserUtility sharedLogin].m_orgType:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_provinceCode.length>0?[US_UserUtility sharedLogin].m_provinceCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_cityCode.length>0?[US_UserUtility sharedLogin].m_cityCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_areaCode.length>0?[US_UserUtility sharedLogin].m_areaCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_townCode.length>0?[US_UserUtility sharedLogin].m_townCode:KCDNDefaultValue,
                          [UleStoreGlobal shareInstance].config.userProvinceIdOrProvinceName.length>0?[UleStoreGlobal shareInstance].config.userProvinceIdOrProvinceName:KCDNDefaultValue];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildCdnFeaturedGetRequestWithKey:(NSString *)key{
//    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:NonEmpty(key) forKey:@"sectionKeys"];
//    [parameDic setObject:@"webp" forKey:@"1"];
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,key.length>0?key:KCDNDefaultValue];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildGoodsSourceScrollBarRequest{
//    NSMutableDictionary *params=@{@"provinceNameOrId":[US_UserUtility getUserOrLocationProvinceName]}.mutableCopy;
    //https://ustatic.ulecdn.com/yxdcdn/v2/item/homePageScrolling/{accesstype}/{provinceNameOrId}
    NSString * urlString= [NSString stringWithFormat:@"%@/%@",API_homePageScrolling,[UleStoreGlobal shareInstance].config.userProvinceIdOrProvinceName.length>0?[UleStoreGlobal shareInstance].config.userProvinceIdOrProvinceName:KCDNDefaultValue];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UleRequest *request=[[UleRequest alloc]initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildSelfRecommendGoodsRequest{
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_findIndexListing andParams:nil];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildHomeBottomRecommendRequest{
    NSString * urlString= [NSString stringWithFormat:@"%@/%@",API_homeBottomRecommend,NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_homeBottomRecommend)];
    UleRequest *request=[[UleRequest alloc]initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildGoodsSourCecategoryWithId:(NSString *)categoryId pageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex{
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params = @{@"categoryId":NonEmpty(categoryId),
//               @"pageSize":NonEmpty(pageSize),
//               @"pageIndex":NonEmpty(pageIndex),
//               @"webp":@"1"}.mutableCopy;
    //https://ustatic.ulecdn.com/yxdcdn/v2/recommend/findRecListingAround/{accessType}/{pageIndex}/{pageSize}/{provinceId}/{categoryId}
    NSString * urlString=[NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                          API_findRecListingAround,
                          pageIndex.length>0?pageIndex:KCDNDefaultValue,
                          pageSize.length>0?pageSize:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_provinceCode.length>0?[US_UserUtility sharedLogin].m_provinceCode:KCDNDefaultValue,
                          categoryId.length>0?categoryId:KCDNDefaultValue];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildSearchGoodsSourceSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder storeId:(NSString *)stroeId keyword:(NSString *)keyword needCityFlag:(BOOL)isCityFlag andPageIndex:(NSString *)pageIndex{
    NSMutableDictionary *params = @{@"sortType":NonEmpty(sortType),
                                    @"sortOrder":NonEmpty(sortOrder),
                                    @"cateId":[[NSString isNullToString:stroeId] isEqualToString:@"0"]?@"":[NSString isNullToString:stroeId],
                                    @"keyword":NonEmpty(keyword),
                                    @"pageIndex":NonEmpty(pageIndex),
                                    @"pageSize":@"10",
                                    @"provinceNameOrId":[UleStoreGlobal shareInstance].config.userProvinceIdOrProvinceName
                                    }.mutableCopy;
    
    if (isCityFlag) {
        [params setObject:@"1" forKey:@"cityFlag"];
    }
    if ([USLocationManager sharedLocation].adcode.length>0) {
        [params setObject:[USLocationManager sharedLocation].adcode forKey:@"area"];
    }
    UleRequest * request=[[UleRequest alloc] initWithApiName:[UleStoreGlobal shareInstance].config.api_searchGoodSource andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderSearchGoodsSourceSignParms:keyword pageIndex:pageIndex andPageSize:@"10"];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetSimilarWord:(NSString *)keyword{
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    NonEmpty(keyword), @"keyWords", nil];
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_SearchSuggestion andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

+ (UleRequest *)buildGetHotSearchWord{
    NSString * recommendUrl= [NSString stringWithFormat:@"%@%@",[UleStoreGlobal shareInstance].config.cdnServerDomain,@"/mobilead/v2/recommend/dwRecommond/app"];
    NSString * urlStr=[NSString stringWithFormat:@"%@/2002/null/null/wap_searchkeyword,wap_search_default_value.html",recommendUrl];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlStr andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildHomeNewMsgNumRequestWithUserId:(NSString *)userId UserType:(NSString *)userType Channel:(NSString *)channel{

    NSMutableDictionary *params = @{@"userId":NonEmpty(userId),
                                    @"userType":NonEmpty(userType),
                                    @"channel":NonEmpty(channel)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_totalNewMsgNum andParams:params requsetMethod:RequestMethod_Post];
    request.baseUrl=[UleStoreGlobal shareInstance].config.livechatDomain;
    return request;
}

@end
