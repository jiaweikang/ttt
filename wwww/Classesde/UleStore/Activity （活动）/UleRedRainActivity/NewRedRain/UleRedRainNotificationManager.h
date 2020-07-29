//
//  UleRedRainNotificationManager.h
//  UleStoreApp
//
//  Created by zemengli on 2019/8/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UleRedRainNotificationManager : NSObject
/** 单例 */
+ (instancetype)sharedManager;
- (void)requestRedPacketRainInfo:(NSString *)themeCode;
- (void)setRedRainNotification:(NSDictionary *)args result:(void (^)(NSString * _Nullable isHaveAuthority))completionHandler;

- (void)cancelRedRainNotification;
- (BOOL)getRedRainNotificationIsOpen:(NSString *)themeCode;
@end

NS_ASSUME_NONNULL_END
