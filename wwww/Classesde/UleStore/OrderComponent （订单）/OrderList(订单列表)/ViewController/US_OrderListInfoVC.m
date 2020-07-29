//
//  US_OrderListInfoVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListInfoVC.h"
#import "US_MyOrderApi.h"
#import "US_OrderListViewModel.h"
#import "UleBasePageViewController.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_OrderListSectionFooter.h"
#import "US_OrderListSectionHeader.h"
#import "US_AlertView.h"
#import "US_OrderPayModel.h"
#import "US_OrderCancelVC.h"
#import "US_MultiOrderPayAlertVC.h"
#import "UIView+ShowAnimation.h"
#import <ModuleYLXD/UleCTMediator+ModuleYLXD.h>
#define kOrderStatusDic  @{@"全部订单":@"1",@"待付款":@"3",@"待发货":@"4",@"待签收":@"5"}

@interface US_OrderListInfoVC ()<US_OrderListSectionFooterDelegate,US_OrderListSectionHeaderDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_OrderListViewModel * mViewModel;
@property (nonatomic, strong) NSString * orderFlag;//3:客户订单 ，  2:我的订单
@property (nonatomic, strong) NSString * orderStatus;//1:全部订单 3:待付款  4:待发货  5:待签收
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) NSString * keywords;
@property (nonatomic, assign) US_OrderListType  orderListType;
@property (nonatomic, strong) US_MultiOrderPayAlertVC * orderPayAlert;
@property (nonatomic, strong) NSString * actCode;//接龙活动订单 活动code
@property (nonatomic, assign) BOOL fromSearch; //从搜索进入
@end

@implementation US_OrderListInfoVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginUpdateOrderList:) name:NOTI_UpdateOrderList object:nil];
}
- (void)setUI{
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    [self.view addSubview:self.mNoItemsBgView];
    self.mNoItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    @weakify(self);
    self.mViewModel.sucessBlock = ^(NSArray * mdataArray) {
        @strongify(self);
        self.mNoItemsBgView.hidden=mdataArray.count<=0?NO:YES;
        [self layoutSearchEmptyPlaceHolderView];
        [self.mTableView reloadData];
    };
    self.orderFlag=[self.m_Params objectForKey:@"orderFlag"];
    self.orderListType=[[self.m_Params objectForKey:@"orderListType"] integerValue];
    self.orderStatus= kOrderStatusDic[self.title];
    self.actCode=[self.m_Params objectForKey:@"actCode"];
//    if (self.actCode.length>0) {
//        if ([self.orderStatus isEqualToString:@"1"]) {
//            self.mNoItemsBgView.titleLabel.text=@"此接龙下暂无客户订单";
//        }else{
//            self.mNoItemsBgView.titleLabel.text=[NSString stringWithFormat:@"此接龙下暂无%@订单哦",self.title];
//        }
//    } else {
//        if ([self.orderStatus isEqualToString:@"1"]) {
//            self.mNoItemsBgView.titleLabel.text=[NSString stringWithFormat:@"您暂时还没有%@订单哦",[self.orderFlag isEqualToString:@"3"]?@"客户":@""];
//        }else{
//            self.mNoItemsBgView.titleLabel.text=[NSString stringWithFormat:@"您暂时还没有%@订单哦",self.title];
//        }
//    }
}

#pragma mark - <>
- (void)didStartLoadData:(NSNotification *)notify{
    if (self.mViewModel.mDataArray.count<=0) {
        self.start=1;
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
        [self beginRequestOrderListFromStart:[NSString stringWithFormat:@"%@",@(self.start)]];
    }
}

- (void)beginUpdateOrderList:(NSNotification *)notify{
    [self performSelector:@selector(beginRefreshHeader) withObject:nil afterDelay:1];
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.start=1;
    [self beginRequestOrderListFromStart:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRefreshFooter{
    self.start++;
    [self beginRequestOrderListFromStart:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)endRefreshAnimation{
    [self.mTableView.mj_header endRefreshing];
    if (self.mViewModel.isEndRefreshFooter) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}
#pragma mark - <http>
- (void)requestOrderListForKeyWords:(NSString *) keyword{
    self.fromSearch = YES;
    self.keywords=keyword;
    [self beginRefreshHeader];
}
- (void)layoutSearchEmptyPlaceHolderView
{
    if (self.fromSearch) {
        self.mNoItemsBgView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noSearch"];
        self.mNoItemsBgView.titleLabel.text = @"未能搜到您查找的信息";
        self.mNoItemsBgView.clickBtn.hidden = YES;
    }
}

//获取订单列表
- (void)beginRequestOrderListFromStart:(NSString *)startIndex{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyOrderApi buildOrderListWithStatus:self.orderStatus flag:self.orderFlag startIndex:startIndex andKeyWord:NonEmpty(self.keywords) andOrderListType:self.orderListType ActCode:self.actCode] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        if (self.actCode.length>0 && self.orderStatus.integerValue==1) {
            NSDictionary * dic=responseObject[@"orderInfo"];
            NSNumber * orderAmount=dic[@"orderAmount"];
            NSNumber * orderCount=dic[@"order_count"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSolitaireOrderCount" object:nil userInfo:@{@"orderAmount":[NSString stringWithFormat:@"%@",NonEmpty(orderAmount)],@"orderCount":[NSString stringWithFormat:@"%@",NonEmpty(NonEmpty(orderCount))]}];
        }
        [self.mViewModel fetchOrderListInfo:responseObject andOrderListType:self.orderListType andOrderFlag:self.orderFlag andOrderType:self.orderStatus atStart:self.start];
        self.mTableView.mj_footer.alpha=1.0;
        [self.mTableView.mj_header endRefreshing];
        [self endRefreshAnimation];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        if (self.mViewModel.mDataArray.count <= 0) {
            self.mNoItemsBgView.hidden=NO;
            [self layoutSearchEmptyPlaceHolderView];
        }
        [self endRefreshAnimation];
    }];
}

#pragma mark - <Foot and head delegate>
- (void)headViewClickWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    [self.mViewModel cellDidClickWithWaybillOrder:sectionModel.sectionData];
}
- (void)footButtonClick:(OrderButtonState)state sectionModel:(nonnull US_OrderListSectionModel *)sectionModel{
//    NSLog(@"state==%@",@(state));
    switch (state) {
        case OrderButtonStateCanDelete:{
            [self deletOrderForSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateCanPay:{
            [self didPayOrderForSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateLogistic:{
            [self hanleLogisticInfoForSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateCanComment:{
            [self didCommentOrderWithSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateCanRecive:{
            [self didSignOrderWithSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateCanCanCel:{
            [self didCancelOrderForSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateCanQueryProcess:{
            [self didCheckChancelProcessSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateGroupDetail:{
            [self didGotoGroupByDetailWithSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateSendout:{
            [self didToSendoutWithSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateRemindDelevery:{
            [self didRemindDeleveryWithSectionModel:sectionModel];
            break;
        }
        case OrderButtonStateRemindDeleveryDisable:{
            
            break;
        }
        default:
            break;
    }
}
#pragma mark - <private 删除 取消 支付 取消进度 签收 去评论>
//删除订单
- (void)deletOrderForSectionModel:(US_OrderListSectionModel *)sectionModel{
    US_AlertView * alert=[US_AlertView alertViewWithTitle:@"" message:@"您确定删除该订单?" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
        if (buttonIndex==1) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在删除"];
            WaybillOrder *billOrder=sectionModel.sectionData;
            @weakify(self);
            [self.networkClient_API beginRequest:[US_MyOrderApi buildDeletOrderWithId:billOrder.esc_orderid] success:^(id responseObject) {
                @strongify(self);
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"删除成功" afterDelay:2];
                [self.mViewModel deletSectionModel:sectionModel];
            } failure:^(UleRequestError *error) {
                @strongify(self);
                [self showErrorHUDWithError:error];
            }];
            [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"删除订单" networkdetail:@""];
        }
    };
    [alert showViewWithAnimation:AniamtionAlert];

}
//支付
- (void)didPayOrderForSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
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
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyOrderApi buildGetPayLinkUrlWithId:esc_orderid businessType:businessType] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
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
    [UleMbLogOperate addMbLogClick:esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"去支付" networkdetail:@""];
}
//查看物流
- (void)hanleLogisticInfoForSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
    if (billOrder.delevery.count>1) {
        NSMutableDictionary * dic=@{@"waybillOrder":billOrder}.mutableCopy;
        [self pushNewViewController:@"US_LogisticListVC" isNibPage:NO withData:dic];
    }else{
        DeleveryInfo * delvery=billOrder.delevery.firstObject;
        NSMutableDictionary * dic=@{@"logisticsId":NonEmpty(delvery.logisticsId),@"logisticsCode":NonEmpty(delvery.logisticsCode),@"package_id":NonEmpty(delvery.package_id),@"waybillOrder":billOrder}.mutableCopy;
        [self pushNewViewController:@"US_LogisticDetailVC" isNibPage:NO withData:dic];
    }
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"查看物流" networkdetail:@""];
}
//取消订单
- (void)didCancelOrderForSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
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
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"取消订单" networkdetail:@""];
}
//查看取消进度
- (void)didCheckChancelProcessSectionModel:(US_OrderListSectionModel *)sectonModel{
    WaybillOrder * billOrder=sectonModel.sectionData;
    NSString *jumpURL = [NSString stringWithFormat:@"%@", [billOrder toHtml5URL]];
    NSString *escOrderId = [NSString stringWithFormat:@"%@", [billOrder esc_orderid]];;
    if (jumpURL.length>0) {
        NSString *urlStr = [NSString stringWithFormat:@"%@?escOrderId=%@", jumpURL, escOrderId];
        NSMutableDictionary *dic=@{@"key":urlStr,
                                   @"hasnavi":@"0"}.mutableCopy;
        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"查看取消进度" networkdetail:@""];
    }
}
//签收
- (void)didSignOrderWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    US_AlertView * alert=[US_AlertView alertViewWithTitle:@"温馨提示" message:@"请确认实物商品是否已收到，如未收到，及时联系商家了解商品详情哦！" cancelButtonTitle:@"取消" confirmButtonTitle:@"确认签收"];
    alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
        if (buttonIndex==1) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在签收"];
            WaybillOrder *billOrder=sectionModel.sectionData;
            [LogStatisticsManager onClickLog:Order_Confirm andTev:billOrder.esc_orderid];
            @weakify(self);
            [self.networkClient_API beginRequest:[US_MyOrderApi buildSignOrderWithId:billOrder.esc_orderid] success:^(id responseObject) {
                @strongify(self);
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"签收成功" afterDelay:2];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil];
            } failure:^(UleRequestError *error) {
                @strongify(self);
                [self showErrorHUDWithError:error];
            }];
            [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"确认签收" networkdetail:@""];
        }
    };
    [alert showViewWithAnimation:AniamtionAlert];
}
//去评论
- (void)didCommentOrderWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    //TODO:
    WaybillOrder *billOrder=sectionModel.sectionData;
    NSMutableDictionary * dic=@{@"waybillOrder":billOrder}.mutableCopy;
    [self pushNewViewController:@"US_OrderCommentDetailVC" isNibPage:NO withData:dic];
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"去评论" networkdetail:@""];
}
//拼团详情
- (void)didGotoGroupByDetailWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
    NSMutableDictionary *params=@{@"key":billOrder.groupBuyingUrl,
                                  KNeedShowNav:@YES,
                                  @"title":@"团购详情"
                                  }.mutableCopy;
    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"拼团详情" networkdetail:@""];
}
//发货
- (void)didToSendoutWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uleMerchant://"]]){
        //商品详情
        NSString *str = [NSString stringWithFormat:@"uleMerchant://OrderDetailViewController:%@",[NSString isNullToString:billOrder.esc_orderid]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id684673362"]];
    };
    [UleMbLogOperate addMbLogClick:billOrder.esc_orderid moduleid:[self.orderFlag isEqualToString:@"3"]?@"我的订单":@"客户订单" moduledesc:@"发货" networkdetail:@""];
}
//提醒发货
- (void)didRemindDeleveryWithSectionModel:(US_OrderListSectionModel *)sectionModel{
    WaybillOrder *billOrder=sectionModel.sectionData;
    [LogStatisticsManager onClickLog:Order_RemindShip andTev:billOrder.esc_orderid];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    [self.networkClient_API beginRequest:[US_MyOrderApi buildRemindDeleveryWithOrderId:[NSString isNullToString:billOrder.esc_orderid]] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString *remindMsg=@"提醒成功";
        if ([NSString isNullToString:[responseObject objectForKey:@"returnMessage"]].length>0) {
            remindMsg=[NSString isNullToString:[responseObject objectForKey:@"returnMessage"]];
        }
        [UleMBProgressHUD showHUDWithText:remindMsg afterDelay:1.5];
        sectionModel.footerModel.buttonOneState=OrderButtonStateRemindDeleveryDisable;
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
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

- (US_OrderListViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_OrderListViewModel alloc] init];
        _mViewModel.rootVC=self;
    }
    return _mViewModel;
}

- (US_EmptyPlaceHoldView *)mNoItemsBgView{
    if (!_mNoItemsBgView) {
        _mNoItemsBgView=[[US_EmptyPlaceHoldView alloc] init];
        _mNoItemsBgView.hidden=YES;
        _mNoItemsBgView.titleLabel.text = @"还没有订单记录哦~";
        _mNoItemsBgView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noOrder"];
        _mNoItemsBgView.clickBtnText = @"去赚钱";
        _mNoItemsBgView.btnClickBlock = ^{
            [[UleCTMediator sharedInstance] uleMediator_earnMoneyBtnAction];
        };
        @weakify(self);
        _mNoItemsBgView.clickEvent = ^{
            @strongify(self);
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
            [self beginRefreshHeader];
        };
    }
    return _mNoItemsBgView;
}

@end
