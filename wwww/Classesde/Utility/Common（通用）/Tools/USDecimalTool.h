//
//  USDecimalTool.h
//  UleStoreApp
//
//  Created by xulei on 2019/10/31.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

//数字处理工具类
NS_ASSUME_NONNULL_BEGIN

@interface USDecimalTool : NSObject
/**
 *加
 */
+ (NSString*)decimalAddNumberA:(NSString *)numberA
                       numberB:(NSString *)numberB;
/**
 *减
 */
+ (NSString*)decimalSubtractNumberA:(NSString *)numberA
                            numberB:(NSString *)numberB;
/**
 *乘
 */
+ (NSString*)decimalMultiplyNumberA:(NSString *)numberA
                            numberB:(NSString *)numberB;

/**
 *除
 */
+ (NSString*)decimalDivideNumberA:(NSString *)numberA
                          numberB:(NSString *)numberB;


/**
 *清除小数点后无效的"0"
 */
+ (NSString *)decimalDeleteInvalidNumber:(NSString *)string;
/**
 *截掉
 *保留小数点后num位
 */
+ (NSString *)decimalCutNumber:(NSString *)number pointNum:(NSInteger)num;

/**
 *四舍五入
 *保留小数点后num位
 */
+ (NSString *)decimalRoundNumber:(NSString *)number pointNum:(NSInteger)num;
/**
 *字符串加三位分隔符“,”
 *保留小数点后num位 截取
 */
+ (NSString *)decimalAddSignCutNumber:(NSString*)number pointNum:(NSInteger)num;

/**
 *字符串加三位分隔符“,”
 *保留小数点后num位
 */
+ (NSString *)decimalAddSignRoundNumber:(NSString*)number pointNum:(NSInteger)num;

/**
*字符串是否是整数
*/
+(BOOL)isIntegerNumber:(NSString *)number;

@end

NS_ASSUME_NONNULL_END
