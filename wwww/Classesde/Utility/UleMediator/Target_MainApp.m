//
//  Target_MainApp.m
//  Demo
//
//  Created by chenzhuqing on 2018/1/9.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "Target_MainApp.h"
#import <CoreLocation/CoreLocation.h>
#import "UleMediatorManager+MainApp.h"
#import "UleMbLogOperate.h"

@implementation Target_MainApp

- (id) Action_saveOperationLog:(NSMutableDictionary *)dic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [UleMbLogOperate addOperateList:dic[@"toVC"] andPreViewPage:dic[@"fromVC"]];
    });
    return nil;
}



@end
