//
//  LogoutModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "LogoutModel.h"
@implementation LogoutSectionData

@end

@implementation LogoutData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"top" : [LogoutSectionData class],
             @"middle" : [LogoutSectionData class],
             @"bottom" : [LogoutSectionData class]
             };
}
@end

@implementation LogoutModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [LogoutData class]
             };
}
@end
