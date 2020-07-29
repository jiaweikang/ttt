//
//  UleCustemNavigationBar.h
//  UleApp
//
//  Created by chenzhuqing on 2018/6/7.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    WidthFixedLayout,   //固定长度（居中显示）
    WidthStretchLayout, //等比拉伸（根据左右按键拉伸显示）
} TitleViewLayoutType;

@interface UleCustemNavigationBar : UIView

@property (nonatomic, strong) UIButton * leftButton;   //左边返回按键
@property (nonatomic,strong) NSArray * leftBarButtonItems;   //导航栏左边按键数组
@property (nonatomic,strong) NSArray * rightBarButtonItems;  //导航栏右边按键数组
@property (nonatomic,strong) UIView * titleView;             //导航栏中间title视图
@property (nonatomic,assign) TitleViewLayoutType titleLayoutType;  //定义中间Titel的布局类型

/**
 设置是否显示底部横线

 @param hidden = YES ：隐藏   ,NO :显示
 */
- (void)ule_setBottomLineHidden:(BOOL)hidden;

/**
 设置透明度，

 @param alpha =0.0 表示全透明  1.0 表示不透明
 */
- (void)ule_setBackgroundAlpha:(CGFloat)alpha;

/**
 设置返回按键，以及Title文字的颜色

 @param color 文字颜色
 */
- (void)ule_setTintColor:(UIColor *)color;

/**
 设置导航栏Title值

 @param title 标题
 */
- (void)customTitleLabel:(NSString *)title;

/**
 显示左边返回按键
 */
- (void)showLeftButton;

/**
 设置背景图片

 @param image 图片
 */
- (void)ule_setBackgroudImage:(UIImage *)image;

- (void)ule_setBackgroudImageUrl:(NSString *)imageUrl;
/**
 设置背景颜色

 @param color 颜色
 */
- (void)ule_setBackgroudColor:(UIColor *)color;

@end

@interface UIViewController (WRRoute)

- (void)ule_toLastViewController;

@end
