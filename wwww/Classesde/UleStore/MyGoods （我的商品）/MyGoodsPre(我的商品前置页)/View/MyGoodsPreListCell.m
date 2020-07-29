//
//  MyGoodsPreListCell.m
//  UleStoreApp
//
//  Created by lei xu on 2020/3/19.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "MyGoodsPreListCell.h"
#import "UleCellBaseModel.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface MyGoodsPreListCell ()
@property (nonatomic, strong) UIImageView   *mImageView;
@property (nonatomic, strong) UILabel       *mTitleLab;
@end

@implementation MyGoodsPreListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor=[UIColor whiteColor];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    [self.contentView sd_addSubviews:@[self.mImageView, self.mTitleLab, lineView]];
    self.mImageView.sd_layout.topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .heightIs(40)
    .widthEqualToHeight();
    self.mTitleLab.sd_layout.centerYEqualToView(self.mImageView)
    .leftSpaceToView(self.mImageView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(25);
    lineView.sd_layout.leftEqualToView(self.mTitleLab)
    .bottomSpaceToView(self.contentView, 0)
    .rightEqualToView(self.mTitleLab)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.mImageView bottomMargin:10];
}

- (void)setModel:(UleCellBaseModel *)model{
    [self.mImageView yy_setImageWithURL:model.data[@"imageUrl"] placeholder:nil];
    self.mTitleLab.text=model.data[@"titleName"];
}

#pragma mark - <getters>
- (UIImageView *)mImageView{
    if (!_mImageView) {
        _mImageView = [[UIImageView alloc]init];
    }
    return _mImageView;
}

- (UILabel *)mTitleLab{
    if (!_mTitleLab) {
        _mTitleLab = [[UILabel alloc]init];
        _mTitleLab.font = [UIFont systemFontOfSize:15];
        _mTitleLab.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _mTitleLab;
}


@end
