//
//  OrganizePickAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "OrganizePickAlertView.h"
#import <UIView+SDAutoLayout.h>

@interface OrganizePickAlertView ()
@property (nonatomic, strong)UIButton       *backUpBtn;
@property (nonatomic, strong)UILabel        *lastLab;
@property (nonatomic, strong)UILabel        *presentLab;
@property (nonatomic, strong)UIButton       *leftBtn;
@property (nonatomic, strong)UIButton       *rightBtn;

@end

@implementation OrganizePickAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat viewHeight = kIphoneX ? KScreenScale(300)+34 : KScreenScale(300);
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, viewHeight)]) {
        [self setUI];
    }
    return self;
}


- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self sd_addSubviews:@[self.backUpBtn, self.lastLab, self.presentLab, self.leftBtn, self.rightBtn]];
    self.backUpBtn.sd_layout.topSpaceToView(self, KScreenScale(30))
    .leftSpaceToView(self, KScreenScale(25))
    .widthIs(KScreenScale(150))
    .heightIs(25);
    self.lastLab.sd_layout.topEqualToView(self.backUpBtn)
    .leftSpaceToView(self.backUpBtn, KScreenScale(10))
    .rightSpaceToView(self, KScreenScale(25))
    .heightRatioToView(self.backUpBtn, 1.0);
    self.presentLab.sd_layout.topSpaceToView(self, KScreenScale(100))
    .leftSpaceToView(self, 0)
    .widthIs(__MainScreen_Width)
    .heightIs(25);
    self.leftBtn.sd_layout.topSpaceToView(self.presentLab, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(25))
    .widthIs(KScreenScale(340))
    .heightIs(KScreenScale(100));
    self.rightBtn.sd_layout.topEqualToView(self.leftBtn)
    .leftSpaceToView(self.leftBtn, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(25))
    .heightRatioToView(self.leftBtn, 1.0);
}


#pragma mark - <action>
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

- (void)showBackupBtn:(BOOL)isShow
{
    self.backUpBtn.hidden=!isShow;
}

-(void)setPresentStr:(NSString *)presentStr andLastStr:(nonnull NSString *)lastStr
{
    NSString *str = [NSString stringWithFormat:@"我是%@员工",presentStr];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:KScreenScale(36)],NSForegroundColorAttributeName:[UIColor convertHexToRGB:@"7a7a7a"]} range:NSMakeRange(2, str.length-4)];
    self.presentLab.attributedText = attributedStr;
    self.lastLab.text=[NSString stringWithFormat:@"%@", lastStr];
}

- (void)backupBtnAction:(UIButton *)sender
{
    if (self.mDelegate&&[self.mDelegate respondsToSelector:@selector(backupBtnAction)]) {
        [self.mDelegate backupBtnAction];
    }
}

- (void)leftBtnAction:(UIButton *)sender
{
    if (self.mDelegate&&[self.mDelegate respondsToSelector:@selector(leftBtnAction)]) {
        [self.mDelegate leftBtnAction];
    }
}

- (void)rightBtnAction:(UIButton *)sender
{
    if (self.mDelegate&&[self.mDelegate respondsToSelector:@selector(rightBtnAction)]) {
        [self.mDelegate rightBtnAction];
    }
}

#pragma mark - <getter>
- (UIButton *)backUpBtn
{
    if (!_backUpBtn) {
        _backUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backUpBtn setImage:[UIImage bundleImageNamed:@"regis_btn_organize_backup"] forState:UIControlStateNormal];
        [_backUpBtn setImage:[UIImage bundleImageNamed:@"regis_btn_organize_backup"] forState:UIControlStateHighlighted];
        _backUpBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
        [_backUpBtn setTitle:@"返回上级" forState:UIControlStateNormal];
        [_backUpBtn setTitleColor:[UIColor convertHexToRGB:@"36a4f1"] forState:UIControlStateNormal];
        [_backUpBtn addTarget:self action:@selector(backupBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backUpBtn;
}

- (UILabel *)lastLab
{
    if (!_lastLab) {
        _lastLab = [[UILabel alloc]init];
        _lastLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _lastLab.textColor = [UIColor convertHexToRGB:@"999999"];
        _lastLab.adjustsFontSizeToFitWidth=YES;
    }
    return _lastLab;
}

- (UILabel *)presentLab
{
    if (!_presentLab) {
        _presentLab = [[UILabel alloc]init];
        _presentLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _presentLab.textAlignment = NSTextAlignmentCenter;
        _presentLab.textColor = [UIColor convertHexToRGB:@"999999"];
        _presentLab.adjustsFontSizeToFitWidth=YES;
    }
    return _presentLab;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"我在下级机构" forState:UIControlStateNormal];
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
        [_rightBtn setTitle:@"确认完成" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
        _rightBtn.layer.cornerRadius = 5;
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

@end
