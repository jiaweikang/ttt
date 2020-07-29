//
//  USScreenshotHelper.h
//  u_store
//
//  Created by xulei on 2018/7/5.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USScreenshotHelper : NSObject

+(instancetype)shared;

-(void)startMonitoring;

@end
