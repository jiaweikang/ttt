//
//  USLineLayer.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface USLineLayer : CALayer
//页面个数
@property (nonatomic, assign) NSInteger numberOfPages;
//当前页码
@property (nonatomic, assign) NSInteger currentPage;
//圆圈直径
@property (nonatomic, assign) CGFloat ballDiameter;
//未选中的颜色
@property (nonatomic, strong) UIColor *unSelectedColor;
//pageControl绑定的scrollView
@property (nonatomic, strong) UIScrollView *bindingScrollView;
@end

NS_ASSUME_NONNULL_END
