//
//  UIScrollView+GestureBack.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/12.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UIScrollView+GestureBack.h"

@implementation UIScrollView (GestureBack)

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

@end
