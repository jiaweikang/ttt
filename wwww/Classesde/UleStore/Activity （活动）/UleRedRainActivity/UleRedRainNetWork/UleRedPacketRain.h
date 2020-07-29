//
//  UleRedPacketRain.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/24.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UleRedPacketRain;

typedef void(^RedPacketRainFinishd)(UleRedPacketRain * obj,id info);

typedef void(^RedPackectRainCountDown)(void);

typedef void(^RedPackectRainClickLog)(void);

@interface UleRedPacketRain : UIView


/**
 显示红包雨页面
 @param winnerList 中奖名单
 @param preShowEnd 红包雨倒计时预告结束回调事件
 @param finishBlock 红包雨结束后回调事件
 */
+ (void)showRedPacketReinWithWinners:(NSArray<NSString *> *)winnerList packetPreShowEnd:(RedPackectRainCountDown) preShowEnd packetRainFinished: (RedPacketRainFinishd) finishBlock redpacketRainClickLog:(RedPackectRainClickLog) clickBlock;

/**
 隐藏红包雨页面
 */
- (void)hiddenRedPacketRain;


@end
