//
//  US_NewsClass.m
//  u_store
//
//  Created by shengyang_yu on 15/12/21.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "US_NewsClass.h"


@implementation US_NewsBase


@end

@implementation US_NewsClass

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"list" : [US_NewsBase class]};
}

@end
