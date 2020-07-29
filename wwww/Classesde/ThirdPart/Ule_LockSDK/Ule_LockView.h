//
//  Ule_LockView.h
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Ule_LockViewDelegate <NSObject>

@required
- (void)lockString:(NSString *)string;

@end

@interface Ule_LockView : UIView

/**
 *  手势代理
 */
@property (nonatomic, weak) id<Ule_LockViewDelegate> delegate;

/**
 *  显示错误的结果 红色线条
 *
 *  @param string 错误信息
 */
- (void)showErrorInfo:(NSString *)string;

/**
 *  重置状态
 */
- (void)clearColorAndSelectedButton;

@end
