//
//  US_UntyingBankCardAlertView.h
//  u_store
//
//  Created by jiangxintong on 2018/6/4.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmActionBlock)(void);
typedef void(^CancelActionBlock)(void);

@interface US_UntyingBankCardAlertView : UIView

+ (US_UntyingBankCardAlertView *)untyingBankCardAlertViewWithTitle:(NSString *)title message:(NSString *)message confirmAction:(ConfirmActionBlock)confirmBlock cancelAction:(CancelActionBlock)cancelBlock;

@end
