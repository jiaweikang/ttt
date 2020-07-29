//
//  ShopStarView.h
//  UleApp
//
//  Created by chenzhuqing on 16/7/14.
//  Copyright © 2016年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopStarView : UIView

- (instancetype) initWithStarHeight:(CGFloat) height StarNumber:(NSInteger)num;
- (instancetype) initWithStarHeight:(CGFloat) height StarNumber:(NSInteger)num StarColor:(NSString *)starColor StarDefaultColor:(NSString *)detaultColor;

- (void) showStars:(CGFloat) stars;
@end

