//
//  OrderCancelView.h
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderCancelCellModel.h"

typedef void(^OrderCancelSelectBlock)(NSString * cancelReason);

@protocol OrderCancelViewDelegate <NSObject>

- (void)didSelectedCancelOrderReason:(NSString *)cancelReason;

@end

@interface OrderCancelView : UIView

- (id)initWithData:(NSMutableArray<OrderCancelCellModel *>  *)mArray delegate:(id<OrderCancelViewDelegate>)delegate;

- (id)initWithData:(NSMutableArray<OrderCancelCellModel *>  *)mArray selectReason:(OrderCancelSelectBlock) select;

@end
