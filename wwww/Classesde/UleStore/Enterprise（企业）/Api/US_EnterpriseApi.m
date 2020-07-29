//
//  US_EnterpriseApi.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseApi.h"
#import "US_Api.h"
#import "CalcKeyIvHelper.h"
#import <NSString+Utility.h>
#import "NSString+Addition.h"

@implementation US_EnterpriseApi

+ (UleRequest *)buildEnterpriseBanner
{
//    NSMutableDictionary *params = @{
//               @"pageIndex": @"1",
//               @"pageSize": @"15",
//               @"orgType": [US_UserUtility sharedLogin].m_orgType,
//               @"province": [US_UserUtility sharedLogin].m_provinceCode,
//               @"city": [US_UserUtility sharedLogin].m_cityCode,
//               @"county": [US_UserUtility sharedLogin].m_areaCode,
//               @"recommends": @"yxdstore_ee_index_1st",
//               @"webp":@"1"
//               }.mutableCopy;
    //https://ustatic.ulecdn.com/yxdcdn/v2/recommend/ylxdRecommends/{accessType}/{orgType}/{pageIndex}/{pageSize}/{province}/{city}/{county}/{recommends}
    NSString * urlString=[NSString stringWithFormat:@"%@/%@/1/15/%@/%@/%@/yxdstore_ee_index_1st",
                          API_ylxdEnterpriseRecommend,
                          [US_UserUtility sharedLogin].m_orgType.length>0?[US_UserUtility sharedLogin].m_orgType:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_provinceCode.length>0?[US_UserUtility sharedLogin].m_provinceCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_cityCode.length>0?[US_UserUtility sharedLogin].m_cityCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_areaCode.length>0?[US_UserUtility sharedLogin].m_areaCode:KCDNDefaultValue];
    UleRequest *request = [[UleRequest alloc]initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildEnterpriseRecommendWithPageIndex:(NSInteger)pageIndex
{
    NSString *provinceCode = [US_UserUtility sharedLogin].m_provinceCode;
    if ([NSString isNullToString:[US_UserUtility sharedLogin].m_userReferrerId].length > 0) {
        if ([[US_UserUtility sharedLogin].m_provinceCode isEqualToString:@"58093"]) {
            //当前用户为邮乐
            provinceCode = [US_UserUtility sharedLogin].m_userReferrerId;
        }
    }
    if (!pageIndex) {
        pageIndex=0;
    }
    
//    NSMutableDictionary *params = @{
//                                    @"pageIndex":[NSString stringWithFormat:@"%@", @(pageIndex)],
//                                    @"pageSize":@"20",
//                                    @"orgType":[US_UserUtility sharedLogin].m_orgType,
//                                    @"orgProvince":provinceCode,
//                                    @"orgCity":[US_UserUtility sharedLogin].m_cityCode,
//                                    @"orgArea":[US_UserUtility sharedLogin].m_areaCode,
//                                    @"webp":@"1"
//                                    }.mutableCopy;
    //https://ustatic.beta.ulecdn.com/mobilead/v2/recommend/dgRecommend/{accessType}/{orgCity}/{orgArea}/{orgProvince}/{orgType}/{flashCache}/{pageIndex}/{pageSize}.html
    NSString * urlString=[NSString stringWithFormat:@"%@/%@/%@/%@/%@/null/%@/20.html",API_dgRecommend,
                          [US_UserUtility sharedLogin].m_cityCode.length>0?[US_UserUtility sharedLogin].m_cityCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_areaCode.length>0?[US_UserUtility sharedLogin].m_areaCode:KCDNDefaultValue,
                          provinceCode.length>0?provinceCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_orgType.length>0?[US_UserUtility sharedLogin].m_orgType:KCDNDefaultValue,
                          @(pageIndex)];
    UleRequest *request = [[UleRequest alloc]initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildWholeSaleZoneId{
    NSDictionary *params=@{@"jituanId":[US_UserUtility sharedLogin].m_orgType,
                           @"provinceId":[US_UserUtility sharedLogin].m_provinceCode,
                           @"cityId":[US_UserUtility sharedLogin].m_cityCode,
                           @"xianId":[US_UserUtility sharedLogin].m_areaCode};
    NSString *timeStamp=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]*1000];
    NSString *normalSign=[NSString stringWithFormat:@"%@%@%@", [UleStoreGlobal shareInstance].config.pixiao_appID, [UleStoreGlobal shareInstance].config.pixiao_secret, timeStamp];
    NSString *signStr=[normalSign stringFromMD5];
    UleRequest *request = [[UleRequest alloc]initWithApiName:kAPI_fx_findZoneByXD andParams:params];
    request.headParams=@{@"timestamp":timeStamp,
                         @"appid":NonEmpty([UleStoreGlobal shareInstance].config.pixiao_appID),
                         @"sign":signStr};
    request.baseUrl=[UleStoreGlobal shareInstance].config.wholesaleDomain;
    return request;
}

+ (UleRequest *)buildWholeSaleItemListByPageStart:(NSNumber *)pageStart
{
    bool bool_true=true;
    NSDictionary *param=@{@"pageNum":[NSString stringWithFormat:@"%@", pageStart],
                          @"pageSize":@"10",
                          @"returnType":@"1",
                          @"isShare":@(bool_true),
                          @"zoneIds":[US_UserUtility getPixiaoZoneIdWithComma]};
    NSString *timeStamp=[NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]*1000];
    NSString *normalSign=[NSString stringWithFormat:@"%@%@%@", NonEmpty([UleStoreGlobal shareInstance].config.pixiao_appID), NonEmpty([UleStoreGlobal shareInstance].config.pixiao_secret), timeStamp];
    NSString *signStr=[normalSign stringFromMD5];
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_fx_yzgList andParams:param];
    request.headParams=@{
        @"Authorization":@"Holder token",
        @"appId":NonEmpty([UleStoreGlobal shareInstance].config.pixiao_appID),
        @"timestamp":timeStamp,
        @"sign":signStr};
    request.baseUrl=[UleStoreGlobal shareInstance].config.wholesaleDomain;
    return request;
}


@end
