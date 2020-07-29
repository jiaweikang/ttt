//
//  USInviteAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UleShareSDK/Ule_ShareView.h>


NS_ASSUME_NONNULL_BEGIN

@interface USInviteAlertView : UIView

@property (nonatomic, copy)void(^btnActionBlock)(NSInteger);

- (instancetype)initWithSure1:(NSString *)mSure1
                    withSure2:(NSString *)mSure2
                   withCancel:(NSString *)mCancel
                    withTitle:(NSString *)mTitle;
@end

NS_ASSUME_NONNULL_END
