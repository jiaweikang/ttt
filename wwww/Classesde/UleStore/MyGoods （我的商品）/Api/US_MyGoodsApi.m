//
//  US_MyGoodsApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsApi.h"
#import "CalcKeyIvHelper.h"
#import <Ule_SecurityKit.h>

@implementation US_MyGoodsApi

+ (UleRequest *)buildGoodsFavPreListRequest{
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_wholesaleList)];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildAddFenXiaoFavorProductWithListId:(NSString *)listId andGoodZoneId:(NSString *)zoneId{
    NSMutableDictionary * params=@{@"listingId":[NSString stringWithFormat:@"%@",NonEmpty(listId)],
                                   @"subType":@"3",
                                   @"zoneId":[NSString isNullToString:zoneId]}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_fx_saveFxListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGoodsFenXiaoListWithStart:(NSString *)start andPageNum:(NSString *)pageSize{
    NSDictionary *param=@{@"pageSize":NonEmpty(pageSize),
                          @"startIndex":NonEmpty(start),
                          @"subType":@"3",
                          @"zoneId":[US_UserUtility getPixiaoZoneIdWithComma]};
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_fx_queryFxListing andParams:param];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}


+ (UleRequest *)buildGoodsRecommandRequest{
    
    NSString *provinceCode = [US_UserUtility sharedLogin].m_provinceCode;
    if ([US_UserUtility sharedLogin].m_userReferrerId.length > 0) {
        if ([[US_UserUtility sharedLogin].m_provinceCode isEqualToString:@"58093"]) {
            //当前用户为邮乐
            provinceCode = [US_UserUtility sharedLogin].m_userReferrerId;
        }
    }
    NSMutableDictionary *params = @{
                                    @"moduleKeys":@"event_ulestorepoor_dt",
                                    @"orgProvince":NonEmpty(provinceCode),
                                    @"orgCity":[US_UserUtility sharedLogin].m_cityCode,
                                    @"orgArea":[US_UserUtility sharedLogin].m_areaCode}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getIndexRecommendItem andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
+ (UleRequest *)buildGoodsPreviewWithId:(NSString *)listId andType:(nonnull NSString *)type{

    NSMutableDictionary *params = @{@"listingId":[NSString stringWithFormat:@"%@",listId],
                                    @"previewType":[NSString stringWithFormat:@"%@",type]}.mutableCopy;

    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getPreviewUrl andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
+ (UleRequest *)buildItemClassifyRequest:(BOOL)isCache{

    NSString * url=isCache?API_getItemClassify:API_getItemClassifyDetail;
    UleRequest * request=[[UleRequest alloc] initWithApiName:url andParams:nil];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildAddFavorProductWithListId:(NSString *)listId{
    NSMutableDictionary * params=@{@"listingId":[NSString stringWithFormat:@"%@",NonEmpty(listId)]}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_saveFavsListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取我的商品的所有商品列表
+ (UleRequest *)buildAllStoreItemsKeyword:(NSString *)keyword flag:(NSString *)flag listingType:(NSString *)listingType start:(NSString *)start andPageNum:(NSString *)pageSize{
    
    NSMutableDictionary *params = @{@"imageType": @"l",
                                    @"pageSize":NonEmpty(pageSize),
                                    @"startIndex":NonEmpty(start)
                                    }.mutableCopy;
    if (flag.length>0) {
        [params setObject:flag forKey:@"flag"];
    }
    if (keyword.length>0) {
        [params setObject:keyword forKey:@"keyword"];
    }
    if (listingType.length>0) {
        [params setObject:listingType forKey:@"yxdListingType"];
    }
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_findStoreItems andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//获取用户单个分类商品列表
+ (UleRequest *)buildCatergoryListWithId:(NSString *)catergoryId start:(NSString *)start andPageNum:(NSString *)pageSize{

    NSMutableDictionary *params = @{
                                    @"categoryId":NonEmpty(catergoryId),
                                    @"pageIndex":NonEmpty(start),
                                    @"pageSize":NonEmpty(pageSize)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getCategoryList andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取邮乐网商品收藏夹列表
+ (UleRequest *)buildGetUleFavoriteListAtStart:(NSString *)start andPageNum:(NSString *)pageSize{

    NSMutableDictionary *params = @{@"pageSize":NonEmpty(pageSize),
                                    @"pageIndex":NonEmpty(start)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getFavoriteListings andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//批量删除失效商品
+ (UleRequest *)buildBatchDeleteWithListIds:(NSString *)listIds{
    
    NSMutableDictionary *params = @{@"listIds":NonEmpty(listIds)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_deleteFavsListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildFenxiaoFavListDeleteWithListId:(NSString *)listId andZoneId:(NSString *)zoneId{
    NSMutableDictionary *params = @{@"subType":@"3",
                                    @"listIds":NonEmpty(listId),
                                    @"zoneId":NonEmpty(zoneId)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_fx_deleteFxListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//批量移除分类商品
+ (UleRequest *)buildBatchRemoveWithListIds:(NSString *)listIds andCategoryId:(nonnull NSString *)categoryId{
    NSMutableDictionary *params = @{@"listingIds":NonEmpty(listIds),
                                    @"categoryId":NonEmpty(categoryId)
    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_removeFavsListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//批量置顶商品最多10条
+ (UleRequest *)buildBatchStickListIds:(NSString *)listIds{
    NSMutableDictionary *params = @{
                                    @"listingId":NonEmpty(listIds)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_batchListingStick andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//批量排序分类
+ (UleRequest *)buildBatchSortCatergoryByInfo:(NSString *)sortInfo{
    
    NSMutableDictionary *params = @{@"yxdCategoryDtos":NonEmpty(sortInfo),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_sortCategory andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//删除分类
+ (UleRequest *)buildDeleteCategoryForId:(NSString *)categoryId{
    NSMutableDictionary *params = @{@"categoryId":NonEmpty(categoryId),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_deleteCategory andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//添加新分类
+ (UleRequest *)buildAddNewCategoryWithName:(NSString *)categoryName{
    NSMutableDictionary *params = @{
                                    @"categoryName":NonEmpty(categoryName),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_createNewCategory andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取未分类商品列表
+ (UleRequest *)buildNoCategoryListAtStart:(NSString *)start andPageSize:(NSString *)pageSize{
    NSMutableDictionary *params = @{
                                    @"imageType": @"l",
                                    @"pageSize":NonEmpty(pageSize),
                                    @"pageIndex":NonEmpty(start)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getNoCategoryList andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//添加新商品
+ (UleRequest *)buildAddGoodsForListingIds:(NSString *)listIds andCategoryId:(NSString *)categroyId{
    NSMutableDictionary *params = @{@"listingIds":NonEmpty(listIds),
                                    @"categoryId":NonEmpty(categroyId),}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_saveCategroyLists andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildStoreDetailListInfoSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder storeId:(NSString *)stroeId keyword:(NSString *)keyword andPageIndex:(NSString *)pageIndex{
    NSMutableDictionary *params = @{@"sortType":NonEmpty(sortType),
                                    @"sortOrder":NonEmpty(sortOrder),
                                    @"uleStoreIds":NonEmpty(stroeId),
                                    @"keyword":NonEmpty(keyword),
                                    @"pageIndex":NonEmpty(pageIndex),
                                    @"pageSize":@"10",
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getStoreDetailList andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderStoreListSignParms:@"10" pageIndex:NonEmpty(pageIndex) andStoreId:NonEmpty(stroeId)];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//同步邮乐收藏的商品
+ (UleRequest *)buildSyncFavoriteLists:(NSString *)listIds{
    NSMutableDictionary *params = @{@"listingIds":NonEmpty(listIds),}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_synFavoriteListings andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildTakeSelfListWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex{
//    NSMutableDictionary *params = @{
//                                    @"pageIndex":NonEmpty(pageIndex),
//                                    @"pageSize":NonEmpty(pageSize),
//                                    @"orgType":NonEmpty([US_UserUtility sharedLogin].m_orgType),
//                                    @"province":NonEmpty([US_UserUtility sharedLogin].m_provinceCode),
//                                    @"city":NonEmpty([US_UserUtility sharedLogin].m_cityCode),
//                                    @"county":NonEmpty([US_UserUtility sharedLogin].m_areaCode),
//                                    }.mutableCopy;
    //https://ustatic.ulecdn.com/yxdcdn/v2/recommend/ylxdSelfServiceListing/{accessType}/{orgType}/{pageIndex}/{pageSize}/{province}/{city}/{county}/{town}
    NSString * urlString=[NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@",API_TakesSelfServiceList,
                          [US_UserUtility sharedLogin].m_orgType.length>0?[US_UserUtility sharedLogin].m_orgType:KCDNDefaultValue,
                          pageIndex.length>0?pageIndex:KCDNDefaultValue,
                          pageSize.length>0?pageSize:KCDNDefaultValue,[US_UserUtility sharedLogin].m_provinceCode.length>0?[US_UserUtility sharedLogin].m_provinceCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_cityCode.length>0?[US_UserUtility sharedLogin].m_cityCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_areaCode.length>0?[US_UserUtility sharedLogin].m_areaCode:KCDNDefaultValue,
                          [US_UserUtility sharedLogin].m_townCode.length>0?[US_UserUtility sharedLogin].m_townCode:KCDNDefaultValue];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}
@end
