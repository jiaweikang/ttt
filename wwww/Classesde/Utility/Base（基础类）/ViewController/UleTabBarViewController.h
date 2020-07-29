//
//  UleTabBarViewController.h
//  UleApp
//
//  Created by chenzhuqing on 16/4/19.
//  Copyright © 2016年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UleTabBarViewControllerDelegate <NSObject>

@optional
- (void)saveTabViewClickLogAtIndex:(NSInteger)index;

@end

@interface UleCustemTabBarItem : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * normalImageUrl;
@property (nonatomic, copy) NSString * selectImageUrl;
@property (nonatomic, strong) UIColor * normalTextColor;
@property (nonatomic, strong) UIColor * selectTextColor;
@property (nonatomic, strong) UIImage * normalImage;
@property (nonatomic, strong) UIImage * selectImage;

- (instancetype) initWithTitle:(NSString *) title normalImage:(NSString *)imageUrl selectImage:(NSString *)selectImageUrl normalColor:(UIColor *)nomalColor selectColor:(UIColor *)selectColor;

- (instancetype) initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage normalColor:(UIColor *)nomalColor selectColor:(UIColor *)selectColor;

@end

@interface UleTabBarViewController : UITabBarController<UleTabBarViewControllerDelegate>

@property (nonatomic, strong) NSArray <UleCustemTabBarItem *> * tabItems;
@property (nonatomic, strong) UIColor * defaultColor;
@property (nonatomic, strong) UIColor * selectedColor;
@property (nonatomic, strong) UIImageView * tabBarImageView;


/**
 设置Tab的ChildViewController 和底部tab

 @param childControllers 子视图
 @param items tab的
 */
- (void) resetTabChildControllers:(NSArray *)childControllers andTabItems:(NSArray<UleCustemTabBarItem *> *)items;
/**
 *  更新BadgeView的值
 *
 *  @param textString 需要显示的值，为空或者为nil的时候隐藏badegView
 *  @param index      在哪个tabBarItem上显示
 */
-(void) updateBadgeViewWithText:(NSString *) textString AtIndex:(NSInteger) index;

/**
 *  选中tabBar
 *
 *  @param index    选择显示的tabBarItem序号
 *  @param animated 是否使用动画效果
 */
-(void) selectTabBarItemAtIndex:(NSInteger) index animated:(BOOL)animated;

/**
 *  是否在tabbarItem上显示小红点
 *
 *  @param index  Item位置
 *  @param isShow 是否显示
 */
-(void) redDotAtIndex:(NSInteger) index isShow:(BOOL) isShow;

/**
 设置Tab

 @param array tab数据数组
 */
- (void) setCustemTabItems:(NSArray *)array;
@end
