//
//  US_OrderDetailCarInsureCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/6/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailCarInsureCell.h"
#import <UIView+SDAutoLayout.h>
#define kOrderDetailMargin 8

@interface US_OrderDetailCarInsureCell ()
@property (nonatomic, strong) UILabel   *titleLab;
@property (nonatomic, strong) UILabel   *desLab;

@end

@implementation US_OrderDetailCarInsureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = kViewCtrBackColor;
        [self.contentView sd_addSubviews:@[lineView, self.titleLab, self.desLab]];
        lineView.sd_layout.topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(3);
        self.titleLab.sd_layout.topSpaceToView(lineView, kOrderDetailMargin)
        .leftSpaceToView(self.contentView, kOrderDetailMargin)
        .rightSpaceToView(self.contentView, kOrderDetailMargin)
        .heightIs(20);
        self.desLab.sd_layout.topSpaceToView(self.titleLab, 5)
        .leftEqualToView(self.titleLab)
        .rightEqualToView(self.titleLab)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomView:self.desLab bottomMargin:kOrderDetailMargin];
    }
    return self;
}

- (void)setModel:(UleCellBaseModel *)model{
    _model = model;
    self.desLab.text = model.data;
}


#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor convertHexToRGB:@"333333"];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.text = @"车险&车贷服务";
    }
    return _titleLab;
}

- (UILabel *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc]init];
        _desLab.textColor = [UIColor convertHexToRGB:@"999999"];
        _desLab.font = [UIFont systemFontOfSize:13];
    }
    return _desLab;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
