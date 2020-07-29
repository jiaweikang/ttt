//
//  US_OrderPayModel.m
//  u_store
//
//  Created by xulei on 2018/6/14.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_OrderPayModel.h"

@implementation US_OrderPayData

@end

@implementation US_OrderPayModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [US_OrderPayData class]};
}
@end
