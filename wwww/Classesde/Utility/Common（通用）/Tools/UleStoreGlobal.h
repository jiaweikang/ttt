//
//  UleStoreGlobal.h
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/26.
//

#import <Foundation/Foundation.h>
#import "UleStoreConfigure.h"
NS_ASSUME_NONNULL_BEGIN

@interface UleStoreGlobal : NSObject
@property (nonatomic, strong) UleStoreConfigure * config;

+ (instancetype) shareInstance;

+ (void)loadUleStoreInfo:(UleStoreConfigure *)config appLogKey:(NSString *)appKey andEnvService:(NSInteger)env;

@end

NS_ASSUME_NONNULL_END
