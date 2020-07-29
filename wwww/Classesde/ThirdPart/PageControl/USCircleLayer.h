//
//  USCircleLayer.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface USCircleLayer : CALayer
//当前progress
@property (nonatomic, assign) CGFloat currentProgress;
//外界矩形大小
@property (nonatomic, assign) CGRect outsideRect;

@property (nonatomic, assign) CGFloat contentOffset_x;
@property (nonatomic, assign) CGFloat lastContentOffset_x;

//页面个数
@property (nonatomic, assign) NSInteger numberOfPages;
//当前页码
@property (nonatomic, assign) NSInteger currentPage;
//pageControl绑定scrollView宽度
@property (nonatomic, assign) CGFloat bindingScrollViewWidth;
//选中的颜色
@property (nonatomic, strong) UIColor *selectedColor;

@end

NS_ASSUME_NONNULL_END
