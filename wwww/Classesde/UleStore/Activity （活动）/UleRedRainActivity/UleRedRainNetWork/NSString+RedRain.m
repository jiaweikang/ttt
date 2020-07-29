//
//  NSString+RedRain.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/8/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "NSString+RedRain.h"

@implementation NSString (RedRain)
- (NSString*) RD_UrlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    if(!encodedString)
        encodedString = @"";
    return encodedString;
}
@end
