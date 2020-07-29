//
//  US_MyGoodsRecommend.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface US_MyGoodsRecommendDetail : NSObject
@property (nonatomic, copy) NSString        *listingName;
@property (nonatomic, copy) NSString        *listingUrl;
@property (nonatomic, copy) NSString        *imgUrl;
@property (nonatomic, copy) NSString        *minPrice;
@property (nonatomic, copy) NSString        *maxPrice;
@property (nonatomic, strong) NSNumber      *inStock;
@property (nonatomic, strong) NSNumber      *storage;
@property (nonatomic, copy) NSString        *sellTotal;
@property (nonatomic, copy) NSString        *lastDaySold;
@property (nonatomic, copy) NSString        *storeId;
@property (nonatomic, copy) NSString        *listingId;
@property (nonatomic, copy) NSString        *itemId;
@property (nonatomic, copy) NSString        *dgTotalCommission;
@property (nonatomic, copy) NSString        *promotionDesc;
@property (nonatomic, copy) NSString        *customAttribute;
@property (nonatomic, copy) NSString        *groupFlag;
@end

@interface US_MyGoodsRecommendData : NSObject
@property (nonatomic, strong) NSMutableArray    *event_ulestorepoor_dt;

@end

@interface US_MyGoodsRecommend : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) US_MyGoodsRecommendData    *data;
@end

NS_ASSUME_NONNULL_END
