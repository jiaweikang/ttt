//
//  Ule_LockPasswordFile.m
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//
//  密码管理
//

#import "Ule_LockPasswordFile.h"
#import <CommonCrypto/CommonDigest.h>
#import "Ule_LockConst.h"
#import "US_UserUtility.h"

@implementation Ule_LockPasswordFile

+ (NSString *)readLockStatus {
    NSString *m_name = [US_UserUtility sharedLogin].m_userId;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *status = [ud objectForKey:[NSString stringWithFormat:@"status%@",m_name]];
    if (status != nil &&
        ![status isEqualToString:@""] &&
        ![status isEqualToString:@"(null)"]) {
        
        return status;
    }
    return nil;
}

+ (BOOL)saveLockStatus:(NSString *)status {
    @try {
        NSString *m_name = [US_UserUtility sharedLogin].m_userId;
        [[NSUserDefaults standardUserDefaults] setObject:status forKey:[NSString stringWithFormat:@"status%@",m_name]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)removeLockStatus {
    @try {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *m_name = [US_UserUtility sharedLogin].m_userId;
        NSString *status = [ud objectForKey:[NSString stringWithFormat:@"status%@",m_name]];
        if (status != nil &&
            ![status isEqualToString:@""] &&
            ![status isEqualToString:@"(null)"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"status%@",m_name]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (NSString *)readLockPassword {
    
    NSString *m_name = [US_UserUtility sharedLogin].m_userId;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *pswd = [ud objectForKey:[NSString stringWithFormat:@"pwd%@",m_name]];
    if (pswd != nil &&
        ![pswd isEqualToString:@""] &&
        ![pswd isEqualToString:@"(null)"]) {
        
        return pswd;
    }
    return nil;
}

+ (BOOL)saveLockPassword:(NSString *)pswd {

    @try {
        pswd = [self cryptoStringWithKey:pswd];
        NSString *m_name = [US_UserUtility sharedLogin].m_userId;
        [[NSUserDefaults standardUserDefaults] setObject:pswd forKey:[NSString stringWithFormat:@"pwd%@",m_name]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (BOOL)removeLockPassword {

    @try {
        // 移除开启状态
        [Ule_LockPasswordFile removeLockStatus];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *m_name = [US_UserUtility sharedLogin].m_userId;
        NSString *pswd = [ud objectForKey:[NSString stringWithFormat:@"pwd%@",m_name]];
        if (pswd != nil &&
            ![pswd isEqualToString:@""] &&
            ![pswd isEqualToString:@"(null)"]) {
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"pwd%@",m_name]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
}

+ (NSString *)cryptoStringWithKey:(NSString *)key {
    if (key == nil || key.length ==0) {
        return @"";
    }
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5str = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x"
                        "%02x%02x%02x%02x%02x%02x",
                        r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9],
                        r[10], r[11], r[12], r[13], r[15], r[14]];
    return md5str;
}

@end
