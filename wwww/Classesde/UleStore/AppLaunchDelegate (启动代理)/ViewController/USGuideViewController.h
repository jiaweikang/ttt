//
//  USGuideViewController.h
//  UleStoreApp
//
//  Created by xulei on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class UleUCiOSAction;
typedef void (^UsGuideDismissBlock)(UleUCiOSAction *tModuleAction);


@interface USGuideViewController : UIViewController
@property (nonatomic, assign) BOOL      statusBarHidden;
@property (nonatomic, copy) UsGuideDismissBlock     mDismissComplete;

@end

NS_ASSUME_NONNULL_END
