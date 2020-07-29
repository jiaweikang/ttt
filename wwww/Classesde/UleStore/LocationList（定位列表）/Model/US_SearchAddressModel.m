//
//  US_SearchAddressModel.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/15.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_SearchAddressModel.h"

@implementation US_Location

@end

@implementation US_AddressModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"location":[US_Location class]
             };
}
- (instancetype)initWithTencentLocation:(TencentLBSLocation *)location{
    self = [super init];
    if (self) {
        self.adcode=location.code;
        self.city=location.city;
        self.title=location.address;
    }
    return self;
}
@end

@implementation US_SearchAddressModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data":[US_AddressModel class]
             };
}
@end
