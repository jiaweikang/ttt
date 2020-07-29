//
//  OrganizeConfirmAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/26.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrganizeConfirmAlertViewBlock)(void);

@interface OrganizeConfirmAlertView : UIView
@property (nonatomic, copy)OrganizeConfirmAlertViewBlock    confirmBlock;

-(void)setConfirmedStr:(NSString *)confirmStr;

@end

NS_ASSUME_NONNULL_END
