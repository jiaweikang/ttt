//
//  US_QueryAuthInfo.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/18.
//  strongright © 2019 chenzhuqing. All rights reserved.
//

#import "US_QueryAuthInfo.h"

@implementation CertificationInfo

@end


@implementation US_QueryAuthData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"certificationInfo" : [CertificationInfo class]
             };
}
@end

@implementation US_QueryAuthInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_QueryAuthData class]
             };
}
@end
