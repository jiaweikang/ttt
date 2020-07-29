//
//  US_WalletBindingCardModel.m
//  u_store
//
//  Created by wangkun on 16/6/24.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "US_WalletBindingCardModel.h"


@implementation US_WalletBindingCardTime
@end

@implementation US_WalletBindingCardInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"createTime" : [US_WalletBindingCardTime class],
             @"smartpayOpenTime":[US_WalletBindingCardTime class],
             @"updateTime":[US_WalletBindingCardTime class]
             };
}
@end

@implementation US_WalletBindingCard


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cardList" : [US_WalletBindingCardInfo class]
             };
}
@end

@implementation US_WalletBindingCardModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_WalletBindingCard class]
             };
}
@end
