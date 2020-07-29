//
//  FeatureModel_HomeRecommend.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NewHomeRecommendApi : NSObject
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

@interface NewHomeRecommendData : NSObject
@property (nonatomic, copy) NSString   *min_version;
@property (nonatomic, copy) NSString   *publishTime;
@property (nonatomic, copy) NSString   *wh_rate;
@property (nonatomic, copy) NSString   *groupid;
@property (nonatomic, copy) NSString   *link;
@property (nonatomic, copy) NSString   *titlecolor;
@property (nonatomic, copy) NSString   *device_type;
@property (nonatomic, copy) NSString   *sectionId;
@property (nonatomic, copy) NSString   *listingId;
@property (nonatomic, copy) NSString   *title;
@property (nonatomic, copy) NSString   *priority;
@property (nonatomic, copy) NSString   *batchId;
@property (nonatomic, copy) NSString   *log_title;
@property (nonatomic, copy) NSString   *customImgUrl;
@property (nonatomic, copy) NSString   *imgUrl;
@property (nonatomic, copy) NSString   *max_version;
@property (nonatomic, copy) NSString   *groupsort;
@property (nonatomic, copy) NSString   *createTime;
@property (nonatomic, copy) NSString   *android_action;
@property (nonatomic, copy) NSString   *ios_action;
@property (nonatomic, copy) NSString   *ID;
@property (nonatomic, copy) NSString   *sales_volume;
@property (nonatomic, copy) NSString   *back_image;

@property (nonatomic, copy) NSString   *moduleKey;
@property (nonatomic, copy) NSString   *customTitle;
@property (nonatomic, copy) NSString   *customDesc;
@property (nonatomic, copy) NSString   *salePrice;
@property (nonatomic, copy) NSString   *commission;
@property (nonatomic, copy) NSArray    *imageList;
@property (nonatomic, strong) NSNumber  *totalSold;
@property (nonatomic, copy) NSArray *tag_imgs;
@property (nonatomic, copy) NSString *more_title;
@property (nonatomic, copy) NSString *more_url;
@property (nonatomic, assign) BOOL jiFenListing; //是否是积分商品
@property (nonatomic, copy) NSString *jiFenPrice; //积分价格
@property (nonatomic, copy) NSString *jiFenTitle; //积分显示按钮文字
@property (nonatomic, copy) NSString *iconImage; //首页角标
@property (nonatomic, copy) NSString *mInsuranceListingId;
@property (nonatomic, assign) BOOL hasSubArray;//是否有子商品，这个属性是用于布局显示圆角的，不是接口返回数据

/*************以上为推荐位字段******************/
@property (nonatomic, strong) NewHomeRecommendApi    *data;

@property (nonatomic, assign) NSInteger locationIndex;

@property (nonatomic, assign) BOOL  isImgLoaded;//非接口返回参数
@property (nonatomic, copy) NSString    *jumpActionType;//非接口返回参数 用来判断登陆后的自动跳转

@end


@interface FeatureModel_HomeRecommend : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
