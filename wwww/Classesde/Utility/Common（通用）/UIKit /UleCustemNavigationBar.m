//
//  UleCustemNavigationBar.m
//  UleApp
//
//  Created by chenzhuqing on 2018/6/7.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleCustemNavigationBar.h"
#import <UIView+SDAutoLayout.h>

#define  kMargin 5        //左右两边的距离
#define  kGap    2         //按键之间的距离
#define  kDefaultButtonSize  40  //默认按键大小
#define  kHeight   (self.height-kStatusBarHeight)      //导航栏内容的总高度（不算状态栏的高度）
@implementation UIViewController (WRRoute)

- (void)ule_toLastViewController
{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            if (self.presentingViewController) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if(self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

+ (UIViewController*)ule_currentViewController {
    UIViewController* rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self ule_currentViewControllerFrom:rootViewController];
}

+ (UIViewController*)ule_currentViewControllerFrom:(UIViewController*)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController *)viewController;
        return [self ule_currentViewControllerFrom:navigationController.viewControllers.lastObject];
    }
    else if([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController *)viewController;
        return [self ule_currentViewControllerFrom:tabBarController.selectedViewController];
    }
    else if (viewController.presentedViewController != nil) {
        return [self ule_currentViewControllerFrom:viewController.presentedViewController];
    }
    else {
        return viewController;
    }
}

@end


@interface UleCustemNavigationBar()

@property (nonatomic, strong) UILabel * titleLabel;   //默认导航栏的TitleLabel;
@property (nonatomic, assign) CGFloat leftOffset;
@property (nonatomic, assign) CGFloat rightOffset;
@property (nonatomic, strong) UIView * bottomLine;    //默认隐藏高斯模糊
@property (nonatomic, strong) UIView  *backgroundView;  //默认背景
@property (nonatomic,strong) UIImageView * barBackgroudImageView;  //用于显示自定义图片背景
@property (nonatomic, strong) UIColor  *barBackgroundColor;      //用于设置导航栏背景颜色
@end

@implementation UleCustemNavigationBar


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.titleLayoutType=WidthFixedLayout;//默认为固定宽度，
        self.leftOffset=kMargin;
        self.rightOffset=kMargin*2;
        [self setupView];
    }
    return self;
}

- (void)setupView{
   
    [self addSubview:self.barBackgroudImageView];
    self.barBackgroudImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self addSubview:self.backgroundView];
    self.backgroundView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self setLeftBarButtonItems:@[self.leftButton]];
    [self addSubview:self.bottomLine];
    self.bottomLine.sd_layout.leftSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.4);
}

- (void)showLeftButton{
    self.leftButton.hidden=NO;
}

- (void) setLeftBarButtonItems:(NSArray *)leftBarButtonItems{
    for (int i=0; i<_leftBarButtonItems.count; i++) {
        UIView * btn=_leftBarButtonItems[i];
        [btn removeFromSuperview];
    }
    _leftBarButtonItems=leftBarButtonItems;
    
    CGFloat leftMargin=kMargin;
    
    for (int i=0; i<_leftBarButtonItems.count; i++) {
        UIView * btn=_leftBarButtonItems[i];
        [self addSubview:btn];
        CGFloat width=btn.frame.size.width>120?120:btn.frame.size.width;
        CGFloat height=btn.frame.size.height>=kHeight?kHeight:btn.frame.size.height;;
        btn.sd_layout.leftSpaceToView(self, leftMargin)
        .bottomSpaceToView(self, floor((kHeight-height)/2.0))
        .heightIs(height)
        .widthIs(width);
        leftMargin+=width;
        leftMargin+=kGap;
    }
    
    self.leftOffset=leftMargin;
    //设置了TitleView 拉伸属性
    if (self.titleLayoutType==WidthStretchLayout) {
        self.titleLayoutType=WidthStretchLayout;
    }
}

- (void)setTitleLayoutType:(TitleViewLayoutType)titleLayoutType{
    _titleLayoutType=titleLayoutType;
    if (self.titleView) {
        CGFloat width=self.titleView.frame.size.width;
        CGFloat height=self.titleView.frame.size.height>=kHeight?kHeight:_titleView.frame.size.height;
        if (titleLayoutType==WidthStretchLayout) {
            //根据左右按键位置进行拉伸处理
            self.titleView.sd_resetLayout.bottomSpaceToView(self, (kHeight-height)/2.0)
            .heightIs(height)
            .leftSpaceToView(self, self.leftOffset)
            .rightSpaceToView(self, self.rightOffset);
            [_titleView updateLayout];
        }else if (titleLayoutType==WidthFixedLayout){
            //固定宽度居中显示
            _titleView.sd_layout.bottomSpaceToView(self, (kHeight-height)/2.0)
            .heightIs(height)
            .centerXEqualToView(self)
            .widthIs(width);
        }
    }
}

- (void)setRightBarButtonItems:(NSArray *)rightBarButtonItems{
    for (int i=0; i<_rightBarButtonItems.count; i++) {
        UIView * btn=_rightBarButtonItems[i];
        [btn removeFromSuperview];
    }
    _rightBarButtonItems=rightBarButtonItems;
    CGFloat rightMargin=kMargin*2;
    if (rightBarButtonItems==nil||rightBarButtonItems.count<1) {
        return;
    }
    for (int i=(int)_rightBarButtonItems.count-1; i>=0; i--) {
        UIView * btn=_rightBarButtonItems[i];
        [self addSubview:btn];
        CGFloat width=btn.frame.size.width>120?120:btn.frame.size.width;
        CGFloat height=btn.frame.size.height>=kHeight?kHeight:btn.frame.size.height;
        btn.sd_layout.rightSpaceToView(self, rightMargin)
        .bottomSpaceToView(self, floor((kHeight-height)/2.0))
        .heightIs(height)
        .widthIs(width);
        rightMargin+=width;
        rightMargin+=kGap;
    }
    self.rightOffset=rightMargin;
    //设置TitleView 为拉伸属性
    if (self.titleLayoutType==WidthStretchLayout) {
        self.titleLayoutType=WidthStretchLayout;
    }
}

- (void)customTitleLabel:(NSString *)title{
    //文本title 为固定宽度，长度为170.
    self.titleLayoutType=WidthFixedLayout;
    self.titleLabel.text=title;
    self.titleLabel.frame=CGRectMake(0, 0, 170, kDefaultButtonSize);
    [self setTitleView:self.titleLabel];
}

- (void)setTitleView:(UIView *)titleView{
    if (_titleView) {
        [_titleView removeFromSuperview];
    }
    _titleView=titleView;
    [self addSubview:_titleView];
    if (self.titleLayoutType== WidthFixedLayout) {
        self.titleLayoutType=WidthFixedLayout;
    }else{
        //设置TitleView 为拉伸属性，则根据左右按键位置进行拉伸处理
        self.titleLayoutType=WidthStretchLayout;
    }
}

- (void)leftBtnClick:(id)sender{
    UIViewController *currentVC = [UIViewController ule_currentViewController];
    [currentVC ule_toLastViewController];
}

- (void)ule_setBottomLineHidden:(BOOL)hidden{
    self.bottomLine.hidden=hidden;
}

- (void)ule_setBackgroundAlpha:(CGFloat)alpha{
    self.backgroundView.alpha=alpha;
    self.barBackgroudImageView.alpha=alpha;
    self.backgroundColor=[UIColor clearColor];
}

- (void)ule_setTintColor:(UIColor *)color{
    self.leftButton.tintColor=color;
    [self.leftButton setImage:[[UIImage bundleImageNamed:@"nav_btn_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    self.titleLabel.textColor=color;
}

- (void)ule_setBackgroudImage:(UIImage *)image{
    self.barBackgroudImageView.image=image;
}

- (void)ule_setBackgroudImageUrl:(NSString *)imageUrl{
    [self.barBackgroudImageView yy_setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:nil];
}

- (void)ule_setBackgroudColor:(UIColor *)color{
    self.backgroundView.backgroundColor=color;
}

#pragma mark - setter and getter
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"TrebuchetMS" size:18];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kNavTitleColor;
    }
    return _titleLabel;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 0, kDefaultButtonSize, kDefaultButtonSize);
        _leftButton.tintColor=kNavTitleColor;
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(9, 9, 9,9);
        [_leftButton setImage:[UIImage bundleImageNamed:@"nav_btn_back"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.hidden=YES;
    }
    return _leftButton;
}
- (UIImageView *)barBackgroudImageView{
    if (!_barBackgroudImageView) {
        _barBackgroudImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    }
    return _barBackgroudImageView;
}
- (UIView *)backgroundView{
    if (!_backgroundView) {
       _backgroundView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _backgroundView.backgroundColor=kNavWhiteColor;
    }
    return _backgroundView;
}

- (void)setBarBackgroundColor:(UIColor *)barBackgroundColor{
    _barBackgroundColor=barBackgroundColor;
    self.backgroundView.backgroundColor=_barBackgroundColor;
}

- (UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.4, CGRectGetWidth(self.frame), 0.4)];
        _bottomLine.backgroundColor=[UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
        _bottomLine.layer.zPosition=50;
        _bottomLine.hidden=YES;
    }
    return _bottomLine;
}

@end
