//
//  US_UleCardListInfo.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UleCardListInfo.h"

@implementation US_UleCardDetail



@end

@implementation US_UleCardList

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"uleCardList" : [US_UleCardDetail class]
             };
}
@end

@implementation US_UleCardListInfo
    
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_UleCardList class]
             };
}
@end
