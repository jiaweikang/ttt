//
//  FeatureModel_HomeRecommend.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_HomeRecommend.h"

@implementation NewHomeRecommendApi



@end


@implementation NewHomeRecommendData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [NewHomeRecommendApi class]};
}

@end

@implementation FeatureModel_HomeRecommend
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [NewHomeRecommendData class]};
}
@end
