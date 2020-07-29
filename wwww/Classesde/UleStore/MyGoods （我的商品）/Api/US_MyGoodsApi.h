//
//  US_MyGoodsApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MyGoodsApi : NSObject

+ (UleRequest *)buildGoodsFavPreListRequest;
//添加分销商品到收藏列表
+ (UleRequest *)buildAddFenXiaoFavorProductWithListId:(NSString *)listId andGoodZoneId:(NSString *)zoneId;
//获取分销收藏列表
+ (UleRequest *)buildGoodsFenXiaoListWithStart:(NSString *)start andPageNum:(NSString *)pageSize;

//我要扶贫商品列表
+ (UleRequest *)buildGoodsRecommandRequest;
//获取商品预览链接
+ (UleRequest *)buildGoodsPreviewWithId:(NSString *)listId andType:(NSString *)type;
//获取商品分类信息
+ (UleRequest *)buildItemClassifyRequest:(BOOL)isCache;
//添加喜欢的商品
+ (UleRequest *)buildAddFavorProductWithListId:(NSString *)listId;
//获取我的商品的所有商品列表
+ (UleRequest *)buildAllStoreItemsKeyword:(NSString *)keyword flag:(NSString *)flag listingType:(NSString *)listingType start:(NSString *)start andPageNum:(NSString *)pageSize;
//获取用户单个分类商品列表
+ (UleRequest *)buildCatergoryListWithId:(NSString *)catergoryId start:(NSString *)start andPageNum:(NSString *)pageSize;
//获取邮乐网商品收藏夹列表
+ (UleRequest *)buildGetUleFavoriteListAtStart:(NSString *)start andPageNum:(NSString *)pageSize;
//批量删除失效商品
+ (UleRequest *)buildBatchDeleteWithListIds:(NSString *)listIds;
//删除分销商品收藏列表商品
+ (UleRequest *)buildFenxiaoFavListDeleteWithListId:(NSString *)listId andZoneId:(NSString *)zoneId;
//批量移除分类商品
+ (UleRequest *)buildBatchRemoveWithListIds:(NSString *)listIds andCategoryId:(nonnull NSString *)categoryId;
//批量置顶商品最多10条
+ (UleRequest *)buildBatchStickListIds:(NSString *)listIds;
//批量排序分类
+ (UleRequest *)buildBatchSortCatergoryByInfo:(NSString *)sortInfo;
//删除分类
+ (UleRequest *)buildDeleteCategoryForId:(NSString *)categoryId;
//添加新分类
+ (UleRequest *)buildAddNewCategoryWithName:(NSString *)categoryName;
//获取未分类商品列表
+ (UleRequest *)buildNoCategoryListAtStart:(NSString *)start andPageSize:(NSString *)pageSize;
//添加新商品
+ (UleRequest *)buildAddGoodsForListingIds:(NSString *)listIds andCategoryId:(NSString *)categroyId;

//获取店铺详情列表
+ (UleRequest *)buildStoreDetailListInfoSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder storeId:(NSString *)stroeId keyword:(NSString *)keyword andPageIndex:(NSString *)pageIndex;
//同步邮乐收藏的商品
+ (UleRequest *)buildSyncFavoriteLists:(NSString *)listIds;

+ (UleRequest *)buildTakeSelfListWithPageSize:(NSString *)pageSize andPageIndex:(NSString *)pageIndex;
@end

NS_ASSUME_NONNULL_END
