//
//  US_UpdateAlertView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/5/9.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    UleUpdateAlertViewTypeNormal,
    UleUpdateAlertViewTypeMustUpdate, //强制更新
} UleUpdateAlertViewType;

typedef void(^AlertClickBlock)(void);
@interface US_UpdateAlertView : UIView

@property (nonatomic, strong) AlertClickBlock confirmClickBlock;
@property (nonatomic, strong) AlertClickBlock cancelClickBlock;

- (instancetype)initWithType:(UleUpdateAlertViewType)type andTitle:(NSString*)title andMessage:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
