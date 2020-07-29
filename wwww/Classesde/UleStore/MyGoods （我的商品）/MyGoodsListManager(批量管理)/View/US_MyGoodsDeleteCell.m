

//
//  US_MyGoodsDeleteCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsDeleteCell.h"
#import <UIView+SDAutoLayout.h>

@interface US_MyGoodsDeleteCell ()
@property (nonatomic, strong) UIImageView * mProductImageView;
@property (nonatomic, strong) UIImageView * mSelectedImageView;
@property (nonatomic, strong) UILabel * mStatusLabel;
@property (nonatomic, strong) UILabel * mTitleLabel;
@end

@implementation US_MyGoodsDeleteCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self.contentView sd_addSubviews:@[self.mProductImageView,self.mSelectedImageView,self.mTitleLabel]];
    [self.mProductImageView addSubview:self.mStatusLabel];
    
    self.mProductImageView.sd_layout.leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightEqualToWidth();
    
    self.mSelectedImageView.sd_layout.rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.contentView, 0)
    .widthIs(KScreenScale(30))
    .heightEqualToWidth();
    
    self.mStatusLabel.sd_layout.leftSpaceToView(self.mProductImageView, 0)
    .bottomSpaceToView(self.mProductImageView, 0)
    .rightSpaceToView(self.mProductImageView, 0)
    .heightIs(KScreenScale(50));
    
    self.mTitleLabel.sd_layout.leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.mProductImageView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0);
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
    [self addGestureRecognizer:tap];
    
}

- (void)setModel:(Favorites *)model{
    _model=model;
    self.mTitleLabel.text = [NSString stringWithFormat:@"%@", _model.listingName];
    NSString *listingState = [NSString stringWithFormat:@"%@", _model.listingState];
    NSString *instock = [NSString stringWithFormat:@"%@", _model.instock];
    
    self.mStatusLabel.hidden=NO;
    if ([listingState integerValue]==2 && _model.listingState!=nil && listingState.length>0) {
        //下架
        self.mStatusLabel.text = @"已下架";
    }else if ([instock intValue]<=0 && _model.listingState!=nil && instock.length>0) {
        //售完
        self.mStatusLabel.text = @"已售罄";
    }else {
        [self.mStatusLabel setHidden:YES];
    }
    self.mSelectedImageView.hidden=_model.isSelected?NO:YES;
    NSString *imgUrl = @"";
    if ([model.imgUrl rangeOfString:@"ule.com"].location!=NSNotFound) {
        model.imgUrl = [NSString getImageUrlString:kImageUrlType_XL withurl:model.imgUrl];
        imgUrl=model.imgUrl;
    }
    [self.mProductImageView yy_setImageWithURL:[NSURL URLWithString:imgUrl]  placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    
}

- (void)cellClick:(UIGestureRecognizer *)recognier{
    self.model.isSelected=!self.model.isSelected;
    self.mSelectedImageView.hidden=_model.isSelected?NO:YES;
}

#pragma mark - <setter and getter>
- (UIImageView *)mProductImageView{
    if (!_mProductImageView) {
        _mProductImageView=[UIImageView new];
    }
    return _mProductImageView;
}
- (UIImageView *)mSelectedImageView{
    if (!_mSelectedImageView) {
        _mSelectedImageView=[UIImageView new];
        _mSelectedImageView.image=[UIImage bundleImageNamed:@"myGoods_icon_selected"];
    }
    return _mSelectedImageView;
}
- (UILabel *)mStatusLabel{
    if (!_mStatusLabel) {
        _mStatusLabel=[UILabel new];
        _mStatusLabel.textAlignment=NSTextAlignmentCenter;
        _mStatusLabel.textColor=[UIColor whiteColor];
        _mStatusLabel.font=[UIFont systemFontOfSize:KScreenScale(25)];
        _mStatusLabel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
    }
    return _mStatusLabel;
}
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[UILabel new];
        _mTitleLabel.numberOfLines=0;
        _mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
    }
    return _mTitleLabel;
}
@end
