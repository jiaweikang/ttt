//
//  WithdrawRecordModel.h
//  u_store
//
//  Created by XL on 2016/12/9.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WithdrawRecordList : NSObject
@property(nonatomic, copy) NSString     *accTypeId;
@property(nonatomic, copy) NSString     *bankCode;
@property(nonatomic, copy) NSString     *bankOrgan;
@property(nonatomic, copy) NSString     *channel;
@property(nonatomic, copy) NSString     *operateTime;
@property(nonatomic, copy) NSString     *orderId;
@property(nonatomic, copy) NSString     *orderMoney;
@property(nonatomic, copy) NSString     *orderType;
@property(nonatomic, copy) NSString     *status;
@property(nonatomic, copy) NSString     *payTime;
@property(nonatomic, copy) NSString     *applyTime;
//v1.7.7新增
@property(nonatomic, copy) NSString     *colorText;
@property(nonatomic, copy) NSString     *statusText;
@property(nonatomic, copy) NSString     *timeText;
@end


@interface WithdrawRecordData : NSObject
@property(nonatomic, copy) NSString       *auditingAmount;//审核中总金额
@property(nonatomic, copy) NSString       *approvalAmount;//已提现总金额
@property(nonatomic, copy) NSString       *totalCount;
@property(nonatomic, copy) NSString       *presentRecordHint;//说明
@property(nonatomic, strong) NSMutableArray *list;

@end


@interface WithdrawRecordModel : NSObject
@property(nonatomic, copy) NSString *returnCode;
@property(nonatomic, copy) NSString *returnMessage;
@property(nonatomic, strong) WithdrawRecordData *data;

@end
