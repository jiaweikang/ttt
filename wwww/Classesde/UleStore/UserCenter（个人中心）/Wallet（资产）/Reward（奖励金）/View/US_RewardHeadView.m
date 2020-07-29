//
//  US_RewardHeadView.m
//  u_store
//
//  Created by mac_chen on 2019/6/26.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_RewardHeadView.h"
#import "US_RewardChooseBtn.h"
#import "TotalRewardsModel.h"
#import "UIView+Shade.h"
#import <UIView+SDAutoLayout.h>

@interface US_RewardHeadView () <ChooseBtnViewDelegate>

@property (nonatomic, strong) UIView *showView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *totalCountLbl; //总额
@property (nonatomic, strong) UILabel *leftLbl; //可用余额
@property (nonatomic, strong) UILabel *rightLbl; //延时生效金额
@property (nonatomic, strong) UILabel *hintLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) US_RewardChooseBtn *chooseBtn;

@end

@implementation US_RewardHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    [self sd_addSubviews:@[self.showView, self.chooseBtn]];
    [self.showView sd_addSubviews:@[self.titleLbl, self.totalCountLbl, self.leftLbl, self.rightLbl, self.hintLbl, self.lineView]];
    
//    self.showView.sd_layout
//    .leftSpaceToView(self, 0)
//    .topSpaceToView(self, 0)
//    .widthIs(__MainScreen_Width)
//    .heightIs(KScreenScale(316));
    
    self.titleLbl.sd_layout
    .leftSpaceToView(self.showView, 0)
    .topSpaceToView(self.showView, KScreenScale(20))
    .widthIs(__MainScreen_Width)
    .heightIs(KScreenScale(30));
    
    self.totalCountLbl.sd_layout
    .leftSpaceToView(self.showView, 0)
    .topSpaceToView(self.showView, KScreenScale(80))
    .widthIs(__MainScreen_Width)
    .heightIs(KScreenScale(50));
    
    self.lineView.sd_layout
    .leftSpaceToView(self.showView, __MainScreen_Width / 2)
    .topSpaceToView(self.showView, KScreenScale(168))
    .widthIs(1)
    .heightIs(KScreenScale(40));
    
    self.leftLbl.sd_layout.topSpaceToView(self.showView, KScreenScale(170))
    .leftSpaceToView(self.showView, KScreenScale(20))
    .rightSpaceToView(self.lineView, KScreenScale(20))
    .heightIs(KScreenScale(32));
    
    self.rightLbl.sd_layout.topEqualToView(self.leftLbl)
    .leftSpaceToView(self.lineView, KScreenScale(20))
    .rightSpaceToView(self.showView, KScreenScale(20))
    .heightIs(KScreenScale(32));
    
    self.hintLbl.sd_layout
    .leftSpaceToView(self.showView, KScreenScale(30))
    .bottomSpaceToView(self.showView, KScreenScale(24))
    .widthIs(__MainScreen_Width - KScreenScale(60))
    .heightIs(KScreenScale(60));
    
}

- (void)setModel:(TotalRewardsHeadData *)model{
    float nullCount = 0.00;
    self.totalCountLbl.text = [NSString stringWithFormat:@"%.2f", model.rewardTotal.floatValue == 0 ? nullCount : model.rewardTotal.floatValue];
    self.leftLbl.text = [NSString stringWithFormat:@"%@%.2f", _leftLbl.text, model.balance.floatValue == 0 ? nullCount : model.balance.floatValue];
    self.rightLbl.text = [NSString stringWithFormat:@"%@%.2f", _rightLbl.text, model.delayBalance.floatValue == 0 ? nullCount : model.delayBalance.floatValue];
    self.hintLbl.text = model.tip;
    
    if (self.leftLbl.text.length>9) {
        [self setAttributedUlePrice:self.leftLbl RangeIndex:NSMakeRange(9, self.leftLbl.text.length-9)];
    }
    if (self.rightLbl.text.length>11) {
         [self setAttributedUlePrice:self.rightLbl RangeIndex:NSMakeRange(11, self.rightLbl.text.length-11)];
    }
}

- (void)topViewDidSelectAtIndex:(NSInteger)index
{
    NSString *transFlag;
    switch (index) {
        case 0:
            transFlag = @"";
            break;
        case 1:
            transFlag = @"D";
            break;
        case 2:
            transFlag = @"E";
            break;
        default:
            break;
    }
    if (self.chooseBtnBlock) {
        self.chooseBtnBlock(transFlag);
    }
}

//渐变
- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, __MainScreen_Width, KScreenScale(316));// 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向为垂直方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1); // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0, @1.0];
    return gradientLayer;
}

//自适应宽度
- (CGFloat)getWitdthForString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(0, KScreenScale(30)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KScreenScale(24)]} context:nil].size.width;
}

//富文本
- (void)setAttributedUlePrice:(UILabel *)label RangeIndex:(NSRange)range {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(30)] range:range];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    label.attributedText = attributedStr;
}

#pragma mark - <setter and getter>
- (UIView *)showView
{
    if (!_showView) {
        _showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(316))];
        [_showView.layer addSublayer:[UIView setGradualChangingColor:_showView fromColor:[UIColor convertHexToRGB:@"EC3D3F"] toColor:[UIColor convertHexToRGB:@"FF663E"] gradualType:GradualTypeVertical]];
    }
    return _showView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"奖励金总额(元)";
        _titleLbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _titleLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UILabel *)totalCountLbl{
    if (!_totalCountLbl) {
        _totalCountLbl = [[UILabel alloc] init];
        _totalCountLbl.textColor = [UIColor whiteColor];
        _totalCountLbl.font = [UIFont systemFontOfSize:KScreenScale(60)];
        _totalCountLbl.text = @"0.00";
        _totalCountLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _totalCountLbl;
}

- (UILabel *)leftLbl{
    if (!_leftLbl) {
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.text = @"可用余额(元)  ";
        _leftLbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _leftLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _leftLbl.textAlignment=NSTextAlignmentCenter;
        _leftLbl.adjustsFontSizeToFitWidth=YES;
    }
    return _leftLbl;
}

- (UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.text = @"延时生效余额(元)  ";
        _rightLbl.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _rightLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _rightLbl.textAlignment=NSTextAlignmentCenter;
        _rightLbl.adjustsFontSizeToFitWidth=YES;
    }
    return _rightLbl;
}

- (UILabel *)hintLbl{
    if (!_hintLbl) {
        _hintLbl = [[UILabel alloc] init];
        _hintLbl.backgroundColor = [UIColor convertHexToRGB:@"FFECC8"];
        _hintLbl.text = @"*奖励金存在有效期，请在有效期内使用（仅限支付时使用）";
        _hintLbl.textColor = [UIColor convertHexToRGB:@"BD851E"];
        _hintLbl.textAlignment = NSTextAlignmentCenter;
        _hintLbl.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _hintLbl.layer.masksToBounds = YES;
        _hintLbl.layer.cornerRadius = KScreenScale(30);
    }
    return _hintLbl;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}

- (US_RewardChooseBtn *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [US_RewardChooseBtn topViewWithDelegate:self frame:CGRectMake(0, KScreenScale(316), __MainScreen_Width, KScreenScale(88)+1.5+1)];
        [_chooseBtn selectBtnAtIndex:0];
    }
    return _chooseBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
