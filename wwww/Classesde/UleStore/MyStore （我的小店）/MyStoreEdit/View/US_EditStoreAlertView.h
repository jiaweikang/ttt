//
//  US_EditStoreAlertView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    US_EditStoreAlertViewSucess,
    US_EditStoreAlertViewFailed,
} US_EditStoreAlertViewType;

typedef void(^EditStoreAlertBlock)(id obj);

NS_ASSUME_NONNULL_BEGIN

@interface US_EditStoreAlertView : UIView

- (instancetype) initWithTitle:(NSString *)title type:(US_EditStoreAlertViewType) type confirmBlock:(EditStoreAlertBlock)block;
@end

NS_ASSUME_NONNULL_END
