//
//  US_PostOrigModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/8.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_PostOrigModel.h"
@implementation US_postOrigData
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"_id":@"id"};
}
@end

@implementation US_PostOrigModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_postOrigData class]
             };
}
@end
