//
//  US_UpdateUserSwitchDefaultAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/27.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^US_UpdateUserSwitchDefaultAlertConfirmBlock)(void);
@interface US_UpdateUserSwitchDefaultAlertView : UIView
@property (nonatomic, copy)US_UpdateUserSwitchDefaultAlertConfirmBlock  mConfirmBlock;
@end

NS_ASSUME_NONNULL_END
