//
//  WithdrawRecordListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/27.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "WithdrawRecordListCell.h"
#import "WithdrawRecordModel.h"
#import <UIView+SDAutoLayout.h>

@interface WithdrawRecordListCell ()
@property (nonatomic, strong) UILabel *bankCardLab;//银行 卡号
@property (nonatomic, strong) UILabel *applyTimeLab;//申请时间
@property (nonatomic, strong) UILabel *payTimeLab;//打款时间
@property (nonatomic, strong) UILabel *amountLab;//金额
@property (nonatomic, strong) UILabel *recordDescLab;//描述
@end
@implementation WithdrawRecordListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor= [UIColor clearColor];
    UIView * lineView = [UIView new];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    [self.contentView sd_addSubviews:@[self.bankCardLab,self.applyTimeLab,self.payTimeLab,self.amountLab,self.recordDescLab,lineView]];
    self.bankCardLab.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(__MainScreen_Width-10)
    .heightIs(20);
    self.applyTimeLab.sd_layout
    .leftEqualToView(self.bankCardLab)
    .topSpaceToView(self.bankCardLab, 3)
    .widthRatioToView(self.bankCardLab, 1)
    .heightIs(20);
    self.payTimeLab.sd_layout
    .leftEqualToView(self.applyTimeLab)
    .topSpaceToView(self.applyTimeLab, 3)
    .widthRatioToView(self.applyTimeLab, 1)
    .heightIs(20);
    self.amountLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(__MainScreen_Width-10)
    .heightIs(20);
    self.recordDescLab.sd_layout
    .rightEqualToView(self.amountLab)
    .topSpaceToView(self.amountLab, 3)
    .widthRatioToView(self.amountLab, 1)
    .heightIs(20);
    lineView.sd_layout
    .topSpaceToView(self.payTimeLab, 10)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    WithdrawRecordList * detail=(WithdrawRecordList *)model.data;
    self.bankCardLab.text = [NSString stringWithFormat:@"%@(尾号%@)",NonEmpty(detail.bankOrgan),NonEmpty(detail.bankCode)];
    [self setAttributedBankInfo:self.bankCardLab];
    self.amountLab.text = [NSString stringWithFormat:@"￥%.2lf",detail.orderMoney.length>0?[detail.orderMoney floatValue]:0.00];
    [self setAttributedOrderMoney:self.amountLab];
    self.applyTimeLab.text = [NSString stringWithFormat:@"申请时间 %@",NonEmpty(detail.applyTime)];
    
    self.recordDescLab.textColor = [UIColor convertHexToRGB:[NSString isNullToString:detail.colorText]];
    self.recordDescLab.text = [NSString isNullToString:detail.statusText];
    self.payTimeLab.text = [NSString isNullToString:detail.timeText];
}

-(void)setAttributedOrderMoney:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    label.attributedText = attributedStr;
}

-(void)setAttributedBankInfo:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"36a4f1"] range:NSMakeRange(attributedStr.length-8, 8)];
    label.attributedText = attributedStr;
}
#pragma mark - <setter and getter>
- (UILabel *)bankCardLab{
    if (!_bankCardLab) {
        _bankCardLab=[UILabel new];
        _bankCardLab.font = [UIFont systemFontOfSize:15];
    }
    return _bankCardLab;
}
- (UILabel *)applyTimeLab{
    if (!_applyTimeLab) {
        _applyTimeLab=[UILabel new];
        _applyTimeLab.font = [UIFont systemFontOfSize:14];
        _applyTimeLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _applyTimeLab;
}
- (UILabel *)payTimeLab{
    if (!_payTimeLab) {
        _payTimeLab=[UILabel new];
        _payTimeLab.font = [UIFont systemFontOfSize:14];
        _payTimeLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _payTimeLab;
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
- (UILabel *)recordDescLab{
    if (!_recordDescLab) {
        _recordDescLab=[UILabel new];
        _recordDescLab.font = [UIFont systemFontOfSize:15];
        _recordDescLab.textAlignment = NSTextAlignmentRight;
    }
    return _recordDescLab;
}
@end
