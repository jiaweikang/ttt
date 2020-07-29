//
//  Ule_LockView.m
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "Ule_LockView.h"
#import "Ule_LockConst.h"

@interface Ule_LockView () {
    /**
     *  所有按钮数组
     */
    NSMutableArray *buttons;
    /**
     *  被选择按钮数组
     */
    NSMutableArray *selectedButtons;
    /**
     *  结果错误的按钮数组
     */
    NSMutableArray *wrongButtons;
    /**
     *  手指一动当前位置
     */
    CGPoint nowPoint;
    /**
     *  重新绘制计时器
     */
    NSTimer* timer;
    /**
     *  手势错误颜色
     */
    BOOL isWrongColor;
    /**
     *  正在移动 手势未结束
     */
    BOOL isDrawing;
}

@end

@implementation Ule_LockView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (void)initCircles {
    buttons = [NSMutableArray array];
    selectedButtons = [NSMutableArray array];
    // 按钮间的空隙
    CGFloat space_w = (self.frame.size.width-kLVMargin*2-kLVDiameter*3)/2;
    // 初始化圆点
    for (NSInteger i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        NSInteger x = kLVMargin + (i%3) * (kLVDiameter+space_w);
        NSInteger y = kLVMargin + (i/3) * (kLVDiameter+space_w);
        [button setFrame:CGRectMake(x, y, kLVDiameter, kLVDiameter)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage bundleImageNamed:kLVImageNone] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage bundleImageNamed:kLVImageSelect] forState:UIControlStateSelected];
        button.userInteractionEnabled= NO;//禁止用户交互
        button.alpha = kLVAlpha;
        button.tag = i + kLockView_tag + 1; // tag从基数+1开始,
        [self addSubview:button];
        [buttons addObject:button];
    }
    
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - 事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = NO;
    // 如果是错误色才重置(timer重置过了)
    if (isWrongColor) {
        [self clearColorAndSelectedButton];
    }
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = YES;
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = NO;
    [self setNeedsDisplay];
    [self performSelector:@selector(endPosition) withObject:nil afterDelay:0.1];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = NO;
    [self setNeedsDisplay];
    [self performSelector:@selector(endPosition) withObject:nil afterDelay:0.1];
}

#pragma mark - 绘制连线
- (void)drawRect:(CGRect)rect {
    
    if (selectedButtons.count > 0) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        isWrongColor ? [kLVLineColorError set] : [kLVLineColor set]; // 正误线条色
        CGContextSetLineWidth(context, kLVLineWidth);
        // 画之前线s
        CGPoint addLines[9];
        int count = 0;
        for (UIButton* button in selectedButtons) {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
        }
        CGContextSetLineJoin(context, kCGLineJoinRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
        // 画当前线
        if (isDrawing) {
            UIButton* lastButton = selectedButtons.lastObject;
            CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
            CGContextAddLineToPoint(context, nowPoint.x, nowPoint.y);
            CGContextStrokePath(context);
        }
    }
}

#pragma mark - 处理
// 当前手指位置
- (void)updateFingerPosition:(CGPoint)point{
    
    nowPoint = point;
    for (UIButton *thisbutton in buttons) {
        CGFloat xdiff = point.x - thisbutton.center.x;
        CGFloat ydiff = point.y - thisbutton.center.y;
        if (fabs(xdiff) < 36 && fabs (ydiff) < 36) {
            // 未选中的才能加入
            if (!thisbutton.selected) {
                thisbutton.selected = YES;
                [selectedButtons addObject:thisbutton];
            }
        }
    }
    [self setNeedsDisplay];
}

- (void)endPosition {
    
    UIButton *strbutton;
    NSString *string = @"";
    // 生成密码串
    for (NSInteger i = 0; i < selectedButtons.count; i++) {
        strbutton = selectedButtons[i];
        string= [string stringByAppendingFormat:@"%@",@(strbutton.tag-kLockView_tag)];
    }
    [self clearColorAndSelectedButton]; // 清除到初始样式
    if ([self.delegate respondsToSelector:@selector(lockString:)]) {
        if (string && string.length>0) {
            [self.delegate lockString:string];
        }
    }
}

// 清除至初始状态
- (void)clearColor {
    if (isWrongColor) {
        // 重置颜色
        isWrongColor = NO;
        // 设置不同颜色
        if (![kLVImageSelect isEqualToString:kLVImageError]) {
            for (UIButton* button in buttons) {
                [button setBackgroundImage:[UIImage bundleImageNamed:kLVImageSelect] forState:UIControlStateSelected];
            }
        }
    }
}

- (void)clearSelectedButton {
    // 换到下次按时再弄
    for (UIButton *thisButton in buttons) {
        [thisButton setSelected:NO];
    }
    [selectedButtons removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)clearColorAndSelectedButton {
    if (!isDrawing) {
        [self clearColor];
        [self clearSelectedButton];
    }
}

#pragma mark - 显示错误
- (void)showErrorInfo:(NSString *)string {
    
    isWrongColor = YES;
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber* number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [buttons[number.integerValue] setSelected:YES];
        [selectedButtons addObject:buttons[number.integerValue]];
    }
    // 设置不同颜色
    if (![kLVImageSelect isEqualToString:kLVImageError]) {
        for (UIButton* button in buttons) {
            if (button.selected) {
                [button setBackgroundImage:[UIImage bundleImageNamed:kLVImageError] forState:UIControlStateSelected];
            }
        }
    }
    [self setNeedsDisplay];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(clearColorAndSelectedButton)
                                           userInfo:nil
                                            repeats:NO];
    
}

@end
