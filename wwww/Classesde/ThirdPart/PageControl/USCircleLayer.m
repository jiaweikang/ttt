//
//  USCircleLayer.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USCircleLayer.h"

#define AnimaBallDistance self.frame.size.width / (self.numberOfPages + 1)

typedef NS_ENUM (NSUInteger, Move_Direction) {
    Move_Left,
    Move_Right
};


@interface USCircleLayer ()
//移动方向
@property (nonatomic, assign) Move_Direction moveDirection;
@property (nonatomic ,assign) CGFloat outsideRectSize;
@property (nonatomic, assign) CGFloat factor;
@end

@implementation USCircleLayer
- (instancetype)init {
    if (self = [super init]) {
        self.outsideRectSize = 7;
        self.currentPage = 1;
        self.currentProgress = 0;
    }
    return self;
}

- (instancetype)initWithLayer:(USCircleLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.currentProgress = layer.currentProgress;
        self.outsideRectSize = layer.outsideRectSize;
        self.outsideRect = layer.outsideRect;
        self.currentPage = layer.currentPage;
    }
    return self;
}

- (void)setLastContentOffset_x:(CGFloat)lastContentOffset_x {
    _lastContentOffset_x = lastContentOffset_x;
}

- (void)setContentOffset_x:(CGFloat)contentOffset_x {
    _contentOffset_x = contentOffset_x;
    
    if (_contentOffset_x - _lastContentOffset_x > 0) {
        self.moveDirection = Move_Right;
        if (_contentOffset_x <= _bindingScrollViewWidth * ((self.lastContentOffset_x / _bindingScrollViewWidth) + .5)) {
            _currentProgress = MIN(1, MAX(0, (ABS(contentOffset_x - _lastContentOffset_x) / _bindingScrollViewWidth)));
        } else {
            _currentProgress = 1 - MIN(1, MAX(0, (ABS(contentOffset_x - _lastContentOffset_x) / _bindingScrollViewWidth)));
        }
    } else if (_contentOffset_x - _lastContentOffset_x <= 0) {
        NSInteger lastPage = (_contentOffset_x / _bindingScrollViewWidth + 2);
        
        self.moveDirection = Move_Left;
        if (_contentOffset_x < lastPage * _bindingScrollViewWidth - _bindingScrollViewWidth * 1.5 && _contentOffset_x > 0) {
            _currentProgress = 1 - MIN(1, MAX(0, (ABS(contentOffset_x - _lastContentOffset_x) / _bindingScrollViewWidth)));
        } else {
            _currentProgress = MIN(1, MAX(0, (ABS(contentOffset_x - _lastContentOffset_x) / _bindingScrollViewWidth)));
        }
        if (_currentProgress > .9) {
            _currentProgress = 0;
        }
    }
    CGFloat origin_x = (self.contentOffset_x / _bindingScrollViewWidth)*(self.frame.size.width / (_numberOfPages + 1)) + AnimaBallDistance - self.outsideRectSize * .5;
    CGFloat origin_y = self.position.y - self.outsideRectSize * .5;
    self.outsideRect = CGRectMake(origin_x, origin_y, self.outsideRectSize, self.outsideRectSize);
    
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    
    //计算出偏移值
    CGFloat offset = self.outsideRect.size.width / 3.6;
    //计算出移动距离
    CGFloat moveDistance = (self.outsideRect.size.width / 6) * fabs(self.currentProgress) * 2;
    //计算出中心点坐标
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x + self.outsideRect.size.width * .5, self.outsideRect.origin.y + self.outsideRect.size.height * .5);
    //计算各个辅助点坐标
    CGPoint point_A = CGPointMake(rectCenter.x,self.outsideRect.origin.y + moveDistance);
    CGPoint point_B = CGPointMake(self.moveDirection == Move_Right ? rectCenter.x + self.outsideRect.size.width * .5:self.outsideRect.size.width * .5 + rectCenter.x + moveDistance * 2, rectCenter.y);
    CGPoint point_C = CGPointMake(rectCenter.x, rectCenter.y + self.outsideRect.size.width * .5 - moveDistance);
    CGPoint point_D = CGPointMake(self.moveDirection == Move_Right ? self.outsideRect.origin.x - moveDistance * 2:self.outsideRect.origin.x, rectCenter.y);
    CGPoint point_c1 = CGPointMake(point_A.x + offset, point_A.y);
    CGPoint point_c2 = CGPointMake(point_B.x,self.moveDirection == Move_Right ? point_B.y - offset:point_B.y - offset + moveDistance);
    CGPoint point_c3 = CGPointMake(point_B.x, self.moveDirection == Move_Right ? point_B.y + offset:point_B.y + offset - moveDistance);
    CGPoint point_c4 = CGPointMake(point_C.x + offset, point_C.y);
    CGPoint point_c5 = CGPointMake(point_C.x - offset, point_C.y);
    CGPoint point_c6 = CGPointMake(point_D.x, self.moveDirection == Move_Right ? point_D.y + offset - moveDistance:point_D.y + offset);
    CGPoint point_c7 = CGPointMake(point_D.x, self.moveDirection == Move_Right ? point_D.y - offset + moveDistance:point_D.y - offset);
    CGPoint point_c8 = CGPointMake(point_A.x - offset,point_A.y);
    //圆的边界
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:point_A];
    [ovalPath addCurveToPoint:point_B controlPoint1:point_c1 controlPoint2:point_c2];
    [ovalPath addCurveToPoint:point_C controlPoint1:point_c3 controlPoint2:point_c4];
    [ovalPath addCurveToPoint:point_D controlPoint1:point_c5 controlPoint2:point_c6];
    [ovalPath addCurveToPoint:point_A controlPoint1:point_c7 controlPoint2:point_c8];
    [ovalPath closePath];
    CGContextAddPath(ctx, ovalPath.CGPath);
    //CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, self.selectedColor.CGColor);
    CGContextFillPath(ctx);
}
@end
