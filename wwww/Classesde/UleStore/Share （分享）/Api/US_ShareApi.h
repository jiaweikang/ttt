//
//  US_ShareApi.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_ShareApi : NSObject

+ (UleRequest *)buildGetShareJsonInfoRequest:(NSString *)listId;

+ (UleRequest *)buildActShareListingUrlRequest:(NSString *)jsonString;

+ (UleRequest *)buildGetShareListingUrlRequest:(NSString *)shareChannel from:(NSString *)shareFrom andListId:(NSString *)listId;

+ (UleRequest *)buildGetFenXiaoShareListingUrlRequest:(NSString *)listId andZoneId:(NSString *)zoneId andShareChannel:(NSString *)shareChannel andShareFrom:(NSString *)shareFrom;

+ (UleRequest *)buildShareTemplateListRequest;

+ (UleRequest *)buildShareRecordWithKeyword:(NSString *)keyword andStart:(NSString *)start;

+ (UleRequest *)buildInsuranceShareLinkRequest:(NSString *)shareChannel from:(NSString *)shareFrom andListId:(NSArray *)listInfo;
@end

NS_ASSUME_NONNULL_END
