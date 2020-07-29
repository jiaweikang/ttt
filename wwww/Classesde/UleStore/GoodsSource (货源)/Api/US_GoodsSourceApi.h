//
//  US_GoodsSourceApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceApi : NSObject

+ (UleRequest *)buildGoodsSourceTabList;

+ (UleRequest *)buildGoodsSourceHomeRecommendIndex3Request;

+ (UleRequest *)buildCdnFeaturedGetRequestWithKey:(NSString *)key;

+ (UleRequest *)buildGoodsSourceScrollBarRequest;

+ (UleRequest *)buildSelfRecommendGoodsRequest;

+ (UleRequest *)buildHomeBottomRecommendRequest;

+ (UleRequest *)buildHomeNewMsgNumRequestWithUserId:(NSString *)userId UserType:(NSString *)userType Channel:(NSString *)channel;

/**
 根据分类id搜索货源列表
 @param categoryId 分类id
 */
+ (UleRequest *)buildGoodsSourCecategoryWithId:(NSString *)categoryId pageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;

+ (UleRequest *)buildSearchGoodsSourceSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder storeId:(NSString *)stroeId keyword:(NSString *)keyword needCityFlag:(BOOL)isCityFlag andPageIndex:(NSString *)pageIndex;

+ (UleRequest *)buildGetSimilarWord:(NSString *)keyword;

+ (UleRequest *)buildGetHotSearchWord;
@end

NS_ASSUME_NONNULL_END
