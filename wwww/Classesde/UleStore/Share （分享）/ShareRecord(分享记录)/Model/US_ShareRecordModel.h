//
//  US_ShareRecordModel.h
//  u_store
//
//  Created by 王昆 on 16/4/1.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareDetailInfo : NSObject
@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, strong) NSNumber *shareId;
@property (nonatomic, strong) NSNumber *listingId;       //商品listId
@property (nonatomic, copy) NSString *ownerId;
@property (nonatomic, copy) NSString *listingName;     //商品名称
@property (nonatomic, strong) NSNumber *shareFrom;
@property (nonatomic, strong) NSNumber *shareChannel; //分享渠道
@property (nonatomic, strong) NSNumber *salPrice;
@property (nonatomic, strong) NSNumber *sharePrice;
@property (nonatomic, strong) NSNumber *marketPrice;  //市场价格
@property (nonatomic, strong) NSNumber *commission;
@property (nonatomic, copy) NSString *createTime;   //分享时间
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *pv;           //浏览
@property (nonatomic, copy) NSString *uv;           //访问
@property (nonatomic, copy) NSString *shareType;    //分享类型
@property (nonatomic, assign) BOOL          isImgLoaded;
//微保分享价格，id
@property (nonatomic, copy) NSString *mInsuranceListingId;
@property (nonatomic, copy) NSString *mInsuranceSharePrice;

@end

@interface ShareDetailData : NSObject
@property (nonatomic, strong) NSMutableArray *result;
@property (nonatomic, strong) NSNumber  *totalRecords;
@end

@interface US_ShareRecordModel : NSObject
@property (nonatomic, copy)   NSString *returnCode;
@property (nonatomic, copy)   NSString *returnMessage;
@property (nonatomic, copy)   NSString *totalCount;
@property (nonatomic, strong) ShareDetailData *data;
@end
