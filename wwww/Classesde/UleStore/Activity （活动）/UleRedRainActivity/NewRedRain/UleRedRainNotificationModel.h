//
//  UleRedRainNotificationModel.h
//  UleApp
//
//  Created by zemengli on 2019/8/14.
//  Copyright © 2019 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UleRedRainNotificationModel : NSObject<NSCoding>
@property (nonatomic, strong) NSString * themeCode;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, strong) NSString * ios_action;

@end

NS_ASSUME_NONNULL_END
