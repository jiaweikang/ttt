//
//  UleRedPacketRainCountDownView.h
//  UleApp
//
//  Created by zemengli on 2018/7/24.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    UleRedPacketRainViewType_ActivityCountDown_Remind_OFF,//倒计时 提醒未开启
    UleRedPacketRainViewType_ActivityCountDown_Remind_ON,//倒计时 提醒开始
    UleRedPacketRainViewType_ActivityStart, //活动开始
} UleRedPacketRainViewType;

typedef void(^UleRedPacketRainCountDownViewClickBlock)(UleRedPacketRainViewType buttonType);
typedef void(^UleRedPacketRainCountDownViewCloseBlock)(UleRedPacketRainViewType buttonType);

@interface UleRedPacketRainCountDownView : UIView

@property(nonatomic, copy)UleRedPacketRainCountDownViewClickBlock clickBlock;
@property(nonatomic, copy)UleRedPacketRainCountDownViewCloseBlock closeBlock;

- (instancetype) initWithFrame:(CGRect)frame withType:(UleRedPacketRainViewType)type;

- (void)startCountDownWithSecondTime:(NSTimeInterval)secondTime;

@end
