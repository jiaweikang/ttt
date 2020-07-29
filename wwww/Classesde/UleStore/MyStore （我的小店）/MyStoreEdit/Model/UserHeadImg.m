//
//  UserHeadImg.m
//  u_store
//
//  Created by 刘培壮 on 15/5/20.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "UserHeadImg.h"

@implementation UserHeadImgData
@end

@implementation UserHeadImg
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data" : [UserHeadImgData class]};
}
@end
