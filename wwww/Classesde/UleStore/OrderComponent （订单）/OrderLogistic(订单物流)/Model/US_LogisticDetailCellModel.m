


//
//  US_LogisticDetailCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticDetailCellModel.h"

@interface US_LogisticDetailCellModel ()
@property (nonatomic, strong)US_ExpressListMap * expressListMap;
@end

@implementation US_LogisticDetailCellModel

- (instancetype)initWithLogiticMapInfo:(US_ExpressListMap *)express{
    self = [super initWithCellName:@"US_LogisticDetailCell"];
    if (self) {
        self.expressListMap=express;
        self.packageInfo=express.map.content;
        self.time=express.map.dealTime;
    }
    return self;
}
@end
