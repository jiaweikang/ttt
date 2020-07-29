//
//  US_RedPacketApi.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "US_NetworkExcuteManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_RedPacketApi : NSObject

//抽奖
+ (UleRequest *)buildLotteryRequestWithActivityCode:(NSString *)activityCode andFieldId:(NSString *)fieldId;

//新红包雨 获取主题
+ (UleRequest *)buildNewRedPacketTheme;
//新红包雨 获取场次
+ (UleRequest *)buildNewRedPacketInfoRainWithTheme:(NSString *)rainTheme;
@end

NS_ASSUME_NONNULL_END
