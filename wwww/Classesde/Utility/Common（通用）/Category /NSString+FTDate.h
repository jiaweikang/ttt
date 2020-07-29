//
//  NSString+FTDate.h
//  PostLifePodDemo
//
//  Created by zemengli on 2018/1/16.
//  Copyright © 2018年 zemengli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FTDate)
/**
 将NSString类型日期值转换为指定格式日期类型值
 @param input 字符串
 @param oldDate 原日期格式
 @param newDate 新日期格式
 @returns   返回新字符串
 */
+ (NSString *)stringToDate:(NSString *)input OldDateFormat:(NSString *)oldDate NewDateFormat:(NSString *)newDate;

/***    转化为时间格式         ***/
+(NSString*)dateToStringWithFormat:(NSDate*)date format:(NSString *) _format;

// 根据字符串格式 NSDate
- (NSDate *)dateFromFormat:(NSString *)formatString;
// 计算两个时间的日期差
+ (NSString *)dateWithStartDay:(NSDate *)startDate endDay:(NSDate *)endDate;


@end
