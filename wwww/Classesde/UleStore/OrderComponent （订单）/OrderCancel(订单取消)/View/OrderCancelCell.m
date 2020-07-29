//
//  OrderCancelCell.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/6.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "OrderCancelCell.h"
#import <UIView+SDAutoLayout.h>


@interface OrderCancelCell ()
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * selectBtn;
@end

@implementation OrderCancelCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView * lineView=[UIView new];
        lineView.backgroundColor=[UIColor convertHexToRGB:@"e4e5e4"];
        lineView.alpha=0.5;
        [self.contentView addSubview:self.messageLabel];
        [self.contentView addSubview:lineView];
        self.accessoryView=self.selectBtn;
        self.messageLabel.sd_layout
        .leftSpaceToView(self.contentView,20)
        .topSpaceToView(self.contentView,15)
        .rightSpaceToView(self.contentView,10)
        .autoHeightRatio(0);
        lineView.sd_layout
        .leftSpaceToView(self.contentView, 20)
        .rightEqualToView(self.accessoryView)
        .bottomSpaceToView(self.contentView, 0)
        .heightIs(1);
        [self setupAutoHeightWithBottomView:self.messageLabel bottomMargin:15];
    }
    return self;
}

- (void)setModel:(OrderCancelCellModel *)model{
    _model=model;
    self.messageLabel.text=model.cancelReason;
    self.selectBtn.selected=model.isSelected;
    if (model.isSelected) {
        self.messageLabel.textColor=[UIColor redColor];
    }else{
        self.messageLabel.textColor=[UIColor blackColor];
    }
    [self.messageLabel updateLayout];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (UILabel *)messageLabel{
    if (_messageLabel==nil) {
        _messageLabel=[[UILabel alloc] init];
        _messageLabel.numberOfLines=0;
        _messageLabel.font=[UIFont systemFontOfSize:15.0];
    }
    return _messageLabel;
}

- (void)selectClick:(UIButton *)sender{
    sender.selected=!sender.selected;
    self.model.isSelected=sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedResonModel:)]) {
        [self.delegate didSelectedResonModel:self.model];
    }
}

- (UIButton *)selectBtn{
    if (_selectBtn==nil) {
        _selectBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_selectBtn setImage:[UIImage bundleImageNamed:@"myOrder_btn_reason_normal"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage bundleImageNamed:@"myOrder_btn_reason_selected"] forState:UIControlStateSelected];
        _selectBtn.userInteractionEnabled=NO;

    }
    return _selectBtn;
}

@end
