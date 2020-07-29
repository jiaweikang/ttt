//
//  US_UpdateUserInfoAlertView.h
//  u_store
//
//  Created by xstones on 2017/1/16.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UpdateResultAlertViewType)
{
    UpdateResultAlertViewTypeSuccess,
    UpdateResultAlertViewTypeFail
};

typedef void(^UpdateResultAlertConfirmBlock)(void);

@interface UpdateUserResultAlertView : UIView

+(UpdateUserResultAlertView *)updateAlertviewWithType:(UpdateResultAlertViewType)type andMessage:(NSString *)msg confirmBlock:(UpdateResultAlertConfirmBlock)confirmBlock;

@end
