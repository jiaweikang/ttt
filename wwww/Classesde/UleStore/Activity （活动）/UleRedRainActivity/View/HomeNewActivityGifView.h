//
//  HomeNewActivityGifView.h
//  u_store
//
//  Created by jiangxintong on 2018/8/6.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface HomeNewActivityGifView : FLAnimatedImageView

- (instancetype)initWithFrame:(CGRect)frame gif:(NSString *)gif;
- (void)addImageGif:(NSData *)gif;
- (void)hideView:(BOOL)isHide;

@end
