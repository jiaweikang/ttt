//
//  US_EmptyPlaceHoldView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_EmptyPlaceHoldView.h"
#import <UIView+SDAutoLayout.h>
#import "UIView+Shade.h"
@interface US_EmptyPlaceHoldView ()



@end

@implementation US_EmptyPlaceHoldView
- (instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor convertHexToRGB:@"f5f5f5"];
    [self sd_addSubviews:@[self.iconImageView,self.titleLabel,self.subTitleLabel,self.clickBtn]];
    
    self.titleLabel.sd_layout.leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .centerYEqualToView(self)
    .heightIs(KScreenScale(35));
    
    self.iconImageView.sd_layout.bottomSpaceToView(self.titleLabel, 10)
    .widthIs(KScreenScale(360))
    .centerXEqualToView(self)
    .heightEqualToWidth();
    
    self.subTitleLabel.sd_layout.leftEqualToView(self.titleLabel)
    .rightEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, 0)
    .heightIs(25);
    
    self.clickBtn.sd_layout.leftSpaceToView(self, KScreenScale(195))
    .topSpaceToView(self.titleLabel, KScreenScale(71))
    .widthIs(KScreenScale(360))
    .heightIs(KScreenScale(80));
    [self layoutBtnLayer];
    
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap:)];
    [self addGestureRecognizer:tap];
}

- (void)layoutBtnLayer
{
    self.clickBtn.layer.mask = [UIView drawCornerRadiusWithRect:self.clickBtn.bounds corners:UIRectCornerAllCorners size:CGSizeMake(KScreenScale(40), KScreenScale(40))];
    [self.clickBtn.layer addSublayer:[UIView setGradualChangingColor:self.clickBtn fromColor:[UIColor convertHexToRGB:@"FE5F45"] toColor:[UIColor convertHexToRGB:@"FD2448"] gradualType:GradualTypeHorizontal]];
}

- (void)clickTap:(UIGestureRecognizer *)recognizer
{
    if (self.clickEvent) {
        self.clickEvent();
    }
}

- (void)setDescribe:(NSString *)describe
{
    self.subTitleLabel.hidden = NO;
    self.subTitleLabel.text = describe;
    
    self.clickBtn.sd_layout.leftSpaceToView(self, KScreenScale(195))
    .topSpaceToView(self.subTitleLabel, KScreenScale(71))
    .widthIs(KScreenScale(360))
    .heightIs(KScreenScale(80));
}

- (void)setClickBtnText:(NSString *)clickBtnText
{
    self.clickBtn.hidden = NO;
    [self.clickBtn setTitle:clickBtnText forState:UIControlStateNormal];
    self.clickBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
    
    if (self.describe.length > 0) {
        self.clickBtn.sd_layout.leftSpaceToView(self, KScreenScale(195))
        .topSpaceToView(self.subTitleLabel, KScreenScale(71))
        .widthIs(KScreenScale(360))
        .heightIs(KScreenScale(80));
    } else {
        self.clickBtn.sd_layout.leftSpaceToView(self, KScreenScale(195))
        .topSpaceToView(self.titleLabel, KScreenScale(71))
        .widthIs(KScreenScale(360))
        .heightIs(KScreenScale(80));
    }
}

- (void)clickBtnAction:(UIButton *)btn
{
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
}

#pragma mark- setter and getter
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
        _iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_empty"];
        _iconImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

- (UILabel *) titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _titleLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        _titleLabel.text=@"啊哦！您还没有添加商品哦";
        _titleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel=[[UILabel alloc] init];
        _subTitleLabel.hidden = YES;
        _subTitleLabel.font=[UIFont systemFontOfSize:14.0f];
        _subTitleLabel.textColor=[UIColor convertHexToRGB:@"6D6D6D"];
        _subTitleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}

- (UIButton *)clickBtn
{
    if (!_clickBtn) {
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.hidden = YES;
        [_clickBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_clickBtn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

@end
