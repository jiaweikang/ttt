//
//  US_OrderDetail.m
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/16.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_OrderDetail.h"
@implementation OrderDetailPayments

@end


@implementation OrderDetailPrd

@end


@implementation OrderDetailDelevery
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"prd":[OrderDetailPrd class]
             };
}
@end


@implementation US_OrderDetailData
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"delevery":[OrderDetailDelevery class],
             @"payments":[OrderDetailPayments class],
             @"payments4Coupon":[OrderDetailPayments class]
             };
}
@end

@implementation US_OrderDetail
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data":[US_OrderDetailData class]
             };
}
@end
