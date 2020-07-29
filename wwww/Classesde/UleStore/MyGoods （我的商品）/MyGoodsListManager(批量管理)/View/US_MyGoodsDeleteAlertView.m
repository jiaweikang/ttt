
//
//  US_MyGoodsDeleteAlertView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_MyGoodsDeleteAlertView ()
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) UILabel * mContentLabel;
@property (nonatomic, strong) UIButton * mCancelButton;
@property (nonatomic, strong) UIButton * mSureButton;
@end

@implementation US_MyGoodsDeleteAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles{
    CGFloat contentHeight=[NSString getSizeOfString:message withFont:self.mContentLabel.font andMaxWidth:__MainScreen_Width-60].height;
    CGFloat height=contentHeight+184;
    height= kStatusBarHeight==20?height:height+34;
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, height)];
    if (self) {
        self.delegate=delegate;
        self.mTitleLabel.text=title;
        self.mContentLabel.text=message;
        [self.mCancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
        [self.mSureButton setTitle:otherButtonTitles forState:UIControlStateNormal];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    [self sd_addSubviews:@[self.mTitleLabel,self.mContentLabel,self.mCancelButton,self.mSureButton]];
    self.mTitleLabel.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(44);
    self.mContentLabel.sd_layout.leftSpaceToView(self, 30)
    .topSpaceToView(self.mTitleLabel, 40)
    .rightSpaceToView(self, 30)
    .autoHeightRatio(0);
    
    self.mCancelButton.sd_layout.leftSpaceToView(self, 20)
    .bottomSpaceToView(self, kStatusBarHeight==20?20:54)
    .heightIs(39)
    .widthIs((__MainScreen_Width-20*3)/2.0);
    
    self.mSureButton.sd_layout.leftSpaceToView(self.mCancelButton, 20)
    .rightSpaceToView(self, 20)
    .bottomEqualToView(self.mCancelButton)
    .heightRatioToView(self.mCancelButton, 1);
    
}

- (void)buttonClick:(UIButton *)sender{
    [self hiddenView];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:sender.tag];
    }
}

- (void) rootViewClick:(UIGestureRecognizer *)sender{
    [self hiddenView];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
        [self.delegate alertView:self clickedButtonAtIndex:0];
    }
}

#pragma mark - <setter and getter>
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[UILabel new];
        _mTitleLabel.font=[UIFont systemFontOfSize:17.0f];
        _mTitleLabel.textColor=[UIColor blackColor];
        _mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _mTitleLabel.backgroundColor=kViewCtrBackColor;
    }
    return _mTitleLabel;
}

- (UILabel *)mContentLabel{
    if (!_mContentLabel) {
        _mContentLabel=[UILabel new];
        _mContentLabel.backgroundColor=[UIColor clearColor];
        _mContentLabel.textColor=[UIColor blackColor];
        _mContentLabel.font=[UIFont systemFontOfSize:15];
        _mContentLabel.textAlignment=NSTextAlignmentCenter;
        [_mContentLabel setTextColor:[UIColor convertHexToRGB:@"333333"]];
        _mContentLabel.numberOfLines=0;
    }
    return _mContentLabel;
}
- (UIButton *)mCancelButton{
    if (!_mCancelButton) {
        _mCancelButton=[[UIButton alloc] initWithFrame:CGRectZero];
        [_mCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _mCancelButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mCancelButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        _mCancelButton.tag=0;
        _mCancelButton.layer.cornerRadius=5;
        _mCancelButton.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
        _mCancelButton.layer.borderWidth=0.6;
        [_mCancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mCancelButton;
}
- (UIButton *)mSureButton{
    if (!_mSureButton) {
        _mSureButton=[[UIButton alloc] initWithFrame:CGRectZero];
        [_mSureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_mSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mSureButton.backgroundColor=kNavBarBackColor;
        _mSureButton.layer.cornerRadius=5;
        _mSureButton.tag=1;
        _mSureButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mSureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mSureButton;
}
@end
