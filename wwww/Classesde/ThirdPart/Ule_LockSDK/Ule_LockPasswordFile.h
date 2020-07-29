//
//  Ule_LockPasswordFile.h
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ule_LockPasswordFile : NSObject

/**
 *  读取当前帐户手势锁开启或关闭
 *
 *  @return 结果
 */
+ (NSString *)readLockStatus;

/**
 *  设置手势锁状态
 *
 *  @param status 开启/关闭
 *
 *  @return 设置结果
 */
+ (BOOL)saveLockStatus:(NSString *)status;

/**
 *  清除状态 与设置为关闭同效
 *
 *  @return 设置结果
 */
+ (BOOL)removeLockStatus;

/**
 *  获取账户手势密码
 *
 *  @return 手势密码
 */
+ (NSString *)readLockPassword;

/**
 *  保存账户手势密码
 *
 *  @param pswd 手势密码
 *
 *  @return 保存结果
 */
+ (BOOL)saveLockPassword:(NSString *)pswd;

/**
 *  移除本地密码
 *
 *  @return 移除结果
 */
+ (BOOL)removeLockPassword;

/**
 *  加密密码
 *
 *  @param key 字符串
 *
 *  @return 加密字符串
 */
+ (NSString *)cryptoStringWithKey:(NSString *)key;

@end
