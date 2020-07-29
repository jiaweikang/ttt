//
//  FeatureModel_GIFRefresh.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_GIFRefresh.h"

@implementation GIFRefreshIndexInfo

@end

@implementation FeatureModel_GIFRefresh

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [GIFRefreshIndexInfo class]};
}

@end
