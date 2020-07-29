//
//  FeatureModel_GIFRefresh.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GIFRefreshIndexInfo : NSObject

@property (nonatomic, copy) NSString *min_version;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl; ////首页下拉919红包雨背景图
@property (nonatomic, copy) NSString *C_CONF_imageUrl;
@property (nonatomic, copy) NSString *refreshModel;
@property (nonatomic, copy) NSString *max_version;
@property (nonatomic, copy) NSString *android_action;
@property (nonatomic, copy) NSString *imageUrl; //首页下拉919红包雨动图
@property (nonatomic, copy) NSString *ios_action;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *logtitle;
@property (nonatomic, copy) NSString *key;

@end

@interface FeatureModel_GIFRefresh : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray *indexInfo;
@end

NS_ASSUME_NONNULL_END
