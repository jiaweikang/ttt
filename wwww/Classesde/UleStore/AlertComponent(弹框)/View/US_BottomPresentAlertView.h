//
//  US_BottomPresentAlertView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/6/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ConfirmActionBlock)(void);
@interface US_BottomPresentAlertView : UIView
+(US_BottomPresentAlertView *)BottomPresentAlertViewWithTitle:(NSString *)title
                                                      Message:(NSString *)message
                                                  cancelTitle:(NSString *)cancelTitle
                                                 ConfirmTitle:(NSString *)confirmTitle
                                       confirmAction:(ConfirmActionBlock)confirmBlock;

@end
NS_ASSUME_NONNULL_END
