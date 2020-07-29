//
//  ule_statistics.h
//  ule_statistics
//
//  Created by bobo on 13-10-8.
//  Copyright (c) 2013年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MB_LOG.h"


@interface ule_statistics : NSObject



/*
 启动App   serviceMode 0 beta   1 prd
 需要AppDelegate的以下函数中调用
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
 - (void)applicationWillEnterForeground:(UIApplication *)application;
 
 */
+(void)startAppClient:(NSString*)appKey  mode:(NSInteger)serviceMode secretkey:(NSString* ) secretkey;


/*
 结束App 或 切换至后台运行
 需要在AppDelegate的以下函数中调用
 - (void)applicationDidEnterBackground:(UIApplication *)application
 */
+(void)endAppClient;


/**
 纪录页面跳转
 obj为MB_LOG.h 相应的类对象  
 **/
+(BOOL)addLog:(id)obj;


/*根据传入的类型返回需要上传的json字符串
 */
+(NSString*)getLogStr:(id)obj;


+(void)startBeginUploadLog;
@end
