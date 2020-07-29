//
//  US_MyOrderDetailVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyOrderDetailVC.h"
#import "MyWaybillOrderInfo.h"
#import "US_MyOrderApi.h"
#import "US_OrderDetailViewModel.h"
#import "US_OrderDetailHeadView.h"
#import "US_OrderDetailBottomView.h"
#import "US_AlertView.h"
#import "US_OrderPayModel.h"
#import "US_OrderCancelVC.h"
#import "US_SignOrderModel.h"
#import "US_LiveChatStatusModel.h"
#import "US_MultiOrderPayAlertVC.h"

@interface US_MyOrderDetailVC ()<US_OrderDetailBottomViewDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) WaybillOrder *waybillOrder;        //一个订单模型
@property (nonatomic, assign) US_OrderListType  orderListType;
@property (nonatomic, strong) US_OrderDetailViewModel * mViewModel;
@property (nonatomic, strong) US_OrderDetailHeadView * headerView;
@property (nonatomic, strong) US_OrderDetailBottomView * bottomView;

@property (nonatomic, strong) UleNetworkExcute * chatNetworkClient_API;
@property (nonatomic, strong) US_MultiOrderPayAlertVC * orderPayAlert;
@property (nonatomic, strong) NSString * orderFlag;//3:客户订单  2:我的订单
@end

@implementation US_MyOrderDetailVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"订单详情"];
    self.waybillOrder=[self.m_Params objectForKey:@"WaybillOrder"];
    self.orderListType=[[self.m_Params objectForKey:@"orderListType"] integerValue];
    self.orderFlag=[self.m_Params objectForKey:@"orderFlag"];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout.leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(0);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0).bottomSpaceToView(self.bottomView, 0);
    @weakify(self);
    self.mViewModel.sucessBlock = ^(id returnValue) {
        @strongify(self);
        self.mTableView.tableHeaderView=self.headerView;
        [self.headerView setModel:[self.mViewModel getHeaderModel]];
        [self.mTableView reloadData];
    };
    [self reloadDetailView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderStatus:) name:NOTI_UpdateOrderList object:nil];
    

    //我的订单 请求订单详情 更新优惠券抵扣信息和支付金额
    if ([self.orderFlag isEqualToString:@"2"]) {
        [self startRequestOrderDetail];
    }
}

- (void)reloadDetailView{
    [self.mViewModel fetchOrderDetailInfo:self.waybillOrder andOrderListType:self.orderListType];
    
    if ([self.mViewModel isShowLogistcsCell]) {
        [self startSeachLogistic];
    }
    if ([self.waybillOrder.orderTag containsString:carOrderStatus] && [NSString isNullToString:self.waybillOrder.merchantUsrEmail].length > 0) {
        [self startRequestCarOrderInfo];
    }
    //二维码请求条件：我的订单，汽车订单，待签收
    if ([self.waybillOrder.myOrder isEqualToString:@"1"]&&[self.waybillOrder.orderTag containsString:carOrderStatus]&&[self.waybillOrder.order_status intValue]==5) {
        [self startRequestCarOrderQR];
    }
    //暂时取消调用 20190703
//    if ([[self.m_Params objectForKey:@"orderFlag"] isEqualToString:@"2"]) {
//        //我的订单请求支付信息
//        [self startRequestPaymentInfo];
//    }
    US_OrderListFooterModel * footerModel=[[US_OrderListFooterModel alloc] initWithBillOrder:self.mViewModel.billOrder pageViewType:OrderListFooterViewTypeDetail];
    [self.bottomView setModel:footerModel];
    CGFloat bottomViewH=[self.mViewModel caculateFooterViewHeight:footerModel];
    self.bottomView.sd_layout.heightIs(bottomViewH);
    
    [self startRequestChatStatus];
}

- (void)updateOrderStatus:(NSNotification *)notify{
    NSDictionary * userInfo=notify.userInfo;
    NSString * status=[userInfo objectForKey:@"orderStatus"];
    if ([status isEqualToString:@"1"]) {//可取消订单
        NSString * toHtml5URL=[userInfo objectForKey:@"toHtml5URL"];
        DeleveryInfo *deleveryInfo = [self.waybillOrder.delevery firstObject];
        if (toHtml5URL.length>0) {
            self.waybillOrder.toHtml5URL=toHtml5URL;
            self.waybillOrder.queryAuditDetailFlag=@"1";//显示查看取消进度
            self.waybillOrder.merchantAuditStatusDes=@"等待商家审核";
            self.waybillOrder.isCanCancel=@"0";//不显示取消订单
            self.waybillOrder.isCanDelete=@"0";//不显示删除订单
        }else{
            self.waybillOrder.order_status=@"1";//大订单状态 已取消
            self.waybillOrder.queryAuditDetailFlag=@"0";
            self.waybillOrder.isCanCancel=@"0";//不显示取消订单
            self.waybillOrder.isCanDelete=@"1";//显示删除订单
            deleveryInfo.order_status_text = @"已取消";
        }
    }
    if ([status isEqualToString:@"7"]) {//待签收订单
         NSString * toHtml5URL=[userInfo objectForKey:@"toHtml5URL"];
        DeleveryInfo *deleveryInfo = [self.waybillOrder.delevery firstObject];
        if (toHtml5URL.length>0) {
            //返回了查看进度链接,更改订单状态,显示查取消进度按钮,不显示取消订单,不显示删除按钮
            self.waybillOrder.toHtml5URL=toHtml5URL;
            self.waybillOrder.order_status=@"7";//大订单状态 已签收;
            self.waybillOrder.isCanCancel=@"1";//显示取消订单
            self.waybillOrder.isCanDelete=@"0";//不显示删除订单
            self.waybillOrder.isConfirmOrder = @"false";
            deleveryInfo.order_status_text = @"已签收";
            self.waybillOrder.isOrderComment = @"true";
        }else {
            self.waybillOrder.order_status=@"7";//大订单状态 已取消
            self.waybillOrder.queryAuditDetailFlag=@"0";
            self.waybillOrder.isCanCancel=@"0";//不显示取消订单
            self.waybillOrder.isCanDelete=@"1";//显示删除订单
            self.waybillOrder.isConfirmOrder = @"false";
            deleveryInfo.order_status_text = @"已签收";
            self.waybillOrder.isOrderComment = @"true";
        }
        for (int i = 0; i < deleveryInfo.prd.count; i++) {
            PrdInfo *itemInfo=deleveryInfo.prd[i];
            if ([self.waybillOrder.orderTag containsString:carOrderStatus]) {
                itemInfo.isCanReplace=@"0";//汽车订单不可以退换货
            } else {
                itemInfo.isCanReplace=@"1";//可以退换货
            }
        }
    }
    if ([status isEqualToString:@"待评论"]) {//待评论订单
        self.waybillOrder.isOrderComment=@"0";
    }
    [self reloadDetailView];
}

- (void)startRequestOrderDetail{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_MyOrderApi buildGetOrderDetailWithEscOrderId:self.waybillOrder.esc_orderid] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fechOrderDetailPaymentsInfo:responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startSeachLogistic{
    @weakify(self);
    [self.networkClient_API beginRequest:[self.mViewModel getSearchLogisticRequest] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchLogistcInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)startRequestCarOrderInfo{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_MyOrderApi buildOrderDetailCarInfor:self.mViewModel.billOrder.merchantUsrEmail] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchCarInof:responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startRequestCarOrderQR{
    [self.networkClient_API beginRequest:[US_MyOrderApi buildOrderDetailCarQR:self.waybillOrder.esc_orderid] success:^(id responseObject) {
        NSDictionary *responseDic=responseObject;
        NSDictionary *dataDic=[responseDic objectForKey:@"data"];
        NSString *jsonStr=@"";
        if (dataDic&&dataDic.allKeys.count>0) {
             jsonStr=[NSString dictionaryToJson:dataDic];
        }
        [self.mViewModel fetchCarQR:jsonStr];
    } failure:^(UleRequestError *error) {
    }];
}

- (void)startRequestPaymentInfo{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyOrderApi buildOrderDetailPaymentInfo:self.mViewModel.billOrder.esc_orderid] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchPaymentInfo:responseObject];
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        
    }];
}

//获取客服状态
- (void)startRequestChatStatus{
    [self.chatNetworkClient_API beginRequest:[US_MyOrderApi buildChatStatusInfo:self.waybillOrder.sellerOnlyid storeId:self.waybillOrder.storeId] success:^(id responseObject) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_LiveChatStatus object:[US_LiveChatStatusModel yy_modelWithDictionary:responseObject]];
    } failure:^(UleRequestError *error) {
    }];
}

#pragma mark - <bottomView delegate>
- (void)footButtonClick:(OrderButtonState)state{
    switch (state) {
        case OrderButtonStateCanDelete:{
            [self deletOrderForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateCanPay:{
            [self didPayOrderForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateLogistic:{
            [self hanleLogisticInfoForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateCanComment:{
            [self didCommentOrderForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateCanRecive:{
            [self didSignOrderForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateCanCanCel:{
            [self didCancelOrderForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateCanQueryProcess:{
            [self didCheckChancelProcessForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateGroupDetail:{
            [self didGotoGroupByDetailForBillOrder:self.waybillOrder];
            break;
        }
        case OrderButtonStateSendout:{
            [self didToSendoutForBillOrder:self.waybillOrder];
            break;
        }
        default:
            break;
    }
}
#pragma mark - <private action>
//删除订单
- (void)deletOrderForBillOrder:(WaybillOrder *)billOrder{
    US_AlertView * alert=[US_AlertView alertViewWithTitle:@"" message:@"您确定删除该订单?" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    @weakify(self);
    alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
        @strongify(self);
        if (buttonIndex==1) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在删除"];
            @weakify(self);
            [self.networkClient_API beginRequest:[US_MyOrderApi buildDeletOrderWithId:billOrder.esc_orderid] success:^(id responseObject) {
                @strongify(self);
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"删除成功" afterDelay:2 withTarget:self dothing:@selector(notifyOrderStatusChanged)];
            } failure:^(UleRequestError *error) {
                @strongify(self);
                [self showErrorHUDWithError:error];
            }];
            [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"删除订单" networkdetail:@""];
        }
    };
    [alert showViewWithAnimation:AniamtionAlert];
}

- (void)notifyOrderStatusChanged{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//支付
- (void)didPayOrderForBillOrder:(WaybillOrder *)billOrder{
    //如果是使用跨店铺优惠券订单 先查询所有订单信息
    if ([billOrder.orderTag containsString:multiStoreOrderStatus]) {
        _orderPayAlert=nil;
        _orderPayAlert=[[US_MultiOrderPayAlertVC alloc] init];
        _orderPayAlert.orderId=billOrder.esc_orderid;
        _orderPayAlert.view.height=450;
        [_orderPayAlert.view showViewWithAnimation:AniamtionPresentBottom];
        @weakify(self);
        //确认一起支付
        _orderPayAlert.confirmBlock = ^(NSString * _Nonnull orderIds) {
             @strongify(self);
            [self GetPayLinkUrlWithId:orderIds businessType:billOrder.businessType];
        };
    }
    else{
        [self GetPayLinkUrlWithId:billOrder.esc_orderid businessType:billOrder.businessType];
    }
}
- (void)GetPayLinkUrlWithId:(NSString *)esc_orderid businessType:(NSString *)businessType{
    [LogStatisticsManager onClickLog:Order_ToBuy andTev:esc_orderid];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyOrderApi buildGetPayLinkUrlWithId:esc_orderid businessType:businessType] success:^(id responseObject) {
        @strongify(self);
        US_OrderPayModel * payModel=[US_OrderPayModel yy_modelWithDictionary:responseObject];
        NSString *url_str=[NSString stringWithFormat:@"%@", payModel.data.payUrl];
        NSMutableDictionary *params=@{@"key":url_str,
                                      KNeedShowNav:@YES,
                                      @"title":@"订单支付"
                                      }.mutableCopy;
        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
    [UleMbLogOperate addMbLogClick:esc_orderid moduleid:@"订单详情" moduledesc:@"去支付" networkdetail:@""];
}

//查看物流
- (void)hanleLogisticInfoForBillOrder:(WaybillOrder *)billOrder{
    if (billOrder.delevery.count>1) {
        NSMutableDictionary * dic=@{@"waybillOrder":billOrder}.mutableCopy;
        [self pushNewViewController:@"US_LogisticListVC" isNibPage:NO withData:dic];
    }else{
        DeleveryInfo * delvery=billOrder.delevery.firstObject;
        NSMutableDictionary * dic=@{@"logisticsId":NonEmpty(delvery.logisticsId),@"logisticsCode":NonEmpty(delvery.logisticsCode),@"package_id":NonEmpty(delvery.package_id),@"waybillOrder":billOrder}.mutableCopy;
        [self pushNewViewController:@"US_LogisticDetailVC" isNibPage:NO withData:dic];
    }
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"查看物流" networkdetail:@""];
}
//取消订单
- (void)didCancelOrderForBillOrder:(WaybillOrder *)billOrder{
    if ([billOrder.order_status isEqualToString:@"4"]&&[billOrder.orderTag containsString:sameCityOrderStatus]&& ![NonEmpty([UleStoreGlobal shareInstance].config.clientType) isEqualToString:@"ylxdsq"]) {
        //待配货且为同城订单
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
        @weakify(self);
        [self.networkClient_Ule beginRequest:[US_MyOrderApi buildOrderSameCityInfo:[NSString isNullToString:billOrder.sellerOnlyid] andOrderTag:[NSString isNullToString:billOrder.orderTag]] success:^(id responseObject) {
            @strongify(self);
            [UleMBProgressHUD hideHUDForView:self.view];
            NSDictionary *responseData=responseObject[@"data"];
            if (responseData) {
                NSString *tipStr=[NSString isNullToString:responseData[@"refundTip"]];
                NSString *phoneStr=[NSString isNullToString:responseData[@"registPhone"]];
                US_AlertView * alert=[US_AlertView alertViewWithTitle:@"温馨提示" message:tipStr cancelButtonTitle:@"取消" confirmButtonTitle:@"拨打电话"];
                alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
                    if (buttonIndex==1) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneStr]]];
                    }
                };
                [alert showViewWithAnimation:AniamtionAlert];
            }
        } failure:^(UleRequestError *error) {
            [UleMBProgressHUD hideHUDForView:self.view];
        }];
    }else {
        US_OrderCancelVC * cancelVC=[[US_OrderCancelVC alloc] init];
        cancelVC.m_Params=@{@"esc_orderid":billOrder.esc_orderid}.mutableCopy;
        [self presentViewController:cancelVC animated:YES completion:nil];
    }
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"我的订单" moduledesc:@"取消订单" networkdetail:@""];
}
//查看取消进度
- (void)didCheckChancelProcessForBillOrder:(WaybillOrder *)billOrder{
    NSString *jumpURL = [NSString stringWithFormat:@"%@", [billOrder toHtml5URL]];
    NSString *escOrderId = [NSString stringWithFormat:@"%@", [billOrder esc_orderid]];;
    if (jumpURL.length>0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@?escOrderId=%@", jumpURL, escOrderId];
        NSMutableDictionary *dic=@{@"key":urlStr,
                                   @"hasnavi":@"0"}.mutableCopy;
        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"查看取消进度" networkdetail:@""];
    }
}
//签收
- (void)didSignOrderForBillOrder:(WaybillOrder *)billOrder{
    US_AlertView * alert=[US_AlertView alertViewWithTitle:@"温馨提示" message:@"请确认实物商品是否已收到，如未收到，及时联系商家了解商品详情哦！" cancelButtonTitle:@"取消" confirmButtonTitle:@"确认签收"];
    alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
        if (buttonIndex==1) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在签收"];
            [LogStatisticsManager onClickLog:Order_Confirm andTev:billOrder.esc_orderid];
            @weakify(self);
            [self.networkClient_API beginRequest:[US_MyOrderApi buildSignOrderWithId:billOrder.esc_orderid] success:^(id responseObject) {
                @strongify(self);
                US_SignOrderModel * signOrder=[US_SignOrderModel yy_modelWithDictionary:responseObject];
                NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
                if (signOrder!=nil&&signOrder.data.length>0) {
                    [dic setObject:signOrder.data forKey:@"toHtml5URL"];
                }
                [dic setObject:@"7" forKey:@"orderStatus"];
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"签收成功" afterDelay:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil userInfo:dic];
                [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"确认签收" networkdetail:@""];
            } failure:^(UleRequestError *error) {
                @strongify(self);
                [self showErrorHUDWithError:error];
            }];
        }
    };
    [alert showViewWithAnimation:AniamtionAlert];
}
//去评论
- (void)didCommentOrderForBillOrder:(WaybillOrder *)billOrder{
    //TODO:
    NSMutableDictionary * dic=@{@"waybillOrder":billOrder}.mutableCopy;
    [self pushNewViewController:@"US_OrderCommentDetailVC" isNibPage:NO withData:dic];
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"去评论" networkdetail:@""];
}
//拼团详情
- (void)didGotoGroupByDetailForBillOrder:(WaybillOrder *)billOrder{
    NSMutableDictionary *params=@{@"key":billOrder.groupBuyingUrl,
                                  KNeedShowNav:@YES,
                                  @"title":@"团购详情"
                                  }.mutableCopy;
    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"拼团详情" networkdetail:@""];
}
//发货
- (void)didToSendoutForBillOrder:(WaybillOrder *)billOrder{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uleMerchant://"]]){
        //商品详情
        NSString *str = [NSString stringWithFormat:@"uleMerchant://OrderDetailViewController:%@",[NSString isNullToString:billOrder.esc_orderid]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id684673362"]];
    };
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:@"订单详情" moduledesc:@"发货" networkdetail:@""];
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (US_OrderDetailViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_OrderDetailViewModel alloc] init];
        
    }
    return _mViewModel;
}

- (US_OrderDetailHeadView *)headerView{
    if (!_headerView) {
        _headerView=[[US_OrderDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 95)];
    }
    return _headerView;
}
- (US_OrderDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[US_OrderDetailBottomView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kStatusBarHeight==20?49:49+34)];
        _bottomView.delegate=self;
    }
    return _bottomView;
}

- (UleNetworkExcute *)chatNetworkClient_API{
    if (!_chatNetworkClient_API) {
        _chatNetworkClient_API=[[UleNetworkExcute alloc] init];
        _chatNetworkClient_API.tManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    return _chatNetworkClient_API;
}
@end
