//
//  TakeSelfModel.m
//  u_store
//
//  Created by MickyChiang on 2019/3/22.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "TakeSelfModel.h"
#import "MJExtension.h"

@implementation TakeSelfIndexInfo
MJExtensionCodingImplementation
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}
@end

@implementation TakeSelfData
MJExtensionCodingImplementation
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"result" : [TakeSelfIndexInfo class]};
}

@end


@implementation TakeSelfModel
MJExtensionCodingImplementation

@end
