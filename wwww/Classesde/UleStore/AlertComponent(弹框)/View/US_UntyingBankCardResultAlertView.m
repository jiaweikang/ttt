//
//  US_UntyingBankCardResultAlertView.m
//  u_store
//
//  Created by jiangxintong on 2018/6/13.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_UntyingBankCardResultAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_UntyingBankCardResultAlertView ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, weak) id<UntyingBankCardResultAlertViewDelegate> mDelegate;
@end

@implementation US_UntyingBankCardResultAlertView
#pragma mark - life cycle
+ (US_UntyingBankCardResultAlertView *)untyingBankCardResultAlertViewWithType:(UntyingBankCardResultAlertViewType)viewType delegate:(id<UntyingBankCardResultAlertViewDelegate>)mDelegate {
     return [[self alloc]initWithViewType:viewType delegate:mDelegate];
}

- (instancetype)initWithViewType:(UntyingBankCardResultAlertViewType)type delegate:(id)viewDelegate {
    if (self=[super initWithFrame:CGRectMake(0, 0, KScreenScale(500), KScreenScale(600))]){
        _mDelegate = viewDelegate;
        [self setUIWithType:type];
    }
    return self;
}

- (void)setUIWithType:(UntyingBankCardResultAlertViewType)type {

    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6.0;

    UIImageView *topImgView = [[UIImageView alloc]init];
    [self addSubview:topImgView];

    topImgView.sd_layout
    .topSpaceToView(self, KScreenScale(150))
    .centerXEqualToView(self)
    .widthIs(KScreenScale(170))
    .heightIs(KScreenScale(190));
    UILabel *contentLab = [[UILabel alloc]init];
    contentLab.textColor = [UIColor convertHexToRGB:@"333333"];
    contentLab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    contentLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLab];

    contentLab.sd_layout
    .topSpaceToView(topImgView, KScreenScale(25))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(45));
    if (type == UntyingBankCardResultAlertViewTypeSuccess) {
        [topImgView setImage:[UIImage bundleImageNamed:@"alert_icon_success"]];
        contentLab.text = @"解绑成功";
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3c3a"];
        finishBtn.layer.cornerRadius = KScreenScale(40);
        [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(successAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finishBtn];

        finishBtn.sd_layout
        .leftSpaceToView(self, KScreenScale(40))
        .rightSpaceToView(self, KScreenScale(40))
        .bottomSpaceToView(self, KScreenScale(40))
        .heightIs(KScreenScale(80));
    } else if (type == UntyingBankCardResultAlertViewTypeFail) {
        [topImgView setImage:[UIImage bundleImageNamed:@"alert_icon_fail"]];
        contentLab.text = @"解绑失败";
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.backgroundColor = [UIColor colorWithRed:228/255.0 green:228/255.0 blue:228/255.0 alpha:1.0];
        cancelBtn.layer.cornerRadius = KScreenScale(40);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        UIButton *againBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        againBtn.backgroundColor = [UIColor convertHexToRGB:@"ef3c3a"];
        againBtn.layer.cornerRadius = KScreenScale(40);
        [againBtn setTitle:@"重试" forState:UIControlStateNormal];
        [againBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [againBtn addTarget:self action:@selector(tryAgainAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:againBtn];

        cancelBtn.sd_layout
        .leftSpaceToView(self, KScreenScale(30))
        .widthIs((self.width_sd-KScreenScale(30)*3)/2)
        .heightIs(KScreenScale(80))
        .bottomSpaceToView(self, KScreenScale(40));
        againBtn.sd_layout
        .rightSpaceToView(self, KScreenScale(30))
        .widthIs((self.width_sd-KScreenScale(30)*3)/2)
        .heightIs(KScreenScale(80))
        .bottomSpaceToView(self, KScreenScale(40));
    }
}

#pragma mark - evenr response
- (void)dismiss {
    [self hiddenView];
}

//解绑完成
- (void)successAction {
    [self dismiss];
    if ([_mDelegate conformsToProtocol:@protocol(UntyingBankCardResultAlertViewDelegate)]&&[_mDelegate respondsToSelector:@selector(untyingBankCardResultAlertViewSuccess)]) {
        [_mDelegate untyingBankCardResultAlertViewSuccess];
    }
}

//再试一次
- (void)tryAgainAction {
    [self dismiss];
    if ([_mDelegate conformsToProtocol:@protocol(UntyingBankCardResultAlertViewDelegate)]&&[_mDelegate respondsToSelector:@selector(untyingBankCardResultAlertViewTryAgainAction)]) {
        [_mDelegate untyingBankCardResultAlertViewTryAgainAction];
    }
}

@end
