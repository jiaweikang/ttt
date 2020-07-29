//
//  USRedPacketCashManager.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/9.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^DrawLotteryResultBlock)(NSString *str);

NS_ASSUME_NONNULL_BEGIN

@interface USRedPacketCashManager : NSObject

+ (instancetype)sharedManager;

/*type为1的现金抽奖（以红包雨形式)
 **/
- (void)requestCashRedPacketByRedRain;

/*type为1的现金抽奖（分享回调调用）直接显示结果（已弃用，改为红包雨形式）
 **/
- (void)requestCashRedPacket;

/*直接调用抽奖接口
 *  activityCode 活动code
 *  fieldId 场次id
 *  isIncrease  是否增加本地记录抽奖次数
 **/
-(void)requestCashRedPacketWithActivityCode:(NSString *)activityCode andFieldId:(NSString *)fieldId increaseDrawCount:(BOOL)isIncrease successBlock:(__nullable DrawLotteryResultBlock)mSuccessBlock errorBlock:(__nullable DrawLotteryResultBlock)mErrorBlock;

/*******红包雨结果处理********/
//分享
-(void)showShareViewWithDataArray:(NSArray *)dataArr andShareText:(NSString *)shareText;

//去主会场
- (void)uleRedPacketGotoMainVenue;

//去使用
- (void)uleRedPacketGotoUse;

//回首页
- (void)uleRedPacketGotoHomePage;
/*******红包雨结果处理********/

@end

NS_ASSUME_NONNULL_END
