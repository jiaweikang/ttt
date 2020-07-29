//
//  UserShareInfoModel.m
//  u_store
//
//  Created by xstones on 2017/2/22.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "UserShareInfoModel.h"

@implementation UserShareInfolList

@end

@implementation UserShareInfoData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"today" : [UserShareInfolList class]};
}
@end

@implementation UserShareInfoModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [UserShareInfoData class]};
}
@end

@implementation UserShareInfoOrderData

@end

@implementation UserShareInfoOrderModel

@end
