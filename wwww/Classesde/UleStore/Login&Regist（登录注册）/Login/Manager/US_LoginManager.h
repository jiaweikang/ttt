//
//  US_LoginManager.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LogInMainViewTypeFrom) {
    LogInMainViewTypeFromLogin,
    LogInMainViewTypeFromRegist
};

@interface US_LoginManager : NSObject

+ (instancetype)sharedManager;

+ (void)logOutToLoginWithMessage:(NSString *)msg;

- (NSDictionary *) logInDecryptData:(NSDictionary *)dic;

- (void)logInToMainviewWithData:(NSDictionary *)dataDic fromType:(LogInMainViewTypeFrom)type;

- (void)saveUserInfoToLocalWithData:(NSDictionary *)dataDic;

+ (void)showLoginView;
@end

NS_ASSUME_NONNULL_END
