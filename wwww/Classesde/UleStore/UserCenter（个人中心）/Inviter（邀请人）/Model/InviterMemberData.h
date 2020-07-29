//
//  InviteMemberData.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface InviterInfo : NSObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *ownerId;
@property (nonatomic,strong) NSString *storeName;
@property (nonatomic,strong) NSString *storeLogo;
@property (nonatomic,strong) NSString *storeState;
@property (nonatomic,strong) NSString *storeDesc;
@property (nonatomic,strong) NSString *ownerType;
@property (nonatomic,strong) NSString *provinceId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *areaId;
@property (nonatomic,strong) NSString *townId;
@property (nonatomic,strong) NSString *delFlag;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *updateTime;
@property (nonatomic,strong) NSString *lastOperaterId;
@property (nonatomic,strong) NSString *lastOperaterType;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *recommendUserId;
@property (nonatomic,strong) NSString *recommendChannel;
@property (nonatomic,strong) NSString *ip;
@property (nonatomic,strong) NSString *currentProvince;
@property (nonatomic,strong) NSString *currentCity;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *contractCode;
@property (nonatomic,strong) NSString *provinceName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic,strong) NSString *townName;
@property (nonatomic,strong) NSString *orgType;
@property (nonatomic,strong) NSString *lockFlag;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *usrTrueName; //用户名
@property (nonatomic,strong) NSString *organizationName; //所属企业名称(最后一级)
@property (nonatomic,strong) NSString *lastShareTime; //最后分享时间
@property (nonatomic,strong) NSString *orderCount; //上月订单量
@property (nonatomic,strong) NSString *prdCommissionCount; //上月收益
@end
@interface InviterData : NSObject
@property (nonatomic,strong)NSMutableArray *result;
@property (nonatomic,strong)NSString *pageSize;
@property (nonatomic,strong)NSString *pageIndex;
@property (nonatomic,strong)NSString *prePageIndex;
@property (nonatomic,strong)NSString *nextPageIndex;
@property (nonatomic,strong)NSString *totalRecords;
@property (nonatomic,strong)NSString *totalPages;
@end
@interface InviterMemberData : NSObject
@property (nonatomic,strong) NSString *returnCode;
@property (nonatomic,strong) NSString *returnMessage;
@property (nonatomic,strong) InviterData *data;
@end

NS_ASSUME_NONNULL_END
