//
//  UleKouLingView.m
//  UleApp
//
//  Created by ZERO on 2019/2/20.
//  Copyright © 2019年 ule. All rights reserved.
//

#import "UleKouLingView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "UleKoulingDetectManager.h"
#import "UleMbLogOperate.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface UleKouLingView ()

@property (nonatomic, strong) UIView * m_maskView;
@property (nonatomic, strong) UIView * m_backView;
@property (nonatomic, strong) UIButton * m_cancelButton;
@property (nonatomic, strong) UIImageView *m_picView;
@property (nonatomic, strong) UIImageView *m_iconView;
@property (nonatomic, strong) UILabel *m_shareNameLabel;
@property (nonatomic, strong) UILabel *m_shareLabel;
@property (nonatomic, strong) UILabel *m_prdNameLabel;
@property (nonatomic, strong) UILabel *m_pricelabel;
@property (nonatomic, strong) UIButton * m_detailButton;
@property (nonatomic, strong) UleKoulingData *data;
@end

@implementation UleKouLingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data = [UleKoulingDetectManager sharedManager].koulingData;
        [self handleViews];
    }
    return self;
}

- (void)handleViews
{
    self.backgroundColor = [UIColor clearColor];

    [self addSubview:self.m_maskView];
    [self sd_addSubviews:@[self.m_backView,self.m_cancelButton]];
    [self.m_backView sd_addSubviews:@[self.m_picView,self.m_iconView,self.m_shareNameLabel,self.m_shareLabel,self.m_prdNameLabel,self.m_pricelabel,self.m_detailButton]];

    _m_backView.sd_layout
    .centerXEqualToView(self)
    .centerYEqualToView(self)
    .widthRatioToView(self, 0.75);
    _m_backView.sd_cornerRadius = @5;

    _m_cancelButton.sd_layout
    .topSpaceToView(_m_backView, 20)
    .centerXEqualToView(_m_backView)
    .widthIs(40)
    .heightIs(40);

    _m_picView.sd_layout
    .topEqualToView(_m_backView)
    .leftEqualToView(_m_backView)
    .rightEqualToView(_m_backView)
    .heightRatioToView(_m_backView, 0.55);

    _m_iconView.sd_layout
    .topSpaceToView(_m_picView, 10)
    .leftSpaceToView(_m_backView, 13)
    .widthIs(30)
    .heightIs(30);

    _m_shareNameLabel.sd_layout
    .topSpaceToView(_m_picView, 20)
    .leftSpaceToView(_m_iconView, 5)
    .heightIs(10);
    [_m_shareNameLabel setSingleLineAutoResizeWithMaxWidth:__MainScreen_Width / 3];

    _m_shareLabel.sd_layout
    .topSpaceToView(_m_picView, 20)
    .leftSpaceToView(_m_shareNameLabel, 5)
    .rightSpaceToView(_m_backView, 20)
    .heightIs(10);

    _m_prdNameLabel.sd_layout
    .topSpaceToView(_m_shareLabel, 20)
    .centerXEqualToView(_m_backView)
    .widthRatioToView(_m_backView, 0.9)
    .heightIs(20);

    _m_pricelabel.sd_layout
    .topSpaceToView(_m_prdNameLabel, 10)
    .centerXEqualToView(_m_backView)
    .widthRatioToView(_m_backView, 0.9)
    .heightIs(20);

    _m_detailButton.sd_layout
    .topSpaceToView(_m_pricelabel, 20)
    .centerXEqualToView(_m_backView)
    .widthRatioToView(_m_backView, 0.9)
    .heightIs(45);

    if ([self.data.type isEqualToString:@"0"]) {
        //活动
        [_m_picView sd_setImageWithURL:[NSURL URLWithString:self.data.imgUrl] placeholderImage:[UIImage bundleImageNamed:@"placeholdImage320x320"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                //获取图片宽高比更新图片布局
                CGFloat height = (__MainScreen_Width * 0.75) / (image.size.width / image.size.height) ;

                self.m_picView.sd_layout
                .heightIs(height);
                [self.m_picView updateLayout];
            }

        }];

        if (self.data.shareInfo.name.length > 0) {

            [_m_shareNameLabel setText:self.data.shareInfo.name];

        }else{
            _m_shareNameLabel.hidden = YES;
        }

        if (self.data.shareInfo.icon.length > 0) {
            if ([self.data.shareInfo.icon rangeOfString:@"http"].location !=NSNotFound) {
                [_m_iconView sd_setImageWithURL:[NSURL URLWithString:self.data.shareInfo.icon]];

            }else{
                [_m_iconView setImage:[UIImage bundleImageNamed:@"head_personal"]];

            }
        }else{
            _m_iconView.hidden = YES;
        }

        if (self.data.shareInfo.desc.length > 0) {
            [_m_shareLabel setText:self.data.shareInfo.desc];
        }else{
            _m_shareLabel.hidden = YES;
        }

        _m_pricelabel.hidden = YES;

        if (_m_shareNameLabel.hidden) {
            _m_prdNameLabel.sd_layout.topSpaceToView(_m_picView, 5);
            [_m_prdNameLabel updateLayout];
        }

        if (self.data.text && self.data.text.length > 0) {
            [_m_prdNameLabel setText:self.data.text];
        }

        _m_detailButton.sd_layout.topSpaceToView(_m_prdNameLabel, 20);
        [_m_detailButton updateLayout];

    }else{
        //商品
        NSString *prdImgUrl = @"";
        if (self.data.imgUrl.length > 0) {
            prdImgUrl = self.data.imgUrl;
        }else{
            prdImgUrl = self.data.listInfo.productUrl;
        }

        [_m_picView sd_setImageWithURL:[NSURL URLWithString:prdImgUrl] placeholderImage:[UIImage bundleImageNamed:@"placeholdImage320x320"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                //获取图片宽高比更新图片布局
                CGFloat height = (__MainScreen_Width * 0.75) / (image.size.width / image.size.height) ;
                //NSLog(@"======%.f======%.f",image.size.width,image.size.height);
                self.m_picView.sd_layout
                .heightIs(height);
                [self.m_picView updateLayout];
            }

        }];


        if (self.data.shareInfo.name.length > 0) {

            [_m_shareNameLabel setText:self.data.shareInfo.name];

        }else{
            _m_shareNameLabel.hidden = YES;
        }

        if (self.data.shareInfo.icon.length > 0) {
            if ([self.data.shareInfo.icon rangeOfString:@"http"].location !=NSNotFound) {
                [_m_iconView sd_setImageWithURL:[NSURL URLWithString:self.data.shareInfo.icon]];

            }else{
                [_m_iconView setImage:[UIImage bundleImageNamed:@"head_personal"]];

            }
        }else{
            _m_iconView.hidden = YES;
        }

        if (self.data.shareInfo.desc.length > 0) {
            [_m_shareLabel setText:self.data.shareInfo.desc];
        }else{
            _m_shareLabel.hidden = YES;
        }

        if (self.data.text && self.data.text.length > 0) {
            if ([self.data.text rangeOfString:@"<P_LISTNAME>"].location !=NSNotFound){
                self.data.text = [self.data.text stringByReplacingOccurrencesOfString:@"<P_LISTNAME>" withString:self.data.listInfo.listName];
                [_m_prdNameLabel setText:self.data.text];
            }else{
                [_m_prdNameLabel setText:self.data.text];
            }
        }

        [_m_pricelabel setText:[NSString stringWithFormat:@"￥%@",self.data.listInfo.price]];
    }

    //如果没有跳转链接就隐藏按钮
    if (self.data.buttonInfo.iosAction && self.data.buttonInfo.iosAction.length > 0) {
        if (self.data.buttonInfo.buttonImgUrl && self.data.buttonInfo.buttonImgUrl.length > 0) {
            [_m_detailButton sd_setBackgroundImageWithURL:[NSURL URLWithString:self.data.buttonInfo.buttonImgUrl] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                CGFloat height = (__MainScreen_Width * 0.7) / (image.size.width / image.size.height) ;

                self.m_detailButton.sd_layout
                .heightIs(height);
                [self.m_detailButton updateLayout];
            }];

        }else{
            [_m_detailButton setBackgroundColor:[UIColor convertHexToRGB:@"e42222"]];
            [_m_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
            _m_detailButton.sd_cornerRadius = @(45/2);

        }

        if (self.data.buttonInfo.buttonText && self.data.buttonInfo.buttonText.length > 0) {
            [_m_detailButton setTitle:self.data.buttonInfo.buttonText forState:UIControlStateNormal];
        }

        [_m_backView setupAutoHeightWithBottomView:_m_detailButton bottomMargin:20];

    }else{
        _m_detailButton.hidden = YES;
        [_m_backView setupAutoHeightWithBottomView:_m_prdNameLabel bottomMargin:20];
    }

}

- (void)show
{
    //统计
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"口令弹框" moduledesc:self.data.sceneCode networkdetail:@""];
    [self showViewWithAnimation:AniamtionAlert];
//    UIWindow *window = [UIApplication sharedApplication].delegate.window;
//
//    [self showInView:window];

    //清空剪贴板内容
    UIPasteboard* pasteboard= [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
}

//弹框动画
- (void)showInView:(UIView *)targetView{
    [targetView addSubview:_m_maskView];
    [targetView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        targetView.alpha = 1;
    }];
    CAKeyframeAnimation *animation=nil;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3, 0.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.layer addAnimation:animation forKey:nil];

}

//隐藏弹框
- (void)hide:(UIButton *)btn {
    [UleKoulingDetectManager sharedManager].isValidKouLing = NO;
    if (btn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initUniversalAlertView" object:nil];
    }
//    [_m_maskView removeFromSuperview];
//    [self removeFromSuperview];
    [self hiddenView];
}

//按钮跳转
- (void)goDetail
{
    [[UleKoulingDetectManager sharedManager] iosAction:self.data.buttonInfo.iosAction];

    //统计
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"小店口令" moduledesc:self.data.sceneCode networkdetail:@""];
    [self hide:nil];
}

- (UIViewController *)getCurrentVC {

    UIViewController *result = nil;

    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)rootVC;
            UIViewController *vc = [navi.viewControllers lastObject];
            result = vc;
            rootVC = vc.presentedViewController;
            continue;
        } else if([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            result = tab;
            rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            continue;
        } else if([rootVC isKindOfClass:[UIViewController class]]) {
            result = rootVC;
            rootVC = nil;
        }
    } while (rootVC != nil);

    return result;
}

#pragma mark - getter
- (UIView *)m_maskView{
    if (_m_maskView == nil) {
        _m_maskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
        _m_maskView.backgroundColor = [UIColor blackColor];
        _m_maskView.alpha = 0.6;
    }
    return _m_maskView;
}

- (UIView *)m_backView{
    if (_m_backView == nil) {
        _m_backView = [[UIView alloc] init];
        _m_backView.backgroundColor = [UIColor whiteColor];
    }
    return _m_backView;
}

- (UIButton *)m_cancelButton{
    if (_m_cancelButton == nil) {
        _m_cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_m_cancelButton setImage:[UIImage bundleImageNamed:@"koulingClose"] forState:UIControlStateNormal];
        [_m_cancelButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _m_cancelButton;
}
- (UIImageView *)m_picView{
    if (_m_picView == nil) {
        _m_picView = [[UIImageView alloc] init];
        _m_picView.backgroundColor = [UIColor redColor];
        _m_picView.clipsToBounds = YES;
    }
    return _m_picView;
}
- (UIImageView *)m_iconView{
    if (_m_iconView == nil) {
        _m_iconView = [[UIImageView alloc] init];
    }
    return _m_iconView;
}
- (UILabel *)m_shareNameLabel{
    if (_m_shareNameLabel == nil) {
        _m_shareNameLabel = [[UILabel alloc] init];
        _m_shareNameLabel.backgroundColor = [UIColor clearColor];
        _m_shareNameLabel.textColor = [UIColor convertHexToRGB:kDarkTextColor];
        _m_shareNameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _m_shareNameLabel;
}
- (UILabel *)m_shareLabel{
    if (_m_shareLabel == nil) {
        _m_shareLabel = [[UILabel alloc] init];
        _m_shareLabel.backgroundColor = [UIColor clearColor];
        _m_shareLabel.textColor = [UIColor lightGrayColor];
        _m_shareLabel.font = [UIFont systemFontOfSize:13];
    }
    return _m_shareLabel;
}

- (UILabel *)m_prdNameLabel{
    if (_m_prdNameLabel == nil) {
        _m_prdNameLabel = [[UILabel alloc] init];
        _m_prdNameLabel.backgroundColor = [UIColor clearColor];
        _m_prdNameLabel.textColor = [UIColor darkGrayColor];
        _m_prdNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _m_prdNameLabel;
}

- (UILabel *)m_pricelabel{
    if (_m_pricelabel == nil) {
        _m_pricelabel = [[UILabel alloc] init];
        _m_pricelabel.backgroundColor = [UIColor clearColor];
        _m_pricelabel.textColor = [UIColor convertHexToRGB:@"f30000"];
        _m_pricelabel.font = [UIFont systemFontOfSize:16];
    }
    return _m_pricelabel;
}

- (UIButton *)m_detailButton{
    if (_m_detailButton == nil) {
        _m_detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_m_detailButton addTarget:self action:@selector(goDetail) forControlEvents:UIControlEventTouchUpInside];

    }
    return _m_detailButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
