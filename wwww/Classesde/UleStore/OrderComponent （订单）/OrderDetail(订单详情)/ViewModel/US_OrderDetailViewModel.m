
//
//  US_OrderDetailViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailViewModel.h"
#import "UleSectionBaseModel.h"
#import "US_OrderDetailAddressCellModel.h"
#import "US_OrderDetailLogisticCellModel.h"
#import "US_ExpressInfo.h"
#import "US_OrderListCellModel.h"
#import "USGoodsPreviewManager.h"
#import "US_OrderDetailCarModel.h"
#import "US_OrderPayInfoModel.h"
#import "US_OrderDetailPayinfoCellModel.h"
#import "US_OrderDetailSectionModel.h"
#import "US_AlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_OrderDetail.h"
@interface US_OrderDetailViewModel ()
@property (nonatomic, strong)UleNetworkExcute   *networkClient_API;
@property (nonatomic, strong)UleNetworkExcute   *networkClient_Ule;
@end

@implementation US_OrderDetailViewModel

- (void)fetchOrderDetailInfo:(WaybillOrder *)billOrder andOrderListType:(US_OrderListType)orderListType{
    if (self.mDataArray) {
        [self.mDataArray removeAllObjects];
    }
    self.billOrder=billOrder;
    //构建地址栏Section
    UleSectionBaseModel * sectionOne=[[UleSectionBaseModel alloc] init];
    sectionOne.footHeight=10;
    if ([self isShowLogistcsCell]) {
        US_OrderDetailLogisticCellModel * logisticsCell=[[US_OrderDetailLogisticCellModel alloc] initWithCellName:@"US_OrderDetailLogisticsCell"];
        logisticsCell.packageInfo = [NSString stringWithFormat:@"该订单已经拆分成%@个包裹, 点击”查看物流”可查看详情", @(self.billOrder.delevery.count)];
        logisticsCell.timeStr=@"  ";
        @weakify(self);
        logisticsCell.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self logisticsCellClickAction];
        };
        [sectionOne.cellArray addObject:logisticsCell];
    }
    US_OrderDetailAddressCellModel * addressCell=[[US_OrderDetailAddressCellModel alloc] initWithBillOrderInfo:billOrder];
    [sectionOne.cellArray addObject:addressCell];
    
    int count = 0;
    //构建订单信息Section
    US_OrderDetailSectionModel * sectionTwo=[[US_OrderDetailSectionModel alloc] init];
    sectionTwo.orderListType=orderListType;
    sectionTwo.headViewName=@"US_OrderDetailSectionHeadView";
    sectionTwo.headData=billOrder;
    sectionTwo.headHeight=50;
    sectionTwo.footViewName=@"US_OrderDetailSectionFootView";
    sectionTwo.footHeight=50;
    sectionTwo.footData=billOrder;
    @weakify(self);
    @weakify(sectionTwo);
    sectionTwo.clickActionBlock = ^{
        @strongify(self);
        @strongify(sectionTwo);
        [self sectionHeadActionWithModel:sectionTwo];
    };
    for (int i=0; i<billOrder.delevery.count; i++) {
        DeleveryInfo * delevery=billOrder.delevery[i];
        for (int j=0; j<delevery.prd.count; j++) {
            PrdInfo * prdInfo=delevery.prd[j];
            US_OrderListCellModel * orderListCellModel=[[US_OrderListCellModel alloc] initWithOrderListData:prdInfo];
            orderListCellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:prdInfo.listing_id  andSearchKeyword:@"" andPreviewType:@"6" andHudVC:(UleBaseViewController *)[UIViewController currentViewController]];
            };
            orderListCellModel.replaceBtnSameCityBlock = ^{
                @strongify(self);
                [self showSameCityTipWithMerchantId:billOrder.sellerOnlyid andOrderTag:billOrder.orderTag];
            };
            orderListCellModel.isOrdeDetailList=YES;
            orderListCellModel.esc_orderId=billOrder.esc_orderid;
            orderListCellModel.deleveryOrderid=delevery.delevery_order_id;
            orderListCellModel.order_tag=billOrder.orderTag;
            [sectionTwo.cellArray addObject:orderListCellModel];
            count += prdInfo.product_num.intValue;
        }
    }
    NSString *totalCountStr = [NSString stringWithFormat:@"%d件", count];
    NSString *totalPriceStr = [NSString stringWithFormat:@"¥%.2f", [billOrder.productAmount doubleValue]];
    NSString *freightStr = [NSString stringWithFormat:@"¥%.2f", [billOrder.transAmount doubleValue]];
    NSArray *payinfoTitles=@[@"数量总计", @"商品总额", @"运费"];
    NSArray *payinfoContents=@[totalCountStr, totalPriceStr, freightStr];
    for (int i=0; i<payinfoTitles.count; i++) {
        US_OrderDetailPayinfoCellModel *payinfoCellModel=[[US_OrderDetailPayinfoCellModel alloc]initWithCellName:@"US_OrderDetailPayinfoCell"];
        payinfoCellModel.titleName=payinfoTitles[i];
        payinfoCellModel.contentName=payinfoContents[i];
        payinfoCellModel.isFirstCell=(i==0?YES:NO);
        [sectionTwo.cellArray addObject:payinfoCellModel];
    }
    //构建订单号以及时间的Section
    UleSectionBaseModel * sectionThree=[[UleSectionBaseModel alloc] init];
    sectionThree.headHeight=10;
    sectionThree.footHeight=5;
    UleCellBaseModel * threeSectionCellModel=[[UleCellBaseModel alloc]initWithCellName:@"US_OrderDetailOrderNumberCell"];
    threeSectionCellModel.data=billOrder;
    [sectionThree.cellArray addObject:threeSectionCellModel];
    //装配到数据源中
    [self.mDataArray addObject:sectionOne];
    [self.mDataArray addObject:sectionTwo];
    //车险车贷
    if ([billOrder.orderTag containsString:carOrderStatus]&&[NSString isNullToString:billOrder.carLoanInsure].length>0) {
        UleSectionBaseModel *insureSection = [[UleSectionBaseModel alloc]init];
        UleCellBaseModel * carInsureCellModel=[[UleCellBaseModel alloc]initWithCellName:@"US_OrderDetailCarInsureCell"];
        carInsureCellModel.data=[NSString isNullToString:self.billOrder.carLoanInsure];
        [insureSection.cellArray addObject:carInsureCellModel];
        [self.mDataArray addObject:insureSection];
    }
    //订单备注
    if ([billOrder.myOrder isEqualToString:@"1"]&&[NSString isNullToString:billOrder.buyerNote3].length>0) {
        UleSectionBaseModel *remarkSection=[[UleSectionBaseModel alloc]init];
        remarkSection.headHeight=10;
        UleCellBaseModel *remarkCelleModel=[[UleCellBaseModel alloc]initWithCellName:@"US_OrderDetailRemarkCell"];
        remarkCelleModel.data=[NSString isNullToString:billOrder.buyerNote3];
        [remarkSection.cellArray addObject:remarkCelleModel];
        [self.mDataArray addObject:remarkSection];
    }
    [self.mDataArray addObject:sectionThree];
    if(self.sucessBlock){
        self.sucessBlock(self.mDataArray);
    }
}

- (void)fechOrderDetailPaymentsInfo:(NSDictionary *)dic{
    US_OrderDetail * orderDetail=[US_OrderDetail yy_modelWithDictionary:dic];
    for (UleSectionBaseModel * model in self.mDataArray) {
           if ([model.headViewName isEqualToString:@"US_OrderDetailSectionHeadView"]) {
               UleSectionBaseModel * sectionTwo=model;
               //抵扣
               if ([orderDetail.data.proBenefits floatValue]>0) {
                   US_OrderDetailPayinfoCellModel *payinfoCellModel=[[US_OrderDetailPayinfoCellModel alloc]initWithCellName:@"US_OrderDetailPayinfoCell"];
                   payinfoCellModel.titleName=@"促销抵扣：";
                   payinfoCellModel.contentName=[NSString stringWithFormat:@"-¥%.2f", [orderDetail.data.proBenefits floatValue]];
                   payinfoCellModel.isFirstCell=NO;
                   [sectionTwo.cellArray addObject:payinfoCellModel];
               }
               //所有支付相关:优惠券 运费券 跨店券 鼓励金
               for (int i=0; i<orderDetail.data.payments4Coupon.count; i++) {
                   OrderDetailPayments * paymentsItem=[orderDetail.data.payments4Coupon objectAt:i];
                   US_OrderDetailPayinfoCellModel *payinfoCellModel=[[US_OrderDetailPayinfoCellModel alloc]initWithCellName:@"US_OrderDetailPayinfoCell"];
                   payinfoCellModel.titleName=paymentsItem.name;
                   payinfoCellModel.contentName=[NSString stringWithFormat:@"-¥%.2f", [paymentsItem.amount doubleValue]];
                   payinfoCellModel.isFirstCell=NO;
                   [sectionTwo.cellArray addObject:payinfoCellModel];
               }
               self.billOrder.userPayAmount=orderDetail.data.userPayAmount;
               sectionTwo.footData=self.billOrder;
           }
       }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)fetchLogistcInfo:(NSDictionary *)dic{
    US_ExpressInfo * logisticInfo=[US_ExpressInfo yy_modelWithDictionary:dic];
    if (logisticInfo) {
        UleSectionBaseModel * sectonOne=self.mDataArray.firstObject;
        US_OrderDetailLogisticCellModel * logisticsCell;
        if ([sectonOne.cellArray.firstObject isKindOfClass:[US_OrderDetailLogisticCellModel class]]) {
            logisticsCell=sectonOne.cellArray.firstObject;
            US_ExpressListMap *mapModel;
            if (logisticInfo.data.map.expressData.myArrayList.count > 0) {
                mapModel = logisticInfo.data.map.expressData.myArrayList[0];
            }
            if ([NSString isNullToString:mapModel.map.content].length > 0) {
                if (self.billOrder.delevery.count == 1) {
                    logisticsCell.packageInfo = [NSString stringWithFormat:@"%@", mapModel.map.content];
                }else{
                    logisticsCell.packageInfo = [NSString stringWithFormat:@"该订单已经拆分成%@个包裹, 点击”查看物流”可查看详情", @(self.billOrder.delevery.count)];
                }
                logisticsCell.timeStr=[NSString stringWithFormat:@"%@", mapModel.map.dealTime];
            } else {
                if (self.billOrder.delevery.count == 1) {
                    logisticsCell.noLogisticInfo = [NSString stringWithFormat:@"暂无物流信息\n物流公司：%@\n包裹号：%@", [self.billOrder.delevery[0] logisticsName], [self.billOrder.delevery[0] package_id]];
                }
            }
        }
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)fetchCarInof:(NSDictionary *)dic{
    US_OrderDetailCarModel * carModel=[US_OrderDetailCarModel yy_modelWithDictionary:dic];
    if (carModel&&carModel.data) {
        //构建订单号以及时间的Section
        UleSectionBaseModel * sectionCarInfo=[[UleSectionBaseModel alloc] init];
        sectionCarInfo.headHeight=10;
        UleCellBaseModel * carCellModel=[[UleCellBaseModel alloc]initWithCellName:@"US_OrderDetailCarListCell"];
        carCellModel.data=carModel.data;
        [sectionCarInfo.cellArray addObject:carCellModel];
        if (self.mDataArray.count>=3) {
            [self.mDataArray insertObject:sectionCarInfo atIndex:self.mDataArray.count-2];
        }
        if (self.sucessBlock) {
            self.sucessBlock(self.mDataArray);
        }
    }
}

- (void)fetchCarQR:(NSString *)jsonStr{
    if (jsonStr.length<=0) {
        return;
    }
    //构建二维码
    UleSectionBaseModel * sectionCarQR=[[UleSectionBaseModel alloc] init];
    sectionCarQR.footHeight=10;
    UleCellBaseModel *cellModel=[[UleCellBaseModel alloc]initWithCellName:@"US_OrderDetailCarQRCell"];
    cellModel.data=jsonStr;
    [sectionCarQR.cellArray addObject:cellModel];
    if (self.mDataArray.count>=2) {
        [self.mDataArray insertObject:sectionCarQR atIndex:1];
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)fetchPaymentInfo:(NSDictionary *)dic{
    if (self.mDataArray.count<2) {
        return;
    }
    UleSectionBaseModel *sectionTwo=[self.mDataArray objectAt:1];
    US_OrderPayInfoModel *model=[US_OrderPayInfoModel yy_modelWithDictionary:dic];
    for (OrderPayInfoPayments *payItem in model.data.payments) {
        US_OrderDetailPayinfoCellModel *payinfoCellModel=[[US_OrderDetailPayinfoCellModel alloc]initWithCellName:@"US_OrderDetailPayinfoCell"];
        payinfoCellModel.titleName=[NSString stringWithFormat:@"%@:", [NSString isNullToString:payItem.name]];;
        payinfoCellModel.contentName=[NSString stringWithFormat:@"¥%.2f", [NSString isNullToString:payItem.amount].doubleValue];
        [sectionTwo.cellArray addObject:payinfoCellModel];
    }
}

- (void)sectionHeadActionWithModel:(US_OrderDetailSectionModel*)model{
    WaybillOrder *billOrder=model.headData;
    if ([NSString isNullToString:model.ownOrderMerchantPhoneNum].length>0) {
        [self showAlertView:[NSString isNullToString:model.ownOrderMerchantPhoneNum]];
    }else if ([NSString isNullToString:billOrder.sellerOnlyid].length>0){
        //请求接口
        [UleMBProgressHUD showHUDWithText:@""];
        @weakify(self);
        [self.networkClient_API beginRequest:[US_MyOrderApi buildOrderDetailMerchantInfo:[NSString isNullToString:billOrder.sellerOnlyid]] success:^(id responseObject) {
            @strongify(self);
            [UleMBProgressHUD hideHUD];
            NSDictionary *responseData=[responseObject objectForKey:@"data"];
            NSString *phoneNum=[responseData objectForKey:@"registPhone"];
            if (phoneNum&&phoneNum.length>0) {
                model.ownOrderMerchantPhoneNum=phoneNum;
                [self showAlertView:phoneNum];
            }
        } failure:^(UleRequestError *error) {
            @strongify(self);
            [self showErrorHud:error];
        }];
    }else{
        [UleMBProgressHUD showHUDWithText:@"未获取到商家信息" afterDelay:1.5];
    }
}

- (void)showSameCityTipWithMerchantId:(NSString *)merchantId andOrderTag:(NSString *)orderTag{
    //待配货且为同城订单
    [UleMBProgressHUD showHUDWithText:@"加载中..."];
    [self.networkClient_Ule beginRequest:[US_MyOrderApi buildOrderSameCityInfo:[NSString isNullToString:merchantId] andOrderTag:[NSString isNullToString:orderTag]] success:^(id responseObject) {
        [UleMBProgressHUD hideHUD];
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
        [UleMBProgressHUD hideHUD];
    }];
}

-(void)showAlertView:(NSString *)message{
    if (kSystemVersion>=10.2) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",message]] options:@{} completionHandler:nil];
        }
    }else {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"拨打电话" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",message]]];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:sureAction];
        [alertControl addAction:cancelAction];
        [[UIViewController currentViewController] presentViewController:alertControl animated:YES completion:^{
        }];
    }
}

- (void)showErrorHud:(UleRequestError *)error
{
    NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
    if ([NSString isNullToString:errorInfo].length>0) {
        [UleMBProgressHUD showHUDWithText:errorInfo afterDelay:1.5];
    }else [UleMBProgressHUD hideHUD];
}

- (CGFloat)caculateFooterViewHeight:(US_OrderListFooterModel *)footerModel{
    CGFloat footHeight=0;
    if (footerModel.buttonOneState!=OrderButtonStateHidden||footerModel.buttonTwoState!=OrderButtonStateHidden||footerModel.buttonThreeState!=OrderButtonStateHidden) {
        footHeight=kStatusBarHeight==20?49:83;
    }
    return footHeight;
}

- (void)logisticsCellClickAction{
    if (self.billOrder.delevery.count>1) {
        NSMutableDictionary * dic=@{@"waybillOrder":self.billOrder}.mutableCopy;
        [[UIViewController currentViewController] pushNewViewController:@"US_LogisticListVC" isNibPage:NO withData:dic];
    }else{
        DeleveryInfo * delvery=self.billOrder.delevery.firstObject;
        NSMutableDictionary * dic=@{@"logisticsId":NonEmpty(delvery.logisticsId),@"logisticsCode":NonEmpty(delvery.logisticsCode),@"package_id":NonEmpty(delvery.package_id),@"waybillOrder":self.billOrder}.mutableCopy;
        [[UIViewController currentViewController] pushNewViewController:@"US_LogisticDetailVC" isNibPage:NO withData:dic];
    }
}

- (BOOL)isShowLogistcsCell{
    BOOL isShow=NO;
    DeleveryInfo * deleveryInfo;
    for (int i = 0; i < self.billOrder.delevery.count; i++) {
        deleveryInfo=self.billOrder.delevery[i];
    }
    if (![self.billOrder.orderTag containsString:carOrderStatus] && deleveryInfo&&deleveryInfo.package_id && ![deleveryInfo.package_id isEqualToString:@""] && ![deleveryInfo.package_id isEqualToString:@"无"]) {
        isShow=YES;
    }
    return isShow;
}

- (US_OrderDetailHeadViewModel *)getHeaderModel{
    US_OrderDetailHeadViewModel * model=[[US_OrderDetailHeadViewModel alloc] init];
    model.statuImageName=[self getOrderStateImg:self.billOrder.order_status];
    model.statuStr= [self getOrderState:self.billOrder.order_status];
    model.subStatusStr=[self getOrderStateStr:self.billOrder.order_status];
    return model;
}

- (UleRequest *)getSearchLogisticRequest{
    DeleveryInfo * deleveryInfo;
    for (int i = 0; i < self.billOrder.delevery.count; i++) {
        deleveryInfo=self.billOrder.delevery[i];
    }
    NSString * logisticsId= NonEmpty(deleveryInfo.logisticsId);
    NSString * logisticsCode=NonEmpty(deleveryInfo.logisticsCode);
    NSString * packageId=NonEmpty(deleveryInfo.package_id);
    UleRequest * request=[US_MyOrderApi buildSearchLogisticWithId:logisticsId code:logisticsCode andPackageId:packageId];
    return request;
}

- (NSString *)getOrderStateImg:(NSString *)state {
    NSString *orderState = nil;
    switch (state.integerValue) {
        case 1:
            orderState = @"order_canceled";
            break;
        case 2:
            orderState = @"order_back";
            break;
        case 3:
            orderState = @"order_obligation";
            break;
        case 4:
            orderState = @"order_distribution";
            break;
        case 5:
            orderState = @"order_to_sign_for";
            break;
        case 7:
            orderState = @"order_completed";
            break;
        default:
            orderState = @"";
            break;
    }
    return orderState;
}

//根据小订单状态返回提示语
- (NSString *)getOrderState:(NSString *)state {
    NSString *orderState = nil;
    switch (state.integerValue) {
        case 0:
            orderState = @"交易完成";
            break;
        case 1:
            orderState = @"已取消";
            break;
        case 2:
            orderState = @"已退换货";
            break;
        case 3:
            orderState = @"待付款";
            break;
        case 4:
            orderState = @"待配货";
            break;
        case 5:
            orderState = @"待签收";
            break;
        case 6:
            orderState = @"配货完成";
            break;
        case 7:
            orderState = @"已签收";
            break;
        case 8:
            orderState = @"未签收";
            break;
        case 9:
            orderState  =@"已取消";
            break;
        default:
            orderState = @"";
            break;
    }
    return orderState;
}

- (NSString *)getOrderStateStr:(NSString *)stateStr {
    NSString *orderState = nil;
    switch (stateStr.integerValue) {
        case 1:
            orderState = @"您的订单已关闭";
            break;
        case 2:
            orderState = @"退货成功, 货款将返还原账户";
            break;
        case 3:
            orderState = @"订单未支付, 请尽快支付";
            break;
        case 4:
            orderState = @"商家正在努力配货中";
            break;
        case 5:
            orderState = @"包裹正在赶来的路上";
            break;
        case 7:
            orderState = @"您的购物已完成";
            break;
        default:
            orderState = @"";
            break;
    }
    return orderState;
}

- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}
- (UleNetworkExcute *)networkClient_Ule{
    if (!_networkClient_Ule) {
        _networkClient_Ule=[US_NetworkExcuteManager uleServerRequestClient];
    }
    return _networkClient_Ule;
}

@end
