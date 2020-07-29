//
//  USKeychainLocalData.m
//  UleStoreApp
//
//  Created by xulei on 2019/5/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USKeychainLocalData.h"
#import "LUKeychainAccess.h"

static NSString *const keySellUserData_usrOnlyid=@"us_usrOnlyid";

@implementation USKeychainLocalData

+ (instancetype)data
{
    static USKeychainLocalData  *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setIsVoicePromptOn:(BOOL)isVoicePromptOn
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:[UleStoreGlobal shareInstance].config.AppGroupsID];
    [userDefaults setBool:!isVoicePromptOn forKey:@"keyVoicePromoteOff"];
    [userDefaults synchronize];
    
    [[LUKeychainAccess standardKeychainAccess] setObject:isVoicePromptOn ? @"1" : @"0" forKey:[NSString stringWithFormat:@"voicePrompt%@", self.usrOnlyid]];
}

- (BOOL)isVoicePromptOn
{
    BOOL isOn;
    
    NSString *isVoicePromptOn = [[LUKeychainAccess standardKeychainAccess] objectForKey:[NSString stringWithFormat:@"voicePrompt%@", self.usrOnlyid]];
    
    if (isVoicePromptOn == nil) {
        isOn = YES;
    } else {
        isOn = [isVoicePromptOn boolValue];
    }
    return isOn;
}

- (void)setUsrOnlyid:(NSString *)usrOnlyid
{
    [[LUKeychainAccess standardKeychainAccess] setObject:usrOnlyid?usrOnlyid:@"" forKey:keySellUserData_usrOnlyid];
}

- (NSString *)usrOnlyid
{
    NSString *usrOnlyidStr = [[LUKeychainAccess standardKeychainAccess] objectForKey:keySellUserData_usrOnlyid];
    self.usrOnlyid = usrOnlyidStr;
    return usrOnlyidStr?usrOnlyidStr:@"";
}

@end

