//
//  US_OrderDetailAddressCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailAddressCellModel.h"

@implementation US_OrderDetailAddressCellModel

- (instancetype)initWithBillOrderInfo:(WaybillOrder *)billOrder{
    self = [super initWithCellName:@"US_OrderDetailAddressCell"];
    if (self) {
        self.data=billOrder;
        self.addressInfo=[self getAddressInfo:billOrder];
        self.userName=billOrder.transName;
        self.phoneNumber =billOrder.transUsrPhone;
        self.isMyOrder=[billOrder.myOrder isEqualToString:@"1"]?YES:NO;
        //汽车订单不显示收货地址
        self.carOrderHiddenAddressInfo=[billOrder.orderTag containsString:carOrderStatus];
    }
    return self;
}

- (NSString *)getAddressInfo:(WaybillOrder *)billOrder{
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@",billOrder.transProvince,billOrder.transCity,billOrder.transArea,billOrder.transTown,billOrder.transAddress];
    return address;

}
@end
