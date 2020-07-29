//
//  MyWaybillOrderInfo.m
//  u_store
//
//  Created by wangkun on 16/4/19.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "MyWaybillOrderInfo.h"



@implementation PrdInfo
- (NSString *)product_num{
    return _product_num?_product_num:_productNum;
}
- (NSString *)is_comment{
    return _is_comment?_is_comment:_isComment;
}
- (NSString *)buyer_comment{
    return _buyer_comment?_buyer_comment:_buyerComment;
}
- (NSString *)product_name{
    return _product_name?_product_name:_productName;
}
- (NSString *)sal_price{
    return _sal_price?_sal_price:_salPrice;
}
- (NSString *)product_pic{
    return _product_pic?_product_pic:_productPic;
}
- (NSString *)listing_id{
    return _listing_id?_listing_id:_listingId;
}
- (NSString *)item_id{
    return _item_id?_item_id:_itemId;
}
- (NSString *)sku_desc{
    return _sku_desc?_sku_desc:_skuDesc;
}
@end


@implementation DeleveryInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"prd" : [PrdInfo class]};
}

- (NSString *)complete_time{
    return _complete_time?_complete_time:_completeTime;
}
- (NSString *)delevery_order_id{
    return _delevery_order_id?_delevery_order_id:_deleveryOrderId;
}
- (NSString *)order_status{
    return _order_status?_order_status:_orderStatus;
}
- (NSString *)order_sub_status{
    return _order_sub_status?_order_sub_status:_orderSubStatus;
}
- (NSString *)package_id{
    return _package_id?_package_id:_packageId;
}
- (NSString *)package_status{
    return _package_status?_package_status:_packageStatus;
}
- (NSString *)sale_type{
    return _sale_type?_sale_type:_saleType;
}
- (NSString *)storage_name{
    return _storage_name?_storage_name:_storageName;
}
- (NSString *)trans_info{
    return _trans_info?_trans_info:_transInfo;
}
@end


@implementation WaybillOrder
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"delevery" : [DeleveryInfo class]};
}

- (NSString *)esc_orderid{
    return _esc_orderid?_esc_orderid:_escOrderId;
}
- (NSString *)create_time{
    return _create_time?_create_time:_createTime;
}
- (NSString *)order_id{
    return _order_id?_order_id:_orderId;
}
- (NSString *)pay_amount{
    return _pay_amount?_pay_amount:_payAmount;
}
- (NSString *)order_amount{
    return _order_amount?_order_amount:_orderAmount;
}
- (NSString *)order_status{
    return _order_status?_order_status:_orderStatus;
}
@end


@implementation WaybillOrderInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"order" : [WaybillOrder class]};
}
@end


@implementation MyWaybillOrderInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"orderInfo" : [WaybillOrderInfo class]};
}

- (void)setMyListingDeliverFlag:(NSString *)myListingDeliverFlag{
    self->_myListingDeliverFlag=myListingDeliverFlag;
    [US_UserUtility sharedLogin].isShowOrderSendout=[[NSString isNullToString:myListingDeliverFlag] isEqualToString:@"1"];
}
@end
