//
//  US_OrderDetailAddressCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "MyWaybillOrderInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailAddressCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * addressInfo;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * phoneNumber;
@property (nonatomic, assign) BOOL isMyOrder;
@property (nonatomic, assign) BOOL carOrderHiddenAddressInfo;

- (instancetype)initWithBillOrderInfo:(WaybillOrder *)billOrder;

@end

NS_ASSUME_NONNULL_END
