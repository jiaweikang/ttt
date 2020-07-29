//
//  DonatePickListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/8.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "DonatePickListCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_PostOrigModel.h"

@interface DonatePickListCell ()
@property (nonatomic, strong) UILabel *nameLab;//机构名称
@property (nonatomic, strong) UIImageView *iconImageView;//选择图标

@end
@implementation DonatePickListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor= [UIColor clearColor];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"d9d9d9"];
    [self.contentView sd_addSubviews:@[self.nameLab,self.iconImageView,lineView]];
    self.nameLab.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 15)
    .autoWidthRatio(0)
    .heightIs(25);
    
    self.iconImageView.sd_layout
    .leftSpaceToView(self.nameLab, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(KScreenScale(40))
    .heightIs(KScreenScale(40));
    lineView.sd_layout
    .topSpaceToView(self.nameLab, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
}
- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    US_postOrigData *listInfo=(US_postOrigData *)model.data;
    self.nameLab.text = listInfo.name;
    [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
    self.iconImageView.hidden = !listInfo.selected;
    if (listInfo.selected) {
        self.nameLab.textColor = [UIColor convertHexToRGB:@"c60a1e"];
    }
    else{
        self.nameLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
}
#pragma mark - <setter and getter>
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab=[UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:16];
        _nameLab.textColor = [UIColor convertHexToRGB:@"666666"];
    }
    return _nameLab;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
        [_iconImageView setImage:[UIImage bundleImageNamed:@"choiseboxSelected"]];
    }
    return _iconImageView;
}
@end
