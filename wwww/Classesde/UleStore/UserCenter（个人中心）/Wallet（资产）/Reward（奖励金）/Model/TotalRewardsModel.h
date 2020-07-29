//
//  TotalRewardsModel.h
//  u_store
//
//  Created by jiangxintong on 2018/8/7.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalRewardsHeadData : NSObject
@property(nonatomic, copy) NSString *balance; //可用余额
@property(nonatomic, copy) NSString *delayBalance; //延时生效余额
@property(nonatomic, copy) NSString *rewardTotal; //奖励金总额
@property(nonatomic, copy) NSString *tip; //提示文字
@end

@interface TotalRewardsHeadModel : NSObject
@property(nonatomic, copy) NSString *returnCode;
@property(nonatomic, copy) NSString *returnMessage;
@property(nonatomic, strong) TotalRewardsHeadData *data;
@end

@interface TotalRewardsList : NSObject
@property(nonatomic, copy) NSString *lastPayId; //最后支付流水号
@property(nonatomic, copy) NSString *payId; //支付流水号
@property(nonatomic, copy) NSString *remark; //备注(订单摘要)
@property(nonatomic, copy) NSString *transFlag; //支取标识 E-支出 D-存入
@property(nonatomic, copy) NSString *transId; //交易流水号
@property(nonatomic, copy) NSString *transMoney; //交易金额
@property(nonatomic, copy) NSString *transTime; //交易时间
@property(nonatomic, copy) NSString *transTypeId; //交易类型
@property(nonatomic, copy) NSString *transTypeName; //交易类型名称
@property(nonatomic, copy) NSString *userOnlyId; //用户ID
@property(nonatomic, copy) NSString *statusText;
@property(nonatomic, copy) NSString *timeType;
@property(nonatomic, copy) NSString *effectiveTime;// 奖励金明细有效期
@property(nonatomic, copy) NSString *iconUrl;//图标
@end


@interface TotalRewardsData : NSObject
@property(nonatomic, copy) NSString *count;
@property(nonatomic, strong) NSMutableArray *AccountTransList;
@end


@interface TotalRewardsModel : NSObject
@property(nonatomic, copy) NSString *returnCode;
@property(nonatomic, copy) NSString *returnMessage;
@property(nonatomic, strong) TotalRewardsData *data;
@end
