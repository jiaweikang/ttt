//
//  FeatureModel_OwnGoodsTips.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_OwnGoodsTips.h"

@implementation FeatureModel_OwnGoodsTipsInfo
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"};
}
@end

@implementation FeatureModel_OwnGoodsTips
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [FeatureModel_OwnGoodsTipsInfo class]};
}
@end
