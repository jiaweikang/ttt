//
//  DESCrypt.m
//  ule_statistics
//
//  Created by lizemeng on 14-7-25.
//  Copyright (c) 2014年 ule. All rights reserved.
//

#import "DESCrypt.h"
#import <NSData+Base64.h>

#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
//static Byte Iv[16]={13, 8, 3, 16, 23, 6, 11, 5};
@implementation DESCrypt
//加密方法encryptUseDES:key:如下
//参考http://www.2cto.com/kf/201304/205511.html
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString*)key iV:(NSData*) Bytes

{
    
    Byte * iv=(Byte *)[Bytes bytes];
    
    NSString *ciphertext =nil;
    
    NSData* data=[plainText dataUsingEncoding: NSUTF8StringEncoding];
    

    NSUInteger bufferSize=([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    
    char buffer[bufferSize];
    
    memset(buffer, 0,sizeof(buffer));
    
    size_t bufferNumBytes;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding,
                                          
                                          [key UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          iv   ,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &bufferNumBytes);
    
    
    
    if (cryptStatus ==kCCSuccess) {
        
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
        
        ciphertext = [data base64EncodedString];
    }

    
    return ciphertext;
    
}

//解密方法decryptUseDES:key:如下

+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key iV:(NSData*) Bytes

{
    Byte * iv=(Byte *)[Bytes bytes];
    
    NSData* data = [NSData base64DataFromString:cipherText];
    
    NSUInteger bufferSize=([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    
    char buffer[bufferSize];
    
    memset(buffer, 0,sizeof(buffer));
    
    size_t bufferNumBytes;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding,
                                          
                                          [key UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          iv,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &bufferNumBytes);
    
    NSString* plainText = nil;

    if (cryptStatus ==kCCSuccess) {
        
        NSData *plainData =[NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];

        plainText = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];

    }
    
    return plainText;
    
}
@end
