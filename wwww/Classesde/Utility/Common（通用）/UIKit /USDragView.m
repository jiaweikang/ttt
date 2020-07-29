//
//  USDragView.m
//  u_store
//
//  Created by jiangxintong on 2019/2/21.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USDragView.h"
// 屏幕高度
//#define susScreenH (__MainView_Height_Real - Height_NavBar - Height_TabBar - 44)
#define susScreenH __MainScreen_Height-kStatusBarHeight-44
// 屏幕宽度
#define susScreenW __MainScreen_Width
//悬浮按钮宽高
//#define kSuspendBtnWidth 60 * susScreenW / 375
//#define kSuspendBtnWidth KScreenScale(140)

@interface USDragView() {
//    CGPoint startLocation;
//    NSString *_action;
    void(^_actionBlock)(void);
//    UIViewController *_vc;
}
@property (nonatomic, weak) UIViewController * vc;
@end


@implementation USDragView
#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame vc:(UIViewController *)vc {
    if (self = [super initWithFrame:frame]) {
        _vc = vc;
        
        _clickImgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:_clickImgView];
        
        self.userInteractionEnabled = YES;
        //创建移动手势事件
        UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panRcognize setMinimumNumberOfTouches:1];
        [panRcognize setEnabled:YES];
        [panRcognize delaysTouchesEnded];
        [panRcognize cancelsTouchesInView];
        [self addGestureRecognizer:panRcognize];
        //创建点击手势事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)setDragHeight:(CGFloat)dragHeight {
    CGRect frame = _clickImgView.frame;
    frame.size.height = dragHeight;
    _clickImgView.frame = frame;
}

#pragma mark - event response
/*
 *  悬浮按钮移动事件处理
 */
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:_vc.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0,susScreenH/2.0);
            
            CGFloat kSuspendBtnWidth = self.frame.size.width;
            CGFloat kSuspendBtnHeight = self.frame.size.height;
            
            if (recognizer.view.center.x < susScreenW/2.0) {
                if (recognizer.view.center.y <= susScreenH/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
//                        stopPoint = CGPointMake(recognizer.view.center.x, kSuspendBtnWidth/2.0);
                        stopPoint = CGPointMake(recognizer.view.center.x, kSuspendBtnHeight/2.0);
                    } else {
                        stopPoint = CGPointMake(kSuspendBtnWidth/2.0, recognizer.view.center.y);
                    }
                } else {
                    //左下
                    if (recognizer.view.center.x  >= susScreenH - recognizer.view.center.y) {
//                        stopPoint = CGPointMake(recognizer.view.center.x, susScreenH - kSuspendBtnWidth/2.0);
                        stopPoint = CGPointMake(recognizer.view.center.x, susScreenH - kSuspendBtnHeight/2.0);
                    } else {
                        stopPoint = CGPointMake(kSuspendBtnWidth/2.0, recognizer.view.center.y);
                    }
                }
                
            } else {
                if (recognizer.view.center.y <= susScreenH/2.0) {
                    //右上
                    if (susScreenW - recognizer.view.center.x  >= recognizer.view.center.y) {
//                        stopPoint = CGPointMake(recognizer.view.center.x, kSuspendBtnWidth/2.0);
                        stopPoint = CGPointMake(recognizer.view.center.x, kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(susScreenW - kSuspendBtnWidth/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (susScreenW - recognizer.view.center.x  >= susScreenH - recognizer.view.center.y) {
//                        stopPoint = CGPointMake(recognizer.view.center.x,susScreenH - kSuspendBtnWidth/2.0);
                        stopPoint = CGPointMake(recognizer.view.center.x,susScreenH - kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(susScreenW - kSuspendBtnWidth/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            if (stopPoint.x - kSuspendBtnWidth/2.0 <= 0) {
                stopPoint = CGPointMake(kSuspendBtnWidth/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + kSuspendBtnWidth/2.0 >= susScreenW) {
                stopPoint = CGPointMake(susScreenW - kSuspendBtnWidth/2.0, stopPoint.y);
            }
            
//            if (stopPoint.y - kSuspendBtnWidth/2.0 <= 0) {
//                stopPoint = CGPointMake(stopPoint.x, kSuspendBtnWidth/2.0);
//            }
            if (stopPoint.y - kSuspendBtnHeight/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, kSuspendBtnHeight/2.0);
            }
            
//            if (stopPoint.y + kSuspendBtnWidth/2.0 >= susScreenH) {
//                stopPoint = CGPointMake(stopPoint.x, susScreenH - kSuspendBtnWidth/2.0);
//            }
            if (stopPoint.y + kSuspendBtnHeight/2.0 >= susScreenH) {
                stopPoint = CGPointMake(stopPoint.x, susScreenH - kSuspendBtnHeight/2.0);
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                CGPoint stopPoint2 = stopPoint;
                stopPoint2.y += kStatusBarHeight;
                recognizer.view.center = stopPoint2;
//                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    [recognizer setTranslation:CGPointMake(0, 0) inView:_vc.view];
}

/*
 *  悬浮按钮点击事件处理
 */
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture {
    NSLog(@"touch float icon ....");
//    if (![NSString IsNullOrWhiteSpace:_action]) {
        //注：这里我删掉两行跟业务有关的代码
//    }
    if (_actionBlock) {
        _actionBlock();
    }
}

//- (void)setAction:(NSString *)action {
//    _action = action;
//}

- (void)setActionBlock:(void (^)(void))block {
    _actionBlock = block;
}

- (void)setInfo:(HomeBannerIndexInfo *)info {
    _info = info;
    [_clickImgView yy_setImageWithURL:[NSURL URLWithString:info.imgUrl] placeholder:nil];
}

@end
