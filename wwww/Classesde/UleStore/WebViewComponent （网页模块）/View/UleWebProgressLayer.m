//
//  UleWebProgressLayer.m
//  UleApp
//
//  Created by shengyang_yu on 2016/11/2.
//  Copyright © 2016年 ule. All rights reserved.
//

#import "UleWebProgressLayer.h"

@interface UleWebProgressLayer ()

// 进度条绘制
@property (nonatomic, strong) CAShapeLayer *mLayer;
// 计时器用来调用递增进度条
@property (nonatomic, strong) NSTimer *mTimer;
// 没次循环递增进度
@property (nonatomic, assign) CGFloat mIncreaseSize;

@end

@implementation UleWebProgressLayer


- (instancetype)init {

    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

/** 初始化设定 */
- (void)initialize {
    // 设置进度条宽
    self.lineWidth = 2.0;
    // 设置进度条颜色
    self.strokeColor = [UIColor redColor].CGColor;//[UIColor convertHexToRGB:@"67c260"].CGColor;
    // 绘制进度条
    UIBezierPath *tPath = [UIBezierPath bezierPath];
    [tPath moveToPoint:CGPointMake(0, 2.0)];
    [tPath addLineToPoint:CGPointMake(__MainScreen_Width, 2.0)];
    self.path = tPath.CGPath;
    self.strokeStart=0.0;
    // 设置起始状态 0
    self.strokeEnd = 0.0;
}


/** 开始加载 */
- (void)startLoad {
    self.hidden = NO;
}

/** 加载完成 */
- (void)finishedLoad {

    // 设置进度条完成,0.25秒后隐藏并移除
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.strokeEnd = 0.0;
    });
}

@end
