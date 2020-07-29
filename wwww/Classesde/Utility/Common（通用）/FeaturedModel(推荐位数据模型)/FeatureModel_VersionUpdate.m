//
//  FeatureModel_VersionUpdate.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_VersionUpdate.h"

@implementation VersionIndexInfo



@end

@implementation FeatureModel_VersionUpdate
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [VersionIndexInfo class]};
}

@end
