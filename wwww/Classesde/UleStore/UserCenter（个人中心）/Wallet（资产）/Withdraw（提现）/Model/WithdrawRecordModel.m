//
//  WithdrawRecordModel.m
//  u_store
//
//  Created by XL on 2016/12/9.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "WithdrawRecordModel.h"

@implementation WithdrawRecordList

@end

@implementation WithdrawRecordData

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [WithdrawRecordList class]
             };
}

@end

@implementation WithdrawRecordModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [WithdrawRecordData class]
             };
}
@end
