//
//  NSArray+Extension.m
//  UleStoreApp
//
//  Created by xulei on 2019/8/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "NSArray+Extension.h"
#import <objc/runtime.h>

static char TAG_SORTTYPE;

@implementation NSArray (Extension)

- (void)setSortType:(NSString *)sortType{
    objc_setAssociatedObject(self, &TAG_SORTTYPE, sortType, OBJC_ASSOCIATION_COPY);
}

- (NSString *)sortType{
    return objc_getAssociatedObject(self, &TAG_SORTTYPE);
}
@end
