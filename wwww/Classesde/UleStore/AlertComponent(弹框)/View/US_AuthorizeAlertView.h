//
//  US_AuthorizeAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AuthorizeViewType)
{
    AuthorizeViewTypeSuccess,
    AuthorizeViewTypeFail
};

@interface US_AuthorizeAlertView : UIView
@property (nonatomic, copy)void(^confirmBlock)(void);

- (instancetype)initWithType:(AuthorizeViewType)showType andMessage:(NSString *)msg isContinuePush:(BOOL)isPush;

@end

NS_ASSUME_NONNULL_END
