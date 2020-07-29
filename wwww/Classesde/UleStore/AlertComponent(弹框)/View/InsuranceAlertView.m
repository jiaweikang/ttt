//
//  InsuranceAlertView.m
//  u_store
//
//  Created by MickyChiang on 2019/3/11.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "InsuranceAlertView.h"
#import <UIView+SDAutoLayout.h>


@interface InsuranceAlertView ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, copy) InsuranceAlertConfirmBlock confirmBlock;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *wh_rate;
@end

@implementation InsuranceAlertView

+ (InsuranceAlertView *)insuranceAlertViewWithUrl:(NSString *)imgUrl wh_rate:(NSString *)wh_rate confirmBlock:(InsuranceAlertConfirmBlock)confirmBlock; {
    return [[self alloc] initWithUrl:imgUrl wh_rate:wh_rate confirmBlock:confirmBlock];
}

- (instancetype)initWithUrl:(NSString *)imgUrl wh_rate:(NSString *)wh_rate confirmBlock:(InsuranceAlertConfirmBlock)confirmBlock {
    if (self = [super init]) {
        _confirmBlock = confirmBlock;
        _imgUrl = imgUrl;
        _wh_rate = wh_rate;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    self.frame = CGRectMake(0, 0, __MainScreen_Width, __MainScreen_Height);
    self.backgroundColor=[UIColor clearColor];
    
    _bgView = [[UIImageView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10.0;
    [self addSubview:_bgView];
    
    CGFloat width = self.frame.size.width-KScreenScale(76)*2;
    CGFloat height = [_wh_rate floatValue]>0 ? width/[_wh_rate floatValue] : width/0.63;
    _bgView.sd_layout.centerXIs(self.centerX_sd)
    .centerYIs(self.centerY_sd)
    .widthIs(width)
    .heightIs(height);


    _closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_closeButton setImage:[UIImage bundleImageNamed:@"goods_btn_AlertClose"] forState:(UIControlStateNormal)];
    [_closeButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    _closeButton.sd_layout.topSpaceToView(_bgView, KScreenScale(30))
    .centerXEqualToView(self)
    .widthIs(KScreenScale(56))
    .heightEqualToWidth();
    
    [_bgView yy_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholder:nil options:(YYWebImageOptionSetImageWithFadeAnimation) completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
    
}

- (void)confirmButtonAction {
    if (_confirmBlock) {
        _confirmBlock();
    }
    [self dismiss];
}

- (void)dismiss {
    [self hiddenView];
//    [UlePushHelper shared].showProtocolAlert = NO;
}

@end
