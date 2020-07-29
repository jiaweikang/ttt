//
//  US_MyCoupons.m
//  u_store
//
//  Created by wangkun on 16/6/6.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "US_MyCoupons.h"

@implementation MyCouponModel


@end

@implementation US_MyCouponsData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"couponInfo" : [MyCouponModel class]
             };
}


@end

@implementation US_MyCoupons
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_MyCouponsData class]
             };
}

@end
