//
//  US_GoodsCatergoryListData.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsCatergoryListData.h"

@implementation US_GoodsCatergoryListItem



@end

@implementation US_GoodsCatergorys

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"result":[US_GoodsCatergoryListItem class]
             };
}

@end

@implementation US_GoodsCatergoryListData
    
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data":[US_GoodsCatergorys class]
             };
}
@end
