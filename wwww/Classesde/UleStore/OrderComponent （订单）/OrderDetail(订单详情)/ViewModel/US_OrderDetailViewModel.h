//
//  US_OrderDetailViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"
#import "MyWaybillOrderInfo.h"
#import "US_OrderDetailHeadView.h"
#import "US_NetworkExcuteManager.h"
#import "US_MyOrderApi.h"
#import "US_OrderListSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailViewModel : UleBaseViewModel
@property (nonatomic, strong)WaybillOrder * billOrder;
- (void)fetchOrderDetailInfo:(WaybillOrder *)billOrder andOrderListType:(US_OrderListType)orderListType;

- (void)fechOrderDetailPaymentsInfo:(NSDictionary *)dic;

- (void)fetchLogistcInfo:(NSDictionary *)dic;

- (void)fetchCarInof:(NSDictionary *)dic;

- (void)fetchCarQR:(NSString *)jsonStr;

- (void)fetchPaymentInfo:(NSDictionary *)dic;

- (BOOL)isShowLogistcsCell;
- (US_OrderDetailHeadViewModel *)getHeaderModel;
//- (US_OrderListFooterModel *)getBottomModel;
- (CGFloat)caculateFooterViewHeight:(US_OrderListFooterModel *)footerModel;
- (UleRequest *)getSearchLogisticRequest;
@end

NS_ASSUME_NONNULL_END
