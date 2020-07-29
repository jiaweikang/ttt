//
//  US_CartoonAlertView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/3.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CartoonAlertBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface US_CartoonAlertView : UIView
+(US_CartoonAlertView *)cartoonAlertViewWithMessage:(NSString *)msg confirmBlock:(CartoonAlertBlock)confirmBlock;
@end

NS_ASSUME_NONNULL_END
