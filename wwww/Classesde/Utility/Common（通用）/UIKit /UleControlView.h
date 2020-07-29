//
//  UleControlView.h
//  UleApp
//
//  Created by shengyang_yu on 16/7/12.
//  Copyright © 2016年 ule. All rights reserved.
//
//  布局图片和文字view 响应点击
//

#import <UIKit/UIKit.h>

@interface UleControlView : UIView

@property (nonatomic, strong) YYAnimatedImageView *mImageView;
@property (nonatomic, strong) UILabel *mTitleLabel;
@property (nonatomic, strong) YYAnimatedImageView   *mBubbleImageView;//气泡背景
@property (nonatomic, strong) UILabel   *mBubbleLabel;

/** target action */
- (void)addTouchTarget:(id)target action:(SEL)action;
/** 点击block */
@property (nonatomic, copy) void (^touchBlock)(UleControlView *view, UIGestureRecognizerState state, NSSet *touches, UIEvent *event);
/** 长按block */
@property (nonatomic, copy) void (^longPressBlock)(UleControlView *view, CGPoint point);
/** 设置图片过虑 */
- (void)setImageFilter:(NSString *)imageName;

@end
