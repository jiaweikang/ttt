//
//  US_ExpressInfo.m
//  u_store
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "US_ExpressInfo.h"


@implementation US_ExpressDataMap
@end

@implementation US_ExpressListMap

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"map" : [US_ExpressDataMap class]};
}


@end

@implementation US_ExpressDataData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"myArrayList" : [US_ExpressListMap class]};
}

@end

@implementation US_MemoryMap

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"expressData" : [US_ExpressDataData class]};
}

@end

@implementation US_ExpressData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"map" : [US_MemoryMap class]};
}

@end

@implementation US_ExpressInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_ExpressData class]};
}
@end
