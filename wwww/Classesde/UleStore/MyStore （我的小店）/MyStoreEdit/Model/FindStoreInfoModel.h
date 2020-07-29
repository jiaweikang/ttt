//
//  FindStoreInfoModel.h
//  u_store
//
//  Created by xstones on 2017/8/21.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindStoreInfoUser : NSObject
@property (nonatomic, strong) NSNumber      *userOnlyId;
@property (nonatomic, copy) NSString        *orgCode;
@property (nonatomic, copy) NSString        *userName;
@property (nonatomic, copy) NSString        *userIcon;
@property (nonatomic, copy) NSString        *stationName;
@property (nonatomic, copy) NSString        *websiteCode;
@property (nonatomic, copy) NSString        *websiteType;

@end

@interface FindStoreInfoStore : NSObject
@property (nonatomic, strong) NSNumber      *storeId;
@property (nonatomic, copy) NSString        *storeName;
@property (nonatomic, strong) NSNumber      *storeOwnerId;
@property (nonatomic, copy) NSString        *storeDescription;
@property (nonatomic, strong) NSNumber      *orgCode;
@property (nonatomic, copy) NSString        *storeLogo;

@end

@interface FindStoreInfoData : NSObject
@property (nonatomic, copy) NSString    *cost;
@property (nonatomic, strong) FindStoreInfoStore    *store;
@property (nonatomic, strong) FindStoreInfoUser     *user;

@end

@interface FindStoreInfoModel : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) FindStoreInfoData *data;
@end
