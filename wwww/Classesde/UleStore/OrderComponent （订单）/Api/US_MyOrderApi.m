//
//  US_MyOrderApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyOrderApi.h"
#import "NSDate+USAddtion.h"

@implementation US_MyOrderApi
+ (UleRequest *)buildOrderPreListRequest{
//    NSMutableDictionary *param=@{@"sectionKeys":@"poststore_order_list",
//                                 @"webp":@"1"}.mutableCopy;
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_OrderList)];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildOrderCountWithOrderFlag:(NSString *)orderFlag{
    NSMutableDictionary *params=@{@"yxdOrderFlag":orderFlag}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_getOrderCount andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOrderListWithStatus:(NSString *)orderStatus flag:(NSString *)flag startIndex:(NSString *)startIndex andKeyWord:(NSString *)keyWord andOrderListType:(US_OrderListType)listType ActCode:(NSString *)actCode{
    NSMutableDictionary *params = @{@"userID":[US_UserUtility sharedLogin].m_userId,
                                    @"startIndex":NonEmpty(startIndex),
                                    @"pageSize":@"10",
                                    @"yxdOrderFlag":NonEmpty(flag),
                                    @"isYxdOrderStatus":[orderStatus isEqualToString:@"1"] ? @"" : orderStatus
                                    }.mutableCopy;
    if (keyWord.length>0) {
        [params setObject:keyWord forKey:@"keywords"];
    }
    if (listType==OrderListTypeOwn) {
        [params setObject:@"1" forKey:@"showMyListing"];
    }else if (listType==OrderListTypeUle){
        [params setObject:@"0" forKey:@"showMyListing"];
    }
    if (actCode.length>0) {
        [params setObject:[orderStatus isEqualToString:@"1"] ? @"" : orderStatus forKey:@"orderStatus"];
        [params setObject:NonEmpty(actCode) forKey:@"unionRef"];
    }
    UleRequest * request=[[UleRequest alloc] initWithApiName:actCode.length>0 ? API_freshOrders: API_getAllOrders andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildSingleOrderListWithOrderId:(NSString *)orderId status:(NSString *)orderStatus flag:(NSString *)orderFlag startIndex:(NSString *)startIndex andKeyWord:(NSString *)keyWord andOrderListType:(US_OrderListType)listType{
    NSMutableDictionary *params = @{@"escOrderId":orderId,
                                    @"userID":[US_UserUtility sharedLogin].m_userId,
                                    @"startIndex":NonEmpty(startIndex),
                                    @"pageSize":@"10",
                                    @"yxdOrderFlag":NonEmpty(orderFlag),
                                    @"isYxdOrderStatus":[orderStatus isEqualToString:@"1"] ? @"" : orderStatus
                                    }.mutableCopy;
    if (keyWord.length>0) {
        [params setObject:keyWord forKey:@"keywords"];
    }
    if (listType==OrderListTypeOwn) {
        [params setObject:@"1" forKey:@"showMyListing"];
    }else if (listType==OrderListTypeUle){
        [params setObject:@"0" forKey:@"showMyListing"];
    }
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getAllOrders andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetOrderDetailWithEscOrderId:(NSString *)escOrderId{
    NSMutableDictionary *params = @{@"escOrderId":NonEmpty(escOrderId),
                                    @"buyerId":[US_UserUtility sharedLogin].m_userId
    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getOrderDetail andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildDeletOrderWithId:(NSString *)escOrderId{
    NSMutableDictionary *params = @{@"escOrderId":NonEmpty(escOrderId)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_deleteOrder andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildSignOrderWithId:(NSString *)escOrderId{
    NSMutableDictionary *params = @{@"escOrderId":NonEmpty(escOrderId)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_signOrder andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildCancelOrderWithId:(NSString *)escOrderId andCancelReason:(NSString *)reason{
    NSMutableDictionary *params = @{@"orderId":NonEmpty(escOrderId),
                                    @"cancelReason":NonEmpty(reason)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_cancelBuyerOrder andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
+ (UleRequest *)buildGetCancelOrderReason{
//    NSMutableDictionary *params = @{@"sectionKeys":kSectionKey_CancelReason,
//                                    @"webp":@"1"
//                                    }.mutableCopy;
    NSString * sectionKey=NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_CancelReason);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildGetDifferentStoreOrderInfoWithOrderId:(NSString *)escOrderId{
    NSMutableDictionary *params = @{@"escOrderId":NonEmpty(escOrderId),
                                    @"userID":[US_UserUtility sharedLogin].m_userId
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_queryMultiStoreOrder andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetPayLinkUrlWithId:(NSString *)escOrderId businessType:(NSString *)businessType{
    NSMutableDictionary *params = @{@"escOrderIds":NonEmpty(escOrderId),
                                    @"businessType":NonEmpty(businessType)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_orderPay andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildRemindDeleveryWithOrderId:(NSString *)escOrderId{
    NSMutableDictionary *params=@{@"escOrderId":escOrderId}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:API_deliverReminder andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildSearchLogisticWithId:(NSString *)logisticId code:(NSString *)logisticCode andPackageId:(NSString *)packegeId{
    NSMutableDictionary *params = @{@"expressId":NonEmpty(logisticId),
                                    @"expressCode":NonEmpty(logisticCode),
                                    @"packageNum":NonEmpty(packegeId)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_expressSearch andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildEvaluateLabelsApi{
    NSString * sectionKey = NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_EvaluateLabels);
    NSMutableDictionary *params = @{@"sectionKeys":sectionKey}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_FeaturedGet andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

+ (UleRequest *)buildUploadCommentImageData:(NSString *)imageData{
    NSString * imageName=[NSString stringWithFormat:@"%@.jpg", [NSDate getCurrentTimes]];
    NSMutableDictionary *params = @{@"imageBase64":NonEmpty(imageData),
                                    @"imageName":NonEmpty(imageName)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_uploadCommentImges andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderUploadImageSignParams:imageName];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildCommitEscOrderId:(NSString *)escOrderId PrdId:(NSString *)prdId Content:(NSString *)content logisticStar:(NSString *)logisticStar serverStar:(NSString *)serverStar productStar:(NSString *)prductStar andPicUrls:(NSString *)picUrls{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                NonEmpty(escOrderId), @"escOrderId",
                                [US_UserUtility sharedLogin].m_userId, @"usrId",
                                [US_UserUtility sharedLogin].m_userName, @"usrName",
                                NonEmpty(prdId), @"productId",
                                NonEmpty(content), @"content",
                                NonEmpty(prductStar), @"productQuality",
                                NonEmpty(serverStar), @"serviceQuality",
                                NonEmpty(logisticStar), @"logisticsQuality",
                                @"3", @"commentSource",
                                NonEmpty(escOrderId), @"deliveryOrderId",
                                NonEmpty(picUrls), @"commentImgsStr",
                                nil];
    
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_AddComment andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOrderDetailCarInfor:(NSString *)addressId{
//    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
//    [dic setObject:NonEmpty(addressId) forKey:@"addressId"];
    //https://ustatic.ulecdn.com/yxdcdn/v2/address/get4SAddress/{accessType}/{addressId}
    NSString * urlString = [NSString stringWithFormat:@"%@/%@",API_get4SAddressList,addressId.length>0?addressId:KCDNDefaultValue];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *)buildOrderDetailCarQR:(NSString *)orderId{
    NSMutableDictionary *dic=@{@"sceneCode":@"0002",
                          @"orderId":[NSString isNullToString:orderId]}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_generateCar andParams:dic];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOrderDetailPaymentInfo:(NSString *)orderId{
    NSMutableDictionary *params=@{@"escOrderid":[NSString isNullToString:orderId]}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_getPaymentInfo andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOrderDetailMerchantInfo:(NSString *)merchantId{
    NSMutableDictionary *params=@{@"merchantId":[NSString isNullToString:merchantId]}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_queryMerchantInfo andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildOrderSameCityInfo:(NSString *)merchantId andOrderTag:(NSString *)orderTag
{
    NSMutableDictionary *params=@{@"merchantId":[NSString isNullToString:merchantId],
                                  @"orderTag":[NSString isNullToString:orderTag]}.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_getRefundTip andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}


+ (UleRequest *)buildChatStatusInfo:(NSString *)merchantId storeId:(NSString *)storeId
{
    NSMutableDictionary *params=@{@"merchantId":[NSString isNullToString:merchantId],
                                  @"storeId":[NSString isNullToString:storeId],
                                  @"source":@"order",
                                  @"platform":@"APP"
    }.mutableCopy;
    UleRequest *request=[[UleRequest alloc]initWithApiName:kAPI_getChatStatus andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.livechatDomain;
    return request;
}
@end
