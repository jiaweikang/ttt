//
//  ProtocolAlertView.h
//  u_store
//
//  Created by jiangxintong on 2018/12/17.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "ProtocolAlertView.h"
#import "UIView+ShowAnimation.h"
#import <UIView+SDAutoLayout.h>

@interface ProtocolAlertView ()

@property (nonatomic, copy) ProtocolAlertConfirmBlock confirmBlock;

@end

@implementation ProtocolAlertView

+ (ProtocolAlertView *)protocolAlertView:(ProtocolAlertConfirmBlock)confirmBlock {
    return [[self alloc] initWithConfirmBlock:confirmBlock];
}

- (instancetype)initWithConfirmBlock:(ProtocolAlertConfirmBlock)confirmBlock {
    if (self = [super init]) {
        _confirmBlock = confirmBlock;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.frame =CGRectMake(0, 0, KScreenScale(600), KScreenScale(320));
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=10;
    self.clipsToBounds=YES;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"服务协议已更新\n请阅读后继续使用";
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:KScreenScale(34)];
    lab.adjustsFontSizeToFitWidth = YES;
    lab.textColor = [UIColor convertHexToRGB:@"666666"];
    [self addSubview:lab];
    CGFloat labHeight = [lab.text heightForFont:lab.font width:KScreenScale(600)];
    lab.sd_layout.topSpaceToView(self, KScreenScale(70))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(labHeight);
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
    [confirmBtn setTitle:@"现在阅读" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
    confirmBtn.layer.cornerRadius = KScreenScale(70)/2.0;
    confirmBtn.layer.borderWidth = 0.5;
    confirmBtn.layer.borderColor = [UIColor convertHexToRGB:@"ef3b39"].CGColor;
    [confirmBtn addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    confirmBtn.sd_layout.leftSpaceToView(self, KScreenScale(30))
    .bottomSpaceToView(self, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(KScreenScale(70));
}

- (void)confirmButtonAction {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [self dismiss];
}

- (void)dismiss {
    [self hiddenView];
}

@end
