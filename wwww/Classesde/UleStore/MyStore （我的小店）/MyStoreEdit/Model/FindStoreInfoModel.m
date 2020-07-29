//
//  FindStoreInfoModel.m
//  u_store
//
//  Created by xstones on 2017/8/21.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "FindStoreInfoModel.h"

@implementation FindStoreInfoUser

@end


@implementation FindStoreInfoStore

@end

@implementation FindStoreInfoData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"store" : [FindStoreInfoStore class],
             @"user":[FindStoreInfoUser class]
            };
}
@end

@implementation FindStoreInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [FindStoreInfoData class]};
}
@end
