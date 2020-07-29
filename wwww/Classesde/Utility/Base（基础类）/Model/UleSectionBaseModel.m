//
//  UleSectionBaseModel.m
//  UleApp
//
//  Created by chenzhuqing on 2018/11/14.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleSectionBaseModel.h"

@implementation UleSectionBaseModel
- (instancetype) init{
    self = [super init];
    if (self) {
        _cellArray=[[NSMutableArray alloc] init];
        self.headHeight=0.0001;
        self.footHeight=0.0001;
    }
    return self;
}

- (instancetype) initWithIdentifier:(NSString *) identify{
    self = [super init];
    if (self) {
        _cellArray=[[NSMutableArray alloc] init];
        self.identify=identify;
        self.headHeight=0.0001;
        self.footHeight=0.0001;
    }
    return self;
}

@end
