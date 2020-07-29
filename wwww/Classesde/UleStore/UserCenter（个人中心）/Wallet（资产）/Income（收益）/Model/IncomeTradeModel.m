//
//  IncomeTradeModel.m
//  u_store
//
//  Created by XL on 2016/12/6.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "IncomeTradeModel.h"


@implementation IncomeTradeDetail

@end


@implementation IncomeTradeResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"orderDetail" : [IncomeTradeDetail class]
             };
}

@end


@implementation IncomeTradeData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"result" : [IncomeTradeResult class]
             };
}

@end

@implementation IncomeTradeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [IncomeTradeData class]
             };
}

@end
