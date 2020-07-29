//
//  UleAudioMananger.h
//  RecorderDemo
//
//  Created by 陈竹青 on 2020/4/8.
//  Copyright © 2020 xuxiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UleAudioMananger : NSObject

- (void)startRecorderAudioWithCurrentViewController:(UIViewController *)currentViewController startStatus:(void(^) (BOOL))success;

- (void)endRecorderAudio;

- (NSString *)getRecorderAudioMp3Path;

@end

NS_ASSUME_NONNULL_END
