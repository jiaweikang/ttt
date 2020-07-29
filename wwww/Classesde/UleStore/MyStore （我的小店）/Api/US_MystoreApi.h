//
//  US_MystoreApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_MystoreApi : NSObject

+ (UleRequest *)buildGetCommisionRequest;

//+ (UleRequest *)buildGetShareInfoRequest;
+ (UleRequest *)buildGetShareInfoVisitCountRequest;

+ (UleRequest *)buildGetShareInfoOrderCountRequest;

+ (UleRequest *)buildGetNewPushMessageNumRequest;

+ (UleRequest *)buildGetButtonListRequest;

@end

NS_ASSUME_NONNULL_END
