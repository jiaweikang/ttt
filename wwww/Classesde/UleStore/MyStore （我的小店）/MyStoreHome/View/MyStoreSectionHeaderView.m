//
//  MyStoreSectionHeaderView.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreSectionHeaderView.h"
#import <UIView+SDAutoLayout.h>
#import "UIView+Shade.h"
#import "US_HomeBtnData.h"
#import "US_MystoreCellModel.h"

@interface MyStoreSectionHeaderView ()
@property (nonatomic, strong)UIView     *mBgView;
@property (nonatomic, strong)UIView     *verticalLineView;
@property (nonatomic, strong)UILabel    *mLabel;
@property (nonatomic, strong)UIView     *horizontalLineView;
@end

@implementation MyStoreSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f5f5f5"];
    [self.contentView sd_addSubviews:@[self.mBgView]];
    [self.mBgView sd_addSubviews:@[self.verticalLineView, self.mLabel, self.horizontalLineView]];
    self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .bottomSpaceToView(self.contentView, 0);
    self.verticalLineView.sd_layout.centerYEqualToView(self.mBgView)
    .leftSpaceToView(self.mBgView, 0)
    .heightIs(15)
    .widthIs(3);
    self.mLabel.sd_layout.leftSpaceToView(self.verticalLineView, 7)
    .topSpaceToView(self.mBgView, 0)
    .bottomSpaceToView(self.mBgView, 0)
    .rightSpaceToView(self.mBgView, 0);
    self.horizontalLineView.sd_layout.bottomSpaceToView(self.mBgView, 0)
    .leftSpaceToView(self.mBgView, KScreenScale(20))
    .rightSpaceToView(self.mBgView, KScreenScale(20))
    .heightIs(0.5);
}

- (void)setModel:(US_MystoreSectionModel*)mModel{
    HomeBtnItem *item=mModel.headData;
    self.mLabel.text=[NSString isNullToString:item.title];
    if ([NSString isNullToString:item.titlecolor].length>0) {
        self.mLabel.textColor=[UIColor convertHexToRGB:[NSString isNullToString:item.titlecolor]];
    }
    if (mModel.headBackColor) {
        self.mBgView.backgroundColor=mModel.headBackColor;
    }else{
        self.mBgView.backgroundColor=[UIColor whiteColor];
    }
}

#pragma mark - <getters>
-(UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]init];
        _mBgView.backgroundColor=[UIColor whiteColor];
        CGRect bounds=CGRectMake(0, 0, KScreenScale(710), KScreenScale(80));
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _mBgView.layer.mask = maskLayer;
    }
    return _mBgView;
}
- (UIView *)verticalLineView{
    if (!_verticalLineView) {
        _verticalLineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 15)];
        _verticalLineView.layer.masksToBounds=YES;
        _verticalLineView.layer.cornerRadius=1.5;
        CAGradientLayer *layer=[UIView setGradualSizeChangingColor:_verticalLineView.bounds.size fromColor:[UIColor convertHexToRGB:@"FF7D43"] toColor:[UIColor convertHexToRGB:@"FE3247"] gradualType:GradualTypeVertical];
        [_verticalLineView.layer addSublayer:layer];
    }
    return _verticalLineView;
}
- (UILabel *)mLabel{
    if (!_mLabel) {
        _mLabel=[[UILabel alloc]init];
        _mLabel.textColor=[UIColor convertHexToRGB:@"4E4E4E"];
        _mLabel.font=[UIFont boldSystemFontOfSize:15];
    }
    return _mLabel;
}
- (UIView *)horizontalLineView{
    if (!_horizontalLineView) {
        _horizontalLineView=[[UIView alloc]init];
        _horizontalLineView.backgroundColor=[UIColor convertHexToRGB:@"f5f5f5"];
    }
    return _horizontalLineView;
}

@end
