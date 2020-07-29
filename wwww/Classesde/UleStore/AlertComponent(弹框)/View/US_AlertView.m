//
//  US_AlertView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_AlertView.h"
#import <UIView+SDAutoLayout.h>
#define kLeftMargin 25
#define kScreenW   [[UIScreen mainScreen] bounds].size.width
#define kScreenH   [[UIScreen mainScreen] bounds].size.height
@interface US_AlertView ()
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * messageLab;
@property (nonatomic, strong) UIButton * cancelButton;
@property (nonatomic, strong) UIButton * confirmButton;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, copy) NSString * cancelTitle;
@property (nonatomic, copy) NSString * confirmTitle;
@end

@implementation US_AlertView


+ (US_AlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle{
    return [[US_AlertView alloc] initWithWithTitle:title message:message cancelButtonTitle:cancelTitle confirmButtonTitle:confirmTitle];
}

- (instancetype) initWithWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle{
    self= [super initWithFrame:CGRectMake(0, 0, 270, 270)];
    if (self) {
        self.title = title;
        self.message = message;
        self.cancelTitle = cancelTitle;
        self.confirmTitle = confirmTitle;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius=8;
    self.clipsToBounds=YES;
    [self sd_addSubviews:@[self.titleLab,self.messageLab,self.cancelButton,self.confirmButton]];
    
    self.titleLab.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, kLeftMargin)
    .rightSpaceToView(self, kLeftMargin)
    .autoHeightRatio(0);
    
    self.messageLab.sd_layout
    .topSpaceToView(self.titleLab, kLeftMargin/2)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .autoHeightRatio(0);
    
    CGFloat buttonWidth = (280-30*2-20)/2;
    self.cancelButton.sd_layout
    .topSpaceToView(self.messageLab, 20)
    .leftEqualToView(self.titleLab)
    .widthIs(buttonWidth)
    .heightIs(38);
    
    self.confirmButton.sd_layout
    .topSpaceToView(self.messageLab, 20)
    .rightEqualToView(self.titleLab)
    .widthIs(buttonWidth)
    .heightIs(38);
    
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
        .widthIs(280-kLeftMargin*2);
    }
    if (self.confirmTitle.length<=0) {
        [self.confirmButton setHidden:YES];
        self.cancelButton.sd_layout
        .leftSpaceToView(self, kLeftMargin)
        .widthIs(280-kLeftMargin*2);
    }
}

- (void)cancelButtonClicked:(UIButton *)button{
    
    if (self.clickBlock) {
        self.clickBlock(0, self.cancelTitle);
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(uleAlertView:clickedButtonAtIndex:)])
    {
        [_delegate uleAlertView:self clickedButtonAtIndex:button.tag];
    }
    [self hiddenView];
}

- (void)confirmButtonClicked:(UIButton *)button{
    
    if (self.clickBlock) {
        self.clickBlock(1, self.confirmTitle);
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(uleAlertView:clickedButtonAtIndex:)])
    {
        [self.delegate uleAlertView:self clickedButtonAtIndex:button.tag];
    }
    [self hiddenView];
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.frame=CGRectMake((kScreenW-CGRectGetWidth(rect))/2.0, (kScreenH-CGRectGetHeight(rect))/2.0, CGRectGetWidth(rect),CGRectGetHeight(rect));
}


#pragma mark - setter and getter

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[UILabel new];
        if (kSystemVersion>=9.0) {
            [_titleLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:19]];
        }
        else{
            [_titleLab setFont:[UIFont systemFontOfSize:19]];
        }
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.textColor=[UIColor blackColor];
        _titleLab.backgroundColor = [UIColor clearColor];
    }
    return _titleLab;
}

- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab=[UILabel new];
        if (kSystemVersion>=9.0) {
            [_messageLab setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
        }
        else{
            [_messageLab setFont:[UIFont systemFontOfSize:15]];
        }
        _messageLab.textAlignment = NSTextAlignmentCenter;
        _messageLab.textColor=[UIColor blackColor];
    }
    return _messageLab;
}

- (UIButton *)cancelButton{
    if (_cancelButton==nil) {
        _cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.tag=0;
        if (kSystemVersion>=9.0) {
            [_cancelButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        }
        else{
            [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        }
        [_cancelButton setBackgroundColor:[UIColor convertHexToRGB:@"ffffff"]];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 2.0;
        _cancelButton.layer.borderColor = [[UIColor convertHexToRGB:@"bbbbbb"] CGColor];
        _cancelButton.layer.borderWidth = 0.6f;
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton{
    if (_confirmButton==nil) {
        _confirmButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.tag=1;
        if (kSystemVersion>=9.0) {
            [_confirmButton.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:17]];
        }
        else{
            [_confirmButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        }
        [_confirmButton setBackgroundColor:[UIColor convertHexToRGB:@"e42222"]];
        [_confirmButton setTitleColor:[UIColor convertHexToRGB:@"fefefe"] forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 2.0;
        [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
