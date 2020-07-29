//
//  US_AlertView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+ShowAnimation.h>
NS_ASSUME_NONNULL_BEGIN

@class US_AlertView;
@protocol US_AlertViewDelegate <NSObject>

@optional
-(void)uleAlertView:(US_AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

typedef void(^US_AlertViewClickBlock)(NSInteger buttonIndex,NSString * title);



@interface US_AlertView : UIView
@property (nonatomic, weak) id <US_AlertViewDelegate> delegate;

+ (US_AlertView *)alertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle;

- (instancetype) initWithWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelTitle confirmButtonTitle:(NSString *)confirmTitle;
@property(nonatomic, copy)US_AlertViewClickBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
