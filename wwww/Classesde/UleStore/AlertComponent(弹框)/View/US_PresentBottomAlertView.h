//
//  US_PresentBottomAlertView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^US_PresentBottomAlertViewClickBlock)(void);
@interface US_PresentBottomAlertView : UIView
+ (US_PresentBottomAlertView *)presentBottomAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle;


@property(nonatomic, copy)US_PresentBottomAlertViewClickBlock confirmBlock;

-(void)show;


-(void)dismiss;
@end

NS_ASSUME_NONNULL_END
