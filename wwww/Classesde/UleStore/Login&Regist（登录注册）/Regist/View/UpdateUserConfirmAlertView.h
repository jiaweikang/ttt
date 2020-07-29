//
//  UpdateUserConfirmAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateUserConfirmBlock)(void);

@interface UpdateUserConfirmAlertView : UIView
@property (nonatomic, copy) UpdateUserConfirmBlock mConfirmBlock;
@property (nonatomic, copy) UpdateUserConfirmBlock mCancelBlock;

- (void)setContentLabStr:(NSString *)str;

//添加提示描述
- (void)addHintMessage;

@end

NS_ASSUME_NONNULL_END
