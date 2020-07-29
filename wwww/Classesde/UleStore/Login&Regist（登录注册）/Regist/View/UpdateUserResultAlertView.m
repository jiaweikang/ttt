//
//  US_UpdateUserInfoAlertView.m
//  u_store
//
//  Created by xstones on 2017/1/16.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "UpdateUserResultAlertView.h"
#import "NSString+Addition.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface UpdateUserResultAlertView ()
@property (nonatomic, assign) UpdateResultAlertViewType type;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UpdateResultAlertConfirmBlock confirmB;

@end

@implementation UpdateUserResultAlertView

+(UpdateUserResultAlertView *)updateAlertviewWithType:(UpdateResultAlertViewType)type andMessage:(NSString *)msg confirmBlock:(UpdateResultAlertConfirmBlock)confirmBlock
{
    return [[self alloc]initWithUpdateAlertViewWithType:type andMessage:msg confirmBlock:confirmBlock];
}

-(instancetype)initWithUpdateAlertViewWithType:(UpdateResultAlertViewType)type andMessage:(NSString *)msg confirmBlock:(UpdateResultAlertConfirmBlock)confirmBlock
{
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]) {
        _type=type;
        _message=msg;
        _confirmB=confirmBlock;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    NSString *imgName=@"";
    if (_type==UpdateResultAlertViewTypeSuccess) {
        imgName=@"withdraw_img_success";
    }else{
        imgName=@"withdraw_img_fail";
    }
    UIImageView *imgView = [[UIImageView alloc]init];
    [imgView setImage:[UIImage bundleImageNamed:imgName]];
    [self addSubview:imgView];
    
    UILabel *contentLab=[[UILabel alloc]init];
    contentLab.textColor=[UIColor blackColor];
    contentLab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    contentLab.numberOfLines=0;
    contentLab.text=_message;
    [self addSubview:contentLab];
    
    CGFloat contentW=[contentLab.text widthForFont:contentLab.font]+5;
    if (contentW>__MainScreen_Width-95) {
        CGFloat contentH=[contentLab.text heightForFont:contentLab.font width:__MainScreen_Width-95]+5;
        imgView.sd_layout.topSpaceToView(self, 40)
        .leftSpaceToView(self, 20)
        .widthIs(40)
        .heightIs(40);
        contentLab.sd_layout.topSpaceToView(self, 43)
        .leftSpaceToView(imgView, 15)
        .rightSpaceToView(self, 20)
        .heightIs(contentH);
    }else{
        CGFloat contentLabX = (__MainScreen_Width-55-contentW)*0.5;
        imgView.sd_layout.topSpaceToView(self, 35)
        .leftSpaceToView(self, contentLabX)
        .widthIs(40)
        .heightIs(40);
        contentLab.sd_layout.topSpaceToView(self, 45)
        .leftSpaceToView(imgView, 15)
        .widthIs(contentW)
        .heightIs(20);
    }
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.layer.masksToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    if (_type==UpdateResultAlertViewTypeSuccess) {
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        [confirmBtn setTitle:@"我再看看" forState:UIControlStateNormal];
    }
    [self addSubview:confirmBtn];
    confirmBtn.sd_layout.leftSpaceToView(self, 20)
    .bottomSpaceToView(self, 20)
    .rightSpaceToView(self, 20)
    .heightIs(KScreenScale(90));
}

-(void)confirmAction:(UIButton *)sender{
    [self hiddenView];
    if (_confirmB) {
        _confirmB();
    }
}

@end
