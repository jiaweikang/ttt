//
//  RegistStoreSuccessAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RegistStoreSuccessAlertViewBlock)(void);

@interface RegistStoreSuccessAlertView : UIView

@property (nonatomic, copy)RegistStoreSuccessAlertViewBlock confirmBlock;

@end

NS_ASSUME_NONNULL_END
