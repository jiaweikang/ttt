//
//  HomeNewActivityGifView.m
//  u_store
//
//  Created by jiangxintong on 2018/8/6.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "HomeNewActivityGifView.h"
#import <SDWebImageManager.h>
@implementation HomeNewActivityGifView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame gif:(NSString *)gif {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeScaleAspectFill;
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:gif] options:SDWebImageRefreshCached progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
        }];
    }
    return self;
}

- (void)addImageGif:(NSData *)gif {
    self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gif];
}

- (void)hideView:(BOOL)isHide{
    if (self.animatedImage) {
        [self setHidden:isHide];
    }
}

@end
