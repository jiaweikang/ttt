//
//  US_MystoreManangerApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MystoreManangerApi : NSObject

+ (UleRequest *)buildFindStoreInfoReqeust;

+ (UleRequest *)buildUploadImageWithStreamData:(NSString *)imageStream;

+ (UleRequest *)buildUpdateStoreInfo:(NSString *)storeName shareText:(NSString *)shareText type:(NSString *)type;

+ (UleRequest *)buildGetMessageListFromIndex:(NSInteger)startIndex;

+ (UleRequest *)buildGetCategroyMessageFromIndex:(NSInteger)startIndex category:(NSString *)category;

+ (UleRequest *)buildUpdateUserName:(NSString *)userName;
@end

NS_ASSUME_NONNULL_END
