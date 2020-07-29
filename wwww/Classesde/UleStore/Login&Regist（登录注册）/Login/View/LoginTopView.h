//
//  LoginTopView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/5.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginTopViewDelegate <NSObject>
- (void)loginTopViewGetSMSCodeByAccountNum:(NSString *)accountNum;//获取验证码
- (void)loginTopViewLoginByAccountNum:(NSString *)accountNum smsCode:(NSString *)codeNum;//验证码登录
- (void)loginTopViewLoginByAccountNum:(NSString *)accountNum passWord:(NSString *)passWdNum;//密码登录
//忘记密码 跳转到设置密码页
- (void)loginTopViewGoToSettingPasswordVCByAccountNum:(NSString *)accountNum;
@end

@interface LoginTopView : UIView
@property (nonatomic, weak)id<LoginTopViewDelegate>p_delegate;

- (void)stopSMSCodeCounting;

@end

NS_ASSUME_NONNULL_END
