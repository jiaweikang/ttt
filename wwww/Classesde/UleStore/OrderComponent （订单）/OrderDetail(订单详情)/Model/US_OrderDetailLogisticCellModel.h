//
//  US_OrderDetailLogisticCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailLogisticCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * packageInfo;
@property (nonatomic, strong) NSString * timeStr;
@property (nonatomic, strong) NSString * noLogisticInfo;


//- (instancetype)initWithBillOrderInfo:(WaybillOrder *)billOrder;

@end

NS_ASSUME_NONNULL_END
