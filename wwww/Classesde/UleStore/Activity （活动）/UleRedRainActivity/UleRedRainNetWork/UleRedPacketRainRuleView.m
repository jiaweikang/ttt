//
//  UleRedPacketRainRuleView.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/2.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleRedPacketRainRuleView.h"
#import <WebKit/WebKit.h>
#import "UleRedPacketConfig.h"

#define kTitleHeight HORIZONTA(50)

@interface UleRedPacketRainRuleView()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView * ruleWebView;
@property (nonatomic, strong) UIImageView * titleImageView;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UIImageView * alertView;
@property (nonatomic, strong) NSString * htmlPath;
@end

@implementation UleRedPacketRainRuleView

+ (void)showRuleViewAtRootView:(UIView *)rootView ruleHtmlPath:(NSString *)htmlpath{
    UleRedPacketRainRuleView * ruleView=[[UleRedPacketRainRuleView alloc] initWithFrame:rootView.frame];
    ruleView.htmlPath=htmlpath;
    [ruleView loadWebData];
    [rootView addSubview:ruleView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.alertView];
        [_alertView addSubview:self.titleImageView];
        [_alertView addSubview:self.closeButton];
        [_alertView addSubview:self.ruleWebView];
        self.alertView.center=self.center;
        
        self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)hiddeView:(UIGestureRecognizer *)recognizer{
    [self removeFromSuperview];
}


- (void)loadWebData{
    NSURL *url = [NSURL URLWithString:self.htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:40.0];
    
    
    [self.ruleWebView loadRequest:request];
}

#pragma mark - <event>
- (void)closeClick:(id)sender{
    [self removeFromSuperview];
}

- (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds; // 创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
    // 设置渐变颜色方向为水平方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0); // 设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0,@1];
    return gradientLayer;
    
}
    
    

#pragma mark - <setter and getter>
- (UIImageView *)alertView{
    if (!_alertView) {
        _alertView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, HORIZONTA(400))];
//        UIView * line=[[UIView alloc] initWithFrame:CGRectMake(15, kTitleHeight-1, _alertView.frame.size.width-2*15, 2)];
//        line.backgroundColor=[UIColor colorWithRed:42/255.0 green:44/255.0 blue:98/255.0 alpha:1];
//        [_alertView addSubview:line];
        _alertView.userInteractionEnabled=YES;
        _alertView.layer.cornerRadius=HORIZONTA(10);
        _alertView.clipsToBounds=YES;
        _alertView.image = LoadBundleImage(@"活动规则底");
    }
    return _alertView;
}

- (WKWebView *)ruleWebView{
    if (!_ruleWebView) {
        _ruleWebView=[[WKWebView alloc] initWithFrame:CGRectMake(0, kTitleHeight, CGRectGetWidth(self.alertView.frame), CGRectGetHeight(self.alertView.frame)-kTitleHeight)];
        _ruleWebView.backgroundColor=[UIColor clearColor];
        [_ruleWebView setOpaque:NO];
        _ruleWebView.scrollView.backgroundColor=[UIColor clearColor];
        
    }
    return _ruleWebView;
}
- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.alertView.frame), kTitleHeight)];
//        _titleImageView.contentMode=UIViewContentModeScaleAspectFit;
        _titleImageView.image=LoadBundleImage(@"活动规则");
    }
    return _titleImageView;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.alertView.frame)-50, 0, 40, kTitleHeight)];
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setImage:LoadBundleImage(@"规则关闭") forState:UIControlStateNormal];
        _closeButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_closeButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

@end
