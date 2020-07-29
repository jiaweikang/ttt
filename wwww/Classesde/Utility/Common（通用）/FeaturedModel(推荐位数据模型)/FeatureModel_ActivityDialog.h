//
//  FeatureModel_ActivityDialog.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDialogIndexInfo : NSObject
@property (nonatomic , copy) NSString              * log_title;
@property (nonatomic , copy) NSString              * pop_type_param;
@property (nonatomic , copy) NSString              * shareCopywriting;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * c_CONF_button_img;
@property (nonatomic , copy) NSString              * listId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * button_text;
@property (nonatomic , copy) NSString              * activity_bg_image;
@property (nonatomic , copy) NSString              * close_image;
@property (nonatomic , copy) NSString              * shareImage;
@property (nonatomic , copy) NSString              * button_img;
@property (nonatomic , copy) NSString              * c_CONF_shareImage;
@property (nonatomic , copy) NSString              * c_CONF_close_image;
@property (nonatomic , copy) NSString              * shareUrl;
@property (nonatomic , copy) NSString              * max_version;
@property (nonatomic , copy) NSString              * priority;
@property (nonatomic , copy) NSString              * button_text_color;
@property (nonatomic , copy) NSString              * showProvince;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * sectionId;
@property (nonatomic , copy) NSString              * activity_time;
@property (nonatomic , copy) NSString              * button_type;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * android_action;
@property (nonatomic , copy) NSString              * activity_code;
@property (nonatomic , copy) NSString              * c_CONF_activity_bg_image;
@property (nonatomic , copy) NSString              * pop_type;
@property (nonatomic , copy) NSString              * min_version;
@property (nonatomic , copy) NSString              * ios_action;
@property (nonatomic , copy) NSString              * key;

@property (nonatomic , copy) NSString              * nowDayShowedCount;//当日已弹出展示次数 本地比较用
@end


@interface FeatureModel_ActivityDialog : NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray               * indexInfo;
@property (nonatomic , copy) NSString              * total;
@end

NS_ASSUME_NONNULL_END
