//
//  US_MyOrderApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MyOrderApi : NSObject

//获取订单类型列表
+ (UleRequest *)buildOrderPreListRequest;

/// 获取订单各状态数量
/// @param orderFlag 2:查询该用户自己下的单 3:查询该用户分享后其他用户下单
+ (UleRequest *)buildOrderCountWithOrderFlag:(NSString *)orderFlag;

/**
 获取订单列表
 @param orderStatus 待付款：3、待发货：4、待收货：5、为空则查询所有
 @param flag 2：我的订单   3：客户订单
 @param startIndex 分页开始点
 @param keyWord 搜索关键字
 @param actCode 接龙活动code
 */
+ (UleRequest *)buildOrderListWithStatus:(NSString *)orderStatus flag:(NSString *)flag startIndex:(NSString *)startIndex andKeyWord:(NSString *)keyWord andOrderListType:(US_OrderListType)listType ActCode:(NSString *)actCode;

/**
获取单个订单信息
@param orderId 订单号
@param orderStatus 待付款：3、待发货：4、待收货：5、为空则查询所有
@param orderFlag 2：我的订单   3：客户订单
@param startIndex 分页开始点
@param keyWord 搜索关键字
*/
+ (UleRequest *)buildSingleOrderListWithOrderId:(NSString *)orderId status:(NSString *)orderStatus flag:(NSString *)orderFlag startIndex:(NSString *)startIndex andKeyWord:(NSString *)keyWord andOrderListType:(US_OrderListType)listType;

/**
获取订单详情
@param escOrderId 订单号
*/
+ (UleRequest *)buildGetOrderDetailWithEscOrderId:(NSString *)escOrderId;

/**
 删除订单

 @param escOrderId 订单号
 */
+ (UleRequest *)buildDeletOrderWithId:(NSString *)escOrderId;

/**
 签收订单
 @param escOrderId 订单号
 */
+ (UleRequest *)buildSignOrderWithId:(NSString *)escOrderId;

/**
 取消订单
 @param escOrderId 订单号
 @param reason 取消原因
 */
+ (UleRequest *)buildCancelOrderWithId:(NSString *)escOrderId andCancelReason:(NSString *)reason;

/**
 获取取消订单原因
 */
+ (UleRequest *)buildGetCancelOrderReason;

/**
 获取支付链接
 @param escOrderId 订单号
 @param businessType 类型
 */
+ (UleRequest *)buildGetPayLinkUrlWithId:(NSString *)escOrderId businessType:(NSString *)businessType;

/**
使用跨店铺优惠券订单支付获取所有订单信息 用于提示显示
@param escOrderId 订单号
*/
+ (UleRequest *)buildGetDifferentStoreOrderInfoWithOrderId:(NSString *)escOrderId;

/**
 提醒发货
 @param escOrderId 订单号
 */
+ (UleRequest *)buildRemindDeleveryWithOrderId:(NSString *)escOrderId;

/**
 查询物流信息

 @param logisticId 物流id
 @param logisticCode 物流Code
 @param packegeId 包裹号
 */
+ (UleRequest *)buildSearchLogisticWithId:(NSString *)logisticId code:(NSString *)logisticCode andPackageId:(NSString *)packegeId;


+ (UleRequest *)buildEvaluateLabelsApi;

+ (UleRequest *)buildUploadCommentImageData:(NSString *)imageData;

+ (UleRequest *)buildCommitEscOrderId:(NSString *)escOrderId PrdId:(NSString *)prdId Content:(NSString *)content logisticStar:(NSString *)logisticStar serverStar:(NSString *)serverStar productStar:(NSString *)prductStar andPicUrls:(NSString *)picUrls;

+ (UleRequest *)buildOrderDetailCarInfor:(NSString *)addressId;
//汽车订单二维码
+ (UleRequest *)buildOrderDetailCarQR:(NSString *)orderId;
//订单支付信息
+ (UleRequest *)buildOrderDetailPaymentInfo:(NSString *)orderId;
//自有订单商家信息
+ (UleRequest *)buildOrderDetailMerchantInfo:(NSString *)merchantId;
//获取同城订单 取消/退换货 提示
+ (UleRequest *)buildOrderSameCityInfo:(NSString *)merchantId andOrderTag:(NSString *)orderTag;
//获取客服状态
+ (UleRequest *)buildChatStatusInfo:(NSString *)merchantId storeId:(NSString *)storeId;
@end

NS_ASSUME_NONNULL_END
