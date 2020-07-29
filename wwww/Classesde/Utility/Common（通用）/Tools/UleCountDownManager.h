//
//  UleCountDownManager.h
//  UleApp
//
//  Created by zemengli on 2017/7/19.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "JSONModel.h"
//@interface SystemTimeObject : JSONModel
//@property (nonatomic,copy) NSString * returnCode;
//@property (nonatomic,copy) NSString * returnMessage;
//@property (nonatomic,copy) NSString * sysTime;
//@end

@protocol UleCountDownEndDelegate <NSObject>

- (void)UleCountDownEnd;
- (void)countDownString:(NSString *)text;

@end

@interface UleCountDownManager : NSObject

+ (instancetype)shareInstanceWithDelegate:(id)delegate;
//调用本方法的页面在 viewWillDisappear要调用下closeTimeAndRemoveObserver
-(void) countDownWithCurrentTime:(NSString *)currentTime WithEndTime:(NSString *)endTime;
- (void)closeTimeAndRemoveObserver;

//判断截止时间是否有效
- (BOOL)computeEndTimeEffective:(NSString *)endtime;

@property (assign, nonatomic)id <UleCountDownEndDelegate> delegate;
@end
