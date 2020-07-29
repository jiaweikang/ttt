//
//  US_PresentBottomAlertView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_PresentBottomAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>
#define kLeftMargin 25
#define kScreenW   [[UIScreen mainScreen] bounds].size.width
#define kScreenH   [[UIScreen mainScreen] bounds].size.height
@interface US_PresentBottomAlertView ()

@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * messageLab;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * confirmButton;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, copy) NSString * confirmTitle;

@end


@implementation US_PresentBottomAlertView
+ (US_PresentBottomAlertView *)presentBottomAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle{
    return [[US_PresentBottomAlertView alloc] initWithWithTitle:title message:message cancelButtonTitle:cancelTitle confirmButtonTitle:confirmTitle];
}
- (instancetype) initWithWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle{
    if (self=[super initWithFrame:CGRectMake(0, 0, kScreenW, KScreenScale(400))]){
        self.title = title;
        self.message = message;
        self.cancelTitle = cancelTitle;
        self.confirmTitle = confirmTitle;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=5.0;
    
    
    [self sd_addSubviews:@[self.titleLab,self.messageLab,self.cancelButton,self.confirmButton]];
    
    self.titleLab.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, kLeftMargin/2)
    .rightSpaceToView(self, kLeftMargin/2)
    .autoHeightRatio(0);
    
    self.messageLab.sd_layout
    .topSpaceToView(self.titleLab, kLeftMargin/2)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .autoHeightRatio(0);
    
    CGFloat buttonWidth = (kScreenW-kLeftMargin*1.5)/2;
    self.cancelButton.sd_layout
    .topSpaceToView(self.messageLab, 20)
    .leftEqualToView(self.titleLab)
    .widthIs(buttonWidth)
    .heightIs(KScreenScale(90));
    
    self.confirmButton.sd_layout
    .topSpaceToView(self.messageLab, 20)
    .rightEqualToView(self.titleLab)
    .widthIs(buttonWidth)
    .heightIs(KScreenScale(90));
    
    [self.titleLab setText:self.title];
    [self.messageLab setText:self.message];
    [_cancelButton setTitle:self.cancelTitle forState: UIControlStateNormal];
    [_confirmButton setTitle:self.confirmTitle forState: UIControlStateNormal];
    
    [self setupAutoHeightWithBottomViewsArray:@[self.cancelButton,self.confirmButton] bottomMargin:20];
    
    if (self.cancelTitle.length<=0&&self.confirmTitle.length<=0) {
        [self.cancelButton setHidden:YES];
        [self.confirmButton setHidden:YES];
        NSLog(@"Error:Alert View cancelTitle and confirmTitle can't be nil at the same time");
        return;
    }
    if (self.cancelTitle.length<=0) {
        [self.cancelButton setHidden:YES];
        self.confirmButton.sd_layout
        .leftSpaceToView(self, kLeftMargin)
        .widthIs(kScreenW-kLeftMargin);
    }
    if (self.confirmTitle.length<=0) {
        [self.confirmButton setHidden:YES];
        self.cancelButton.sd_layout
        .leftSpaceToView(self, kLeftMargin)
        .widthIs(kScreenW-kLeftMargin);
    }
    [self layoutIfNeeded];
}


-(void)show{
    [self showViewWithAnimation:AniamtionPresentBottom];
}


-(void)dismiss{
    [self hiddenView];
}

- (void)confirmButtonClicked:(UIButton *)button{
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    [self hiddenView];
}

#pragma mark - setter and getter
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[UILabel new];
        [_titleLab setFont:[UIFont systemFontOfSize:KScreenScale(36)]];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _titleLab;
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab=[UILabel new];
        [_messageLab setFont:[UIFont systemFontOfSize:KScreenScale(33)]];
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.numberOfLines = 0;
        _messageLab.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _messageLab;
}

- (UIButton *)cancelButton{
    
    if (_cancelButton==nil) {
        _cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.backgroundColor=[UIColor whiteColor];
        _cancelButton.layer.borderWidth=1.0;
        _cancelButton.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
        _cancelButton.layer.cornerRadius=5.0;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(36)];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton{
    if (_confirmButton==nil) {
        _confirmButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        _confirmButton.layer.cornerRadius=5.0;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(36)];
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
@end
