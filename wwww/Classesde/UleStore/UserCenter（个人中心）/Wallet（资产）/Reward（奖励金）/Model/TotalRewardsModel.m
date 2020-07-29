//
//  TotalRewardsModel.m
//  u_store
//
//  Created by jiangxintong on 2018/8/7.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "TotalRewardsModel.h"

@implementation TotalRewardsHeadData

@end

@implementation TotalRewardsHeadModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [TotalRewardsHeadData class]
             };
}
@end

@implementation TotalRewardsList

@end

@implementation TotalRewardsData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"AccountTransList" : [TotalRewardsList class]
             };
}
@end

@implementation TotalRewardsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [TotalRewardsData class]
             };
}
@end
