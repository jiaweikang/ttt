//
//  MyWaybillOrderInfo.h
//  u_store
//
//  Created by wangkun on 16/4/19.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrdInfo : NSObject
@property (nonatomic, copy) NSString *attributes;
@property (nonatomic, copy) NSString *buyer_comment;
@property (nonatomic, copy) NSString *is_comment;
@property (nonatomic, copy) NSString *item_id;
@property (nonatomic, copy) NSString *item_weight;
@property (nonatomic, copy) NSString *listing_id;
@property (nonatomic, copy) NSString *merchantOnlyid;
@property (nonatomic, copy) NSString *merchantSku;
@property (nonatomic, copy) NSString *prdCommission;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_num;
@property (nonatomic, copy) NSString *product_pic;
@property (nonatomic, copy) NSString *sal_price;
@property (nonatomic, copy) NSString *sku_desc;
@property (nonatomic, copy) NSString *storageId;
@property (nonatomic, copy) NSString *isCanReplace;
@property (nonatomic, copy) NSString *estimatedDeliveryTime;

//***接龙活动客户订单列表返回字段***
@property (nonatomic, copy) NSString *productNum;
@property (nonatomic, copy) NSString *isComment;
@property (nonatomic, copy) NSString *buyerComment;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *salPrice;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *listingId;
@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *skuDesc;
//***接龙活动客户订单列表返回字段***
@end


@interface DeleveryInfo : NSObject
@property (nonatomic, copy) NSString *complete_time;
@property (nonatomic, copy) NSString *delevery_order_id;
@property (nonatomic, copy) NSString *order_status;//订单页使用  订单详情页直接取order_status_text
@property (nonatomic, copy) NSString *order_status_text;//状态
@property (nonatomic, copy) NSString *order_sub_status;
@property (nonatomic, copy) NSString *package_id;
@property (nonatomic, copy) NSString *package_status;
@property (nonatomic, copy) NSString *sale_type;
@property (nonatomic, copy) NSString *storage_name;
@property (nonatomic, copy) NSString *trans_info;   //-------> 有返回null
@property (nonatomic, copy) NSString *logisticsCode;
@property (nonatomic, copy) NSString *logisticsId;
@property (nonatomic, copy) NSString *logisticsName;
@property (nonatomic, strong) NSMutableArray *prd;

//***接龙活动客户订单列表返回字段***
@property (nonatomic, copy) NSString *completeTime;
@property (nonatomic, copy) NSString *deleveryOrderId;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *orderSubStatus;
@property (nonatomic, copy) NSString *packageId;
@property (nonatomic, copy) NSString *packageStatus;
@property (nonatomic, copy) NSString *saleType;
@property (nonatomic, copy) NSString *storageName;
@property (nonatomic, copy) NSString *transInfo;
//***接龙活动客户订单列表返回字段***
@end

@interface WaybillOrder : NSObject
@property (nonatomic, copy) NSString *allCommented;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *buyerNote;
@property (nonatomic, copy) NSString *buyerNote2;
@property (nonatomic, copy) NSString *buyerNote3;//20191115 小店订单备注
@property (nonatomic, copy) NSString *buyerPayTime;
@property (nonatomic, copy) NSString *commissionAmount;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *esc_orderid;
@property (nonatomic, copy) NSString *feedback;
@property (nonatomic, copy) NSString *isConfirmOrder;
@property (nonatomic, copy) NSString *isOrderComment;
@property (nonatomic, copy) NSString *order_amount;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_status;
@property (nonatomic, copy) NSString *order_sub_status;
@property (nonatomic, copy) NSString *orderAtiveTime;
@property (nonatomic, copy) NSString *orderDeleted;
@property (nonatomic, copy) NSString *orderTag;
@property (nonatomic, copy) NSString *orderType;
@property (nonatomic, copy) NSString *partnerPurchaseNote;
@property (nonatomic, copy) NSString *partnerShippingNote;
@property (nonatomic, copy) NSString *pay_amount;
@property (nonatomic, copy) NSString *sellerModifyTime;
@property (nonatomic, copy) NSString *sellerNote;
@property (nonatomic, copy) NSString *sellerNote2;
@property (nonatomic, copy) NSString *sellerOnlyid;
@property (nonatomic, copy) NSString *shipitemNotifyEmail;
@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *supportedByType;
@property (nonatomic, copy) NSString *transAddress;
@property (nonatomic, copy) NSString *transAmount;
@property (nonatomic, copy) NSString *transArea;
@property (nonatomic, copy) NSString *transTown;
@property (nonatomic, copy) NSString *transCity;
@property (nonatomic, copy) NSString *transMobile;
@property (nonatomic, copy) NSString *transName;
@property (nonatomic, copy) NSString *transPhone;
@property (nonatomic, copy) NSString *transProvince;
@property (nonatomic, copy) NSString *transType;
@property (nonatomic, copy) NSString *transUsrPhone;
@property (nonatomic, copy) NSString *isCanDelete;
@property (nonatomic, copy) NSString *isCanCancel;//是否可以取消订单  0-不可以  1-可以
@property (nonatomic, copy) NSString *groupBuyingUrl; //团购详情链接
@property (nonatomic, copy) NSString *groupBuyingDispatchStatus;//团购状态
@property (nonatomic, copy) NSString *queryAuditDetailFlag;//为1显示 查看订单取消详情
@property (nonatomic, copy) NSString *myOrder;//是否是当前用户店主自己的订单  0-不是 1-是
@property (nonatomic, copy) NSString *toHtml5URL;//取消订单进度的跳转链接
@property (nonatomic, copy) NSString *merchantAuditStatusDes;//订单取消进度的描述
@property (nonatomic, copy) NSString *merchant_backurl;
@property (nonatomic, copy) NSString *customerService; //小能客服跳转链接
@property (nonatomic, copy) NSString *isShowBanner; //是否显示原生头
@property (nonatomic, copy) NSString *bannerName; //客服原生头标题
@property (nonatomic, copy) NSString *commUrl; //积分订单详情地址
@property (nonatomic, copy) NSString *merchantUsrEmail; //汽车订单门店id
@property (nonatomic, copy) NSString *carLoanInsure; //汽车订单车险及车贷信息
@property (nonatomic, strong)NSNumber *showDeliveryBtn;//0=默认不显示发货提醒,1=显示提醒发货按钮,2,显示但是不能点
@property (nonatomic , strong) NSMutableArray *delevery;
@property (nonatomic, copy) NSString *productAmount;
//@property (nonatomic, copy) NSString *userPayedAmount;
//@property (nonatomic, copy) NSString *payedTransAmount;
@property (nonatomic, copy) NSString *userPayAmount;//还需支付金额 注意：从订单详情接口返回 非订单列表接口返回


//***接龙活动客户订单列表返回字段***
@property (nonatomic, copy) NSString *escOrderId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *payAmount;
@property (nonatomic, copy) NSString *orderAmount;
@property (nonatomic, copy) NSString *orderStatus;
//***接龙活动客户订单列表返回字段***

@end


@interface WaybillOrderInfo : NSObject
@property (nonatomic, strong) NSMutableArray *order;
@property (nonatomic, strong) NSString *order_count;
@property (nonatomic, strong) NSString *orderAmount;
@end


@interface MyWaybillOrderInfo : NSObject
@property (nonatomic, copy) NSString *appendCommentDate;
@property (nonatomic, copy) NSString *cancelDate;
@property (nonatomic, copy) NSString *canNotCancelMerchantIds;
@property (nonatomic, copy) NSString *canReturnOrderType;
@property (nonatomic, copy) NSString *confirmOrderType;
@property (nonatomic, copy) NSString *currentTime;
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *returnTime;
@property (nonatomic, copy) NSString *myListingDeliverFlag;//发货开关 0-关 1-开  20190625

@property (nonatomic, strong) WaybillOrderInfo *orderInfo;
@end
