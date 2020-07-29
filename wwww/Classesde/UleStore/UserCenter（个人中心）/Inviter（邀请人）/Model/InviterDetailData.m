//
//  InviterDetailData.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterDetailData.h"
@implementation InviterGoodsInfo

@end


@implementation InviterDetailStoreData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"storeDetail" : [InviterGoodsInfo class]
             };
}
@end


@implementation InviterDetailData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [InviterDetailStoreData class]
             };
}
@end
