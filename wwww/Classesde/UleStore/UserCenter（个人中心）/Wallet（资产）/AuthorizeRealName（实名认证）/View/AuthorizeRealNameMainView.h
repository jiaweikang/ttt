//
//  AuthorizeRealNameMainView.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizeRealNameMainView : UIView

+ (UIView *)getPromoteViewWithStr:(NSString *)textStr;

@end

@interface AuthorizeRealNameTopView : AuthorizeRealNameMainView
//@property (nonatomic, copy)NSString     *userName;
//@property (nonatomic, copy)NSString     *idCard;

@end

@interface AuthorizeRealNameCenterView : AuthorizeRealNameMainView
//@property (nonatomic, copy)NSString     *bankCard;
@property (nonatomic, copy) void (^choosenBtnBlock)(void);

- (void)setBankCardNum:(NSString *)cardNum;

- (void)setBankCardChoosenBtnHidden:(BOOL)isHidden;

@end

@class US_SMSCodeButton;
@interface AuthorizeRealNameBootomView : AuthorizeRealNameMainView
//@property (nonatomic, copy)NSString     *mobileStr;
//@property (nonatomic, copy)NSString     *smsCodeStr;
@property (nonatomic, strong)US_SMSCodeButton   *smsCodeBtn;
@property (nonatomic, copy) void (^smsCodeBtnBlock)(void);

- (void)setMobileNum:(NSString *)mobileNum;

@end
NS_ASSUME_NONNULL_END
