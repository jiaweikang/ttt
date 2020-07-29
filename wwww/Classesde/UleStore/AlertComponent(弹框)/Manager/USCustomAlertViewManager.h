//
//  USCustomAlertViewManager.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CustomAlertViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface USCustomAlertViewManager : NSObject
+ (instancetype)sharedManager;
//请求弹框
- (void)startRequestAppicationAlertView;

//离开请求组
- (void)leaveApplicationAlertRequestGroup;

//后台回前台
- (void)startRequestAlertViewWillEnterForeground;

@end

NS_ASSUME_NONNULL_END
