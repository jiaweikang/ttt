//
//  FeaturedModel_UserCenter.h
//  u_store
//
//  Created by mac_chen on 2019/4/22.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeaturedModel_UserCenterIndex :NSObject
@property (nonatomic , copy) NSString              * api;
@property (nonatomic , copy) NSString              * android_action;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * maxversion;
@property (nonatomic , copy) NSString              * ios_action;
@property (nonatomic , copy) NSString              * minversion;
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * priority;
@property (nonatomic , copy) NSString              * sectionId;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * imgurl2;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * groupsort;
@property (nonatomic , copy) NSString              * functionId;
@property (nonatomic , copy) NSString              * showProvince;
@property (nonatomic , copy) NSString              * devicetype;
@property (nonatomic , copy) NSString              * needlogin;
@property (nonatomic , copy) NSString              * showbadge;
@property (nonatomic , copy) NSString              * newfunction;
@property (nonatomic , copy) NSString              * groupid;

@property (nonatomic , copy) NSString              * wh_rate;
@property (nonatomic , copy) NSString              * sub_title;
@property (nonatomic , copy) NSString              * statistics_flag;
@property (nonatomic , copy) NSString              * log_title;

@end

@interface FeaturedModel_UserCenter : NSObject

@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSString              * total;
@property (nonatomic , strong) NSMutableArray      * indexInfo;

@end

NS_ASSUME_NONNULL_END
