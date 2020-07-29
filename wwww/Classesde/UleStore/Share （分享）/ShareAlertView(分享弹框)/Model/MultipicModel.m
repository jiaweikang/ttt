//
//  MultipicData.m
//  u_store
//
//  Created by xstones on 2017/1/10.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "MultipicModel.h"

@implementation MultipicList

@end


@implementation MultipicData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"resultList" : [MultipicList class]
             };
}
@end

@implementation MultipicModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [MultipicData class]
             };
}
@end
