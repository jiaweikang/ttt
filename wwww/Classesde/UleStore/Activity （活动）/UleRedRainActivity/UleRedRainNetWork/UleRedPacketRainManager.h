//
//  UleRedPacketRainManager.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleRedPacketConfig.h"
#import "UleRedPacketRainAwardView.h"



//typedef void(^UleRedpacketRainShareBlock)(NSArray<UleAwardCellModel *> * obj);
//typedef void(^UleRedpacketRainCloseBlock)(void);

@interface UleRedPacketRainModel:NSObject

@property (nonatomic, copy) NSString * channel;   //渠道号
@property (nonatomic, copy) NSString * userId;      //用户ID
@property (nonatomic, copy) NSString * activityCode; //活动Code
@property (nonatomic, copy) NSString * deviceId;   // 设备ID
@property (nonatomic, copy) NSString * fieldId;    //活动场次

@property (nonatomic, copy) NSString * province;   //省（定位）
@property (nonatomic, copy) NSString * orgCode;   //小店需要的

@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval endTime;
@property (nonatomic, copy) NSString * startDate;   //
@property (nonatomic, copy) NSString * endDate;   //
@property (nonatomic, copy) NSString * activityDate;//活动日期
@property (nonatomic, copy) NSString * wishes;//祝福语
@end


@interface UleRedPacketRainManager : NSObject



/**
 开始红包雨
 @param model 红包雨数据模型
 @param isprd 接口运行环境 YES 为生产 NO为beta
 @param clickBlock 分享按键点击回调
 */

+ (void) startUleRedPacketRainWithModel:(UleRedPacketRainModel *)model environment:(BOOL)isprd increaseCashDarw:(BOOL)isIncrease ClickEvent:(UleRedpacketRainClickBlock)clickBlock;


+ (void) showRedRainResultWithModel:(UleRedPacketRainModel *)model environment:(BOOL)isprd increaseCashDarw:(BOOL)isIncrease ClickEvent:(UleRedpacketRainClickBlock)clickBlock;

/**
 隐藏红包雨页面
 */
+ (void)hiddenUleRdPacketRain;

/**
 记录日志
 @param eventName 事件名称（提醒：RedPacketsNotify ，下红包雨：RedPacketsRain，分享：RedPacketsShare）
 @param redModel 接口参数model
 */
+ (void)startRecordLogWithEventName:(NSString *)eventName environment:(BOOL)isprd withModel:(UleRedPacketRainModel *)redModel;
@end
