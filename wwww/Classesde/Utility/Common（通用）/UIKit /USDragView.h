//
//  USDragView.h
//  u_store
//
//  Created by jiangxintong on 2019/2/21.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeatureModel_HomeBanner.h"

@interface USDragView : UIView

- (instancetype)initWithFrame:(CGRect)frame vc:(UIViewController *)vc;
- (void)setActionBlock:(void(^)(void))block;
@property (nonatomic, strong) YYAnimatedImageView *clickImgView;
@property (nonatomic, strong) HomeBannerIndexInfo *info;
@property (nonatomic, assign) CGFloat dragHeight;

@end

