//
//  UleRedPacketRainActivityInfo.m
//  UleApp
//
//  Created by zemengli on 2018/8/3.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleRedPacketRainActivityInfo.h"
@implementation RedRainTheme
@end


@implementation RedRainThemes
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"themes" : [RedRainTheme class]};
}
@end


@implementation RedRainFieldInfo

@end


@implementation RedRainActivityInfoContent
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"fieldInfos" : [RedRainFieldInfo class]};
}
@end


@implementation UleRedPacketRainActivityInfo
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"content" : [RedRainActivityInfoContent class]};
}
@end
