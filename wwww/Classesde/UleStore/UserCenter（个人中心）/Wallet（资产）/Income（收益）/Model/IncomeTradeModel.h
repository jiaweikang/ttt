//
//  IncomeTradeModel.h
//  u_store
//
//  Created by XL on 2016/12/6.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IncomeTradeDetail : NSObject
@property (nonatomic, copy) NSString    *escOrderId; //订单编号
@property (nonatomic, copy) NSString  *orderAmount; //订单销售额
@property (nonatomic, copy) NSString    *orderCreateTime; //订单创建时间
@property (nonatomic, strong) NSMutableArray    *orderDetailList; //订单商品详情
@property (nonatomic, copy) NSString  *orderQty; //订单销售数量
@property (nonatomic, copy) NSString  *orderStatus; //订单状态
@property (nonatomic, copy) NSString    *payTime;//
@property (nonatomic, copy) NSString  *paymentCommission; //订单佣金
@property (nonatomic, copy) NSString    *completeTime; //签收时间
@property (nonatomic, copy) NSString  *issueStatus;//佣金状态 , 103 表示预发放 , 100 表示不发放, 1 表示待发放, 2 表示可发放, 3表示已发放,101表示发放失败,102表示特殊订单只扣不发
@property (nonatomic, copy) NSString *commissionTypeDescribe; //收益标识
@property (nonatomic, copy) NSString *commissionTypeColor; ////收益标识颜色
@end

@interface IncomeTradeResult : NSObject
@property (nonatomic, copy) NSString      *unIssueCms;
@property (nonatomic, copy) NSString      *Total;
@property (nonatomic, strong) NSMutableArray    *orderDetail;
@end

@interface IncomeTradeData : NSObject
@property (nonatomic, strong) IncomeTradeResult    *result;
@property (nonatomic, copy) NSString               *incomeTransactionswenanHint;//代购佣金发放规则
@property (nonatomic, copy) NSString               *virutalTransactionswenanHint;//虚拟商品发放规则;
@property (nonatomic, copy) NSString               *multipleComissionHint;//多阶佣金发放规则
@end



@interface IncomeTradeModel : NSObject
@property (nonatomic, copy) NSString        *returnCode;
@property (nonatomic, copy) NSString        *returnMessage;
@property (nonatomic, strong) IncomeTradeData *data;
@end
