//
//  US_OrderDetailOrderNumberCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailOrderNumberCell.h"
#import <UIView+SDAutoLayout.h>
#import "MyWaybillOrderInfo.h"
#define kOrderDetailMargin 8
@interface US_OrderDetailOrderNumberCell ()

@property (nonatomic, strong) UILabel * mOrderNumberLabel;
@property (nonatomic, strong) UILabel * mCreatTimeLabel;
@property (nonatomic, strong) UILabel * mPayTimeLabel;
@property (nonatomic, strong) UIButton *mCopyOrderNumber;
@end

@implementation US_OrderDetailOrderNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView sd_addSubviews:@[self.mOrderNumberLabel,self.mCreatTimeLabel,self.mPayTimeLabel,self.mCopyOrderNumber]];
        self.mOrderNumberLabel.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
        .topSpaceToView(self.contentView, kOrderDetailMargin)
        .heightIs(20).rightSpaceToView(self.contentView, kOrderDetailMargin);
        self.mCreatTimeLabel.sd_layout.leftEqualToView(self.mOrderNumberLabel)
        .topSpaceToView(self.mOrderNumberLabel, 5)
        .heightIs(20).rightEqualToView(self.mOrderNumberLabel);
        self.mPayTimeLabel.sd_layout.leftEqualToView(self.mOrderNumberLabel)
        .topSpaceToView(self.mCreatTimeLabel, 5)
        .heightIs(20)
        .rightEqualToView(self.mOrderNumberLabel);
        
        self.mCopyOrderNumber.sd_layout.rightSpaceToView(self.contentView, 10)
        .topEqualToView(self.mOrderNumberLabel)
        .widthIs(60).heightRatioToView(self.mOrderNumberLabel, 1);
        
        [self setupAutoHeightWithBottomView:self.mPayTimeLabel bottomMargin:kOrderDetailMargin];
    }
    return self;
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    WaybillOrder * billOrder=(WaybillOrder *)model.data;
    self.mOrderNumberLabel.text= [NSString stringWithFormat:@"订单编号：%@",billOrder.esc_orderid];
    self.mCreatTimeLabel.text=[NSString stringWithFormat:@"下单时间：%@",billOrder.create_time];
    self.mPayTimeLabel.text=[NSString stringWithFormat:@"付款时间：%@",billOrder.buyerPayTime.length>0?billOrder.buyerPayTime:@"无"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)copyBtnAction:(id)sender{
     WaybillOrder * billOrder=(WaybillOrder *)self.model.data;
    if ([NSString isNullToString:billOrder.esc_orderid].length > 0) {
        UIPasteboard *board = [UIPasteboard generalPasteboard];
        [board setString:billOrder.esc_orderid];
        [UleMBProgressHUD showHUDWithText:@"订单号已复制" afterDelay:1.5];
    }
}

#pragma mark - <setter and getter>
- (UILabel *)mOrderNumberLabel{
    if (!_mOrderNumberLabel) {
        _mOrderNumberLabel=[UILabel new];
        _mOrderNumberLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _mOrderNumberLabel.font = [UIFont systemFontOfSize:13];
    }
    return _mOrderNumberLabel;
}
- (UILabel *)mCreatTimeLabel{
    if (!_mCreatTimeLabel) {
        _mCreatTimeLabel=[UILabel new];
        _mCreatTimeLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _mCreatTimeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _mCreatTimeLabel;
}
- (UILabel *)mPayTimeLabel{
    if (!_mPayTimeLabel) {
        _mPayTimeLabel=[UILabel new];
        _mPayTimeLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _mPayTimeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _mPayTimeLabel;
}
- (UIButton *)mCopyOrderNumber{
    if (!_mCopyOrderNumber) {
        _mCopyOrderNumber=[[UIButton alloc] init];
        [_mCopyOrderNumber setTitle:@"复制单号" forState:UIControlStateNormal];
        [_mCopyOrderNumber setTitleColor:[UIColor convertHexToRGB:kDarkTextColor] forState:UIControlStateNormal];
        _mCopyOrderNumber.titleLabel.font = [UIFont systemFontOfSize:10];
        _mCopyOrderNumber.layer.masksToBounds = YES;
        _mCopyOrderNumber.layer.cornerRadius = 4;
        _mCopyOrderNumber.tintColor = [UIColor convertHexToRGB:@"999999"];
        _mCopyOrderNumber.layer.borderWidth = 0.6;
        [_mCopyOrderNumber addTarget:self action:@selector(copyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mCopyOrderNumber;
}
@end
