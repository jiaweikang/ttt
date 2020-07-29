//
//  PostOrgModel.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "PostOrgModel.h"

@implementation PostOrgData

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}


@end

@implementation PostOrgModel

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data":[PostOrgData class]};
}

@end
