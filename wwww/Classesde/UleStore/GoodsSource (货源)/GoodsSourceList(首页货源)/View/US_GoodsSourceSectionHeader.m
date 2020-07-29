//
//  US_GoodsSourceSectionHeader.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceSectionHeader.h"
#import <UIView+SDAutoLayout.h>
#import "UIView+Shade.h"
@interface US_GoodsSourceSectionHeader ()
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation US_GoodsSourceSectionHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setUI{
    [self sd_addSubviews:@[self.titleLabel]];
    self.titleLabel.sd_layout.centerXEqualToView(self)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .autoWidthRatio(0);
    
}

- (void)setModel:(NewHomeRecommendData*)model{
    _model=model;
    self.titleLabel.text=model.more_title;
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];

}

#pragma mark - <click event>
- (void)headClick:(UIGestureRecognizer *)recognizer{
    NSMutableDictionary *dic = @{
                                 @"title": @"爆款商品",
                                 @"key":NonEmpty(self.model.more_url),
                                 }.mutableCopy;
    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
}

#pragma mark - <setter and getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.font=[UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor convertHexToRGB:@"ec3d3f"];
    }
    return _titleLabel;
}

@end

@interface US_GoodsSourceFooter ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * leftLine;
@property (nonatomic, strong) UIView * rightLine;
@end

@implementation US_GoodsSourceFooter

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_addSubviews:@[self.leftLine,self.rightLine,self.titleLabel]];
        self.titleLabel.sd_layout.centerXEqualToView(self)
        .centerYEqualToView(self)
        .heightIs(KScreenScale(30))
        .autoWidthRatio(0);
        
        self.leftLine.sd_layout.centerYEqualToView(self.titleLabel)
        .rightSpaceToView(self.titleLabel, 5)
        .heightIs(0.5)
        .widthIs(KScreenScale(90));
        
        self.rightLine.sd_layout.centerYEqualToView(self.titleLabel)
        .leftSpaceToView(self.titleLabel, 5)
        .heightIs(0.5)
        .widthIs(KScreenScale(90));
        
        [self.titleLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return self;
}

#pragma mark - <setter and getter>
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.text = @"我是有底线的";
        _titleLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor convertHexToRGB:@"BBBBBB"];
    }
    return _titleLabel;
}

- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine=[UIView new];
        _leftLine.backgroundColor = [UIColor convertHexToRGB:@"bbbbbb"];
    }
    return _leftLine;
}
- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine=[UIView new];
        _rightLine.backgroundColor = [UIColor convertHexToRGB:@"bbbbbb"];
    }
    return _rightLine;
}
@end

@interface US_GoodsSourceRecommendHeader ()
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel   *mLabel;
@end

@implementation US_GoodsSourceRecommendHeader

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    self.backgroundColor=[UIColor whiteColor];
    [self sd_addSubviews:@[self.lineView, self.mLabel]];
    self.lineView.sd_layout.topSpaceToView(self, 10)
    .leftSpaceToView(self, 5)
    .heightIs(20)
    .widthIs(3);
    self.mLabel.sd_layout.leftSpaceToView(self.lineView, 7)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, 0);
}

#pragma mark - <getters>
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 20)];
        _lineView.layer.masksToBounds=YES;
        _lineView.layer.cornerRadius=1.5;
        CAGradientLayer *layer=[UIView setGradualSizeChangingColor:_lineView.bounds.size fromColor:[UIColor convertHexToRGB:@"FF7D43"] toColor:[UIColor convertHexToRGB:@"FE3247"] gradualType:GradualTypeVertical];
        [_lineView.layer addSublayer:layer];
    }
    return _lineView;
}
- (UILabel *)mLabel{
    if (!_mLabel) {
        _mLabel=[[UILabel alloc]init];
        _mLabel.text=@"优品推荐";
        _mLabel.textColor=[UIColor convertHexToRGB:@"4E4E4E"];
        _mLabel.font=[UIFont boldSystemFontOfSize:15];
    }
    return _mLabel;
}

@end
