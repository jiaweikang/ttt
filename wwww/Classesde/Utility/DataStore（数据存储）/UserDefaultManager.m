//
//  UserDefaulfManager.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/6.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (NSString *)getLocalDataString:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey) {
        return nil;
    }
    
    NSString *strRet = [defaults objectForKey:aKey];
    
    return strRet;
}

+ (void)setLocalDataString:(NSString *)aValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setObject:aValue forKey:aKey];
    [defaults synchronize];
}

+ (BOOL)getLocalDataBoolen:(NSString *)aKey {
    BOOL bRet = NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        bRet = NO;
    } else {
        bRet = [defaults boolForKey:aKey];
    }
    
    return bRet;
}

+ (void)setLocalDataBoolen:(BOOL)bValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setBool:bValue forKey:aKey];
    [defaults synchronize];
}

+ (NSInteger)getLocalDataInt:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return 0;
        
    } else {
        return [defaults integerForKey:aKey];
    }
}

+ (CGFloat)getLocalDataCGfloat:(NSString *)aKey {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return 0;
        
    } else {
        return [defaults floatForKey:aKey];
    }
}

+ (void)setLocalDataCGfloat:(CGFloat)num key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return ;
    }
    [defaults setFloat:num forKey:aKey];
    [defaults synchronize];
    
}

+ (void)setLocalDataInt:(NSInteger)num key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (nil == defaults || aKey == nil) {
        return;
    }
    [defaults setInteger:num forKey:aKey];
    [defaults synchronize];
}

+ (id)getLocalDataObject:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return nil;
    }
    
    id strRet = [defaults objectForKey:aKey];
    
    return strRet;
}

+ (void)setLocalDataObject:(id)aValue key:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (nil == defaults || nil == aKey) {
        return;
    }
    
    [defaults setObject:aValue forKey:aKey];
    [defaults synchronize];
}

+ (void)saveRecordSearchText:(NSString *)text{
    NSMutableArray * search_arr = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserDefault_SearchRecord] mutableCopy];
    if (search_arr==nil) {
        search_arr=[NSMutableArray new];
    }
    [search_arr removeObject:text];
    [search_arr insertObject:text atIndex:0];
    if ([search_arr count]>10) {
        [search_arr removeObjectsInRange:NSMakeRange(9, [search_arr count]-10)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:search_arr forKey:kUserDefault_SearchRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
