//
//  OwnGoodsDetailManager.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OwnGoodsDetailManager : NSObject

@property (nonatomic, strong) UIViewController *rootVC;

+ (instancetype)shareManager;
- (void)withDrawAction;

@end

NS_ASSUME_NONNULL_END
