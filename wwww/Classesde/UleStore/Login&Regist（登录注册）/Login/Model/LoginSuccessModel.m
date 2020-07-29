//
//  LoginSuccessModel.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/7.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "LoginSuccessModel.h"

@implementation LoginSuccessAuthMap


@end

@implementation LoginSuccessModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id",
             @"userToken":@"X-Emp-Token"};
}

@end
