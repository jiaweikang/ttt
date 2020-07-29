//
//  USRedPacketCashStartView.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/9.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USRedPacketCashStartView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>

@implementation USRedPacketCashStartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIButton *btn_dismiss = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_dismiss setBackgroundImage:[UIImage bundleImageNamed:@"CountDoenClose"] forState:UIControlStateNormal];
    [btn_dismiss addTarget:self action:@selector(dismissBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_dismiss];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"redPacketCash_img_frontBg"]];
    imgView.userInteractionEnabled = YES;
    [self addSubview:imgView];
    UIButton *btn_start = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_start setBackgroundImage:[UIImage bundleImageNamed:@"redPacketCash_btn_start"] forState:UIControlStateNormal];
    [btn_start addTarget:self action:@selector(startBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:btn_start];
    imgView.sd_layout.centerXIs(CGRectGetWidth(self.frame)*0.5)
    .centerYIs(CGRectGetHeight(self.frame)*0.5)
    .widthIs(KScreenScale(670))
    .heightIs(KScreenScale(660));
    btn_start.sd_layout.centerXEqualToView(imgView)
    .bottomSpaceToView(imgView, KScreenScale(50))
    .widthIs(KScreenScale(420))
    .heightIs(KScreenScale(108));
    btn_dismiss.sd_layout.centerXEqualToView(imgView)
    .bottomSpaceToView(imgView, KScreenScale(40))
    .widthIs(KScreenScale(64))
    .heightIs(KScreenScale(64));
}


- (void)startBtnAction{
    if (self.confirmActionBlock) {
        self.confirmActionBlock();
    }
    [self hiddenView];
}

- (void)dismissBtnAction{
    [self hiddenView];
}

@end
