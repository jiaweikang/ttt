//
//  WithdrawFailAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/1.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WithdrawFailConfirmBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawFailAlertView : UIView

+ (WithdrawFailAlertView *)withdrawFailViewWithMsg:(NSString *)msg confirmBlock:(WithdrawFailConfirmBlock)block;

@end

NS_ASSUME_NONNULL_END
