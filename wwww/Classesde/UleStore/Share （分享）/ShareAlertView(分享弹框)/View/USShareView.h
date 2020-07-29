//
//  USShareView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/11.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USShareModel.h"
#import <UleShareSDK/Ule_ShareView.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^USShareViewBlock)(id response);

@interface USShareView : UIView

+ (instancetype) shareInstance;

+ (void)shareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack;

+ (void)insuranceShareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack;

+ (void)fenxiaoShareWithModel:(USShareModel *)shareModel success:(USShareViewBlock)shareCallBack;

// 分享注册
+ (void)registWeChatForAppKey:(NSString *)appKey;

@end

NS_ASSUME_NONNULL_END
