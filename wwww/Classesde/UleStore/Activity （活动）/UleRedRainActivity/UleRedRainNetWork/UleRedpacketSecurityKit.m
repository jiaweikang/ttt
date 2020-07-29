//
//  UleRedpacketSecurityKit.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleRedpacketSecurityKit.h"
#import "NSData+UleRedPacketRain.h"
#include <CommonCrypto/CommonCrypto.h>

@implementation UleRedpacketSecurityKit

+ (NSData *)RD_EncryptWithData:(NSData *)data WithM1:(NSString *)m1 withM2:(const void *)m2{
    return [data RD_AES128EncryptWithKey:m1 withIv:m2];;
}

+ (NSString *)RD_EncodeHash:(NSString *)key text:(NSString *)text{
    
    NSData* secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* stringData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* keyBytes = [secretData bytes];
    const void* dataBytes = [stringData bytes];
    
    ///#define CC_SHA1_DIGEST_LENGTH   20          /* digest length in bytes */
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, keyBytes, [secretData length], dataBytes, [stringData length], outs);
    
    // Soluion 1
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    
    return [NSData RD_encode:signatureData];;
}
@end
