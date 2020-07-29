//
//  UleNativePayManager.h
//  UleApp
//
//  Created by chenzhuqing on 2018/6/4.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface UleNativePayManager : NSObject

+ (instancetype) shareInstance;

- (void) startNativePayWithParams:(NSDictionary *)params result:(void (^)(NSString * _Nullable result,BOOL complete))completionHandler;

-(BOOL) UleNativePayOpenUrl:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
