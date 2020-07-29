//
//  UleRedPacketRainAwardView.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/25.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleRedPacketConfig.h"


typedef enum : NSUInteger {
    UleAwardNoneType,
    UleAwardCashType,
    UleAwardCouponType,
} UleAwardType;

@class UleRedPacketRainAwardView;
//typedef void(^UleAwardShareBlock)(UleRedPacketRainAwardView * obj,id info);
//typedef void(^UleAwardCloseBlock)(UleRedPacketRainAwardView * obj);
typedef enum : NSUInteger {
    UleRedpacketRainEventShare,   //分享
    UleRedpacketRainEventToMain,   //回主会场
    UleRedpacketRainEventToHomePage,    //回首页
    UleRedpacketRainEventToUse,   //去使用
    UleRedpacketRainEventOneMore,  //再来一次
} UleRedpacketRainClickEventType;

@class UleAwardCellModel;
typedef void(^UleRedpacketRainClickBlock)(UleRedpacketRainClickEventType event,NSArray<UleAwardCellModel*> *obj) ;


@interface UleAwardCellModel:NSObject
@property (nonatomic, strong) NSString * money;
@property (nonatomic, strong) NSString * awardTypeStr;
@property (nonatomic, strong) NSString * useCondition;
@property (nonatomic, strong) NSString * limitPurchase;
@property (nonatomic, strong) NSString * expiryDate;
@property (nonatomic, strong) NSString * limitMoney;
@property (nonatomic, assign) UleAwardType awardType;
@property (nonatomic, copy) NSString * activityDate;//活动日期
@property (nonatomic, copy) NSString * wishes;//祝福语

@end

@interface UleRedPacketRainAwardView : UIView


/**
 显示中奖页面
 @param dataArray 中奖数据（包含显示文案，中奖金额，有效期等数据）
 @param clickBlock 按键点击事件
 */
+ (instancetype)showAwardViewWithDataArray:(NSArray<UleAwardCellModel *> *)dataArray channel:(NSString *)channel isShowShareBtn:(BOOL)showShareBtn clickBlock:(UleRedpacketRainClickBlock)clickBlock;

- (void)hiddenAwardView;

@end
