//
//  FeatureModel_OwnGoodsTips.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeatureModel_OwnGoodsTipsInfo : NSObject
@property (nonatomic, copy) NSString    *_id;
@property (nonatomic, copy) NSString    *imgUrl;
@property (nonatomic, copy) NSString    *sectionId;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *priority;
@property (nonatomic, copy) NSString    *link;
@property (nonatomic, copy) NSString    *key;
@end

@interface FeatureModel_OwnGoodsTips : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, copy) NSString    *total;
@property (nonatomic, strong) NSMutableArray   *indexInfo;
@end

NS_ASSUME_NONNULL_END
