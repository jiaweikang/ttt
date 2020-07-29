//
//  EnterprisePickAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/20.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "EnterprisePickAlertView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>

@implementation EnterprisePickAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat viewHeight = kIphoneX ? KScreenScale(300)+34 : KScreenScale(300);
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, viewHeight)]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
    self.titleLab.sd_layout.topSpaceToView(self, KScreenScale(60))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(50));
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
    backBtn.layer.cornerRadius = 5;
    backBtn.layer.borderWidth = 1;
    backBtn.layer.borderColor = [UIColor convertHexToRGB:@"ef3b39"].CGColor;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    backBtn.sd_layout.topSpaceToView(self.titleLab, KScreenScale(60))
    .leftSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(330))
    .heightIs(KScreenScale(100));
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确认完成" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
    confirmBtn.layer.cornerRadius = 5;
    confirmBtn.tag = 1001;
    [confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    confirmBtn.sd_layout.leftSpaceToView(backBtn, KScreenScale(30))
    .topEqualToView(backBtn)
    .widthRatioToView(backBtn, 1.0)
    .heightRatioToView(backBtn, 1.0);
}


#pragma mark - <action>
- (void)backBtnAction:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock(0);
    }
}

- (void)confirmBtnAction:(UIButton *)sender
{
    if (self.actionBlock) {
        self.actionBlock(1);
    }
}

- (void)show
{
    CGFloat frameH=CGRectGetHeight(self.frame);
    self.frame=CGRectMake(0, __MainScreen_Height, __MainScreen_Width,frameH);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, __MainScreen_Height-frameH, __MainScreen_Width, frameH);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(0, __MainScreen_Height, __MainScreen_Width, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - <getters>
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, KScreenScale(100), __MainScreen_Width, 25)];
        _titleLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor = [UIColor convertHexToRGB:@"999999"];
    }
    return _titleLab;
}

@end
