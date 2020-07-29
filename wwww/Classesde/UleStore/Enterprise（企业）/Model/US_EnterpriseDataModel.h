//
//  US_EnterpriseDataModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionList :NSObject
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * name;

@end

@interface SaleRange :NSObject
@property (nonatomic , copy) NSString              * cityId;
@property (nonatomic , copy) NSString              * provinceId;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * provinceName;

@end


@interface US_EnterpriseRecommendList :NSObject
@property (nonatomic , copy) NSString              * defImgUrl;
@property (nonatomic , copy) NSString              * listId;
@property (nonatomic , copy) NSString              * groupFlag;
@property (nonatomic , copy) NSString              * provinceCode;
@property (nonatomic , copy) NSString              * maxPrice;
@property (nonatomic , copy) NSArray<PromotionList *>              * promotionList;
@property (nonatomic , copy) NSString              * sharePrice;
@property (nonatomic , copy) NSString              * itemIds;
@property (nonatomic , copy) NSString              * limitWay;
@property (nonatomic , copy) NSString              * totalSold;
@property (nonatomic , copy) NSString              * _id;
@property (nonatomic , copy) NSString              * listName;
@property (nonatomic , copy) NSString              * previewUrl;
@property (nonatomic , copy) NSString              * listDesc;
@property (nonatomic , copy) NSString              * commission;
@property (nonatomic , copy) NSArray<NSString *>              * services;
@property (nonatomic , copy) NSString              * minPrice;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSArray<SaleRange *>              * saleRange;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * limitNum;
@property (nonatomic, copy) NSString               * listingTag;

@end

@interface US_EnterpriseRecommendData :NSObject
@property (nonatomic , copy) NSString              * totalCount;
@property (nonatomic , copy) NSArray<US_EnterpriseRecommendList *>              * recommendDaily;
@property (nonatomic , copy) NSString              * currentPage;

@end

@interface US_EnterpriseRecommend :NSObject
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , strong) US_EnterpriseRecommendData              * data;

@end







@interface US_EnterpriseBannerData :NSObject<NSCopying>
@property (nonatomic , copy) NSString              * customAtt_title;
@property (nonatomic , copy) NSString              * log_title;
@property (nonatomic , copy) NSString              * link_title;
@property (nonatomic , copy) NSString              * android_action;
@property (nonatomic , assign) NSInteger              _id;
@property (nonatomic , copy) NSString              * moduleKey;
@property (nonatomic , copy) NSString              * max_version;
@property (nonatomic , assign) NSInteger              orgunitId;
@property (nonatomic , copy) NSArray              * imageList;
@property (nonatomic , copy) NSString              * ios_action;
@property (nonatomic , copy) NSString              * salePrice;
@property (nonatomic , copy) NSString              * sales_volume;
@property (nonatomic , assign) NSInteger              orgType;
@property (nonatomic , copy) NSString              * startTime;
@property (nonatomic , copy) NSString              * min_version;
@property (nonatomic , copy) NSString              * titlecolor;
@property (nonatomic , copy) NSString              * customAtt_link;
@property (nonatomic , copy) NSString              * customDesc;
@property (nonatomic , copy) NSString              * groupsort;
@property (nonatomic , assign) NSInteger              priority;
@property (nonatomic , copy) NSArray              * tag_imgs;
@property (nonatomic , copy) NSString              * back_image;
@property (nonatomic , assign) NSInteger              delFlag;
@property (nonatomic , copy) NSString              * endTime;
@property (nonatomic , copy) NSString              * related_module_key;
@property (nonatomic , copy) NSString              * customTitle;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , copy) NSString              * customImgUrl;
@property (nonatomic , copy) NSString              * wh_rate;
@property (nonatomic , copy) NSString              * link;
@property (nonatomic , assign) NSInteger              listingId;
@property (nonatomic , copy) NSString              * data;
@property (nonatomic , copy) NSString              * commission;
@property (nonatomic , copy) NSString              * device_type;
@property (nonatomic , copy) NSString              * backImage;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , assign) NSInteger              moduleType;
@property (nonatomic , assign) NSInteger              totalSold;
@property (nonatomic , assign) NSInteger              moduleId;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * groupid;
@property (nonatomic , copy) NSString              * moduleName;

@end

@interface US_EnterpriseBanner :NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray<US_EnterpriseBannerData *>              * data;

@end




NS_ASSUME_NONNULL_END
