//
//  US_OrderDetail.h
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/16.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OrderDetailPayments :NSObject
@property (nonatomic , copy) NSString              * amount;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * type;
@end

@interface OrderDetailPrd : NSObject
@property (nonatomic, strong)           NSString *noSupMerchant;
@property (nonatomic, strong)           NSString *isComment;
@property (nonatomic, strong)           NSString *salPrice;
@property (nonatomic, strong)           NSString *partnerPurchaseNote;
@property (nonatomic, strong)           NSString *replaceMsg;
@property (nonatomic, strong)           NSString *productName;
@property (nonatomic, strong)           NSString *merchantOnlyid;
@property (nonatomic, strong)           NSString *isCanReplace;
@property (nonatomic, strong)           NSString *itemWeight;
@property (nonatomic, strong)           NSString *deleveryOrderID;
@property (nonatomic, strong)           NSString *storageID;
@property (nonatomic, strong)           NSString *productNum;
@property (nonatomic, strong)           NSString *productPic;
@property (nonatomic, strong)           NSString *listingID;
@property (nonatomic, strong)           NSString *buyerComment;
@property (nonatomic, strong)           NSString *itemID;
@property (nonatomic, strong)           NSString *attributes;
@property (nonatomic, strong)           NSString *skuDesc;
@property (nonatomic, strong)           NSString *escOrderID;
@property (nonatomic, strong)           NSString *specification;
@property (nonatomic, strong)           NSString *itemColor;
@property (nonatomic, strong)           NSString *listingTag;
@property (nonatomic, strong)           NSString *merchantSku;
@property (nonatomic, strong)           NSString *listingType;
@property (nonatomic, strong)           NSString *estimatedDeliveryTime;
@property (nonatomic, strong)           NSString *prdCommission;
@end

@interface OrderDetailDelevery : NSObject
@property (nonatomic, strong)           NSString *isCanCancel;
@property (nonatomic, strong)           NSString *deleveryOrderID;
@property (nonatomic, strong)           NSString *packageStatus;
@property (nonatomic, strong)           NSString *transInfo;
@property (nonatomic, strong)           NSString *cancelMsg;
@property (nonatomic, strong)           NSString *completeTime;
@property (nonatomic, strong)           NSString *packageID;
@property (nonatomic, strong)           NSString *storageName;
@property (nonatomic, strong)           NSString *orderSubStatus;
@property (nonatomic, strong)           NSString *saleType;
@property (nonatomic, strong)           NSString *orderStatus;
@property (nonatomic, strong)           NSArray<OrderDetailPrd *> *prd;
@property (nonatomic, strong)           NSString *invoiceTitle;
@property (nonatomic, strong)           NSString *transAmount;
@property (nonatomic, strong)           NSString *transName;
@property (nonatomic, strong)           NSString *storageAddress;
@property (nonatomic, strong)           NSString *transPhone;
@property (nonatomic, strong)           NSString *invoiceContent;
@property (nonatomic, strong)           NSString *orderAmount;
@property (nonatomic, strong)           NSString *transAddress;
@property (nonatomic, strong)           NSString *buyType;
@property (nonatomic, strong)           NSString *transType;
@property (nonatomic, strong)           NSString *orderType;
@property (nonatomic, strong)           NSString *jsonResultStr;
@property (nonatomic, strong)           NSString *logisticsID;
@property (nonatomic, strong)           NSString *logisticsName;
@property (nonatomic, strong)           NSString *logisticsCode;
@property (nonatomic, strong)           NSString *prdNum;
@end

@interface US_OrderDetailData : NSObject
@property (nonatomic, strong)           NSArray *logistics;
@property (nonatomic, strong)           NSString *orderAmount;
@property (nonatomic, strong)           NSString *createTime;
@property (nonatomic, strong)           NSString *escOrderID;
@property (nonatomic, strong)           NSString *orderID;
@property (nonatomic, strong)           NSString *orderSubStatus;
@property (nonatomic, strong)           NSString *orderStatus;
@property (nonatomic, strong)           NSString *payAmount;
@property (nonatomic, strong)           NSString *supportBuyType;
@property (nonatomic, strong)           NSString *transMobile;
@property (nonatomic, strong)           NSString *activityURL;
@property (nonatomic, strong)           NSString *orderDeleted;
@property (nonatomic, strong)           NSString *sellerNote;
@property (nonatomic, strong)           NSString *transAddress;
@property (nonatomic, strong)           NSString *allCommented;
@property (nonatomic, strong)           NSString *transProvince;
@property (nonatomic, strong)           NSString *isCanDelete;
@property (nonatomic, strong)           NSString *sellerOnlyid;
@property (nonatomic, strong)           NSString *buyerNote2;
@property (nonatomic, strong)           NSString *isConfirmOrder;
@property (nonatomic, strong)           NSString *sellerModifyTime;
@property (nonatomic, strong)           NSString *transPhone;
@property (nonatomic, strong)           NSString *feedback;
@property (nonatomic, strong)           NSString *supportedByType;
@property (nonatomic, strong)           NSString *buyerNote;
@property (nonatomic, strong)           NSString *shipitemNotifyEmail;
@property (nonatomic, strong)           NSString *transArea;
@property (nonatomic, strong)           NSString *resumeMsg;
@property (nonatomic, strong)           NSString *escOrderid;
@property (nonatomic, strong)           NSString *isOrderComment;
@property (nonatomic, strong)           NSString *activityDesc;
@property (nonatomic, strong)           NSString *transName;
@property (nonatomic, strong)           NSString *transAmount;
@property (nonatomic, strong)           NSString *partnerPurchaseNote;
@property (nonatomic, strong)           NSString *transUSRPhone;
@property (nonatomic, strong)           NSString *buyerPayTime;
@property (nonatomic, strong)           NSString *orderType;
@property (nonatomic, strong)           NSString *isCanResume;
@property (nonatomic, strong)           NSString *transCity;
@property (nonatomic, strong)           NSString *cancelMsg;
@property (nonatomic, strong)           NSString *sellerNote2;
@property (nonatomic, strong)           NSString *isCanCancel;
@property (nonatomic, strong)           NSString *transType;
@property (nonatomic, strong)           NSString *partnerShippingNote;
@property (nonatomic, strong)           NSString *deleteMsg;
@property (nonatomic, strong)           NSString *storeID;
@property (nonatomic, strong)           NSString *bigorderAmount;
@property (nonatomic, strong)           NSArray<OrderDetailDelevery *> *delevery;
@property (nonatomic, strong)           NSArray<OrderDetailPayments *> *payments;//所有支付信息 包括优惠券
@property (nonatomic, strong)           NSArray<OrderDetailPayments *> *payments4Coupon;//优惠券抵扣信息
@property (nonatomic, strong)           NSString *payStartline;
@property (nonatomic, strong)           NSString *payDeadline;
@property (nonatomic, strong)           NSString *payLastDeadline;
@property (nonatomic, strong)           NSString *businessType;
@property (nonatomic, strong)           NSString *firstPaymentAmount;
@property (nonatomic, strong)           NSString *finalPaymentAmount;
@property (nonatomic, strong)           NSString *payVersion;
@property (nonatomic, strong)           NSString *isMerAuditFlag;
@property (nonatomic, strong)           NSString *isRollCancelFlag;
@property (nonatomic, strong)           NSString *merchantAuditStatus;
@property (nonatomic, strong)           NSString *queryAuditDetailFlag;
@property (nonatomic, strong)           NSString *groupbuyingdispatchStatus;
@property (nonatomic, strong)           NSString *groupBuyingURL;
@property (nonatomic, strong)           NSString *orderUserCERT;
@property (nonatomic, strong)           NSString *isCheckSFZ;
@property (nonatomic, strong)           NSString *itemNum;
@property (nonatomic, strong)           NSString *orderAtiveTime;
@property (nonatomic, strong)           NSString *canToPay;
@property (nonatomic, strong)           NSString *transTown;
@property (nonatomic, strong)           NSString *nowTime;
@property (nonatomic, strong)           NSString *orderTag;
@property (nonatomic, strong)           NSString *salesChannel;
@property (nonatomic, strong)           NSString *prdNames;
@property (nonatomic, strong)           NSString *notDeliveryPrds;
@property (nonatomic, strong)           NSString * isCancel;
@property (nonatomic, strong)           NSString * isShortage;
@property (nonatomic, strong)           NSString * isCancelReplace;
@property (nonatomic, strong)           NSString *productAmount;
@property (nonatomic, strong)           NSString *qrURL;
@property (nonatomic, strong)           NSString *siteID;
@property (nonatomic, strong)           NSString *listingType;
@property (nonatomic, strong)           NSString *buyerName;
@property (nonatomic, strong)           NSString *buyerOnlyid;
@property (nonatomic, strong)           NSString *proBenefits;
@property (nonatomic, strong)           NSString *userPayAmount;
@end

@interface US_OrderDetail : NSObject
@property (nonatomic, strong)           NSString *returnCode;
@property (nonatomic, strong)           NSString *returnMessage;
@property (nonatomic, strong)         US_OrderDetailData *data;
@end

NS_ASSUME_NONNULL_END
