//
//  FeaturedModel_OrderPre.h
//  u_store
//
//  Created by xulei on 2019/6/28.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeaturedModel_OrderPreIndex :NSObject
@property (nonatomic , copy) NSString              * log_title;
@property (nonatomic , copy) NSString              * need_login;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * is_new;
@property (nonatomic , copy) NSString              * banner_key;
@property (nonatomic , copy) NSString              * groupid;
@property (nonatomic , copy) NSString              * activity_zone;
@property (nonatomic , copy) NSString              * groupsort;
@property (nonatomic , copy) NSString              * max_version;
@property (nonatomic , copy) NSString              * priority;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * sectionId;
@property (nonatomic , copy) NSString              * authorization;
@property (nonatomic , copy) NSString              * titlecolor;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * android_action;
@property (nonatomic , copy) NSString              * wh_rate;
@property (nonatomic , copy) NSString              * min_version;
@property (nonatomic , copy) NSString              * device_type;
@property (nonatomic , copy) NSString              * default_function;
@property (nonatomic , copy) NSString              * ios_action;
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * showProvince;

@end

@interface FeaturedModel_OrderPre : NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSMutableArray<FeaturedModel_OrderPreIndex *>              * indexInfo;
@property (nonatomic , copy) NSString              * total;

@end

NS_ASSUME_NONNULL_END
