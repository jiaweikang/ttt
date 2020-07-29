//
//  US_NetwordExcuteManager.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<UleNetworkExcute.h>)
#import <UleNetworkExcute.h>
#import <UleReachability.h>
#else
#import "UleNetworkExcute.h"
#import "UleReachability.h"
#endif
#import "US_Api.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_NetworkExcuteManager : NSObject
+ (NSString *) netWorkType;
//vps.ule.com/yzgApiWAR 替换为api.ule.com域名 2019.08.14
+ (UleNetworkExcute *) uleVPSRequestClient;

+ (UleNetworkExcute *) uleAPIRequestClient;

+ (UleNetworkExcute *) uleCDNRequestClient;

+ (UleNetworkExcute *) uleServerRequestClient;

+ (UleNetworkExcute *) uleTrackRequestClient;

+ (UleNetworkExcute *) uleUstaticCDNRequestClient;

+ (NSMutableDictionary *)getRequestHeaderNormalSignParams;
+ (NSMutableDictionary *)getRequestHeaderUploadImageSignParams:(NSString *) imageName;
+ (NSMutableDictionary *)getRequestHeaderStoreListSignParms:(NSString *)pageSize pageIndex:(NSString *)pageIndex andStoreId:(NSString *)storeId;
+ (NSMutableDictionary *)getRequestHeaderSearchGoodsSourceSignParms:(NSString *)keyword pageIndex:(NSString *)pageIndex andPageSize:(NSString*)pageSize;

+ (NSMutableDictionary *)getRequestCouponBacthId:(NSString *)batchId pageIndex:(NSString * )pageIndex andPageSize:(NSString *)pageSize;


//加密后的参数
+ (NSMutableDictionary *)getEncryptedParamsWithDic:(NSDictionary *)dic andKey:(NSString *)encryptKey andIV:(NSString *)encryptIV;

@end

NS_ASSUME_NONNULL_END
