//
//  USUniversalAlertView.h
//  u_store
//
//  Created by mac_chen on 2019/2/20.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    alertClickType_button, //点击按钮
    alertClickType_image, //点击图片
} AlertClickType;

typedef void(^AlertConfirmBlock)(AlertClickType);
typedef void(^AlertCloseBlock)(void);

@class ActivityDialogIndexInfo,UleBaseViewController;
@interface USUniversalAlertView : UIView

+ (USUniversalAlertView *)alertWithData:(ActivityDialogIndexInfo *)data confirmBlock:(AlertConfirmBlock)confirmBlock closeBlock:(AlertCloseBlock)closeBlock;

@end

NS_ASSUME_NONNULL_END
