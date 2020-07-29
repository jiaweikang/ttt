//
//  Ule_LockIndicator.h
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//
//  绘制页面顶部 显示上一次绘制手势密码图案
//

#import <UIKit/UIKit.h>

@interface Ule_LockIndicator : UIView

/**
 *  根据文本信息绘制
 *
 *  @param string 文本信息
 */
- (void)rectPasswordString:(NSString *)string;

@end
