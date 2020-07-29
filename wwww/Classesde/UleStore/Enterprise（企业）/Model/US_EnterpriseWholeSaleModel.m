//
//  US_EnterpriseWholeSaleModel.m
//  UleStoreApp
//
//  Created by lei xu on 2020/3/24.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseWholeSaleModel.h"

@implementation EnterpriseWholeSaleInfo

@end

@implementation EnterpriseWholeSaleList

@end

@implementation US_EnterpriseWholeSaleData
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list":[EnterpriseWholeSaleList class]};
}

@end

@implementation US_EnterpriseWholeSaleModel

@end
