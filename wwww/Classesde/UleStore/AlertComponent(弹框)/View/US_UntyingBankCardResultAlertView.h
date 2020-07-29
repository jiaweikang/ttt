//
//  US_UntyingBankCardResultAlertView.h
//  u_store
//
//  Created by jiangxintong on 2018/6/13.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UntyingBankCardResultAlertViewType){
    UntyingBankCardResultAlertViewTypeSuccess,
    UntyingBankCardResultAlertViewTypeFail
};

@protocol UntyingBankCardResultAlertViewDelegate <NSObject>
@optional
- (void)untyingBankCardResultAlertViewSuccess;
- (void)untyingBankCardResultAlertViewTryAgainAction;
@end

@interface US_UntyingBankCardResultAlertView : UIView

+ (US_UntyingBankCardResultAlertView *)untyingBankCardResultAlertViewWithType:(UntyingBankCardResultAlertViewType)viewType delegate:(id<UntyingBankCardResultAlertViewDelegate>)mDelegate;

@end
