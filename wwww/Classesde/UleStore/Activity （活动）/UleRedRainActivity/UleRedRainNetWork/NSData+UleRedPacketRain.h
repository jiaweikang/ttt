//
//  NSData+UleRedPacketRain.h
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const Iv_key_16;
UIKIT_EXTERN const Byte Iv_1_16[16];


@interface NSData (UleRedPacketRain)
- (NSData *) RD_AES128EncryptWithKey:(NSString *)key withIv:(const void *)bytes;
+ (NSString*) RD_encode:(const uint8_t*) input length:(NSInteger) length;
+ (NSString*) RD_encode:(NSData*) rawBytes;
@end
