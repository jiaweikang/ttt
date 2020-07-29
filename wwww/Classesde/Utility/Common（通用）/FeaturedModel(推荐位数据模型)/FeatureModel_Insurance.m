//
//  FeatureModel_Insurance.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_Insurance.h"


@implementation InsuranceIndexInfo



@end

@implementation FeatureModel_Insurance

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [InsuranceIndexInfo class]};
}

@end
