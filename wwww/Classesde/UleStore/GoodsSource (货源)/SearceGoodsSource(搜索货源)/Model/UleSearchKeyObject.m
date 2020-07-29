//
//  UleSearchKeyObject.m
//  UleApp
//
//  Created by chenzhuqing on 2017/10/25.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleSearchKeyObject.h"

@implementation SearchKeyWordItem

@end

@implementation UleSearchKeyObject

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"wap_searchkeyword" : [SearchKeyWordItem class]};
}

@end
