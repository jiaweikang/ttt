//
//  InviterDetailData.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface InviterGoodsInfo : NSObject
@property (nonatomic, copy) NSString *listingId;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *listingName;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *prdCommission;
@property (nonatomic, copy) NSString *orderCount;
@property (nonatomic, copy) NSString *escOrderId;
@property (nonatomic, copy) NSString *recordId;
@end

@interface InviterDetailStoreData : NSObject
@property (nonatomic, copy) NSString *uv; //访客量
@property (nonatomic, copy) NSString *orderCount; //订单量
@property (nonatomic, copy) NSString *prdCommissionCount; //月收益
@property (nonatomic, copy) NSString *storeLogo; //店铺logo
@property (nonatomic, copy) NSString *storeName; //店铺名
@property (nonatomic, copy) NSString *usrTrueName; //用户名
@property (nonatomic, copy) NSString *top; //商品列表标题
@property (nonatomic, strong) NSMutableArray *storeDetail;
@end

@interface InviterDetailData : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) InviterDetailStoreData *data;
@end

NS_ASSUME_NONNULL_END
