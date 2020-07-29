//
//  US_WarningAlertView.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ConfirmBlock)(void);

@interface US_WarningAlertView : UIView

@property (nonatomic, copy) ConfirmBlock confirmBlock;

@end

NS_ASSUME_NONNULL_END
