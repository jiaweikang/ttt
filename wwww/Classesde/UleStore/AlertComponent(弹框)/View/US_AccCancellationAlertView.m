//
//  AccCancellationAlertView.m
//  u_store
//
//  Created by jiangxintong on 2018/12/14.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_AccCancellationAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_AccCancellationAlertView ()

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;
@property (nonatomic, copy) Callback callback;

@end

@implementation US_AccCancellationAlertView

+ (US_AccCancellationAlertView *)showResultAlertWithType:(AccCancellationAlertType)alertType message:(NSString *)message callback:(Callback)callback {
    return [[US_AccCancellationAlertView alloc] initWithAlertType:alertType message:message callback:callback];
}

- (instancetype)initWithAlertType:(AccCancellationAlertType)alertType message:(NSString *)message callback:(Callback)callback {
    if (self=[super initWithFrame:CGRectMake(0, 0, KScreenScale(600), KScreenScale(354))]){
        _callback = callback;

        self.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        self.layer.cornerRadius = KScreenScale(16);

        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = alertType==AccCancellationAlertTypeSuccess ? @"申请成功！" : @"申请失败！";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:titleLabel.text];
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        attchImage.image = [UIImage bundleImageNamed:alertType==AccCancellationAlertTypeSuccess ? @"logout_img_success" : @"logout_img_failed"];
        attchImage.bounds = CGRectMake(-KScreenScale(10), -KScreenScale(10), KScreenScale(52), KScreenScale(52));
        NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
        [attriStr insertAttributedString:stringImage atIndex:0];
        titleLabel.attributedText = attriStr;
        [self addSubview:titleLabel];

        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.text = message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        messageLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        messageLabel.numberOfLines = 0;
        [self addSubview:messageLabel];

        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        [self addSubview:lineView];

        UIButton *okBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        okBtn.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        okBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
        [okBtn setTitle:@"好的" forState:(UIControlStateNormal)];
        [okBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:(UIControlStateNormal)];
        [okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:okBtn];

        titleLabel.sd_layout
        .topSpaceToView(self, KScreenScale(50))
        .leftSpaceToView(self, KScreenScale(20))
        .rightSpaceToView(self, KScreenScale(20))
        .heightIs(KScreenScale(35));
        messageLabel.sd_layout
        .topSpaceToView(titleLabel, KScreenScale(30))
        .leftSpaceToView(self, KScreenScale(20))
        .rightSpaceToView(self, KScreenScale(20))
        .autoHeightRatio(0);
        okBtn.sd_layout
        .bottomSpaceToView(self, kIphoneX?34:0)
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 5)
        .heightIs(KScreenScale(90));
        lineView.sd_layout
        .bottomSpaceToView(okBtn, 0)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(1);
        
        [self showViewWithAnimation:AniamtionAlert];
    }
    return self;
}

- (void)okBtnAction {
    [self hiddenView];
    if (_callback) {
        _callback();
    }
}


+ (US_AccCancellationAlertView *)showAlertWithMessage:(NSString *)message cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmBlock)confirmBlock {
    return [[US_AccCancellationAlertView alloc] initAlertWithMessage:message cancelBlock:cancelBlock confirmBlock:confirmBlock];
}

- (instancetype)initAlertWithMessage:(NSString *)message cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmBlock)confirmBlock {
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width,  kIphoneX?34+KScreenScale(419):KScreenScale(419))]){
        _message = message;
        _confirmBlock = confirmBlock;
        _cancelBlock = cancelBlock;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    [self setBackgroundColor:[UIColor convertHexToRGB:@"ffffff"]];
    
    UIImageView *tipImgView = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"accancel_alert"]];
    [self addSubview:tipImgView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor convertHexToRGB:@"333333"];
    label.font = [UIFont systemFontOfSize:KScreenScale(32)];
    [self addSubview:label];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    [self addSubview:lineView];
    
    UIButton *confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    confirmBtn.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
    confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
    confirmBtn.layer.cornerRadius = KScreenScale(45);
    confirmBtn.layer.borderColor = [UIColor convertHexToRGB:@"ef3b39"].CGColor;
    confirmBtn.layer.borderWidth = 0.5;
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:(UIControlStateNormal)];
    [confirmBtn setTitle:@"执意离去" forState:(UIControlStateNormal)];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancelBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
    cancelBtn.layer.cornerRadius = KScreenScale(45);
    [cancelBtn setTitle:@"再看看" forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    tipImgView.sd_layout
    .topSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(140))
    .heightIs(KScreenScale(89))
    .centerXEqualToView(self);
    label.sd_layout
    .topSpaceToView(tipImgView, KScreenScale(50))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(50));
    lineView.sd_layout
    .topSpaceToView(label, KScreenScale(48))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
    
    confirmBtn.sd_layout
    .topSpaceToView(lineView, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(50))
    .widthIs((__MainScreen_Width-KScreenScale(150))/2)
    .heightIs(KScreenScale(90));
    cancelBtn.sd_layout
    .topSpaceToView(lineView, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(50))
    .widthIs((__MainScreen_Width-KScreenScale(150))/2)
    .heightIs(KScreenScale(90));

    [self showViewWithAnimation:AniamtionPresentBottom];
}

- (void)confirmAction {
    [self hiddenView];
    if (_confirmBlock) {
        _confirmBlock();
    }
}

- (void)cancelAction {
    [self hiddenView];
    if (_cancelBlock) {
        _cancelBlock();
    }
}

@end
