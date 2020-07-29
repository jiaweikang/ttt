//
//  USDecimalTool.m
//  UleStoreApp
//
//  Created by xulei on 2019/10/31.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "USDecimalTool.h"

@implementation USDecimalTool
/**
 *加
 */
+ (NSString*)decimalAddNumberA:(NSString *)numberA
                       numberB:(NSString *)numberB
{
    if(numberA.length<=0){
        numberA = @"0";
    }
    if(numberB.length<=0){
        numberB = @"0";
    }
    NSDecimal decimalNumA = [[NSDecimalNumber decimalNumberWithString:numberA] decimalValue];
    NSDecimal decimalNumB = [[NSDecimalNumber decimalNumberWithString:numberB] decimalValue];
    NSLocale *locale = [NSLocale currentLocale];
    NSDecimal result;
    NSDecimalAdd(&result, &decimalNumA, &decimalNumB, NSRoundPlain);
    return NSDecimalString(&result, locale);
}

/**
 *减
 */
+ (NSString*)decimalSubtractNumberA:(NSString *)numberA
                            numberB:(NSString *)numberB
{
    if(numberA.length<=0){
        numberA = @"0";
    }
    if(numberB.length<=0){
        numberB = @"0";
    }
    NSDecimal decimalNumA = [[NSDecimalNumber decimalNumberWithString:numberA] decimalValue];
    NSDecimal decimalNumB = [[NSDecimalNumber decimalNumberWithString:numberB] decimalValue];
    NSLocale *locale = [NSLocale currentLocale];
    NSDecimal result;
    NSDecimalSubtract(&result, &decimalNumA, &decimalNumB, NSRoundPlain);
    return NSDecimalString(&result, locale);
}

/**
 *乘
 */
+ (NSString*)decimalMultiplyNumberA:(NSString *)numberA
                            numberB:(NSString *)numberB
{
    if(numberA.length<=0){
        numberA = @"0";
    }
    if(numberB.length<=0){
        numberB = @"0";
    }
    NSDecimal decimalNumA = [[NSDecimalNumber decimalNumberWithString:numberA] decimalValue];
    NSDecimal decimalNumB = [[NSDecimalNumber decimalNumberWithString:numberB] decimalValue];
    NSLocale *locale = [NSLocale currentLocale];
    NSDecimal result;
    NSDecimalMultiply(&result, &decimalNumA, &decimalNumB, NSRoundPlain);
    return NSDecimalString(&result, locale);
}

/**
 *除
 */
+ (NSString*)decimalDivideNumberA:(NSString *)numberA
                          numberB:(NSString *)numberB
{
    if(numberA.length<=0){
        numberA = @"0";
    }
    NSDecimal decimalNumA = [[NSDecimalNumber decimalNumberWithString:numberA] decimalValue];
    NSDecimal decimalNumB = [[NSDecimalNumber decimalNumberWithString:numberB] decimalValue];
    NSLocale *locale = [NSLocale currentLocale];
    NSDecimal result;
    NSDecimalDivide(&result, &decimalNumA, &decimalNumB, NSRoundPlain);
    return NSDecimalString(&result, locale);
}


+ (NSString *)decimalDeleteInvalidNumber:(NSString *)string;
{
    if ([string rangeOfString:@"."].location ==NSNotFound) {
        return string;
    }
    NSString * s = nil;
    NSInteger offset = string.length - 1;
    while (offset)
    {
        s = [string substringWithRange:NSMakeRange(offset, 1)];
        if ([s isEqualToString:@"0"])
        {
            offset--;
        }else if([s isEqualToString:@"."]){
            offset--;
            break;
        }else{
            break;
        }
    }
    NSString * outNumber = [string substringToIndex:offset+1];
    NSLog(@"%@", outNumber);
    return outNumber;
}
+ (NSString *)decimalAddPointNumber:(NSString *)number pointNum:(NSInteger)num
{
    if (num==0)
        return number;
    
    NSString *point;
    NSString *money;
    
    NSArray * numberArray = [number componentsSeparatedByString:@"."];
    if (numberArray.count>=2) {
        point =numberArray[1];
        money =numberArray[0];
    }else{
        point = @"";
        money = number;
    }
    
    if (point.length==num) {
        return number;
    }
    
    while (point.length<num) {
        point = [NSString stringWithFormat:@"%@0",point];
    }
    if (num>0) {
        money =[NSString stringWithFormat:@"%@.%@",money,point];
    }
    return  money;
}

/**
 *截掉   保留小数点后num位
 */
+ (NSString *)decimalCutNumber:(NSString *)number pointNum:(NSInteger)num;
{
    NSRoundingMode roundMode = NSRoundDown;
    if(number.floatValue<0) {
        roundMode = NSRoundUp;
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundMode
                                                                                                      scale:num
                                                                                           raiseOnExactness:YES
                                                                                            raiseOnOverflow:YES
                                                                                           raiseOnUnderflow:YES
                                                                                        raiseOnDivideByZero:YES];
    NSDecimalNumber *ouncesDecimal = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * cutString =[NSString stringWithFormat:@"%@",roundedOunces];
    cutString = [USDecimalTool decimalAddPointNumber:cutString pointNum:num];
    return cutString;
}

/**
 *四舍五入  保留小数点后num位
 */
+ (NSString *)decimalRoundNumber:(NSString *)number pointNum:(NSInteger)num;
{
    
    if(number.length<=0){
        number = @"0";
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                                      scale:num
                                                                                           raiseOnExactness:NO
                                                                                            raiseOnOverflow:NO
                                                                                           raiseOnUnderflow:NO
                                                                                        raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal = [NSDecimalNumber decimalNumberWithString:number];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString * cutString =[NSString stringWithFormat:@"%@",roundedOunces];
    cutString = [USDecimalTool decimalAddPointNumber:cutString pointNum:num];
    return cutString;

}

/**
 *字符串加三位分隔符  “,” 保留小数点后num位 截取
 */
+ (NSString *)decimalAddSignCutNumber:(NSString*)number pointNum:(NSInteger)num;
{
    NSString * cutNumber = [USDecimalTool decimalCutNumber:number pointNum:num];
    NSString *point;
    NSString *money;
    
    if (num==0) {
        point = @"";
        money = cutNumber;
        
    }else{
        if (cutNumber.doubleValue ==0) {
            cutNumber = @"0.00";
            return cutNumber;
        }
        point =[cutNumber substringFromIndex:cutNumber.length-num-1];
        money =[cutNumber substringToIndex:cutNumber.length-num-1];
    }
    return [[USDecimalTool decimalCountNumChangeformat:money] stringByAppendingString:point];
}



/**
 *字符串加三位分隔符  “,” 保留小数点后num位 四舍五入
 */
+ (NSString *)decimalAddSignRoundNumber:(NSString*)number pointNum:(NSInteger)num;
{
    NSString * roundNumber = [USDecimalTool decimalRoundNumber:number pointNum:num];
    NSString *point;
    NSString *money;

    if (num==0) {
        point = @"";
        money = roundNumber;
    
    }else{
        if (roundNumber.doubleValue ==0) {
            roundNumber = @"0.00";
            return roundNumber;
        }
        point =[roundNumber substringFromIndex:roundNumber.length-num-1];
        money =[roundNumber substringToIndex:roundNumber.length-num-1];
    }
    return [[USDecimalTool decimalCountNumChangeformat:money] stringByAppendingString:point];
}

#pragma mark 金额加‘，’
//传入整数类型的数值
+(NSString *)decimalCountNumChangeformat:(NSString *)num
{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3)
    {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

+(BOOL)isIntegerNumber:(NSString *)number {
    if (number.length<=0) {
        number=@"0";
    }
    NSDecimalNumber *decimalNumber=[[NSDecimalNumber alloc]initWithString:number];
    NSDecimal value = [decimalNumber decimalValue];
    if (NSDecimalIsNotANumber(&value)) return NO;
    NSDecimal rounded;
    NSDecimalRound(&rounded, &value, 0, NSRoundPlain);
    return NSDecimalCompare(&rounded, &value) == NSOrderedSame;
}
@end
