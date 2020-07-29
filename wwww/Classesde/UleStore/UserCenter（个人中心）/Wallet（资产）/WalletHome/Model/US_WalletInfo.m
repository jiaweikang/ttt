//
//  US_WalletInfo.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/31.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_WalletInfo.h"
@implementation WalletInfo
@end

@implementation US_WalletInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [WalletInfo class]
             };
}
@end
