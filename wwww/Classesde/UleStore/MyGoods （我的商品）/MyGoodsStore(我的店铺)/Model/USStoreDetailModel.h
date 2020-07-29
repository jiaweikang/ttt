//
//  USStoreDetailModel.h
//  u_store
//
//  Created by jiangxintong on 2019/1/24.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface PromotionListItem : NSObject
@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSString *name;
@end


@interface USStoreDetailListingItem : NSObject
@property (nonatomic, copy) NSString *listId;
@property (nonatomic, copy) NSString *listName;
@property (nonatomic, copy) NSString *defImgUrl;
@property (nonatomic, assign) BOOL isImgLoaded; //判断列表的图片是否加载出来，如果加载失败在微信分享时用占位图代替
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSNumber *commission;
@property (nonatomic, copy) NSString *groupFlag;
@property (nonatomic, copy) NSString *sharePrice;
@property (nonatomic, copy) NSString *maxPrice;

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *promotionList;
@property (nonatomic, copy) NSString *limitWay;
//日志
@property (nonatomic, copy) NSString * tel;

@end



@interface USStoreDetailInfo : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *productRate;
@property (nonatomic, copy) NSString *logisticsRate;
@property (nonatomic, copy) NSString *serviceRate;
@property (nonatomic, copy) NSString *totalRate;
@property (nonatomic, copy) NSString *storeLogo;
@property (nonatomic, strong) NSNumber *storeState;
@property (nonatomic, copy) NSString *outTime;
@property (nonatomic, copy) NSString *storeTip;
@property (nonatomic, copy) NSString *storeUrl;
@end



@interface USStoreDetailData : NSObject
@property (nonatomic, strong) NSMutableArray *Listings;
@property (nonatomic, strong) USStoreDetailInfo *storeInfo;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *currentPage;
@end



@interface USStoreDetailModel : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) USStoreDetailData *data;
@end

