//
//  OrganizePickAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol OrganizePickAlertViewDelegate <NSObject>
- (void)backupBtnAction;
- (void)leftBtnAction;
- (void)rightBtnAction;

@end

@interface OrganizePickAlertView : UIView

@property (nonatomic, weak)id<OrganizePickAlertViewDelegate> mDelegate;

- (void)show;

- (void)dismiss;

- (void)showBackupBtn:(BOOL)isShow;

- (void)setPresentStr:(NSString *)presentStr andLastStr:(NSString *)lastStr;


@end

NS_ASSUME_NONNULL_END
