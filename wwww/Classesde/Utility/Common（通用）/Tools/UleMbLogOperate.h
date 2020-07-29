//
//  UleMbLogOperate.h
//  UleApp
//
//  Created by chenzhuqing on 2017/2/24.
//  Copyright © 2017年 ule. All rights reserved.
//
// 注：该文件用于日志统计，修改时，需要同时修改网络请求pod，以及支付SDk中的相同文件，
#import <Foundation/Foundation.h>
#import "ule_statistics.h"
@interface UleMbLogOperate : NSObject
//添加Launch表
+ (void)addMBLogLaunchList;
//添加Device表b
+ (void)addMBLogDeviceList;

+ (void)addOperateList:(NSString *)viewPage andPreViewPage:(NSString *)preViewPage;

+ (void)addMbLogClick:(NSString*) params
              moduleid:(NSString*) moduleId
            moduledesc:(NSString*) moduleDesc
         networkdetail:(NSString*) networkDetail;

+ (void)addMbLogAction:(NSString *) actionType
             actionName:(NSString *) actionName
                 params:(NSString *) params
            consumeTime:(NSString *)time
          networkdetail:(NSString*) networkDetail;


@end
