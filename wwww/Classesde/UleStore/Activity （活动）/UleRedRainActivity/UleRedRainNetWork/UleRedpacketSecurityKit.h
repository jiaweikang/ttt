//
//  UleRedpacketSecurityKit.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UleRedpacketSecurityKit : NSObject
+ (NSData *)RD_EncryptWithData:(NSData *)data WithM1:(NSString *)m1 withM2:(const void *)m2;
+ (NSString *)RD_EncodeHash:(NSString *)key text:(NSString *)text;
@end
