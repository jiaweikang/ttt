//
//  USPageControl.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USLineLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface USPageControl : UIView
//背景横线视图
@property (nonatomic, strong) USLineLayer *lineLayer;

//页面个数
@property (nonatomic, assign) NSInteger numberOfPages;
//当前页面
@property (nonatomic, assign) NSInteger currentPage;
//圆圈直径
@property (nonatomic, assign) CGFloat  ballDiameter;

//选中的颜色
@property (nonatomic, strong) UIColor *selectedColor;
//未选中的颜色
@property (nonatomic, strong) UIColor *unSelectedColor;
//pageControl绑定的scrollView
@property (nonatomic, strong) UIScrollView *bindingScrollView;
//绑定的scrollView的contentOffset.x
@property (nonatomic, assign) CGFloat contentOffset_x;
//绑定的scrollView的lastContentOffset.x
@property (nonatomic, assign) CGFloat lastContentOffset_x;
@end

NS_ASSUME_NONNULL_END
