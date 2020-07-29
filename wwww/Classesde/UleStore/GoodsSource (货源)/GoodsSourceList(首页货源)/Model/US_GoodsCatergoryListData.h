//
//  US_GoodsCatergoryListData.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsCatergoryListItem : NSObject
//共用
@property (nonatomic, copy) NSString    *listingName;
@property (nonatomic, copy) NSString    *imgUrl;
@property (nonatomic, copy) NSString    *minPrice;
@property (nonatomic, copy) NSString    *maxPrice;
@property (nonatomic, copy) NSString    *listingId;
//推荐位
//@property (nonatomic, copy) NSString    *listingUrl;
//@property (nonatomic, strong) NSNumber    *inStock;
//@property (nonatomic, strong) NSNumber    *storage;
//@property (nonatomic, copy) NSString    *sellTotal;
//@property (nonatomic, copy) NSString    *lastDaySold;
//@property (nonatomic, copy) NSString    *storeId;
//@property (nonatomic, copy) NSString    *itemId;
//@property (nonatomic, copy) NSString    *dgTotalCommission;
//@property (nonatomic, copy) NSString    *promotionDesc;
//@property (nonatomic, copy) NSString    *customAttribute;

//换接口新增
@property (nonatomic, copy) NSString    *salePrice;
@property (nonatomic, strong) NSNumber  *commission;
@property (nonatomic, strong) NSNumber  *commistion;
@property (nonatomic, copy) NSString    *provinceId;
@property (nonatomic, copy) NSString    *provinceName;
@property (nonatomic, copy) NSString    *cityId;
@property (nonatomic, copy) NSString    *cityName;
@property (nonatomic, copy) NSString    *areaId;
@property (nonatomic, copy) NSString    *areaName;
@property (nonatomic, copy) NSString    *townId;
@property (nonatomic, copy) NSString    *townName;
@property (nonatomic, strong) NSNumber  *categoryId;
@property (nonatomic, strong) NSNumber  *totalSold;


@property (nonatomic, copy) NSString    *listId;//非接口返回 为了请求分享链接时匹配(因为分享接口取json串里的listId)
@property (nonatomic, assign)BOOL       isImgLoaded;//判断列表的图片是否加载出来，如果加载失败在微信分享时用占位图代替

@property (nonatomic, copy) NSString *groupFlag; //拼团标识 1是 0否 20180927



@end

@interface US_GoodsCatergorys : NSObject
@property (nonatomic, strong) NSMutableArray *result;
@end

@interface US_GoodsCatergoryListData : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *totalPages;
@property (nonatomic, strong) NSNumber *totalRecords;
@property (nonatomic, strong) US_GoodsCatergorys    *data;
@end

NS_ASSUME_NONNULL_END
