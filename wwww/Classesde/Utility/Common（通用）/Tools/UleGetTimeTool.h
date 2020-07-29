//
//  UleGetTimeTool.h
//  UleApp
//
//  Created by zemengli on 2018/8/5.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UleGetTimeTool : NSObject
//本地当前时间
+ (NSTimeInterval)getLocalTime;

+(NSTimeInterval) getServerTime;

//计算倒计时时间
+ (NSTimeInterval)computeActivitiesTime:(NSTimeInterval)serverTime startTime:(NSTimeInterval) start endTime:(NSTimeInterval) end;
@end
