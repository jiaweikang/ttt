//
//  UleBasePageViewController.h
//  视图控制器管理
//
//  Created by chenzhuqing on 2017/1/13.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleBaseViewController.h"

static NSString * const PageViewClickOrScrollDidFinshNote = @"PageViewClickOrScrollDidFinshNote";

// 重复点击通知
static NSString * const PageViewRepeatClickTitleNote = @"PageViewRepeatClickTitleNote";

@protocol UleBasePageViewControllerDelegate <NSObject>

@optional
- (UIView *) titleCustemCoverView;
- (void)titleClickEventAtIndex:(NSInteger)index;
@end

typedef enum : NSUInteger {
    PageVCTitleTypeUnline,
    PageVCTitleTypeCover,
} PageVCTitleType;

typedef enum : NSUInteger {
    PageVCTitleFixedWidth,
    PageVCTitleAutoWidth,
} PageVCTitleLayoutType;

@interface UleBasePageViewController : UleBaseViewController<UleBasePageViewControllerDelegate>
@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) YYAnimatedImageView   *mBackgroundImageView;
@property (nonatomic, strong) UIScrollView * titleScrollView;
@property (nonatomic, strong) UIView * underline;
@property (nonatomic, strong) UIView * customUnderLine;//自定义的underLine
@property (nonatomic, strong) UIView * separateLine;//底部分隔线
@property (nonatomic, strong) UICollectionView * pageCollectionView;
@property (nonatomic, strong) NSMutableArray * lablesArray;
@property (nonatomic, assign) PageVCTitleType titleType;
@property (nonatomic, assign) PageVCTitleLayoutType titleLayoutType;
@property (nonatomic, weak) id<UleBasePageViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) BOOL hasNaviBar;
@property (nonatomic, assign) BOOL hasTabBar;
@property (nonatomic, assign) CGFloat titleMarin;
@property (nonatomic, assign) CGFloat offsetY;
@property (nonatomic, assign) BOOL hiddenUnderLine;//隐藏下划线
- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor andFont:(UIFont *)font;
- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor normalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont;
- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor andFont:(UIFont *)font andNormalALpha:(NSString *)normalAlpha andSelectedAlpha:(NSString *)selectedAlpha;
- (void)pageSelect:(NSInteger)pageIndex;

- (void)resetTabListVCAtCurrentPageIndex:(NSInteger)index;
- (void)scrollViewToHiddenNavigationBar:(BOOL)isHidden;
- (void)setUnLineColor:(UIColor *)color;
@end
