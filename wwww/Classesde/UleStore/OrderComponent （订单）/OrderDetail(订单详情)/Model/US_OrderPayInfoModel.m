//
//  US_OrderPayInfoModel.m
//  u_store
//
//  Created by xulei on 2019/7/1.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_OrderPayInfoModel.h"

@implementation OrderPayInfoCtocOrder

@end

@implementation OrderPayInfoPayments

@end

@implementation OrderPayInfoData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"payments" : [OrderPayInfoPayments class]};
}
@end

@implementation US_OrderPayInfoModel

@end

