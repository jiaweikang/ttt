//
//  US_UpdateAlertView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/5/9.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_UpdateAlertView.h"
#import <UIView+SDAutoLayout.h>
#import "UIView+ShowAnimation.h"
#import "UIView+Shade.h"

@interface US_UpdateAlertView ()

@property (nonatomic) UleUpdateAlertViewType m_tpye;
@property (nonatomic, strong) NSString * m_message;
@property (nonatomic, strong) NSString * m_title;

@property (nonatomic, strong) UIImageView *alertBgView;
@property (nonatomic, strong) UILabel * messageLabel;
@property (nonatomic, strong) UIButton * m_okButton;
@property (nonatomic, strong) UIButton * m_cancelButton;
@property (nonatomic, strong) UIView *confirmBtnBgView; //渐变背景
@property (nonatomic, strong) UIScrollView *messageScrollView;

@end

@implementation US_UpdateAlertView
- (instancetype) initWithType:(UleUpdateAlertViewType)type andTitle:(NSString*)title andMessage:(NSString *)message{
    self = [super initWithFrame:CGRectMake(0, 0, KScreenScale(680), KScreenScale(900))];
    if (self) {
        self.m_tpye = type;
        self.m_title = title;
        self.m_message = message;
        [self setupView];
    }
    return self;
}
- (void)setupView{
    self.backgroundColor=[UIColor clearColor];
    [self addSubview:self.alertBgView];
    [self.alertBgView addSubview:self.confirmBtnBgView];
    
    //消息
    CGFloat textHeight = [self.m_message heightForFont:[UIFont systemFontOfSize:KScreenScale(26)] width:KScreenScale(490)] + 5;
    
    [self.alertBgView addSubview:self.messageScrollView];
    [self.messageScrollView addSubview:self.messageLabel];
    _messageScrollView.contentSize = CGSizeMake(0, textHeight);
    
    self.alertBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.messageLabel.sd_layout.leftSpaceToView(_messageScrollView, 0)
    .topSpaceToView(_messageScrollView, 0)
    .widthIs(_messageScrollView.frame.size.width)
    .heightIs(textHeight);
    
    if (self.m_tpye == UleUpdateAlertViewTypeNormal) {
        self.confirmBtnBgView.frame = CGRectMake(KScreenScale(366), KScreenScale(730), KScreenScale(220), KScreenScale(64));
        [_confirmBtnBgView.layer addSublayer:[UIView setGradualChangingColor:_confirmBtnBgView fromColor:[UIColor convertHexToRGB:@"FE3247"] toColor:[UIColor convertHexToRGB:@"FF7D43"] gradualType:GradualTypeHorizontal]];
        
        [self.alertBgView addSubview:self.m_cancelButton];
        [self.confirmBtnBgView addSubview:self.m_okButton];
        self.m_cancelButton.sd_layout.leftSpaceToView(self.alertBgView, KScreenScale(96))
        .topSpaceToView(self.alertBgView, KScreenScale(730))
        .widthIs(KScreenScale(220))
        .heightIs(KScreenScale(64));
        self.m_okButton.sd_layout.leftSpaceToView(self.confirmBtnBgView, 0)
        .topSpaceToView(self.confirmBtnBgView, 0)
        .widthIs(KScreenScale(220))
        .heightIs(KScreenScale(64));
    } else {
        self.confirmBtnBgView.frame = CGRectMake(KScreenScale(96), KScreenScale(730), KScreenScale(490), KScreenScale(64));
        [_confirmBtnBgView.layer addSublayer:[UIView setGradualChangingColor:_confirmBtnBgView fromColor:[UIColor convertHexToRGB:@"FE3247"] toColor:[UIColor convertHexToRGB:@"FF7D43"] gradualType:GradualTypeHorizontal]];
        [self.confirmBtnBgView addSubview:self.m_okButton];
        self.m_okButton.sd_layout.leftSpaceToView(self.confirmBtnBgView, 0)
        .topSpaceToView(self.confirmBtnBgView, 0)
        .widthIs(KScreenScale(490))
        .heightIs(KScreenScale(64));
    }
    [self layoutIfNeeded];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.height_sd=rect.size.height;
}

- (void)showViewWithAnimation:(AniamtionType)animationType{
    [super showViewWithAnimation:animationType];
    [US_UserUtility sharedLogin].versionUpdateAlertShowedDate=[NSDate date];
}
#pragma mark - event
- (void)sureButtonClick:(id)sender{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.confirmClickBlock) {
            self.confirmClickBlock();
        }
    });
    [self hiddenView];
}

- (void)hiddenUpdateView{
    if (self.cancelClickBlock) {
        self.cancelClickBlock();
    }
    [self hiddenView];
}

#pragma mark - setter and getter

- (UIImageView *)alertBgView{
    if (!_alertBgView) {
        _alertBgView=[[UIImageView alloc] init];
        _alertBgView.image=[UIImage bundleImageNamed:@"updateAlertBg"];
        _alertBgView.userInteractionEnabled = YES;
    }
    return _alertBgView;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel=[[UILabel alloc] init];
        _messageLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        _messageLabel.text=self.m_message;
        _messageLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _messageLabel;
}

- (UIButton *)m_okButton{
    if (!_m_okButton) {
        _m_okButton =[[UIButton alloc] init];
        [_m_okButton setTitle:@"立即更新" forState:UIControlStateNormal];
        _m_okButton.titleLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(28)];
        [_m_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _m_okButton.clipsToBounds = YES;
        [_m_okButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _m_okButton;
}

- (UIButton *)m_cancelButton{
    if (!_m_cancelButton) {
        _m_cancelButton =[[UIButton alloc] init];
        [_m_cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
        _m_cancelButton.titleLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(28)];
        [_m_cancelButton setTitleColor:[UIColor convertHexToRGB:@"F66E2A"] forState:UIControlStateNormal];
        [_m_cancelButton setBackgroundColor:[UIColor whiteColor]];
        _m_cancelButton.layer.cornerRadius=KScreenScale(32);
        _m_cancelButton.layer.borderColor=[UIColor convertHexToRGB:@"F66E2A"].CGColor;
        _m_cancelButton.layer.borderWidth = 1;
        _m_cancelButton.clipsToBounds = YES;
        [_m_cancelButton addTarget:self action:@selector(hiddenUpdateView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _m_cancelButton;
}

- (UIView *)confirmBtnBgView
{
    if (!_confirmBtnBgView) {
        _confirmBtnBgView = [[UIView alloc] init];
        _confirmBtnBgView.layer.masksToBounds = YES;
        _confirmBtnBgView.layer.cornerRadius = KScreenScale(32);
    }
    return _confirmBtnBgView;
}

- (UIScrollView *)messageScrollView
{
    if (!_messageScrollView) {
        _messageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(KScreenScale(96), KScreenScale(334), KScreenScale(490), KScreenScale(372))];
    }
    return _messageScrollView;
}

@end
