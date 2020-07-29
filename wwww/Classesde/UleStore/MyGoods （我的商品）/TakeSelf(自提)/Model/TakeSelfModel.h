//
//  TakeSelfModel.h
//  u_store
//
//  Created by MickyChiang on 2019/3/22.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface TakeSelfIndexInfo : NSObject
@property (nonatomic, copy) NSString *android_action;
@property (nonatomic, copy) NSString *backImage;
@property (nonatomic, copy) NSString *back_image;
@property (nonatomic, copy) NSString *commission;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *customAtt_link;
@property (nonatomic, copy) NSString *customAtt_title;
@property (nonatomic, copy) NSString *customDesc;
@property (nonatomic, copy) NSString *customImgUrl;
@property (nonatomic, copy) NSString *customTitle;
@property (nonatomic, copy) NSString *device_type;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *groupsort;
@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) NSMutableArray *imageList;
@property (nonatomic, copy) NSString *ios_action;
@property (nonatomic, copy) NSString *jiFenCahsPrice;
@property (nonatomic, assign) BOOL jiFenListing;
@property (nonatomic, copy) NSString *jiFenPrice;
@property (nonatomic, copy) NSString *jiFenTitle;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *link_title;
@property (nonatomic, strong) NSNumber *listingId;
@property (nonatomic, copy) NSString *log_title;
@property (nonatomic, copy) NSString *mInsuranceListingId;
@property (nonatomic, copy) NSString *max_version;
@property (nonatomic, copy) NSString *min_version;
@property (nonatomic, copy) NSString *moduleKey;
@property (nonatomic, copy) NSString *moduleName;
@property (nonatomic, strong) NSNumber *orgType;
@property (nonatomic, strong) NSNumber *orgunitId;
@property (nonatomic, strong) NSNumber *priority;
@property (nonatomic, copy) NSString *promotionDesc;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *wh_rate;
@property (nonatomic, copy) NSString *sales_volume;
@property (nonatomic, strong) NSNumber *totalSold;
@property (nonatomic, copy) NSString *listingTag;
@property (nonatomic, copy) NSString *groupFlag;
@property (nonatomic, assign) BOOL isImgLoaded;//非接口返回参数
@end


@interface TakeSelfData : NSObject
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *pageIndex;
@property (nonatomic, strong) NSNumber *nextPageIndex;
@property (nonatomic, strong) NSNumber *prePageIndex;
@property (nonatomic, strong) NSNumber *totalPages;
@property (nonatomic, strong) NSNumber *totalRecords;
@property (nonatomic, strong) NSMutableArray *result;
@end


@interface TakeSelfModel : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) TakeSelfData *data;
@end
