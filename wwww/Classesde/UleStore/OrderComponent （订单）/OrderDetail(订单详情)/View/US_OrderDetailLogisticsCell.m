//
//  US_OrderDetailLogisticsCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailLogisticsCell.h"
#import <UIView+SDAutoLayout.h>

#define kOrderDetailMargin 15

@interface US_OrderDetailLogisticsCell ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * noLogisticLabel;
@property (nonatomic, strong) UILabel * packgeLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * arrowView;
@property (nonatomic, strong) UIView * bottomLine;
@end

@implementation US_OrderDetailLogisticsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.iconImageView,self.packgeLabel,self.timeLabel,self.noLogisticLabel,self.arrowView,self.bottomLine]];
    
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
    .centerYEqualToView(self.contentView)
    .widthIs(18).heightEqualToWidth();
    
    self.arrowView.sd_layout.rightSpaceToView(self.contentView, kOrderDetailMargin)
    .centerYEqualToView(self.contentView)
    .widthIs(7).heightIs(12);
    
    self.packgeLabel.sd_layout.leftSpaceToView(self.iconImageView, kOrderDetailMargin)
    .topSpaceToView(self.contentView, kOrderDetailMargin)
    .rightSpaceToView(self.arrowView, kOrderDetailMargin)
    .autoHeightRatio(0);
    
    self.timeLabel.sd_layout.leftEqualToView(self.packgeLabel)
    .topSpaceToView(self.packgeLabel, 10)
    .rightEqualToView(self.packgeLabel).heightIs(15);
    
    self.bottomLine.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(0.6);
    
    self.noLogisticLabel.sd_layout.leftSpaceToView(self.iconImageView, kOrderDetailMargin)
    .rightSpaceToView(self.arrowView, kOrderDetailMargin)
    .topSpaceToView(self.contentView, kOrderDetailMargin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:kOrderDetailMargin];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(US_OrderDetailLogisticCellModel *)model{
    self.packgeLabel.text=model.packageInfo;
    self.timeLabel.text=model.timeStr;
    if (model.noLogisticInfo.length>0) {
        self.packgeLabel.text=@"";
        self.timeLabel.text=@"";
        self.noLogisticLabel.text=model.noLogisticInfo;
        [self setupAutoHeightWithBottomView:self.noLogisticLabel bottomMargin:kOrderDetailMargin];
    }else{
        self.noLogisticLabel.text=@"";
        [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:kOrderDetailMargin];
    }
}

#pragma mark - <setter and getter>
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
        _iconImageView.image=[UIImage bundleImageNamed:@"myOrder_icon_logistics"];
    }
    return _iconImageView;
}

- (UILabel *)packgeLabel{
    if (!_packgeLabel) {
        _packgeLabel=[UILabel new];
        _packgeLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _packgeLabel.font = [UIFont systemFontOfSize:14.0];
        _packgeLabel.numberOfLines = 0;
    }
    return _packgeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel=[UILabel new];
        _timeLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _timeLabel;
}

- (UILabel *)noLogisticLabel{
    if (!_noLogisticLabel) {
        _noLogisticLabel=[UILabel new];
        _noLogisticLabel.font = [UIFont systemFontOfSize:14.0];
        _noLogisticLabel.numberOfLines = 0;
        _noLogisticLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _noLogisticLabel;
}

- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView=[[UIImageView alloc] init];
        _arrowView.image=[UIImage bundleImageNamed:@"myOrder_icon_rightArrow"];
    }
    return _arrowView;
}
- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine=[UIView new];
        _bottomLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    }
    return _bottomLine;
}
@end
