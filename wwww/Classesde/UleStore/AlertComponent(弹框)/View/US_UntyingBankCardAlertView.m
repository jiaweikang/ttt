//
//  US_UntyingBankCardAlertView.m
//  u_store
//
//  Created by jiangxintong on 2018/6/4.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_UntyingBankCardAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_UntyingBankCardAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) ConfirmActionBlock confirmBlock;
@property (nonatomic, copy) CancelActionBlock cancelBlock;

@end

@implementation US_UntyingBankCardAlertView
#pragma mark - life cycle
+ (US_UntyingBankCardAlertView *)untyingBankCardAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmAction:(ConfirmActionBlock)confirmBlock cancelAction:(CancelActionBlock)cancelBlock {
    return [[self alloc] initWithTitle:title message:message confirmAction:confirmBlock cancelAction:cancelBlock];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message confirmAction:(ConfirmActionBlock)confirmBlock cancelAction:(CancelActionBlock)cancelBlock {
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kIphoneX ? KScreenScale(400)+24 : KScreenScale(400))]){
        _title = title;
        _message = message;
        _confirmBlock = confirmBlock;
        _cancelBlock = cancelBlock;
        [self setUI];
    }
    return self;
}

- (void)setUI {

    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:KScreenScale(33)];
    titleLabel.text = _title;
    titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    [self addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc]init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];;
    messageLabel.text = _message;
    messageLabel.textColor = [UIColor convertHexToRGB:@"666666"];
    [self addSubview:messageLabel];
    
    titleLabel.sd_layout
    .topSpaceToView(self, KScreenScale(74))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(40));
    messageLabel.sd_layout
    .topSpaceToView(titleLabel, KScreenScale(18))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(40));
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.layer.borderWidth = 1.0;
    cancelBtn.layer.borderColor = [UIColor convertHexToRGB:@"666666"].CGColor;
    cancelBtn.layer.cornerRadius = 5.0;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(36)];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3c3a"];
    confirmBtn.layer.cornerRadius = 5.0;
    [confirmBtn setTitle:@"确定解除绑定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = cancelBtn.titleLabel.font;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    cancelBtn.sd_layout
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs((self.width_sd-KScreenScale(55))/2)
    .heightIs(KScreenScale(90))
    .bottomSpaceToView(self, kIphoneX ? KScreenScale(30)+24 : KScreenScale(30));
    confirmBtn.sd_layout
    .rightSpaceToView(self, KScreenScale(20))
    .widthRatioToView(cancelBtn, 1)
    .heightIs(KScreenScale(90))
    .bottomSpaceToView(self, kIphoneX ? KScreenScale(30)+24 : KScreenScale(30));

}

#pragma mark - event response
- (void)confirmAction:(id)sender {
    [self hiddenView];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)cancelAction:(id)sender {
    [self hiddenView];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
