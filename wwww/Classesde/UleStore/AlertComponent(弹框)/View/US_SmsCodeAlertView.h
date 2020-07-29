//
//  US_SmsCodeAlertView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ConfirmActionBlock)(void);
@interface US_SmsCodeAlertView : UIView
+(US_SmsCodeAlertView *)smsCodeAlertViewWithPhoneNum:(NSString *)phoneNum
                                   confirmAction:(ConfirmActionBlock)confirmBlock;
@end

NS_ASSUME_NONNULL_END
