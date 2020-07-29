//
//  US_UpdateUserInfoView.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ChangeStoreInfoType,   //修改店铺描述
    ChangeStoreNameType,    //修改店铺名
    ChangeUserNameType,    //修改用户名
} AlertType;

typedef void(^ConfirmBlock)(NSString *info);

@interface US_UpdateUserInfoView : UIView
+ (US_UpdateUserInfoView *)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder alertType:(AlertType)alertType confirmBlock:(ConfirmBlock)confirmBlock;
@end

NS_ASSUME_NONNULL_END
