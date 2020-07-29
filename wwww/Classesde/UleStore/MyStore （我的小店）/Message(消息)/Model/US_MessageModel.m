//
//  US_MessageModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MessageModel.h"

@implementation US_MessageDetail

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"_id":@"id"
//             @"createTime":@"create_time",
//             @"expireTime":@"expire_time"
             };
}


@end

@implementation US_MessageData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_MessageDetail class]};
}


@end

@implementation US_MessageModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_MessageData class]};
}

@end

@implementation  MessageData2

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_MessageDetail class]};
}
@end
