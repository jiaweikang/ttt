//
//  WithdrawFailAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/1.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "WithdrawFailAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface WithdrawFailAlertView ()
@property (nonatomic, strong) NSString                  *showMsg;
@property (nonatomic, copy) WithdrawFailConfirmBlock    confirmBlock;
@end

@implementation WithdrawFailAlertView

+ (WithdrawFailAlertView *)withdrawFailViewWithMsg:(NSString *)msg confirmBlock:(WithdrawFailConfirmBlock)block{
    return [[self alloc]initWithMsg:msg confirmBlock:block];
}

- (instancetype)initWithMsg:(NSString *)msg confirmBlock:(WithdrawFailConfirmBlock)block{
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]) {
        self.showMsg = msg;
        self.confirmBlock = [block copy];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.text=@"申请失败!";
    titleLab.textColor=[UIColor convertHexToRGB:@"f63937"];
    titleLab.font=[UIFont boldSystemFontOfSize:KScreenScale(38)];
    [self addSubview:titleLab];
    titleLab.sd_layout.topSpaceToView(self, KScreenScale(82))
    .leftSpaceToView(self, KScreenScale(60))
    .rightSpaceToView(self, KScreenScale(60))
    .heightIs(KScreenScale(45));
    UILabel *contentLab=[[UILabel alloc]init];
    contentLab.text=self.showMsg;
    contentLab.numberOfLines=0;
    contentLab.adjustsFontSizeToFitWidth = YES;
    contentLab.textColor=[UIColor convertHexToRGB:@"333333"];
    contentLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    [self addSubview:contentLab];
    CGFloat contentH=[contentLab.text heightForFont:contentLab.font width:__MainScreen_Width-KScreenScale(120)]+5;
    contentLab.sd_layout.topSpaceToView(titleLab, KScreenScale(30))
    .leftSpaceToView(titleLab, 0)
    .rightSpaceToView(titleLab, 0)
    .heightIs(contentH);
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    backBtn.backgroundColor=[UIColor whiteColor];
    backBtn.layer.cornerRadius=5.0;
    backBtn.layer.borderColor=[UIColor convertHexToRGB:@"999999"].CGColor;
    backBtn.layer.borderWidth=0.5;
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(self, KScreenScale(30))
    .bottomSpaceToView(self, KScreenScale(20))
    .widthIs(KScreenScale(290))
    .heightIs(KScreenScale(88));
    UIButton *bankCardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [bankCardBtn setTitle:@"选择银行卡" forState:UIControlStateNormal];
    [bankCardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bankCardBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
    bankCardBtn.layer.cornerRadius=5.0;
    [bankCardBtn addTarget:self action:@selector(chooseBankCardAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bankCardBtn];
    bankCardBtn.sd_layout.topEqualToView(backBtn)
    .leftSpaceToView(backBtn, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(30))
    .heightRatioToView(backBtn, 1.0);
}

- (void)dismiss{
    [self hiddenView];
}

- (void)chooseBankCardAction{
    [self hiddenView];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

@end
