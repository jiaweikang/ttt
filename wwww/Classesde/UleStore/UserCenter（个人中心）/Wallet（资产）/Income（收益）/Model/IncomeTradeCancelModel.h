//
//  IncomeTradeCancelModel.h
//  AFNetworking
//
//  Created by lei xu on 2020/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IncomeTradeCancelList : NSObject
@property (nonatomic , copy) NSString              * escOrderId;
@property (nonatomic , copy) NSString              * returnOrderId;
@property (nonatomic , strong) NSNumber            * saleType;
@property (nonatomic , copy) NSString              * refundTime;
@property (nonatomic , copy) NSString              * paymentTime;
@property (nonatomic , strong) NSNumber            * commissionAmount;
@property (nonatomic , copy) NSString              * commissionType;
@property (nonatomic , copy) NSString              * commissionTypeDesc;
@property (nonatomic , copy) NSString              * orderStatus;
@property (nonatomic , copy) NSString              * orderStatusDesc;
@end

@interface IncomeTradeCancelResult : NSObject
@property (nonatomic , strong) NSNumber             * total;
@property (nonatomic , strong) NSNumber             * pages;
@property (nonatomic , strong) NSMutableArray              * list;
@end

@interface IncomeTradeCancelData : NSObject
@property (nonatomic , strong) IncomeTradeCancelResult    * result;
@end

@interface IncomeTradeCancelModel : NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , strong) IncomeTradeCancelData     * data;
@end

NS_ASSUME_NONNULL_END
