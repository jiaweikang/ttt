//
//  UleCellBaseModel.m
//  UleApp
//
//  Created by chenzhuqing on 2018/11/14.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleCellBaseModel.h"

@implementation UleCellBaseModel

- (instancetype) initWithCellName:(NSString *)cellName{
    self = [super init];
    if (self) {
        self.cellName=cellName;
    }
    return self;
}


@end
