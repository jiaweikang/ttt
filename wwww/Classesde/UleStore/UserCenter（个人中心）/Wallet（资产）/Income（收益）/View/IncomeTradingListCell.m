//
//  IncomeTradingListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/25.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "IncomeTradingListCell.h"
#import <UIView+SDAutoLayout.h>
#import "IncomeTradeModel.h"
#import "IncomeTradeCancelModel.h"
#import "UleDateFormatter.h"

@interface IncomeTradingListCell ()
@property (nonatomic, strong) UILabel *orderNumLab;//订单号
@property (nonatomic, strong) UILabel *payTimeLab;//支付时间
@property (nonatomic, strong) UILabel *receiveTimeTitleLab;//签收时间标题
@property (nonatomic, strong) UILabel *receiveTimeLab;//签收时间
@property (nonatomic, strong) UILabel *amountLab;//金额
@property (nonatomic, strong) UILabel *incomeDescLab;//描述
@property (nonatomic, strong) UILabel *commissionDecriptLabel;
@end

@implementation IncomeTradingListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor= [UIColor whiteColor];
    self.selectionStyle=UITableViewCellSeparatorStyleNone;
    //
    UILabel * orderNumTitleLab = [UILabel new];
    orderNumTitleLab.text=@"订单号";
    orderNumTitleLab.textColor = [UIColor convertHexToRGB:@"B3B3B3"];
    orderNumTitleLab.font = [UIFont systemFontOfSize:14];
    UILabel * payTimeTitleLab = [UILabel new];
    payTimeTitleLab.text=@"支付时间";
    payTimeTitleLab.textColor = [UIColor convertHexToRGB:@"666666"];
    payTimeTitleLab.font = [UIFont systemFontOfSize:14];
    
    UIView * lineView = [UIView new];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    
    [self.contentView sd_addSubviews:@[self.commissionDecriptLabel, orderNumTitleLab,payTimeTitleLab,self.receiveTimeTitleLab,self.orderNumLab,self.payTimeLab,self.receiveTimeLab,self.amountLab,self.incomeDescLab,lineView]];
    
    self.commissionDecriptLabel.sd_layout.leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(30);
    
    orderNumTitleLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.commissionDecriptLabel, 0)
    .widthIs(60)
    .heightIs(20);
    payTimeTitleLab.sd_layout
    .leftEqualToView(orderNumTitleLab)
    .topSpaceToView(orderNumTitleLab, 3)
    .widthRatioToView(orderNumTitleLab, 1)
    .heightIs(20);
    self.receiveTimeTitleLab.sd_layout
    .leftEqualToView(orderNumTitleLab)
    .topSpaceToView(payTimeTitleLab, 3)
    .widthRatioToView(orderNumTitleLab, 1)
    .heightIs(20);
    self.amountLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.commissionDecriptLabel, 10)
    .widthIs(100)
    .heightIs(20);
    self.incomeDescLab.sd_layout
    .rightEqualToView(self.amountLab)
    .topSpaceToView(self.amountLab, 3)
    .widthRatioToView(self.amountLab, 1)
    .heightIs(20);
    self.orderNumLab.sd_layout
    .topEqualToView(orderNumTitleLab)
    .leftSpaceToView(orderNumTitleLab, 5)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20);
    self.payTimeLab.sd_layout
    .topEqualToView(payTimeTitleLab)
    .leftEqualToView(self.orderNumLab)
    .rightEqualToView(self.orderNumLab)
    .heightIs(20);
    self.receiveTimeLab.sd_layout
    .topEqualToView(self.receiveTimeTitleLab)
    .leftSpaceToView(self.receiveTimeTitleLab, 5)
    .rightEqualToView(self.orderNumLab)
    .heightIs(20);
    lineView.sd_layout
    .topSpaceToView(self.receiveTimeLab, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0.7);
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    if ([model.data isKindOfClass:[IncomeTradeCancelList class]]) {
        IncomeTradeCancelList *listInfo=model.data;
        self.incomeDescLab.text = @"不发放";//佣金发放状态
        self.incomeDescLab.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        self.orderNumLab.text = [NSString isNullToString:listInfo.escOrderId];//订单号
        self.receiveTimeTitleLab.text=@"退款完成时间";
        self.receiveTimeTitleLab.sd_layout.widthIs(90);
        NSString *payCommission=[NSString isNullToString:[listInfo.commissionAmount stringValue]];
        payCommission=payCommission.length>0?payCommission:@"0.00";
        self.amountLab.text = [NSString stringWithFormat:@"%.2lf",payCommission.doubleValue];
        self.commissionDecriptLabel.text = [NSString isNullToString:listInfo.commissionTypeDesc];
        self.commissionDecriptLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        //支付时间
        if ([NSString isNullToString:listInfo.paymentTime].length > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.payTimeLab.text = [UleDateFormatter GetCustomDate:[formatter dateFromString:[NSString isNullToString:listInfo.paymentTime]] dataFormat:@"MM-dd HH:mm"];
        }
        if ([NSString isNullToString:listInfo.refundTime].length>0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.receiveTimeLab.text = [UleDateFormatter GetCustomDate:[formatter dateFromString:[NSString isNullToString:listInfo.refundTime]] dataFormat:@"MM-dd HH:mm"];
        }
    }else if ([model.data isKindOfClass:[IncomeTradeDetail class]]) {
        IncomeTradeDetail *listInfo=(IncomeTradeDetail *)model.data;
        NSString *stateStr=@"";
        NSString *stateColor=@"ef3b39";
        //佣金发放状态
        if (listInfo.issueStatus.length > 0) {
            switch ([listInfo.issueStatus intValue]) {
                case 103:
                    //预发放
                {
                    stateStr=@"预发放";
                    stateColor=@"ef3b39";
                }
                    break;
                case 1:
                case 2:
                case 101:
                {
                    stateStr=@"待发放";
                    stateColor=@"ef3b39";
                }
                    break;
                case 3:
                {
                    stateStr=@"已发放";
                    stateColor=@"36a4f1";
                }
                    break;
                default:
                {
                    stateStr=@"待发放";
                    stateColor=@"ef3b39";
                }
                    break;
            }
        }
        if ([listInfo.orderStatus intValue]==7) {
            self.receiveTimeTitleLab.text = @"签收时间";
            self.receiveTimeLab.text = [NSString isNullToString:listInfo.completeTime];
        }else{
            self.receiveTimeTitleLab.text = @"签收时间";
            self.receiveTimeLab.text=@"未签收";
        }
        self.incomeDescLab.text = stateStr;//佣金发放状态
        self.incomeDescLab.textColor = [UIColor convertHexToRGB:stateColor];
        self.orderNumLab.text = [NSString isNullToString:listInfo.escOrderId];//订单号
        NSString *payCommission=[NSString isNullToString:listInfo.paymentCommission];
        payCommission=payCommission.length>0?payCommission:@"0.00";
        self.amountLab.text = [NSString stringWithFormat:@"%@%.2lf",payCommission.doubleValue>=0?@"+":@"",payCommission.doubleValue];
        self.commissionDecriptLabel.text = listInfo.commissionTypeDescribe;
        self.commissionDecriptLabel.textColor = [UIColor convertHexToRGB:listInfo.commissionTypeColor];
        //支付时间
        if (listInfo.payTime.length > 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            self.payTimeLab.text = [UleDateFormatter GetCustomDate:[formatter dateFromString:listInfo.payTime] dataFormat:@"MM-dd HH:mm"];
        }
    }
}

#pragma mark - <setter and getter>
- (UILabel *)orderNumLab{
    if (!_orderNumLab) {
        _orderNumLab=[UILabel new];
        _orderNumLab.font = [UIFont systemFontOfSize:14];
        _orderNumLab.textColor = [UIColor convertHexToRGB:@"B3B3B3"];
    }
    return _orderNumLab;
}
- (UILabel *)payTimeLab{
    if (!_payTimeLab) {
        _payTimeLab=[UILabel new];
        _payTimeLab.font = [UIFont systemFontOfSize:14];
        _payTimeLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _payTimeLab;
}
- (UILabel *)receiveTimeTitleLab{
    if (!_receiveTimeTitleLab) {
        _receiveTimeTitleLab = [UILabel new];
        _receiveTimeTitleLab.text=@"签收时间";
        _receiveTimeTitleLab.textColor = [UIColor convertHexToRGB:@"666666"];
        _receiveTimeTitleLab.font = [UIFont systemFontOfSize:14];
    }
    return _receiveTimeTitleLab;
}
- (UILabel *)receiveTimeLab{
    if (!_receiveTimeLab) {
        _receiveTimeLab=[UILabel new];
        _receiveTimeLab.font = [UIFont systemFontOfSize:14];
        _receiveTimeLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _receiveTimeLab;
}
- (UILabel *)amountLab{
    if (!_amountLab) {
        _amountLab=[UILabel new];
        _amountLab.font = [UIFont systemFontOfSize:16];
        _amountLab.textColor = [UIColor blackColor];
        _amountLab.textAlignment = NSTextAlignmentRight;
    }
    return _amountLab;
}
- (UILabel *)incomeDescLab{
    if (!_incomeDescLab) {
        _incomeDescLab=[UILabel new];
        _incomeDescLab.font = [UIFont systemFontOfSize:15];
        _incomeDescLab.textAlignment = NSTextAlignmentRight;
    }
    return _incomeDescLab;
}

- (UILabel *)commissionDecriptLabel{
    if (!_commissionDecriptLabel) {
        _commissionDecriptLabel=[UILabel new];
        _commissionDecriptLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _commissionDecriptLabel.font = [UIFont boldSystemFontOfSize:16];
        _commissionDecriptLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _commissionDecriptLabel;
}
@end
