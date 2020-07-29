//
//  RegistStoreSuccessAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "RegistStoreSuccessAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface RegistStoreSuccessAlertView ()
@property (nonatomic, strong)UIImageView    *imgView;
@property (nonatomic, strong)UILabel        *lab;
@property (nonatomic, strong)UIButton       *btn;

@end

@implementation RegistStoreSuccessAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat viewHeight = kIphoneX ? KScreenScale(660)+34 : KScreenScale(660);
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, viewHeight)]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self sd_addSubviews:@[self.imgView, self.lab, self.btn]];
    self.imgView.sd_layout.topSpaceToView(self, KScreenScale(72))
    .centerXEqualToView(self)
    .widthIs(KScreenScale(282))
    .heightIs(KScreenScale(258));
    self.lab.sd_layout.topSpaceToView(self.imgView, KScreenScale(60))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(50));
    self.btn.sd_layout.leftSpaceToView(self, KScreenScale(45))
    .rightSpaceToView(self, KScreenScale(45))
    .bottomSpaceToView(self, KScreenScale(50))
    .heightIs(KScreenScale(90));
}

//重写类别方法
- (void) rootViewClick:(UIGestureRecognizer *)sender{
}

#pragma mark - <action>
- (void)confirmButtonAction:(UIButton *)sender
{
    [self hiddenView];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

#pragma mark - <getter>
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"regis_img_success"]];
    }
    return _imgView;
}

- (UILabel *)lab
{
    if (!_lab) {
        _lab=[[UILabel alloc]init];
        _lab.text=@"恭喜！您已经成功开店";
        _lab.textAlignment=NSTextAlignmentCenter;
        _lab.font=[UIFont systemFontOfSize:KScreenScale(34)];
        _lab.adjustsFontSizeToFitWidth=YES;
        _lab.textColor=[UIColor convertHexToRGB:@"666666"];
    }
    return _lab;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn=[UIButton buttonWithType:UIButtonTypeCustom];
        _btn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        [_btn setTitle:@"确定" forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn.layer.cornerRadius=5.0;
        [_btn addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

@end
