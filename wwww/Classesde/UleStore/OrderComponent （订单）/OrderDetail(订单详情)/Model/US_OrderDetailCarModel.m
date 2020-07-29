//
//  US_CarModel.m
//  u_store
//
//  Created by MickyChiang on 2019/5/20.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import "US_OrderDetailCarModel.h"

@implementation OrderDetailCarList

@end

@implementation US_OrderDetailCarModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [OrderDetailCarList class]};
}

@end
