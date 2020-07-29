//
//  CouponListCell.m
//  UleApp
//
//  Created by chenhan on 2018/9/10.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "US_CouponListCell.h"
#import <UIView+SDAutoLayout.h>
#import <UIColor+ColorUtility.h>
typedef enum : NSUInteger {
    CouponUseTypeCanUse,    //可以使用
    CouponUseTypeUsed,      //已经使用
    CouponUseTypeExpired,   //已经过期
} CouponUseType;

@interface US_CouponListCell ()
@property (nonatomic, strong) UIView * colorView;
@property (nonatomic, strong) UILabel * valueLabel;
@property (nonatomic, strong) UILabel * discribeLabel;
@property (nonatomic, strong) UILabel * codeLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UILabel * startTimeLabel;
@property (nonatomic, strong) UILabel * endTimeLabel;
@property (nonatomic, strong) UIButton * useButton;
@property (nonatomic, strong) UIImageView * statusIconImageView;
@property (nonatomic, strong) UIImageView * statusImageView;

@end

@implementation US_CouponListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    UIImageView *halfedg = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"coupon_img_splitView.png"]];
    [self.contentView sd_addSubviews:@[self.colorView,halfedg,self.valueLabel,self.codeLabel,self.discribeLabel,self.contentLabel,self.startTimeLabel,self.endTimeLabel,self.useButton,self.statusIconImageView,self.statusImageView]];
    
    self.colorView.sd_layout
    .leftSpaceToView(self.contentView,10)
    .topSpaceToView(self.contentView,5)
    .heightIs(115)
    .widthIs(115);
    
    halfedg.sd_layout
    .leftSpaceToView(self.colorView,-5.25)
    .topEqualToView(self.colorView)
    .widthIs(10.5)
    .heightRatioToView(self.colorView,1);
    
    self.valueLabel.sd_layout
    .leftSpaceToView(self.contentView,12)
    .topSpaceToView(self.contentView,32)
    .heightIs(30)
    .rightSpaceToView(halfedg, 0);
    
    self.discribeLabel.sd_layout
    .leftEqualToView(self.valueLabel)
    .topSpaceToView(self.valueLabel,3)
    .rightEqualToView(self.valueLabel)
    .heightIs(28);
    
    self.contentLabel.sd_layout
    .leftSpaceToView(self.valueLabel,KScreenScale(25))
    .topSpaceToView(self.contentView,24)
    .rightSpaceToView(self.contentView,KScreenScale(75))
    .heightIs(40);
    
    self.useButton.sd_layout
    .bottomSpaceToView(self.contentView, 23)
    .rightSpaceToView(self.contentView,KScreenScale(35))
    .heightIs(21)
    .widthIs(63);
    
    self.startTimeLabel.sd_layout
    .topSpaceToView(self.contentLabel, 0)
    .leftEqualToView(self.contentLabel)
    .rightSpaceToView(self.useButton, 10)
    .bottomSpaceToView(self.contentView,10);
    
    self.statusIconImageView.sd_layout
    .topSpaceToView(self.contentView,5)
    .leftSpaceToView(self.contentView,10)
    .widthIs(60)
    .heightIs(60);
    
    self.statusImageView.sd_layout
    .bottomSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .widthIs(65)
    .heightIs(65);
    
    [self setupAutoHeightWithBottomView:self.colorView bottomMargin:5];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];

    CGRect drawRect = {10, 5, rect.size.width-20, rect.size.height-10};
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:drawRect cornerRadius:5];
    CGContextAddPath(context, bezierPath.CGPath);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextDrawPath(context,kCGPathFill);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setModel:(US_CouponListCellModel *)model{
    _model=model;
    MyCouponModel * couponData=(MyCouponModel *)model.data;
    self.useButton.hidden=NO;
    self.useButton.enabled=NO;
    self.statusIconImageView.hidden=YES;
    self.statusImageView.hidden=YES;
    self.colorView.backgroundColor=model.colorStr.length>0?[UIColor convertHexToRGB:model.colorStr]:[UIColor redColor];
    [self.useButton setTitleColor:model.colorStr.length>0?[UIColor convertHexToRGB:model.colorStr]:[UIColor redColor] forState:UIControlStateNormal];
    self.useButton.layer.masksToBounds = YES;
    _useButton.tintColor = model.colorStr.length>0?[UIColor convertHexToRGB:model.colorStr]:[UIColor redColor];
    self.startTimeLabel.text=model.startTime;
    self.contentLabel.attributedText =model.mCouponNameAttribute;
    self.valueLabel.attributedText=model.mCouponMoneyAttribute;
    self.discribeLabel.text = model.descriStr;
    
    //判断是否显示已用标识
    if ([_model.status isEqualToString:@"2"]) {
        [self.useButton setTitle:@"已使用" forState:UIControlStateNormal];
        _useButton.titleLabel.text=@"已使用";
        self.useButton.enabled=NO;
        self.useButton.hidden=YES;
        self.statusImageView.image=[UIImage bundleImageNamed:@"coupon_img_Used"];
        self.statusImageView.hidden=NO;
        
    } else {
        [self.useButton setTitle:@"立即使用" forState:UIControlStateNormal];
        if ([couponData.couponType isEqualToString:@"4"]) { //充值券 则隐藏button
            self.useButton.hidden = YES;
        } else {
            self.useButton.hidden = NO;
            if (couponData.forthcomingCoupon.integerValue == 1) {//即将过期 券
                self.statusIconImageView.image=[UIImage bundleImageNamed:@"coupon_icon_willexpire"];
                self.statusIconImageView.hidden=NO;
            }
            if (couponData.isTodayCoupon.integerValue == 1) {//新到 券
                self.statusIconImageView.image=[UIImage bundleImageNamed:@"coupon_icon_new"];
                self.statusIconImageView.hidden=NO;
            }
        }
    }
}

#pragma mark - action
- (void)useButtonAction:(UIButton *)sender{
    NSLog(@"Action===");

}

#pragma  mark - setter and getter

- (UIView *)colorView{
    if (_colorView==nil) {
        _colorView=[UIView new];
        _colorView.backgroundColor=[UIColor redColor];
        _colorView.layer.masksToBounds = YES;
        _colorView.layer.cornerRadius = 5.0;
    }
    return _colorView;
}

- (UILabel *)valueLabel{
    if(_valueLabel==nil){
        _valueLabel=[UILabel new];
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        _valueLabel.textColor=[UIColor whiteColor];
        _valueLabel.font=[UIFont systemFontOfSize:22];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLabel;
}

- (UILabel *)codeLabel{
    if(_codeLabel==nil){
        _codeLabel=[UILabel new];
    }
    return _codeLabel;
}

- (UILabel *)contentLabel{
    if (_contentLabel==nil) {
        _contentLabel=[UILabel new];
        _contentLabel.numberOfLines=2;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return  _contentLabel;
}

- (UILabel *)discribeLabel{
    if (_discribeLabel==nil) {
        _discribeLabel=[UILabel new];
        _discribeLabel.backgroundColor = [UIColor clearColor];
        _discribeLabel.textColor = [UIColor whiteColor];
        _discribeLabel.textAlignment = NSTextAlignmentCenter;
        _discribeLabel.font = [UIFont systemFontOfSize:13];
        _discribeLabel.numberOfLines=0;
        _discribeLabel.adjustsFontSizeToFitWidth=YES;
    }
    return  _discribeLabel;
}

- (UILabel *)startTimeLabel{
    if (_startTimeLabel==nil) {
        _startTimeLabel=[UILabel new];
        _startTimeLabel.numberOfLines=1;
        _startTimeLabel.font = [UIFont systemFontOfSize:KScreenScale(20)];
        _startTimeLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _startTimeLabel.adjustsFontSizeToFitWidth=YES;
    }
    return  _startTimeLabel;
}

- (UILabel *)endTimeLabel{
    if (_endTimeLabel==nil) {
        _endTimeLabel=[UILabel new];
        _endTimeLabel.font=[UIFont systemFontOfSize:13];
        _endTimeLabel.textColor=[UIColor whiteColor];
        _endTimeLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _endTimeLabel;
}

- (UIButton *)useButton{
    if (_useButton==nil) {
        _useButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _useButton.layer.cornerRadius = 21/2.0;
        _useButton.layer.borderWidth = 1;
        _useButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _useButton.backgroundColor=[UIColor convertHexToRGB:@"ffffff"];
//        [_useButton addTarget:self action:@selector(useButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useButton;
}

- (UIImageView *)statusIconImageView{
    if (_statusIconImageView==nil) {
        _statusIconImageView=[UIImageView new];
    }
    return _statusIconImageView;
}

- (UIImageView *)statusImageView{
    if (_statusImageView==nil) {
        _statusImageView=[UIImageView new];
    }
    return _statusImageView;
}

@end
