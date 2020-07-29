//
//  SettingPayPwdView.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/13.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_SMSCodeButton.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SettingPayPwdTypeSettingNew,//找回支付密码
    SettingPayPwdTypeModify, //修改支付密码
} SettingPayPwdType;

typedef void(^ConfirmButtonClickBlock)(void);

@interface SettingPayPwdView : UIView

@property (nonatomic, weak) UIViewController * rootViewController;
@property (nonatomic, strong) US_SMSCodeButton * sendCodeButton;
@property (nonatomic, strong) UITextField * codeTextField;//验证码
@property (nonatomic, strong) UITextField * oldPwdTextField;//旧密码
@property (nonatomic, strong) UITextField * pwdTextField;//新密码
@property (nonatomic, strong) UITextField * confirmPwdTextField;//确认密码
@property (nonatomic, strong) ConfirmButtonClickBlock confirmBlock;


- (instancetype) initWithWithViewType:(SettingPayPwdType )viewType;

@end

NS_ASSUME_NONNULL_END
