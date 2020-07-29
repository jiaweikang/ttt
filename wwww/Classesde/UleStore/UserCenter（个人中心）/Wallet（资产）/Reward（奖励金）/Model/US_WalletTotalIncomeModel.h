//
//  US_WalletTotalIncomeModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TotalIncomeListInfo : NSObject
@property(nonatomic, copy) NSString *lastPayId;//最后支付流水号
@property(nonatomic, copy) NSString *payId;//支付流水号
@property(nonatomic, copy) NSString *remark;//备注
@property(nonatomic, copy) NSString *transFlag;//支取标识
@property(nonatomic, copy) NSString *transId;//交易流水号
@property(nonatomic, copy) NSString *transMoney;//交易金额
@property(nonatomic, copy) NSString *transTime;//交易时间
@property(nonatomic, copy) NSString *transTypeId;//交易类型
@property(nonatomic, copy) NSString *transTypeName;//交易类型名称
@property(nonatomic, copy) NSString *userOnlyId;//用户ID
@property(nonatomic, copy) NSString *statusText;
@property(nonatomic, copy) NSString *timeType;
@property(nonatomic, copy) NSString *effectiveTime;// 奖励金明细有效期（有换行符）
@property(nonatomic, copy) NSString *iconUrl;//图标

@end

@interface TotalIncomeData : NSObject
@property(nonatomic, copy) NSString *count;
@property(nonatomic, copy) NSString *balance;
@property(nonatomic, strong) NSMutableArray *AccountTransList;
@end

@interface US_WalletTotalIncomeModel : NSObject
@property(nonatomic, copy) NSString *returnCode;
@property(nonatomic, copy) NSString *returnMessage;
@property(nonatomic,strong) TotalIncomeData *data;
@end

NS_ASSUME_NONNULL_END
