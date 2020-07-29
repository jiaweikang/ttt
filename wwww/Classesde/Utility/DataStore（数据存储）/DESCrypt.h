//
//  DESCrypt.h
//  ule_statistics
//
//  Created by lizemeng on 14-7-25.
//  Copyright (c) 2014年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESCrypt : NSObject
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString*)key iV:(NSData*) Bytes;
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key iV:(NSData*) Bytes;
@end
