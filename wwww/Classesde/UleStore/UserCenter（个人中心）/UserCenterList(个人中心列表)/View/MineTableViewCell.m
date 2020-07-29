//
//  MineTableViewCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MineTableViewCell.h"
#import <UIView+SDAutoLayout.h>
#import "MineCellModel.h"
#import <UIImageView+WebCache.h>

@interface MineTableViewCell ()
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * rightTitleLabel;
@property (nonatomic, strong) UIView * bottomLine;
@end

@implementation MineTableViewCell

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView sd_addSubviews:@[self.iconImageView,self.titleLabel,self.rightTitleLabel]];
        self.iconImageView.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 13)
        .widthIs(21)
        .heightIs(21);
        self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0)
        .heightIs(20)
        .centerYEqualToView(self.contentView)
        .widthIs(30);
        self.titleLabel.sd_layout.leftSpaceToView(self.iconImageView, 10)
        .centerYEqualToView(self.contentView)
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.rightTitleLabel, 10);
        
        [self setupAutoHeightWithBottomView:self.iconImageView bottomMargin:13];
    }
    return self;
}

- (void)setModel:(MineCellModel *)model{
    _model=model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconUrlStr]];
    self.titleLabel.text=model.titleStr;
    if (model.rightTitleStr.length > 0) {
        self.rightTitleLabel.text=model.rightTitleStr;
        //右边字体圆角红色背景 ：购物车商品数量
        if ([model.groupId isEqualToString:@"3"]) {
            self.accessoryType=UITableViewCellAccessoryNone;
            self.rightTitleLabel.backgroundColor = [UIColor convertHexToRGB:@"EF3B39"];
            self.rightTitleLabel.layer.masksToBounds = YES;
            self.rightTitleLabel.layer.cornerRadius = 10;
            self.rightTitleLabel.textColor = [UIColor convertHexToRGB:@"ffffff"];
            self.rightTitleLabel.textAlignment = NSTextAlignmentCenter;
            self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 20);
        } else {
            self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            self.rightTitleLabel.textColor = [UIColor blackColor];
            self.rightTitleLabel.backgroundColor = [UIColor clearColor];
            self.rightTitleLabel.sd_layout.rightSpaceToView(self.contentView, 0);
        }
    }
    else{
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        self.rightTitleLabel.backgroundColor = [UIColor clearColor];
        self.rightTitleLabel.text=@"";
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        if (self.model.rightTitleStr.length > 0) {
            if ([self.model.groupId isEqualToString:@"3"]) {
                self.rightTitleLabel.backgroundColor = [UIColor convertHexToRGB:@"EF3B39"];
            } else {
                self.rightTitleLabel.backgroundColor = [UIColor clearColor];
            }
        }
        else{
            self.rightTitleLabel.backgroundColor = [UIColor clearColor];
        }
    }
}
#pragma mark - <setter and getter>
- (UIImageView *) iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _iconImageView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.font=[UIFont systemFontOfSize:15];
        _titleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)rightTitleLabel{
    if (!_rightTitleLabel) {
        _rightTitleLabel=[[UILabel alloc] init];
        _rightTitleLabel.font = [UIFont systemFontOfSize:14];
        _rightTitleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rightTitleLabel;
}

@end
