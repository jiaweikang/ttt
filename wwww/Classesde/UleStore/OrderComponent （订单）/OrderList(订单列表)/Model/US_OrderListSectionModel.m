//
//  US_OrderListSectionModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListSectionModel.h"

@implementation US_OrderListHeaderModel



@end

@implementation US_OrderListFooterModel

- (instancetype)initWithBillOrder:(WaybillOrder *)billOrder pageViewType:(OrderListFooterViewType)viewType{
    self = [super init];
    if (self) {
        self.buttonOneState=OrderButtonStateHidden;
        self.buttonTwoState=OrderButtonStateHidden;
        self.buttonThreeState=OrderButtonStateHidden;
        NSString *myOder=[NSString stringWithFormat:@"%@", billOrder.myOrder];
        BOOL isOwnOrder=NO;//是否是我的订单；
        if ([myOder isEqualToString:@"0"]) {
            isOwnOrder=NO;
        }else if([myOder isEqualToString:@"1"]){
            isOwnOrder=YES;
        }
        if (isOwnOrder) {
            
            //第一个按键状态包括（提醒发货 支付 签收 评论）
            NSString * isCanPay=billOrder.order_status;
            NSString * isComfirmOrder=billOrder.isConfirmOrder;
            NSString * isCanCommentOrder=billOrder.isOrderComment;
            if (viewType==OrderListFooterViewTypeList) {
                if ([billOrder.showDeliveryBtn intValue]==1) {
                    self.buttonOneState=OrderButtonStateRemindDelevery;
                }else if ([billOrder.showDeliveryBtn intValue]==2) {
                    self.buttonOneState=OrderButtonStateRemindDeleveryDisable;
                }
            }
            if ([isCanPay isEqualToString:@"3"]&&![billOrder.orderType isEqualToString:@"3108"]) {
                self.buttonOneState=OrderButtonStateCanPay;
            }
            if ([isComfirmOrder boolValue]&&isComfirmOrder.length>0) {
                self.buttonOneState=OrderButtonStateCanRecive;
            }
            if ([isCanCommentOrder boolValue] && isCanCommentOrder.length>0) {
                self.buttonOneState=OrderButtonStateCanComment;
            }
            //第二按键属性包括三种状态（删除 取消 查看进度）不可以同时出现
            //是否可删除
            NSString *isCanDelete=[NSString stringWithFormat:@"%@",billOrder.isCanDelete];
            //是否可取消
            NSString *isCanCancel=[NSString stringWithFormat:@"%@",billOrder.isCanCancel];
            //是否查看取消进度
            NSString *isCheckCancelPrecess=[NSString stringWithFormat:@"%@", billOrder.queryAuditDetailFlag];
            if ([isCanDelete isEqualToString:@"1"]) {
                self.buttonTwoState=OrderButtonStateCanDelete;
            }
            if ([isCanCancel isEqualToString:@"1"]) {
                self.buttonTwoState=OrderButtonStateCanCanCel;
            }
            if ([isCheckCancelPrecess isEqualToString:@"1"]) {
                self.buttonTwoState=OrderButtonStateCanQueryProcess;
            }
            
        }
        DeleveryInfo *info = [[DeleveryInfo alloc] init];
        for (int i = 0; i < billOrder.delevery.count; i++) {
            info=billOrder.delevery[i];
        }
        //第三个按键状态 （查看物流/拼团详情）
        //汽车订单没有查看物流
        if (![billOrder.orderTag containsString:carOrderStatus] && info.package_id && ![info.package_id isEqualToString:@""] && ![info.package_id isEqualToString:@"无"] && info.logisticsId.length>0 && info.logisticsCode.length>0) {
            self.buttonThreeState=OrderButtonStateLogistic;
        }
        if ([billOrder.businessType isEqualToString:@"1101"] || [billOrder.businessType isEqualToString:@"1102"] || [billOrder.businessType isEqualToString:@"1103"]) {
            if ([billOrder.order_status isEqualToString:@"4"]) {
                self.buttonThreeState=OrderButtonStateGroupDetail;
            }
        }
        //自有订单 发货按钮
        if ([billOrder.orderTag containsString:ownOrderStatus]) {
            BOOL isCanSendout = [billOrder.order_status intValue]==4&&[US_UserUtility sharedLogin].isShowOrderSendout;
            if (isCanSendout) {
                self.buttonOneState=OrderButtonStateSendout;
            }
        }
    }
    return self;
}

@end

@implementation US_OrderListSectionModel
- (instancetype)initWithRuleData:(WaybillOrder *)billOrder{
    self = [super init];
    if (self) {
        self.sectionData=billOrder;
        self.headerModel=[[US_OrderListHeaderModel alloc] init];
        self.footerModel=[[US_OrderListFooterModel alloc] initWithBillOrder:billOrder pageViewType:OrderListFooterViewTypeList];
        self.headerModel.nameStr=[NSString stringWithFormat:@"收货人：%@",billOrder.transName];
        self.headerModel.statusStr=[self getHeaderOrderStatusWithBillOrder:billOrder];
        self.headerModel.nameAttribute=[self buildNameAttributeStr:billOrder];
        self.headViewName=@"US_OrderListSectionHeader";
        self.headHeight=50;
        self.sectionData=billOrder;
        self.footViewName=@"US_OrderListSectionFooter";
        self.footHeight=[self caculateFooterViewHeight:billOrder];
        self.footerModel.freightValue=[self getFreightValue:billOrder];
        self.footerModel.payedMoneyValue=[self getpayMoneyStr:billOrder];
        self.footerModel.numbleStr=[self getSaleNumbers:billOrder];
        self.footerModel.footValueAttribute=[self getFootLabelAttributeStr];
    }
    return self;
}

- (NSMutableAttributedString *)buildNameAttributeStr:(WaybillOrder*)billOrder{
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货人：%@", billOrder.transName]];
    NSMutableArray * images=[[NSMutableArray alloc] init];
    if ([[NSString isNullToString:billOrder.orderTag] containsString:selfTakeOrderStatus]) {
        UIImage * selfTakeImage=[NSString transforOvalImageWithTargetText:@"自提" withColor:[UIColor whiteColor] backgroudColor:[UIColor convertHexToRGB:@"FF9914"] andfont:[UIFont systemFontOfSize:11]];
        [images addObject:selfTakeImage];
    }
    if ([billOrder.businessType isEqualToString:@"1101"] || [billOrder.businessType isEqualToString:@"1102"] || [billOrder.businessType isEqualToString:@"1103"]){
        UIImage * groupBuyImage=[NSString transforOvalImageWithTargetText:@"团购" withColor:[UIColor whiteColor] backgroudColor:[UIColor convertHexToRGB:@"FF7769"] andfont:[UIFont systemFontOfSize:11]];
        [images addObject:groupBuyImage];
    }else if ([billOrder.businessType isEqualToString:preferenceOrderType]) {
        UIImage * preferenceImage=[NSString transforOvalImageWithTargetText:@"邮特惠" withColor:[UIColor whiteColor] backgroudColor:[UIColor convertHexToRGB:@"FF7769"] andfont:[UIFont systemFontOfSize:11]];
        [images addObject:preferenceImage];
    }
    
    for (int i = 0; i < [images count]; i ++) {
        UIImage *labelImage=images[i];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = labelImage;                                  //设置图片源
        textAttachment.bounds = CGRectMake(0, -5, labelImage.size.width, labelImage.size.height);//设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
        NSMutableAttributedString *spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
        CGFloat insertposition=0;
        [result insertAttributedString:spaceString atIndex: insertposition];
        [result insertAttributedString: attrStr atIndex: insertposition];
    }
    return result;
}

- (NSString *) getHeaderOrderStatusWithBillOrder:(WaybillOrder*)billOrder{
    NSString *orderStatusStr = [self getOrderState:billOrder.order_status];
    
    if ([billOrder.businessType isEqualToString:@"1101"] || [billOrder.businessType isEqualToString:@"1102"] || [billOrder.businessType isEqualToString:@"1103"]){
        if ([orderStatusStr isEqualToString:@"待发货"] && [billOrder.groupBuyingDispatchStatus isEqualToString:@"拼团中"]) {
            orderStatusStr = billOrder.groupBuyingDispatchStatus;
        }
        else if (([orderStatusStr isEqualToString:@"待发货"] || [orderStatusStr isEqualToString:@"已发货"]) && [billOrder.groupBuyingDispatchStatus isEqualToString:@"拼团成功"]){
            orderStatusStr = [NSString stringWithFormat:@"%@,%@", billOrder.groupBuyingDispatchStatus, orderStatusStr];
        }
        
    }
    return orderStatusStr;
}

- (CGFloat)caculateFooterViewHeight:(WaybillOrder *)billOrder{
    CGFloat footHeight=50;
    if (self.footerModel.buttonOneState!=OrderButtonStateHidden||self.footerModel.buttonTwoState!=OrderButtonStateHidden||self.footerModel.buttonThreeState!=OrderButtonStateHidden) {
        footHeight=100;
    }
    return footHeight;
}

- (NSString *)getSaleNumbers:(WaybillOrder *)billOrder{
    int count = 0;
    for (DeleveryInfo *deleveryInfo in billOrder.delevery) {
        for (PrdInfo *prdInfo in deleveryInfo.prd) {
            count += prdInfo.product_num.intValue;
        }
    }
    NSString * numberStr=[NSString stringWithFormat:@"共%d件 ",count];
    return numberStr;
}

- (NSString *)getFreightValue:(WaybillOrder *)billOrder{
    NSString * freightValueStr=@"";
    if ([billOrder.orderType isEqualToString:@"3108"]) {
        freightValueStr=@"";
    }else if (billOrder.pay_amount.doubleValue==0.00) {
        freightValueStr=@"";
    }else{
        freightValueStr = [NSString stringWithFormat:@"(含运费¥%.2f)", billOrder.transAmount.doubleValue];
    }
    return freightValueStr;
}

- (NSString * )getpayMoneyStr:(WaybillOrder *)billOrder{
    NSString * totalpayed=@"实付金额: 未支付 ";
    if ([billOrder.orderType isEqualToString:@"3108"]) {
        totalpayed=@"实付金额: 积分支付 ";
    }else if ([billOrder.order_status intValue]==3) {
        totalpayed=[NSString stringWithFormat:@"待支付金额: ¥%.2f", [billOrder.order_amount doubleValue]-[billOrder.pay_amount doubleValue]];
    }/*else if (billOrder.pay_amount.doubleValue==0.00) {
        totalpayed=@"实付金额: 未支付 ";
    }*/
    else{
        totalpayed = [NSString stringWithFormat:@"合计金额: ¥%.2f ", billOrder.pay_amount.doubleValue];
    }

    return totalpayed;
}

- (NSMutableAttributedString *)getFootLabelAttributeStr{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:self.footerModel.numbleStr];
     [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,self.footerModel.numbleStr.length)];

    NSMutableAttributedString *attriString2 = [[NSMutableAttributedString alloc] initWithString:self.footerModel.payedMoneyValue];
    [attriString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0,[attriString2.string rangeOfString:@":"].location)];
    NSMutableAttributedString *attriString3 = [[NSMutableAttributedString alloc] initWithString:self.footerModel.freightValue];
    [attriString3 addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"999999"] range:NSMakeRange(0,self.footerModel.freightValue.length)];
    [attriString appendAttributedString:attriString2];
    [attriString appendAttributedString:attriString3];
    return attriString;
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
            orderState = @"待发货";
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

@end
