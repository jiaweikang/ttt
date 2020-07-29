//
//  UleGetTimeTool.m
//  UleApp
//
//  Created by zemengli on 2018/8/5.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleGetTimeTool.h"

@implementation UleGetTimeTool
#pragma 时间处理
//本地当前时间
+ (NSTimeInterval)getLocalTime{
    
    NSDate *  localDate=[NSDate date];
    NSTimeInterval localInterval=[localDate timeIntervalSince1970]*1000;
    return localInterval;
}

//获得服务器时间
 +(NSTimeInterval) getServerTime{
     NSTimeInterval currentTimeInterVal;
     NSString * timeStr = [[NSUserDefaults standardUserDefaults]
                       objectForKey:@"Vi_TimeInterval"];
     NSTimeInterval interval=[timeStr doubleValue];
     if (timeStr) {
         currentTimeInterVal=[UleGetTimeTool getLocalTime]+interval;
     }
     else{
         currentTimeInterVal=[UleGetTimeTool getLocalTime];
     }
     return currentTimeInterVal;
 }

//计算倒计时时间
+ (NSTimeInterval)computeActivitiesTime:(NSTimeInterval)serverTime startTime:(NSTimeInterval) start endTime:(NSTimeInterval) end{
    NSTimeInterval interverTime;
    if(serverTime>=end){//活动结束
        interverTime=-1;
    }
    else if (serverTime>=start) {//活动已开始
        
        interverTime=(end-serverTime)/1000;
        
    }
    else{//活动未开始
        
        interverTime=(start-serverTime)/1000;
        
    }
    return interverTime;
}
@end
