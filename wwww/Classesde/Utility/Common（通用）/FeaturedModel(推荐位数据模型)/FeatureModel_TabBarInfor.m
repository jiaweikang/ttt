//
//  FeatureModel_TabBarInfor.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "FeatureModel_TabBarInfor.h"
#import <MJExtension.h>
@implementation TabbarIndexInfo
MJExtensionCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"_id":@"id"};
}


@end

@implementation FeatureModel_TabBarInfor

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"indexInfo" : @"TabbarIndexInfo"};
}
@end
