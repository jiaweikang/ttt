//
//  FeatureModel_UleHome.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_UleHome.h"

@implementation UleIndexInfo



@end

@implementation FeatureModel_UleHome

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [UleIndexInfo class]};
}

@end
