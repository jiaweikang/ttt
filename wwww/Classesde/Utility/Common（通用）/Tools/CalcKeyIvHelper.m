//
//  CalcKeyIvHelper.m
//  
//
//  Created by wangkun on 16/4/29.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import "CalcKeyIvHelper.h"

static const NSInteger kCount = 32;

@interface CalcKeyIvHelper ()
@property (nonatomic, assign) NSUInteger count;
@end

@implementation CalcKeyIvHelper

+ (CalcKeyIvHelper *)shared {
    static dispatch_once_t predicate;
    static CalcKeyIvHelper *calcKeyIvHelper = nil;
    dispatch_once(&predicate, ^{
        calcKeyIvHelper = [[CalcKeyIvHelper alloc] init];
    });
    return calcKeyIvHelper;
}

- (Byte *)getLOGIN_KEY_SEED {
    return [self getTheBytes:@"uleloginShangHaiULE"];
}

- (Byte *)getUSERID_KEY_SEED {
    return [self getTheBytes:@"ULEThis4059is010uleloginShangHai"];
}

- (Byte *)getKEY_SEED {
    return [self getTheBytes:@"whoy0556is021ULE"];
}

/**
 *  字符串转化byte数组
 */
- (Byte *)getTheBytes:(NSString *)string {
    NSData *randomData = [string dataUsingEncoding: NSUTF8StringEncoding];
    Byte *randomByte = (Byte *)[randomData bytes];
//    [self showBytes:randomByte];
    return randomByte;
}

/**
 *  获取时间戳
 */
+ (NSString *)getTimestamp {
    NSDate *m_date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval m_a=[m_date timeIntervalSince1970];
    NSString *m_time = [NSString stringWithFormat:@"%.0f",m_a];
    return m_time;
}

/**
 *  计算登录密钥
 *
 *  @param randomStr 32位随机字符串
 *
 *  @return 字节数组
 */
- (Byte *)getLoginKey:(NSString *)randomStr {
    self.count = 16;
    Byte *randomByte = [self getTheBytes:randomStr];
    
//    NSLog(@"源串..");
//    [self showBytes:randomByte];
    
    randomByte = [self swap12:randomByte];
    
//    NSLog(@"交换后..");
//    [self showBytes:randomByte];
    
    Byte *result = [self byteXOR:randomByte and:[self getLOGIN_KEY_SEED]];
    return result;
}

/**
 *  计算登录向量
 *
 *  @param randomStr 随机数
 *
 *  @return 字节数组
 */
- (Byte *)getLoginLv:(NSString *)randomStr {
    self.count = 32;
    Byte *b1 = [self getTheBytes:randomStr];
    b1 = [self swap12:b1];
    int strLength = (int)randomStr.length / 2;
    //值是token的前一半
    Byte s1[strLength];
    //值是token的后一半
    Byte s2[strLength];
    for (int i = 0; i < strLength; i ++) {
        s1[i] = b1[i];
    }
    for (int i = strLength; i < randomStr.length; i ++) {
        s2[i - strLength] = b1[i];
    }
    self.count = 16;
    Byte *result = [self byteXOR:s1 and:s2];
    return result;
}

/**
 *  计算登录密钥
 *
 *  @param randomStr 32位随机字符串
 *
 *  @return 字节数组转化生成的字符串
 */
- (NSString *)getLoginKeyString:(NSString *)randomStr {
    //改成AES128后取前16位
    NSString *pre16Str=[randomStr substringToIndex:16];
    NSString *o_key = [[NSString alloc]initWithBytes:[self getLoginKey:pre16Str]
                                              length:16
                                            encoding:NSUTF8StringEncoding];
    return o_key;
}

/**
 *  计算登录向量
 *
 *  @param randomStr 32位随机字符串
 *
 *  @return 字节数组转化生成的字符串取16位
 */
- (NSString *)getLoginLvString:(NSString *)randomStr {
    self.count = 32;
    Byte *b1 = [self getTheBytes:randomStr];
    b1 = [self swap12:b1];
    int strLength = (int)randomStr.length / 2;
    //值是token的前一半
    Byte s1[strLength];
    //值是token的后一半
    Byte s2[strLength];
    for (int i = 0; i < strLength; i ++) {
        s1[i] = b1[i];
    }
    for (int i = strLength; i < randomStr.length; i ++) {
        s2[i - strLength] = b1[i];
    }
    self.count = 16;
    Byte *result = [self byteXOR:s1 and:s2];
    NSString *IvStr = [NSString stringWithFormat:@"%s",result];
    return IvStr;
}

/**
 *  计算一般密钥
 *
 *  @param token     token即32位随机字符串
 *  @param timestamp 时间戳
 *
 *  @return 字节数组
 */
- (Byte *)getKey:(NSString *)token timestamp:(NSString *)timestamp {
    self.count = 16;
    Byte * b1 = [self getTheBytes:token];
    b1 = [self swap1234:b1];
    Byte *t1 = [self getTheBytes:timestamp];
    for (int i = 0; i < 6; i ++) {
        b1[i] = t1[timestamp.length - 2 - i];
    }
    Byte *result = [self byteXOR:b1 and:[self getKEY_SEED]];
    return result;
}

/**
 *  计算一般向量
 *
 *  @param token即32位随机字符串
 *
 *  @return 字节数组
 */
//- (Byte *)getLv:(NSString *)token {
//    self.count = 32;
//    Byte *b1 = [self getTheBytes:token];
//    b1 = [self swap1234:b1];
//    int strLength = (int)token.length / 2;
//    //值是token的前一半
//    Byte s1[strLength];
//    //值是token的后一半
//    Byte s2[strLength];
//    for (int i = 0; i < strLength; i ++) {
//        s1[i] = b1[i];
//    }
//    for (int i = strLength; i < token.length; i ++) {
//        s2[i - strLength] = b1[i];
//    }
//    self.count = 16;
//    Byte *result = [self byteXOR:s1 and:s2];
//    return result;
//}

/**
 *  计算一般密钥
 *
 *  @param token     token即32位随机字符串
 *  @param timestamp 时间戳
 *
 *  @return 字节数组转化成的字符串
 */
- (NSString *)getKeyString:(NSString *)token timestamp:(NSString *)timestamp {
    if (!token||token.length<16) {
        return @"";
    }
    NSString *pre16Str=[token substringToIndex:16];
    NSString *o_key = [[NSString alloc]initWithBytes:[self getKey:pre16Str timestamp:timestamp]
                                              length:16
                                            encoding:NSUTF8StringEncoding];
    return o_key;
}

/**
 *  计算一般向量
 *
 *  @param token token即32位随机字符串
 *
 *  @return 字节数组转化成的字符串取16位
 */
- (NSString *)getIvString:(NSString *)token {
    self.count = 32;
    Byte *b1 = [self getTheBytes:token];
    b1 = [self swap1234:b1];
    int strLength = (int)token.length / 2;
    //值是token的前一半
    Byte s1[strLength];
    //值是token的后一半
    Byte s2[strLength];
    for (int i = 0; i < strLength; i ++) {
        s1[i] = b1[i];
    }
    for (int i = strLength; i < token.length; i ++) {
        s2[i - strLength] = b1[i];
    }
    self.count = 16;
    Byte *result = [self byteXOR:s1 and:s2];
    NSString *IvStr = [NSString stringWithFormat:@"%s",result];
    if (IvStr.length > 16) {
        IvStr = [IvStr substringToIndex:16];
    }
    return IvStr;
}

/**
 *  打印字节的debug工具类
 *
 *  @param byte 字节数组
 */
- (void)showBytes:(Byte *)byte {
    
    if (byte == nil) return;
    NSMutableString *mutableStr = [NSMutableString new];
    [mutableStr appendString:@"[ "];
    for (int i = 0; i < self.count; i ++) {
        mutableStr = [NSString stringWithFormat:@"%@%hhu ",mutableStr,byte[i]].mutableCopy;
    }
    [mutableStr appendString:@"]"];
    NSLog(@"%@",mutableStr);
}

/***********交换字节位置***********/
- (Byte *)swap12:(Byte *)byte{
    if (!byte) return nil;
    for (int i = 0 ; i < self.count; i = i + 2) {
        Byte tmp = byte[i];
        byte[i] = byte[i + 1];
        byte[i + 1] = tmp;
    }
    return byte;
}

- (Byte *)swap123:(Byte *)byte {
    if (!byte) return nil;
    for (int i = 0; i < (self.count - 3); i = i + 3) {
        Byte tmp = byte[i];
        byte[i] = byte[i + 1];
        byte[i + 1] = byte[i + 2];
        byte[i + 2] = tmp;
    }
    return byte;
}

- (Byte *)swap1234:(Byte *)byte {
    if (!byte) return nil;
    for (int i = 0; i < (self.count - 4); i = i + 4) {
        Byte tmp = byte[i];
        byte[i] = byte[i + 1];
        byte[i + 1] = byte[i + 2];
        byte[i + 2] = byte[i + 3];
        byte[i + 3] = tmp;
    }
    return byte;
}

/**
 *  两个字符异或操作
 *
 *  @param byte1 字符数组1
 *  @param byte2 字符数组2
 *
 */
- (Byte *)byteXOR:(Byte *)byte1 and:(Byte *)byte2 {
    
    if (self.count != kCount) {
//        NSLog(@"%ld - %ld 两个字节数组长度不一,取短",self.count,(long)kCount);
    }
    NSUInteger len = self.count > kCount ? kCount : self.count;
    
    Byte r[len];
    Byte tmp3;
    
    for (int i = 0; i < len; i ++) {
        Byte tmp1 = byte1[i];
        Byte tmp2 = byte2[i];
        tmp3 = (Byte)(tmp1 ^ tmp2);
        r[i] = tmp3;
    }
    
    for (int i = 0; i < len; i ++) {
        int v = r[i];
        bool isTrue = (v >= 48 && v <= 57) || (v >= 65 && v <= 90) || (v >= 97 && v <= 122);
        if (!isTrue) {
            int m = 97 + abs((int)r[i]) % 25; //摸，值在0-25之间
            r[i] = (Byte)m;
//            NSLog(@" %hhu",r[i]);
        }
    }
    
    for (int i = 0; i < len; i ++) {
        byte1[i] = r[i];
    }
    return byte1;
}

/**
 *  获取随机字符串
 *
 *  @param length 随机字符串的位数
 *
 *  @return 生成的随机字符串
 */
- (NSString *)getRandomStr:(int)length {
    int maxNum = 62;
    int i;         //生成的随机数
    int count = 0; //生成的密码的长度
    char str[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
        'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C',
        'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
        'X', 'Y', 'Z'};
    NSMutableString *mutableStr = [NSMutableString new];
    while (count < length) {
        i = arc4random() % maxNum;
        if (i >= 0 && i < 62) {
            [mutableStr appendString:[NSString stringWithFormat:@"%c",str[i]]];
            count ++;
        }
    }
    return mutableStr;
}

@end
