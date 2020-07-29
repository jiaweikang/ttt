//
//  UleStoreGlobal.m
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/26.
//

#import "UleStoreGlobal.h"

@implementation UleStoreGlobal


+ (instancetype) shareInstance{
    static UleStoreGlobal * manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[UleStoreGlobal alloc] init];
    });
    return manager;
}

+ (void)loadUleStoreInfo:(UleStoreConfigure *)config appLogKey:(NSString *)appKey andEnvService:(NSInteger)env{
    UleStoreGlobal * global=[UleStoreGlobal shareInstance];
    global.config=config;
    
}

@end
