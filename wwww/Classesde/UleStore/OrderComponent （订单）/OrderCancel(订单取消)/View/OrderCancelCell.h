//
//  OrderCancelCell.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCancelCellModel.h"

@protocol OrderCancelCellDelegate <NSObject>

- (void)didSelectedResonModel:(OrderCancelCellModel * )model;

@end

@interface OrderCancelCell : UITableViewCell
@property (nonatomic, strong) OrderCancelCellModel * model;
@property (nonatomic, weak) id<OrderCancelCellDelegate> delegate;
@end
