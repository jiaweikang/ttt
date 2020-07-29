


//
//  US_SearchGoodsSourceModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/12.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SearchGoodsSourceModel.h"

@implementation PromotionListData
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"};
}

@end

@implementation OperateStateTime

@end

@implementation RecommendModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"updateTime" : [OperateStateTime class],
             @"operateStateTime":[OperateStateTime class],
             @"promotionList":[PromotionListData class],
             };
}
@end

@implementation US_GoodsSorcesData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"Listings" : [RecommendModel class],
             @"recommendDaily":[RecommendModel class]
             };
}


@end

@implementation US_SearchGoodsSourceModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_GoodsSorcesData class]};
}

@end
