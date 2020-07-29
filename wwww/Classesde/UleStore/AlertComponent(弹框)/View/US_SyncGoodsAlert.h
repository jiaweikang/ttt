//
//  US_SyncGoodsAlert.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+ShowAnimation.h>

typedef NS_ENUM(NSUInteger, US_SyncGoodsAlertType){
    US_SyncGoodsAlertTypeSuccess,
    US_SyncGoodsAlertTypeFail
};

typedef void(^SyncAlertBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface US_SyncGoodsAlert : UIView

+ (US_SyncGoodsAlert *)alertWithType:(US_SyncGoodsAlertType)type clickBlock:(__nullable SyncAlertBlock) click;
@end

NS_ASSUME_NONNULL_END
