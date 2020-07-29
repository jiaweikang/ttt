//
//  US_HomeBtnData.m
//  u_store
//
//  Created by yushengyang on 15/7/10.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "US_HomeBtnData.h"
#import <MJExtension/MJExtension.h>

@implementation HomeBtnItem
MJExtensionCodingImplementation
@end

@implementation HomeRecommend



@end


@implementation US_HomeBtnData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"indexInfo" : [HomeBtnItem class],
             @"data":[HomeRecommend class]
             };
}
@end


@implementation US_HomeRecommendData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [HomeBtnItem class]};
}

@end
