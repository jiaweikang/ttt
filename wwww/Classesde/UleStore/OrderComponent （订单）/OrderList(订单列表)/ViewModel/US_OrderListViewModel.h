//
//  US_OrderListViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"
#import "US_OrderListSectionModel.h"
#import "OrderCancelCellModel.h"
#import "OrderCancelView.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_OrderListViewModel : UleBaseViewModel
@property (nonatomic, assign) BOOL isEndRefreshFooter;

- (void)fetchOrderListInfo:(NSDictionary *)orderDic andOrderListType:(US_OrderListType)orderListType andOrderFlag:(NSString *)orderFlag andOrderType:(NSString *)orderType atStart:(NSInteger)start;

- (void)deletSectionModel:(US_OrderListSectionModel *)sectionModel;

- (void)cellDidClickWithWaybillOrder:(WaybillOrder *)billOrder;

- (void)fetchOrderCancelReasonInfo:(NSDictionary *)dic selectReason:(OrderCancelSelectBlock)selectBlock;

@end

NS_ASSUME_NONNULL_END
