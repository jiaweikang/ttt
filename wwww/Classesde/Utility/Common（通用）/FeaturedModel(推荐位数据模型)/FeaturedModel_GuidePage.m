//
//  FeaturedModel_GuidePage.m
//  UleStoreApp
//
//  Created by xulei on 2019/1/23.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeaturedModel_GuidePage.h"

@implementation FeaturedModel_GuidePageIndex
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id":@"id"};
}

@end


@implementation FeaturedModel_GuidePage

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"indexInfo":@"FeaturedModel_GuidePageIndex"};
}

@end
