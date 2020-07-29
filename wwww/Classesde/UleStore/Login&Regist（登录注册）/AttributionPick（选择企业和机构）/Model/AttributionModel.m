//
//  AttributionModel.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "AttributionModel.h"

@implementation AttributionData

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}

@end

@implementation AttributionModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data":[AttributionData class]};
}

@end
