//
//  US_EnterprisePlaceholderView.h
//  u_store
//
//  Created by jiangxintong on 2018/12/3.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kImageWidth KScreenScale(360)
#define kImageHeight KScreenScale(360)
#define kLabelHeight 50.0
#define kButtonHeight 40.0

typedef void(^TapCallback)(void);

@interface US_EnterprisePlaceholderView : UIView

@property (nonatomic, copy) TapCallback callback;

- (void)setPickButtonHidden:(BOOL)isHide;

@end

