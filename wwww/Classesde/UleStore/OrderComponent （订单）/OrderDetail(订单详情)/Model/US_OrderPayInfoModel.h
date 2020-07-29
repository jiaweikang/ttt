//
//  US_OrderPayInfoModel.h
//  u_store
//
//  Created by xulei on 2019/7/1.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OrderPayInfoCtocOrder :NSObject
@property (nonatomic , assign) NSInteger              payedAmount;
@property (nonatomic , copy) NSString              * areaCode;
@property (nonatomic , copy) NSString              * buyerIpAddr;
@property (nonatomic , assign) NSInteger              merchantId;
@property (nonatomic , copy) NSString              * orderTag;
@property (nonatomic , copy) NSString              * buyerMobile;
@property (nonatomic , copy) NSString              * transPostalCode;
@property (nonatomic , assign) NSInteger              sellerOnlyid;
@property (nonatomic , assign) NSInteger              unionStatus;
@property (nonatomic , assign) NSInteger              orderSubstatus;
@property (nonatomic , copy) NSString              * transProvinceCode;
@property (nonatomic , assign) NSInteger              transType3Value;
@property (nonatomic , copy) NSString              * escOrderid;
@property (nonatomic , copy) NSString              * partnerShippingNote;
@property (nonatomic , assign) NSInteger              discountAmount;
@property (nonatomic , copy) NSString              * salesChannel;
@property (nonatomic , copy) NSString              * area;
@property (nonatomic , copy) NSString              * sellerNote;
@property (nonatomic , assign) NSInteger              deliverTime;
@property (nonatomic , assign) NSInteger              groupBuyingDispatchStatus;
@property (nonatomic , assign) NSInteger              buyerOnlyid;
@property (nonatomic , assign) NSInteger              orderActiveTime;
@property (nonatomic , assign) NSInteger              orderAmount;
@property (nonatomic , copy) NSString              * transCity;
@property (nonatomic , assign) NSInteger              freezeStatus;
@property (nonatomic , copy) NSString              * supportedBuyType;
@property (nonatomic , assign) NSInteger              transAmount;
@property (nonatomic , copy) NSString              * buyerNote2;
@property (nonatomic , copy) NSString              * buyerLoginid;
@property (nonatomic , copy) NSString              * transAddress;
@property (nonatomic , copy) NSString              * transCityCode;
@property (nonatomic , assign) NSInteger              buyerPayTime;
@property (nonatomic , assign) NSInteger              reserveFlag;
@property (nonatomic , assign) NSInteger              saleType;
@property (nonatomic , copy) NSString              * buyerName;
@property (nonatomic , copy) NSString              * channel;
@property (nonatomic , copy) NSString              * sellerLoginid;
@property (nonatomic , copy) NSString              * partnerPurchaseNote;
@property (nonatomic , assign) NSInteger              orderPoint;
@property (nonatomic , assign) NSInteger              orderStatus;
@property (nonatomic , assign) NSInteger              transType3Amount;
@property (nonatomic , assign) NSInteger              orderCreateTime;
@property (nonatomic , copy) NSString              * sellerNote3;
@property (nonatomic , copy) NSString              * transProvince;
@property (nonatomic , assign) NSInteger              transType4Amount;
@property (nonatomic , assign) NSInteger              transType5Amount;
@property (nonatomic , copy) NSString              * buyerMacId;
@property (nonatomic , copy) NSString              * invoiceRequired;
@property (nonatomic , assign) NSInteger              orderId;
@property (nonatomic , assign) NSInteger              transStatus;
@property (nonatomic , assign) NSInteger              productAmount;
@property (nonatomic , assign) NSInteger              paymentAmount;
@property (nonatomic , assign) NSInteger              updateTime;
@property (nonatomic , copy) NSString              * transCountry;
@property (nonatomic , assign) NSInteger              sellerModifyTime;
@property (nonatomic , assign) NSInteger              transType;
@property (nonatomic , assign) NSInteger              orderDeleted;
@property (nonatomic , copy) NSString              * merchantBackurl;
@property (nonatomic , assign) NSInteger              payVersion;
@property (nonatomic , assign) NSInteger              orderType;
@property (nonatomic , assign) NSInteger              transType3Addvalue;
@property (nonatomic , copy) NSString              * transUsrPhone;
@property (nonatomic , assign) NSInteger              businessType;
@property (nonatomic , copy) NSString              * settlementVersion;
@property (nonatomic , copy) NSString              * transUsrName;

@end

@interface OrderPayInfoPayments :NSObject
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * type;

@end

@interface OrderPayInfoData :NSObject
@property (nonatomic , strong) OrderPayInfoCtocOrder              * ctocOrder;
@property (nonatomic , copy) NSArray<OrderPayInfoPayments *>              * payments;

@end

@interface US_OrderPayInfoModel :NSObject
@property (nonatomic , copy) NSString              * msg;
@property (nonatomic , strong) OrderPayInfoData              * data;
@property (nonatomic , copy) NSString              * code;

@end

NS_ASSUME_NONNULL_END
