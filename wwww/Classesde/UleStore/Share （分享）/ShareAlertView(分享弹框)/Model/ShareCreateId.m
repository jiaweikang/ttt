//
//  ShareCreateId.m
//  u_store
//
//  Created by ule_aofeilin on 15/11/4.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "ShareCreateId.h"
@implementation ShareMiniWxInfo


@end

@implementation ShareCreateResult


@end

@implementation ShareCreateData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sectionList" : [ShareCreateResult class],
             @"miniWxShareInfo" : [ShareMiniWxInfo class]
             };
}

@end

@implementation ShareCreateId

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ShareCreateData class]
             };
}

@end
