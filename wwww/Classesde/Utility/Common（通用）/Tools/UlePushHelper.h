//
//  UlePushHelper.h
//  u_store
//
//  Created by wangkun on 16/5/25.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UlePushHelper : NSObject

@property (nonatomic, strong) NSDictionary *pushInfo;//push跳转
@property (nonatomic, strong) NSDictionary *pushAlertInfo;//显示push弹框
@property (nonatomic, assign) BOOL showPushAlert;//推送弹框
//@property (nonatomic, assign) BOOL showVersionUpdateAlert;//版本更新弹框
@property (nonatomic, strong) NSString  *msgInfo;//短信链接

+ (UlePushHelper *)shared;

- (void)handleRemoteNotification:(NSDictionary *)userInfo;

- (void)handlePushAction:(NSDictionary *)userInfo;

- (void)handlePushParams:(NSString *)context alertStr:(NSString *)alertStr;


@end
