//
//  US_OrderDetailPayinfoCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/2.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailPayinfoCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_OrderDetailPayinfoCellModel.h"

static CGFloat const KDetailPayinfoCellMargin = 8.0;
@interface US_OrderDetailPayinfoCell ()
@property (nonatomic, strong) UILabel   *titleLab;
@property (nonatomic, strong) UILabel   *contentLab;

@end

@implementation US_OrderDetailPayinfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView sd_addSubviews:@[self.titleLab,self.contentLab]];
        self.titleLab.sd_layout.topSpaceToView(self.contentView, 2.5)
        .leftSpaceToView(self.contentView, KDetailPayinfoCellMargin)
        .widthIs(100)
        .heightIs(15);
        self.contentLab.sd_layout.topEqualToView(self.titleLab)
        .rightSpaceToView(self.contentView, KDetailPayinfoCellMargin)
        .heightRatioToView(self.titleLab, 1)
        .autoWidthRatio(0);
        [self setupAutoHeightWithBottomView:self.titleLab bottomMargin:2.5];
    }
    return self;
}

- (void)setModel:(US_OrderDetailPayinfoCellModel *)model{
    self.titleLab.text=model.titleName;
    self.contentLab.text=model.contentName;
    [self.contentLab setSingleLineAutoResizeWithMaxWidth:300];
    if (model.isFirstCell) {
        self.titleLab.sd_layout.topSpaceToView(self.contentView, KDetailPayinfoCellMargin);
    }else self.titleLab.sd_layout.topSpaceToView(self.contentView, 2.5);
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.font = [UIFont systemFontOfSize:13];
        _titleLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _titleLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab=[[UILabel alloc]init];
        _contentLab.font = [UIFont systemFontOfSize:13];
        _contentLab.textColor = [UIColor convertHexToRGB:@"666666"];
        _contentLab.textAlignment = NSTextAlignmentRight;
    }
    return _contentLab;
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
