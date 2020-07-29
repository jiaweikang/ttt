//
//  US_EnterpriseApi.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UleRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_EnterpriseApi : NSObject

+ (UleRequest *)buildEnterpriseBanner;
+ (UleRequest *)buildEnterpriseRecommendWithPageIndex:(NSInteger)pageIndex;
// 根据机构id获取专区id（zoneId）
+ (UleRequest *)buildWholeSaleZoneId;
// 查询批销商品
+ (UleRequest *)buildWholeSaleItemListByPageStart:(NSNumber *)pageStart;
@end

NS_ASSUME_NONNULL_END
