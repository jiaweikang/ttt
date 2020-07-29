//
//  UleNewRedPacketRainManager.h
//  UleApp
//
//  Created by zemengli on 2019/7/11.
//  Copyright © 2019 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^UleNewRedRainRequestThemeFinishBlock)(void);
@interface UleNewRedPacketRainManager : NSObject
@property (nonatomic, assign) BOOL isPullDownRefresh;//是否是下拉刷新 手动下拉刷新 才调用获取活动场次接口
@property (nonatomic, assign) BOOL isActivating;//活动是否开始
/** 单例 */
+ (instancetype)sharedManager;
- (void)requestRedPacketRainTheme;
@property (nonatomic, copy) UleNewRedRainRequestThemeFinishBlock requestThemeFinishBlock;
@end

NS_ASSUME_NONNULL_END
