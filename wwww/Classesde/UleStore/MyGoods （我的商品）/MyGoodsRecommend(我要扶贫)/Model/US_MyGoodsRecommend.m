//
//  US_MyGoodsRecommend.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsRecommend.h"

@implementation US_MyGoodsRecommendDetail


@end

@implementation US_MyGoodsRecommendData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"event_ulestorepoor_dt" : [US_MyGoodsRecommendDetail class]};
}
@end

@implementation US_MyGoodsRecommend

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_MyGoodsRecommendData class]};
}

@end
