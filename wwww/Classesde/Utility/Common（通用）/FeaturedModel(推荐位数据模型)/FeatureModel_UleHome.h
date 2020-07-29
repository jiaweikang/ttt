//
//  FeatureModel_UleHome.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 首页推荐位 */
@interface UleIndexInfo : NSObject

@property (nonatomic, copy) NSString *ios_action;
@property (nonatomic, copy) NSString *maxversion;
@property (nonatomic, copy) NSString *wh_rate;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *logtitle;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *mid;
@property (nonatomic, copy) NSString *groupsort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *needlogin;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *api;
@property (nonatomic, copy) NSString *minversion;
@property (nonatomic, copy) NSString *showbadge;
@property (nonatomic, copy) NSString *devicetype;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *android_action;
@property (nonatomic, copy) NSString *imgurl2;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *attribute1;
@property (nonatomic, copy) NSString *attribute2;
@property (nonatomic, copy) NSString *attribute3;
@property (nonatomic, copy) NSString *attribute4;
@property (nonatomic, copy) NSString *attribute5;
@property (nonatomic, copy) NSString *attribute6;
@property (nonatomic, copy) NSString *attribute7;
@property (nonatomic, copy) NSString *attribute8;
@property (nonatomic, copy) NSString *imgHeight;
@property (nonatomic, copy) NSString *isPiont;
@property (nonatomic, copy) NSString *change_attri;
//tabBar
@property (nonatomic, copy) NSString *normal_text;
@property (nonatomic, copy) NSString *select_text;
@property (nonatomic, copy) NSString *normal_icon;
@property (nonatomic, copy) NSString *select_icon;
@property (nonatomic, copy) NSString *position_type;
//评价商品 标签
@property (nonatomic, copy) NSString *label_text;
@property (nonatomic, copy) NSString *default_text;
@end


@interface FeatureModel_UleHome : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray <UleIndexInfo *> *indexInfo;

@end

NS_ASSUME_NONNULL_END
