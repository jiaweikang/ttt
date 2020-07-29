//
//  InsuranceAlertView.h
//  u_store
//
//  Created by MickyChiang on 2019/3/11.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+ShowAnimation.h>
typedef void(^InsuranceAlertConfirmBlock)(void);

@interface InsuranceAlertView : UIView
+ (InsuranceAlertView *)insuranceAlertViewWithUrl:(NSString *)imgUrl wh_rate:(NSString *)wh_rate confirmBlock:(InsuranceAlertConfirmBlock)confirmBlock;
@end
