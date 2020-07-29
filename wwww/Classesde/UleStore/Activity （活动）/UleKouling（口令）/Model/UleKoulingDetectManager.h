//
//  UleKoulingDetectOManager.h
//  UleApp
//
//  Created by ZERO on 2019/2/20.
//  Copyright © 2019年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleKoulingData.h"

NS_ASSUME_NONNULL_BEGIN

@interface UleKoulingDetectManager : NSObject

@property (nonatomic, strong) UleKoulingData *koulingData;
@property (nonatomic, assign) BOOL isValidKouLing; //是否有有效口令
@property (nonatomic,copy) NSString *localKouLing; 

//单例方法
+ (instancetype)sharedManager;
//是否需要请求接口
- (BOOL)isNeedRequestKouling;
//检测剪贴板
- (void)detectPasteBoard;
//跳转
- (void)iosAction:(NSString *)iosActionStr;

@end

NS_ASSUME_NONNULL_END
