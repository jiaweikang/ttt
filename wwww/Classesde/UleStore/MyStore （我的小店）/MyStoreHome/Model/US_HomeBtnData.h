//
//  US_HomeBtnData.h
//  u_store
//
//  Created by yushengyang on 15/7/10.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeRecommend : NSObject
/*******共用字段*******/
@property (nonatomic, strong) NSNumber  *listingId;
@property (nonatomic, strong) NSNumber  *commistion;
/*******团购字段*******/
@property (nonatomic, copy) NSString    *activityCode;//活动code
@property (nonatomic, copy) NSString    *goodsName;//商品名称
@property (nonatomic, strong) NSNumber  *groupbuyPrice;//团购价
@property (nonatomic, strong) NSNumber  *price;//市场价
@property (nonatomic, strong) NSNumber  *countListingId;//购买人数
@property (nonatomic, strong) NSNumber  *personNum;//几人团
/******高佣商品字段******/
@property (nonatomic, copy) NSString    *listingName;
@property (nonatomic, copy) NSString    *imgUrl;
@property (nonatomic, strong) NSNumber  *salePrice;
@property (nonatomic, strong) NSNumber  *marketPrice;
@property (nonatomic, strong) NSNumber  *totalSold;

@end
/**
 HomeBtnItem:首页推荐位按钮返回类
 */
@interface HomeBtnItem : NSObject

@property (nonatomic, copy) NSString * ios_action;
@property (nonatomic, copy) NSString * default_function;
@property (nonatomic, copy) NSString * device_type;
@property (nonatomic, copy) NSString * link;
@property (nonatomic, copy) NSString * log_title;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * m_Id;
@property (nonatomic, copy) NSString * is_new;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * sectionId;
@property (nonatomic, copy) NSString * need_login;
@property (nonatomic, copy) NSString * min_version;
@property (nonatomic, copy) NSString * priority;
@property (nonatomic, copy) NSString * max_version;
@property (nonatomic, copy) NSString * android_action;
@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSString * authorization;
@property (nonatomic, copy) NSString * banner_key;
@property (nonatomic, copy) NSString * functionId;
@property (nonatomic, copy) NSString * maxversion;
@property (nonatomic, copy) NSString * minversion;

@property (nonatomic, copy) NSString * wh_rate;
@property (nonatomic, copy) NSString * groupsort;
@property (nonatomic, copy) NSString * activity_zone;
@property (nonatomic, copy) NSString * groupid;
@property (nonatomic, copy) NSString * titlecolor;
@property (nonatomic, copy) NSString * showProvince;//根据用户所属省过滤显示数据 20171023 --xulei

@property (nonatomic, copy) NSString * customImgUrl;
@property (nonatomic, copy) NSString * back_image;
@property (nonatomic, strong) HomeRecommend * data;
@property (nonatomic, copy) NSString * sales_volume;
@end




@interface US_HomeBtnData : NSObject

@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * returnCode;
@property (nonatomic, copy) NSString * returnMessage;
@property (nonatomic, strong) NSMutableArray * indexInfo;

@end


@interface US_HomeRecommendData:NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) NSMutableArray *data;
@end
