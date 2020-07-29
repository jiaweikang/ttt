//
//  CalcKeyIvHelper.h
//  
//
//  Created by wangkun on 16/4/29.
//  Copyright © 2016年 wangkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalcKeyIvHelper : NSObject

@property (nonatomic, copy) NSString    *x_Emp_Key;
@property (nonatomic, copy) NSString    *x_Emp_Iv;


+ (CalcKeyIvHelper *)shared;
- (Byte *)getTheBytes:(NSString *)string;
//- (Byte *)getLoginKey:(NSString *)randomStr;
//- (Byte *)getLoginLv:(NSString *)randomStr;

//获取时间戳
+ (NSString *)getTimestamp;

//获取登录的密钥和向量
- (NSString *)getLoginKeyString:(NSString *)randomStr;
- (NSString *)getLoginLvString:(NSString *)randomStr;

//获取一般的密钥和向量，即登录接口除外的
- (NSString *)getKeyString:(NSString *)token timestamp:(NSString *)timestamp;
- (NSString *)getIvString:(NSString *)token;

@end
