//
//  US_OrderListViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListViewModel.h"
#import "MyWaybillOrderInfo.h"
#import "US_OrderListCellModel.h"
#import "US_OrderListSectionModel.h"
#import "CancelOrderInfo.h"
#import <UIView+ShowAnimation.h>

@interface US_OrderListViewModel ()
@property (nonatomic, assign) US_OrderListType  orderListType;
@property (nonatomic, copy) NSString * orderFlag;
@end

@implementation US_OrderListViewModel

//处理订单列表数据，组装成sectionModel 数组用于显示
- (void) fetchOrderListInfo:(NSDictionary *)orderDic
           andOrderListType:(US_OrderListType)orderListType
               andOrderFlag:(NSString *)orderFlag
               andOrderType:(NSString *)orderType
                    atStart:(NSInteger)start{
    if (start==1) {
        [self.mDataArray removeAllObjects];
    }
    self.orderListType=orderListType;
    self.orderFlag=orderFlag;
    MyWaybillOrderInfo * orderList=[MyWaybillOrderInfo yy_modelWithDictionary:orderDic];
    for (int i=0; i<orderList.orderInfo.order.count; i++) {
        WaybillOrder * billOrder=orderList.orderInfo.order[i];
        US_OrderListSectionModel * sectionModel=[[US_OrderListSectionModel alloc] initWithRuleData:billOrder];
        for (int j=0; j<billOrder.delevery.count; j++) {
            DeleveryInfo * delevery=billOrder.delevery[j];
            for (PrdInfo * prd in delevery.prd) {
                US_OrderListCellModel * cellModel=[[US_OrderListCellModel alloc] initWithOrderListData:prd];
                @weakify(self);
                cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                    @strongify(self);
                    [self cellDidClickWithWaybillOrder:billOrder];
                };
                [sectionModel.cellArray addObject:cellModel];
            }
        }
        [self.mDataArray addObject:sectionModel];
    }
    if (self.mDataArray.count==[orderList.orderInfo.order_count integerValue]) {
        self.isEndRefreshFooter=YES;
    }else{
        self.isEndRefreshFooter=NO;
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)cellDidClickWithWaybillOrder:(WaybillOrder *)billOrder{
    if ([billOrder.orderType isEqualToString:@"3108"]) {
        if ([NSString isNullToString:billOrder.commUrl].length > 0) {
            NSMutableDictionary * dic=@{@"key":billOrder.commUrl,KNeedShowNav:@"0"}.mutableCopy;
            [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        }else {
            [UleMBProgressHUD showHUDWithText:@"当前为邮政积分订单，系统正在升级，暂不支持查看详情" afterDelay:2];
        }
    }
    NSMutableDictionary * dic=@{@"WaybillOrder":billOrder,@"orderFlag":self.orderFlag,@"orderListType":[NSNumber numberWithInteger:self.orderListType]}.mutableCopy;
    [[UIViewController currentViewController] pushNewViewController:@"US_MyOrderDetailVC" isNibPage:NO withData:dic];
    NSString * logModleId=[self.orderFlag isEqualToString:@"3"]?@"客户订单":@"我的订单";
    [UleMbLogOperate addMbLogClick:@"" moduleid:logModleId moduledesc:@"订单详情" networkdetail:@""];
}

//删除源数据，并刷新列表
- (void)deletSectionModel:(US_OrderListSectionModel *)sectionModel{
    if (sectionModel) {
        [self.mDataArray removeObject:sectionModel];
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}
//订单取消原因
- (void)fetchOrderCancelReasonInfo:(NSDictionary *)dic selectReason:(OrderCancelSelectBlock)selectBlock{
    CancelOrderInfo * cancelOrder=[CancelOrderInfo yy_modelWithJSON:(NSDictionary *)dic];
    NSMutableArray * array=[NSMutableArray array];
    for (int i=0; i<cancelOrder.indexInfo.count; i++) {
        CoItemData * item=cancelOrder.indexInfo[i];
        OrderCancelCellModel * model=[[OrderCancelCellModel alloc] init];
        model.cancelReason=item.attribute1;
        model.isSelected=NO;
        [array addObject:model];
    }
    OrderCancelView * cancelAlert=[[OrderCancelView alloc] initWithData:array selectReason:selectBlock];
    [cancelAlert showViewWithAnimation:AniamtionPresentBottom];
}

@end
