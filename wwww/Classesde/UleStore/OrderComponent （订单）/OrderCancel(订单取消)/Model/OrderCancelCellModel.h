//
//  OrderCancelCellModel.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
@interface OrderCancelCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * cancelReason;
@property (nonatomic, assign) BOOL isSelected;
@end
