//
//  US_OrderListSectionModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleSectionBaseModel.h"
#import "MyWaybillOrderInfo.h"

typedef enum : NSUInteger {
    OrderButtonStateCanPay,   //去付款
    OrderButtonStateCanRecive,//确认收货
    OrderButtonStateCanComment,//去评论
    OrderButtonStateCanCanCel,//取消订单
    OrderButtonStateCanDelete,//删除订单
    OrderButtonStateCanQueryProcess,//查看进度
    OrderButtonStateHidden,//隐藏
    OrderButtonStateBuyAgain,//继续购买
    OrderButtonStateLogistic,//查看物流
    OrderButtonStateGroupDetail,//拼团详情
    OrderButtonStateReturnGoods,//退换货
    OrderButtonStateSendout,//发货
    OrderButtonStateRemindDelevery,//提醒发货(可点击)
    OrderButtonStateRemindDeleveryDisable//提醒发货(不可点)
} OrderButtonState;
typedef enum : NSInteger {
    OrderListFooterViewTypeList=1,//订单列表
    OrderListFooterViewTypeDetail//订单详情
} OrderListFooterViewType;

@interface US_OrderListHeaderModel : NSObject
@property (nonatomic, copy) NSString * nameStr;
@property (nonatomic, copy) NSString * statusStr;
@property (nonatomic, strong) NSMutableAttributedString * nameAttribute;

@end

@interface US_OrderListFooterModel : NSObject
@property (nonatomic, strong) NSString * freightValue;
@property (nonatomic, strong) NSString * payedMoneyValue;
@property (nonatomic, strong) NSString * numbleStr;
@property (nonatomic, strong) NSMutableAttributedString * footValueAttribute;
@property (nonatomic, assign) OrderButtonState buttonOneState;
@property (nonatomic, assign) OrderButtonState buttonTwoState;
@property (nonatomic, assign) OrderButtonState buttonThreeState;

- (instancetype)initWithBillOrder:(WaybillOrder *)billOrder pageViewType:(OrderListFooterViewType)viewType;
@end

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderListSectionModel : UleSectionBaseModel
@property (nonatomic, strong) US_OrderListHeaderModel * headerModel;
@property (nonatomic, strong) US_OrderListFooterModel * footerModel;

- (instancetype)initWithRuleData:(WaybillOrder *)billOrder;

@end

NS_ASSUME_NONNULL_END
