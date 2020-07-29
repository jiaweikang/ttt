//
//  FeatureModel_HomeBanner.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBannerIndexInfo : NSObject
@property (nonatomic, copy) NSString *min_version;
@property (nonatomic, copy) NSString *wh_rate;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *titlecolor;
@property (nonatomic, copy) NSString *device_type;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *listingId;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *log_title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *max_version;
@property (nonatomic, copy) NSString *groupsort;
@property (nonatomic, copy) NSString *android_action;
@property (nonatomic, copy) NSString *ios_action;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *sales_volume;
@property (nonatomic, copy) NSString *background_url;
@property (nonatomic, copy) NSString *background_url_new;//20191022新增
@property (nonatomic, copy) NSString *drag_position;//20200114
/*气泡 20200109*/
@property (nonatomic, copy) NSString *bubble_backImg;
@property (nonatomic, copy) NSString *bubble_title;
@property (nonatomic, copy) NSString *bubble_titleColor;

@property (nonatomic, assign) BOOL isImgLoaded;//非接口返回参数
@end

@interface FeatureModel_HomeBanner : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSMutableArray *indexInfo;
@end

NS_ASSUME_NONNULL_END
