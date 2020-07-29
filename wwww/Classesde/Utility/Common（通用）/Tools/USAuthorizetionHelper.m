//
//  USAuthorizetionHelper.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USAuthorizetionHelper.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UserNotifications/UserNotifications.h>

@implementation USAuthorizetionHelper

+ (BOOL)photoLibaryAuth {
    BOOL isAuth = NO;
    if (kSystemVersion>=9.0) {
        //请求权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
        }];
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        isAuth = !(status == PHAuthorizationStatusDenied || status == PHAuthorizationStatusRestricted);
    }
    else {
        ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
        isAuth = !(author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied);
    }
    return isAuth;
}

+ (BOOL) currentNotificationAllowed{
    __block BOOL enabled = NO;
    if (@available(iOS 10, *)) {
        dispatch_semaphore_t sem;
        sem = dispatch_semaphore_create(0);
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            switch (settings.authorizationStatus) {
                case UNAuthorizationStatusAuthorized:
                    enabled = YES;
                    break;
                default:
                    break;
            }
            dispatch_semaphore_signal(sem);
        }];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); //获取通知设置的过程是异步的，这里需要等待
    }
    else{
        UIApplication *application = [UIApplication sharedApplication];
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
            UIUserNotificationSettings *settings = [application currentUserNotificationSettings];
            if (settings.types != UIUserNotificationTypeNone)
            {
                enabled = YES;
            }
        }
    }
    return enabled;
}

@end
