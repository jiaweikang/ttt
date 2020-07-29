//
//  AccCancellationAlertView.h
//  u_store
//
//  Created by jiangxintong on 2018/12/14.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AccCancellationAlertType) {
    AccCancellationAlertTypeSuccess,
    AccCancellationAlertTypeFailed
};

typedef void(^ConfirmBlock)(void);
typedef void(^CancelBlock)(void);
typedef void(^Callback)(void);

@interface US_AccCancellationAlertView : UIView

+ (US_AccCancellationAlertView *)showAlertWithMessage:(NSString *)message cancelBlock:(CancelBlock)cancelBlock confirmBlock:(ConfirmBlock)confirmBlock;
+ (US_AccCancellationAlertView *)showResultAlertWithType:(AccCancellationAlertType)alertType message:(NSString *)message callback:(Callback)callback;

@end
