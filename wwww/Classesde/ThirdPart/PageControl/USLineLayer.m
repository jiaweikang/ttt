//
//  USLineLayer.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USLineLayer.h"

#define BallCenterDistance self.frame.size.width / (self.numberOfPages + 1)

@interface USLineLayer ()
//选中的颜色
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation USLineLayer

- (instancetype)init {
    if (self = [super init]) {
        self.numberOfPages = 3;
        self.currentPage = 1;
        self.ballDiameter = 5.0;
        self.unSelectedColor = [UIColor lightGrayColor];
        self.selectedColor = [UIColor clearColor];
    }
    return self;
}

//必须重载，调用drawInContext前必定调用此方法获取上一个状态
- (instancetype)initWithLayer:(USLineLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        
        self.numberOfPages = layer.numberOfPages;
        self.currentPage = layer.currentPage;
        self.ballDiameter = layer.ballDiameter;
    }
    return self;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    [self setNeedsDisplay];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        if (_currentPage <= 0) {
            _currentPage = 1;
        }
        if (_currentPage >= _numberOfPages + 1) {
            _currentPage = _numberOfPages;
        }
        [self setNeedsDisplay];
    }
}

//当调用setNeedDisplay时触发drawInContext:
- (void)drawInContext:(CGContextRef)ctx {
    CGMutablePathRef linePath = CGPathCreateMutable();
    //画圆操作
    for (int index = 0; index < self.numberOfPages; index ++) {
        if (index == self.currentPage - 1) {
            continue;
        }
        CGPathAddEllipseInRect(linePath, NULL, CGRectMake((index + 1)* BallCenterDistance - self.ballDiameter * .5, self.frame.size.height * .5 - self.ballDiameter * .5, self.ballDiameter, self.ballDiameter));
    }
    CGContextAddPath(ctx, linePath);
    CGContextSetFillColorWithColor(ctx, self.unSelectedColor.CGColor);
    CGContextFillPath(ctx);
}
@end
