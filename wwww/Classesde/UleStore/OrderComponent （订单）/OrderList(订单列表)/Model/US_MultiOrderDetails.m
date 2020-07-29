//
//  US_MultiOrderDetails.m
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/14.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_MultiOrderDetails.h"
@implementation US_MultiOrderInfo

@end


@implementation US_MultiOrderDetails
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"details" : [US_MultiOrderInfo class]};
}
@end
