//
//  SettingPwdView.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/17.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_SMSCodeButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SettingPwdTypeLogined,//已登录修改密码
    SettingPwdTypeUnlogin,//未登录设置密码
} SettingPwdType;

typedef void(^GetSMSCodeBlock)(void);
typedef void(^ConfirmButtonClickBlock)(void);

@interface SettingPwdView : UIView

@property (nonatomic, weak) UIViewController * rootViewController;
@property (nonatomic, strong) UITextField * phoneTextField;//手机号
@property (nonatomic, strong) UITextField * codeTextField;//验证码
@property (nonatomic, strong) US_SMSCodeButton * sendCodeButton;
@property (nonatomic, strong) UITextField * pwdTextField;//新密码
@property (nonatomic, strong) UITextField * confirmPwdTextField;//确认密码
@property (nonatomic, strong) ConfirmButtonClickBlock confirmBlock;
@property (nonatomic, strong) GetSMSCodeBlock getSMSCodeBlock;

- (instancetype) initWithWithViewType:(SettingPwdType )viewType;

@end
NS_ASSUME_NONNULL_END
