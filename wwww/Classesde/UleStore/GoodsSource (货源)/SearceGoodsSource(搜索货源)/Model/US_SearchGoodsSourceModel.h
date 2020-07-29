//
//  US_SearchGoodsSourceModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/12.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PromotionListData : NSObject
    @property (nonatomic, strong) NSNumber  * _id;
    @property (nonatomic, strong) NSString  *name;
    
    @end

@interface OperateStateTime : NSObject
    @property (nonatomic, copy) NSString *date;
    @property (nonatomic, copy) NSString *day;
    @property (nonatomic, copy) NSString *hours;
    @property (nonatomic, copy) NSString *minutes;
    @property (nonatomic, copy) NSString *month;
    @property (nonatomic, copy) NSString *seconds;
    @property (nonatomic, copy) NSString *time;
    @property (nonatomic, copy) NSString *timezoneOffset;
    @property (nonatomic, copy) NSString *year;
    @end

@interface RecommendModel : NSObject
    @property (nonatomic, copy) NSString *activityDesc;
    @property (nonatomic, copy) NSString *attribute;
    @property (nonatomic, copy) NSString *attributeList;
    @property (nonatomic, copy) NSString *brand;
    @property (nonatomic, copy) NSString *brandName;
    @property (nonatomic, copy) NSString *categoryId;
    @property (nonatomic, copy) NSString *categoryName;
    @property (nonatomic, copy) NSString *categoryPath;
    @property (nonatomic, strong) NSNumber *commission;
    @property (nonatomic, strong) NSNumber *commistion;
    @property (nonatomic, copy) NSString *dcCityMame;
    @property (nonatomic, copy) NSString *dcCode;
    @property (nonatomic, copy) NSString *dcName;
    @property (nonatomic, copy) NSString *dcProvinceName;
    @property (nonatomic, copy) NSString *defImgUrl;
    @property (nonatomic, copy) NSString *deliveryType;
    @property (nonatomic, copy) NSString *dgStoreId;
    @property (nonatomic, copy) NSString *extraCommission;
    @property (nonatomic, copy) NSString *hdPicUrl;
    @property (nonatomic, copy) NSString *highCommission;
    @property (nonatomic, copy) NSString *itemIds;
    @property (nonatomic, copy) NSString *limitWay;
    @property (nonatomic, copy) NSString *limitNum;
    @property (nonatomic, copy) NSString *listDesc;
    @property (nonatomic, copy) NSString *listId;
    @property (nonatomic, copy) NSString *listingType;
    @property (nonatomic, copy) NSString *listName;
    @property (nonatomic, copy) NSString *listNumber;
    @property (nonatomic, copy) NSString *listPromotionName;
    @property (nonatomic, copy) NSString *maxPrice;      //邮乐市场价
    @property (nonatomic, copy) NSString *merchantFreightPay;
    @property (nonatomic, copy) NSString *merchantId;
    @property (nonatomic, copy) NSString *merchantName;
    @property (nonatomic, copy) NSString *minPrice;      //邮乐价
    @property (nonatomic, copy) NSString *payments;
    @property (nonatomic, copy) NSString *promotionDesc;
    @property (nonatomic, strong) NSMutableArray *promotionList;
    @property (nonatomic, copy) NSString *saleRange;
    @property (nonatomic, copy) NSString *saleRangeLimit;
    @property (nonatomic, strong) NSMutableArray *services;
    @property (nonatomic, copy) NSString *soldCount;
    @property (nonatomic, copy) NSString *standardAttributeIds;
    @property (nonatomic, copy) NSString *storage;
    @property (nonatomic, copy) NSString *storeCategoryPath;
    @property (nonatomic, copy) NSString *storeCls1;
    @property (nonatomic, copy) NSString *storeCls1name;
    @property (nonatomic, copy) NSString *storeId;
    @property (nonatomic, copy) NSString *tag;
    @property (nonatomic, copy) NSString *totalCommission;
    @property (nonatomic, copy) NSString *weight;
    @property (nonatomic, copy) NSString *_id;
    @property (nonatomic, strong) OperateStateTime *operateStateTime;
    
    @property (nonatomic, copy) NSString *sharePrice;     //分享价
    @property (nonatomic, copy) NSString *marketPrice;    //市场价
    @property (nonatomic, copy) NSString *createTime;  //创建时间
    @property (nonatomic, copy) NSString *previewUrl;  //图片预览链接
    @property (nonatomic, copy) NSString *provinceCode;//省ID
    @property (nonatomic, copy) NSString *remark;      //备注
    @property (nonatomic, strong) OperateStateTime *updateTime;  //更新时间
    @property (nonatomic, copy) NSString *totalSold;    //销量
    @property (nonatomic, assign) BOOL isImgLoaded;////判断列表的图片是否加载出来，如果加载失败在微信分享时用占位图代替
    @property (nonatomic, copy) NSString *groupFlag; //2018.09.27 团购标识 1是 0否
    @property (nonatomic, copy) NSString *listingTag;//1666-先行赔付 20190806
    @end

@interface US_GoodsSorcesData : NSObject
    @property (nonatomic, strong) NSNumber          *totalCount;
    @property (nonatomic, strong) NSNumber          *currentPage;
    @property (nonatomic, strong) NSMutableArray    *Listings;//货源
    @property (nonatomic, strong) NSMutableArray    *recommendDaily;//天天推荐
    @end

@interface US_SearchGoodsSourceModel : NSObject
    @property (nonatomic, copy)   NSString *returnCode;
    @property (nonatomic, copy)   NSString *returnMsg;
    @property (nonatomic, copy)   NSString *returnMessage;
    @property (nonatomic, strong) US_GoodsSorcesData *data;
    @end

NS_ASSUME_NONNULL_END
