//
//  USApplicationLaunchApi.h
//  UleStoreApp
//
//  Created by xulei on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UleRequest.h>
#import "US_NetworkExcuteManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface USApplicationLaunchApi : NSObject

/**
 *  请求用户信息
 **/
+ (UleRequest *)buildRequestUserInfo;

/**
 *  请求广告页
 **/
+ (UleRequest *)buildRequestAdvertise;

/**
 *  请求tabbar推荐位
 **/
+ (UleRequest *)buildRequestTabbar;

/**
 *  请求首页活动a弹框
 **/
+ (UleRequest *)buildRequestHomeActivityDialog;

/**
 *  请求推荐人信息
 **/
+ (UleRequest *)buildGetReferrerInfoRequest;

/**
 * 上次launch信息，（单独接口）
 */
+ (UleRequest *)buildUploadLanchInfoRequest;

/**
 * 推送注册
 */
+ (UleRequest *)buildPushRegist;

/**
 * 推送点击请求
 */
+ (UleRequest *)buildPushMsgClickRequestWithBatchId:(NSString *)batchId;

/**
 * 请求服务器时间
 */
+ (UleRequest *)buildServerTimeRequest;
@end

NS_ASSUME_NONNULL_END
