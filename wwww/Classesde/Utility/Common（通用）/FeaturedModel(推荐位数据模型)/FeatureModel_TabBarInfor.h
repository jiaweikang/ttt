//
//  FeatureModel_TabBarInfor.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabbarIndexInfo : NSObject
@property (nonatomic, copy) NSString    *maxversion;
@property (nonatomic, copy) NSString    *link;
@property (nonatomic, copy) NSString    *normal_text_color;
@property (nonatomic, copy) NSString    *C_CONF_normal_icon;
@property (nonatomic, copy) NSString    *sectionId;
@property (nonatomic, copy) NSString    *select_text_color;
@property (nonatomic, copy) NSString    *minversion;
@property (nonatomic, copy) NSString    *priority;
@property (nonatomic, copy) NSString    *title;
@property (nonatomic, copy) NSString    *needlogin;
@property (nonatomic, copy) NSString    *select_icon;
@property (nonatomic, copy) NSString    *devicetype;
@property (nonatomic, copy) NSString    *imgUrl;
@property (nonatomic, copy) NSString    *android_action;
@property (nonatomic, copy) NSString    *ios_action;
@property (nonatomic, copy) NSString    *_id;
@property (nonatomic, copy) NSString    *normal_icon;
@property (nonatomic, copy) NSString    *C_CONF_select_icon;
@property (nonatomic, copy) NSString    *logtitle;
@property (nonatomic, copy) NSString    *key;
@property (nonatomic, copy) NSString    *bottom_background;

//下载好的icon图片
@property (nonatomic, strong) NSData    *normal_imageData;
@property (nonatomic, strong) NSData    *select_imageData;

@end


@interface FeatureModel_TabBarInfor : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, copy) NSString    *total;
@property (nonatomic, strong) NSMutableArray   *indexInfo;
@end

NS_ASSUME_NONNULL_END
