//
//  OrganizeConfirmAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/26.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "OrganizeConfirmAlertView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>

@interface OrganizeConfirmAlertView ()
@property (nonatomic, strong)UILabel    *contentLab;
@property (nonatomic, strong)UIButton   *leftBtn;
@property (nonatomic, strong)UIButton   *rightBtn;

@end

@implementation OrganizeConfirmAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat viewHeight = kIphoneX ? KScreenScale(400)+34 : KScreenScale(400);
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, viewHeight)]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor=[UIColor whiteColor];
    [self sd_addSubviews:@[self.contentLab, self.leftBtn, self.rightBtn]];
    self.contentLab.sd_layout.topSpaceToView(self, KScreenScale(100))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(30);
    self.leftBtn.sd_layout.topSpaceToView(self.contentLab, KScreenScale(100))
    .leftSpaceToView(self, KScreenScale(25))
    .widthIs(KScreenScale(340))
    .heightIs(KScreenScale(90));
    self.rightBtn.sd_layout.topEqualToView(self.leftBtn)
    .rightSpaceToView(self, KScreenScale(25))
    .widthRatioToView(self.leftBtn, 1.0)
    .heightRatioToView(self.leftBtn, 1.0);
}


#pragma mark - <action>
- (void)leftBtnAction:(UIButton *)sender
{
    [self hiddenView];
}

- (void)rightBtnAction:(UIButton *)sender
{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

-(void)setConfirmedStr:(NSString *)confirmStr
{
    NSString *str = [NSString stringWithFormat:@"您确定是%@员工吗?",confirmStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:KScreenScale(36)],NSForegroundColorAttributeName:[UIColor convertHexToRGB:@"333333"]} range:NSMakeRange(4, str.length-8)];
    self.contentLab.attributedText = attributedStr;
}

//重写类别方法
- (void) rootViewClick:(UIGestureRecognizer *)sender{
}
#pragma mark - <getter>
- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.adjustsFontSizeToFitWidth=YES;
        _contentLab.textColor = [UIColor convertHexToRGB:@"999999"];
        _contentLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _contentLab.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLab;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"我再看看" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        _leftBtn.layer.cornerRadius = 5;
        _leftBtn.layer.borderWidth = 1;
        _leftBtn.layer.borderColor = [UIColor convertHexToRGB:@"ef3b39"].CGColor;
        [_leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"确定好了" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
        _rightBtn.layer.cornerRadius = 5;
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
