//
//  FeatureModel_HomeBanner.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_HomeBanner.h"

@implementation HomeBannerIndexInfo
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"};
}

@end

@implementation FeatureModel_HomeBanner

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [HomeBannerIndexInfo class]};
}

@end
