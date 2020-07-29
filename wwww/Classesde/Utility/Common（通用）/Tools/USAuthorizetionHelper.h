//
//  USAuthorizetionHelper.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USAuthorizetionHelper : NSObject
//相册权限
+ (BOOL)photoLibaryAuth;

//是否有推送权限
+ (BOOL) currentNotificationAllowed;
@end

NS_ASSUME_NONNULL_END
