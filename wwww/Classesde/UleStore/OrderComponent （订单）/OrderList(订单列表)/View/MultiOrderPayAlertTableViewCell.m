//
//  MultiOrderPayAlertTableViewCell.m
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/13.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "MultiOrderPayAlertTableViewCell.h"
#import "UIView+SDAutoLayout.h"

@interface MultiOrderPayAlertTableViewCell ()


@property (nonatomic, strong) UILabel * storeNameLabel;
@property (nonatomic, strong) UILabel * orderAmountLabel;
@property (nonatomic, strong) UILabel * numLabel;

@end
@implementation MultiOrderPayAlertTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{

    self.selectionStyle=UITableViewCellSelectionStyleNone;

    [self.contentView sd_addSubviews:@[self.storeNameLabel,self.orderAmountLabel,self.numLabel]];
    
    self.orderAmountLabel.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(25)
    .widthIs(120);
    self.storeNameLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,10)
    .heightIs(25)
    .rightSpaceToView(self.orderAmountLabel, 5);
    self.numLabel.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.storeNameLabel,0)
    .heightIs(25)
    .widthIs(150);
}
- (void)setModel:(US_MultiOrderInfo *)orderInfo{
    self.storeNameLabel.text=orderInfo.storeName;
    self.orderAmountLabel.text=[NSString stringWithFormat:@"¥%.2f", orderInfo.orderAmount.doubleValue];
    self.numLabel.text=[NSString stringWithFormat:@"共%@件",orderInfo.productNumTotal];
}

#pragma  mark - setter and getter
- (UILabel *)storeNameLabel{
    if(_storeNameLabel==nil){
        _storeNameLabel=[UILabel new];
        _storeNameLabel.textColor=[UIColor darkGrayColor];
        _storeNameLabel.font=[UIFont systemFontOfSize:14];
        _storeNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _storeNameLabel;
}
- (UILabel *)orderAmountLabel{
    if(_orderAmountLabel==nil){
        _orderAmountLabel=[UILabel new];
        _orderAmountLabel.textColor=[UIColor darkGrayColor];
        _orderAmountLabel.font=[UIFont systemFontOfSize:14];
        _orderAmountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderAmountLabel;
}
- (UILabel *)numLabel{
    if(_numLabel==nil){
        _numLabel=[UILabel new];
        _numLabel.textColor=[UIColor darkGrayColor];
        _numLabel.font=[UIFont systemFontOfSize:14];
        _numLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _numLabel;
}
@end
