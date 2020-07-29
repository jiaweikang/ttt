//
//  UleWebProgressLayer.h
//  UleApp
//
//  Created by shengyang_yu on 2016/11/2.
//  Copyright © 2016年 ule. All rights reserved.
//
//  UIWebView模拟进度条
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface UleWebProgressLayer : CAShapeLayer

/** 开始加载 */
- (void)startLoad;

/** 加载完成 */
- (void)finishedLoad;

@end
