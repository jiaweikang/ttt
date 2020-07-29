//
//  FeatureModel_OrderPre.m
//  u_store
//
//  Created by xulei on 2019/6/28.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "FeaturedModel_OrderPre.h"

@implementation FeaturedModel_OrderPreIndex
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID":@"id"};
}

@end

@implementation FeaturedModel_OrderPre
+(NSDictionary *)mj_objectClassInArray
{
    return @{@"indexInfo":@"FeaturedModel_OrderPreIndex"};
}
@end
