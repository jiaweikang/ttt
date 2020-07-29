//
//  US_MyCoupons.h
//  u_store
//
//  Created by wangkun on 16/6/6.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouponModel : NSObject
@property (nonatomic, copy) NSString *activeDate;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *expiredDate;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *typeId;
@property (nonatomic, copy) NSString *usedTime;
@property (nonatomic, copy) NSString *usedUserId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *currentTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *couponColour;
@property (nonatomic, copy) NSString *forthcomingCoupon;
@property (nonatomic, copy) NSString *isTodayCoupon;
@property (nonatomic, copy) NSString *couponType; //优惠券类型
@property (nonatomic, copy) NSString *couponName;
@property (nonatomic, copy) NSString *batchId; //批次
@property (nonatomic, copy) NSString *listId; //商品Id(可能会拼接多个 用,隔开)
@end

@interface US_MyCouponsData : NSObject
@property (nonatomic, strong) NSString *couponTotal;
@property (nonatomic, strong) NSMutableArray *couponInfo;
@end

@interface US_MyCoupons : NSObject
@property (nonatomic, copy)   NSString *returnCode;
@property (nonatomic, copy)   NSString *returnMessage;
@property (nonatomic, strong) US_MyCouponsData * data;
@end
