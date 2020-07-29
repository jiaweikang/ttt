//
//  US_OrderListSectionHeader.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListSectionHeader.h"
#import <UIView+SDAutoLayout.h>
@interface US_OrderListSectionHeader ()

@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * orderStatusLabel;
@end

@implementation US_OrderListSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.bgView];
        self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.bgView.sd_layout.topSpaceToView(self.contentView, 5);
        [self.bgView sd_addSubviews:@[self.nameLabel,self.orderStatusLabel]];
        self.nameLabel.sd_layout.leftSpaceToView(self.bgView, 8)
        .centerYEqualToView(self.bgView)
        .heightIs(30)
        .widthIs(200);
        self.orderStatusLabel.sd_layout.rightSpaceToView(self.bgView, 8)
        .centerYEqualToView(self.bgView)
        .heightIs(30)
        .widthIs(200);
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headViewClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setModel:(US_OrderListSectionModel *)model{
    _model=model;
    self.orderStatusLabel.text=model.headerModel.statusStr;
    self.nameLabel.attributedText=model.headerModel.nameAttribute;
}

- (void)headViewClick:(UIGestureRecognizer *)recognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(headViewClickWithSectionModel:)]) {
        [self.delegate headViewClickWithSectionModel:self.model];
    }
}

#pragma mark - <setter and getter>
- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[UIView new];
        _bgView.backgroundColor=[UIColor whiteColor];
    }
    return _bgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _nameLabel;
}
- (UILabel *)orderStatusLabel{
    if (!_orderStatusLabel) {
        _orderStatusLabel=[UILabel new];
        _orderStatusLabel.font = [UIFont systemFontOfSize:14];
        _orderStatusLabel.textAlignment = NSTextAlignmentRight;
        _orderStatusLabel.textColor = [UIColor convertHexToRGB:@"ec3d3f"];
    }
    return _orderStatusLabel;
}
@end
