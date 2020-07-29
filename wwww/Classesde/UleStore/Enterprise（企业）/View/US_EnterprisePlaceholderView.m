//
//  US_EnterprisePlaceholderView.m
//  u_store
//
//  Created by jiangxintong on 2018/12/3.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "US_EnterprisePlaceholderView.h"
#import "UleTabBarViewController.h"

@interface US_EnterprisePlaceholderView ()
@property (nonatomic, strong) UIButton      *pickButton;
@end

@implementation US_EnterprisePlaceholderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((__MainScreen_Width-kImageWidth) / 2, 0, kImageWidth, kImageHeight)];
        imageView.image = [UIImage bundleImageNamed:@"placeholder_img_empty"];
        [self addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height+20, __MainScreen_Width, kLabelHeight)];
        label.text = @"企业现在没有推荐哦\n请点击重试";
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.userInteractionEnabled = YES;
        [self addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [label addGestureRecognizer:tap];
        
        if ([[US_UserUtility sharedLogin].m_orgType intValue]!=1000) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake((__MainScreen_Width-210)/2.0, label.frame.origin.y+label.frame.size.height+20, 210, kButtonHeight);
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitle:@"前往货源挑选商品" forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(buttonClicked) forControlEvents:(UIControlEventTouchUpInside)];
            button.tintColor = [UIColor convertHexToRGB:@"ef3b39"];
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 20;
            [self addSubview:button];
            self.pickButton=button;
        }
    }
    return self;
}

- (void)setPickButtonHidden:(BOOL)isHide{
    if (self.pickButton) {
        self.pickButton.hidden=isHide;
    }
}

- (void)buttonClicked {
    UleTabBarViewController *tabbarVC = (UleTabBarViewController *)[UIViewController currentViewController].tabBarController;
    if (tabbarVC&&tabbarVC.viewControllers.count>0) {
        [tabbarVC selectTabBarItemAtIndex:0 animated:YES];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if (self.callback) {
        self.callback();
    }
}

@end
