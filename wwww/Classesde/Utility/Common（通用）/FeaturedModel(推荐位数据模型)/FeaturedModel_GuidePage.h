//
//  FeaturedModel_GuidePage.h
//  UleStoreApp
//
//  Created by xulei on 2019/1/23.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface FeaturedModel_GuidePageIndex :NSObject
@property (nonatomic , copy) NSString              * image3;
@property (nonatomic , copy) NSString              * android_action;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * c_CONF_image6;
@property (nonatomic , copy) NSString              * image2;
@property (nonatomic , copy) NSString              * c_CONF_image1;
@property (nonatomic , copy) NSString              * max_version;
@property (nonatomic , copy) NSString              * ios_action;
@property (nonatomic , copy) NSString              * image1;
@property (nonatomic , copy) NSString              * min_version;
@property (nonatomic , copy) NSString              * image0;
@property (nonatomic , copy) NSString              * c_CONF_image9;
@property (nonatomic , copy) NSString              * key;
@property (nonatomic , copy) NSString              * c_CONF_image4;
@property (nonatomic , copy) NSString              * priority;
@property (nonatomic , copy) NSString              * c_CONF_image7;
@property (nonatomic , copy) NSString              * image9;
@property (nonatomic , copy) NSString              * c_CONF_image2;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , copy) NSString              * image8;
@property (nonatomic , copy) NSString              * sectionId;
@property (nonatomic , copy) NSString              * device_type;
@property (nonatomic , copy) NSString              * image7;
@property (nonatomic , copy) NSString              * c_CONF_image5;
@property (nonatomic , copy) NSString              * c_CONF_image0;
@property (nonatomic , copy) NSString              * image6;
@property (nonatomic , copy) NSString              * image5;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * c_CONF_image8;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * c_CONF_image3;
@property (nonatomic , copy) NSString              * image4;
@property (nonatomic , copy) NSString              * resolution;
@property (nonatomic , copy) NSString              * log_title;
/*新增字段 20200107*/
@property (nonatomic , copy) NSString              * showProvince;
@property (nonatomic , copy) NSString              * guide_count;
@property (nonatomic , copy) NSString              * guide_time;
@property (nonatomic , copy) NSString              * guide_code;
@property (nonatomic , copy) NSString              * video;
@property (nonatomic , copy) NSString              * videoImage;

//自加参数
@property (nonatomic, copy) NSString    *downloadImgStr;//适配手机尺寸的链接
@property (nonatomic, strong) UIImage   *resultImage;//down下来的iamge
@property (nonatomic , copy) NSString   *nowDayShowedCount;//当日已弹出展示次数 本地比较用
@end

@interface FeaturedModel_GuidePage :NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSString              * total;
@property (nonatomic , strong) NSMutableArray      * indexInfo;

@end


NS_ASSUME_NONNULL_END
