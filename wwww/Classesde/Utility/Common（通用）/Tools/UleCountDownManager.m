//
//  UleCountDownManager.m
//  UleApp
//
//  Created by zemengli on 2017/7/19.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleCountDownManager.h"
#import "UleDateFormatter.h"
#import "NSString+FTDate.h"
#import "UleGetTimeTool.h"
#import "US_Api.h"
//@implementation SystemTimeObject
//@end

@interface UleCountDownManager ()

@property (nonatomic, strong) NSTimer * countDownTime;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) NSString * endTime;
@end

@implementation UleCountDownManager

+ (instancetype)shareInstanceWithDelegate:(id)delegate {
    static dispatch_once_t onceToken;
    static UleCountDownManager * manager=nil;
    dispatch_once(&onceToken, ^{
        manager=[[UleCountDownManager alloc] init];
    });
    manager.delegate = delegate;
    return manager;
//    self= [super init];
//    if (self) {
//        self.delegate = delegate;
//    }
//    return self;
}

-(void) countDownWithCurrentTime:(NSString *)currentTime WithEndTime:(NSString *)endTime{
    self.endTime = endTime;
    NSTimeInterval serverTimer=currentTime.longLongValue;
    NSTimeInterval endDateInterval = self.endTime.longLongValue;
    if (endDateInterval > serverTimer) {
        
        _timeInterval=(endDateInterval-serverTimer)/1000;
        
        [self startTime];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(closeTime)
                                                     name:@"CloseTimeNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshSeckillData) name:@"updataCountDownTime"
                                                   object:nil];
        
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(UleCountDownEnd)]) {
            [self.delegate UleCountDownEnd];
        }
    }
}
- (void)startTime{
    NSLog(@"startTime");
    [self closeTime];
    _timeInterval++;//因为nstime是马上执行，所以要自增1秒
    self.countDownTime=[NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(timeFunction)
                                                      userInfo:nil
                                                       repeats:true];
    
    [self.countDownTime fire];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTime   forMode:NSRunLoopCommonModes];
}

- (void)timeFunction{
    _timeInterval--;
    //NSLog(@"_timeInterval:%f",_timeInterval);
    if (_timeInterval <= 0) {
        [self closeTime];
        if (self.delegate && [self.delegate respondsToSelector:@selector(UleCountDownEnd)]) {
            [self.delegate UleCountDownEnd];
        }
    }
    
    if (_timeInterval >= 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(countDownString:)]) {
            [self.delegate countDownString:[self timeFormatted:_timeInterval]];
        }
    }
}

-(void) refreshSeckillData{
    NSLog(@"refreshSeckillData");
    NSTimeInterval interval=[[[NSUserDefaults standardUserDefaults]
                              objectForKey:@"Vi_TimeInterval"] doubleValue];
    NSTimeInterval serverTimer=[UleGetTimeTool getLocalTime]+interval;
    NSTimeInterval endDateInterval = self.endTime.longLongValue;
    if (endDateInterval > serverTimer) {
        _timeInterval=(endDateInterval-serverTimer)/1000;
        [self  startTime];
        
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(UleCountDownEnd)]) {
            [self.delegate UleCountDownEnd];
        }
    }
}

- (void)closeTime{
    if (self.countDownTime.isValid) {
        [self.countDownTime invalidate];
        self.countDownTime=nil;
    }
}

- (void)closeTimeAndRemoveObserver{
    [self closeTime];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

//判断截止时间是否有效
- (BOOL)computeEndTimeEffective:(NSString *)endtime{
    if (endtime.length <= 0) {
        return NO;
    }
    NSTimeInterval interval=[[[NSUserDefaults standardUserDefaults]
                              objectForKey:@"Vi_TimeInterval"] doubleValue];
    NSTimeInterval serverTimer=[UleGetTimeTool getLocalTime]+interval;
    NSTimeInterval endDateInterval = endtime.longLongValue;
    if (endDateInterval > serverTimer) {
        return YES;
    }
    else{
        return NO;
    }
}

- (void)dealloc{
    [self closeTime];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
}

@end
