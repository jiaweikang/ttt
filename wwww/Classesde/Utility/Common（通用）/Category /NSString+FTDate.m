//
//  NSString+FTDate.m
//  PostLifePodDemo
//
//  Created by zemengli on 2018/1/16.
//  Copyright © 2018年 zemengli. All rights reserved.
//

#import "NSString+FTDate.h"

@implementation NSString (FTDate)
+ (NSString *)stringToDate:(NSString *)input OldDateFormat:(NSString *)oldDate NewDateFormat:(NSString *)newDate
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init] ;
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [inputFormatter setDateFormat:oldDate];
    NSDate* inputDate = [inputFormatter dateFromString:input];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init] ;
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:newDate];
    NSString *str = [outputFormatter stringFromDate:inputDate];
    
    return str;
}


//日期转字符串格式4
+(NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString *) _format{
    //得到毫秒
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:_format];//@"yyyy-MM-dd hh:mm:ss"
    //NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
    NSString *currentdt = [dateFormatter stringFromDate:date];
    return currentdt;
}

// 根据字符串格式 NSDate
- (NSDate *)dateFromFormat:(NSString *)formatString
{
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    [inputFormatter setDateFormat:formatString];
    NSDate* inputDate = [inputFormatter dateFromString:self];
    return inputDate;
}

+ (NSString *)dateWithStartDay:(NSDate *)startDate endDay:(NSDate *)endDate
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //当前时间
    NSDate *senderDate = [dateFormatter dateFromString:[dateFormatter stringFromDate:startDate]];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:senderDate];
    int days = ((int)time)/(3600*24);
    return [NSString stringWithFormat:@"%d",days];
}
@end
