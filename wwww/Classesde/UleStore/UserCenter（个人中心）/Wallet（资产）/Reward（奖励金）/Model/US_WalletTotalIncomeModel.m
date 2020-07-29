//
//  US_WalletTotalIncomeModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_WalletTotalIncomeModel.h"

@implementation TotalIncomeListInfo

@end

@implementation TotalIncomeData
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"AccountTransList" : [TotalIncomeListInfo class]
             };
}
@end

@implementation US_WalletTotalIncomeModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [TotalIncomeData class]
             };
}
@end
