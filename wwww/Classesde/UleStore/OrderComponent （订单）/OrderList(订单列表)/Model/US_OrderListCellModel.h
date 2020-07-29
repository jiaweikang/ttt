//
//  US_OrderListCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "MyWaybillOrderInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_OrderListCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * imageUrlStr;
@property (nonatomic, strong) NSString * listNameStr;
@property (nonatomic, strong) NSString * sizeStr;
@property (nonatomic, strong) NSString * numberStr;
@property (nonatomic, strong) NSString * priceStr;
@property (nonatomic, strong) NSString * isCanReplace;

@property (nonatomic, copy) NSString * esc_orderId;
@property (nonatomic, copy) NSString * deleveryOrderid;
@property (nonatomic, copy) NSString * order_tag;
@property (nonatomic, assign) BOOL isOrdeDetailList;//是否是订单详情中的列表
@property (nonatomic, copy)void(^replaceBtnSameCityBlock)(void);

- (instancetype) initWithOrderListData:(PrdInfo *)prdInfo;

@end

NS_ASSUME_NONNULL_END
