//
//  USKeychainLocalData.h
//  UleStoreApp
//
//  Created by xulei on 2019/5/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USKeychainLocalData : NSObject

+ (instancetype)data;

/***** 语音播报 *****/
@property (nonatomic, assign) BOOL isVoicePromptOn;
@property (nonatomic, strong) NSString *usrOnlyid;

@end

NS_ASSUME_NONNULL_END
