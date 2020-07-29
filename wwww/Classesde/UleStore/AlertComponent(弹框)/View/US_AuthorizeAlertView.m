//
//  US_AuthorizeAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_AuthorizeAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_AuthorizeAlertView ()
@property (nonatomic, assign) AuthorizeViewType showType;
@property (nonatomic, copy) NSString        *showMsg;
@property (nonatomic, assign) BOOL          isPushView;
@property (nonatomic, strong) UIButton      *confirmBtn;

@end

@implementation US_AuthorizeAlertView

- (instancetype)initWithType:(AuthorizeViewType)showType andMessage:(NSString *)msg isContinuePush:(BOOL)isPush
{
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]) {
        self.showType=showType;
        self.showMsg=msg;
        self.isPushView=isPush;
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    if (self.isPushView) {
        [self.confirmBtn setTitle:@"继续提现" forState:UIControlStateNormal];
    }
    self.confirmBtn.sd_layout.bottomSpaceToView(self, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(40))
    .rightSpaceToView(self, KScreenScale(40))
    .heightIs(KScreenScale(90));
    UIImageView *imgView = [[UIImageView alloc]init];
    [self addSubview:imgView];
    imgView.sd_layout.bottomSpaceToView(self.confirmBtn, KScreenScale(110))
    .leftSpaceToView(self, KScreenScale(60))
    .widthIs(KScreenScale(80))
    .heightIs(KScreenScale(80));
    UILabel *lab = [[UILabel alloc]init];
    lab.text = self.showMsg;
    lab.adjustsFontSizeToFitWidth = YES;
    lab.textColor = [UIColor convertHexToRGB:kBlackTextColor];
    lab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    [self addSubview:lab];
    lab.sd_layout.centerYEqualToView(imgView)
    .leftSpaceToView(imgView, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightRatioToView(imgView, 1.0);
    
    if (self.showType==AuthorizeViewTypeSuccess) {
        [imgView setImage:[UIImage bundleImageNamed:@"authorize_img_alert_success"]];
    }else if (self.showType==AuthorizeViewTypeFail) {
        [imgView setImage:[UIImage bundleImageNamed:@"authorize_img_alert_fail"]];
    }
}


#pragma mark - <actions>
- (void)confirmBtnAction:(UIButton *)sender{
    [self hiddenView];
    if (_confirmBlock) {
        _confirmBlock();
    }
}

#pragma mark - <getters>
- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setBackgroundColor:kCommonRedColor];
        _confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _confirmBtn.layer.cornerRadius = 5.0;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end
