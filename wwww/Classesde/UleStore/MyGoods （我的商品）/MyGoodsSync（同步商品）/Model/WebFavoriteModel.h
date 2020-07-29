//
//  WebFavoriteModel.h
//  u_store
//
//  Created by xstones on 2018/3/20.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebFavoriteList : NSObject
@property (nonatomic, strong) NSNumber  *_id;
@property (nonatomic, strong) NSNumber  *classid;
@property (nonatomic, strong) NSNumber  *itemId;
@property (nonatomic, strong) NSNumber  *tagIds;
@property (nonatomic, strong) NSNumber  *listingId;
@property (nonatomic, strong) NSNumber  *usrId;
@property (nonatomic, copy) NSString    *usrEmail;
@property (nonatomic, strong) NSNumber  *favsStatus;
@property (nonatomic, copy) NSString    *createTime;
@property (nonatomic, copy) NSString    *updateTime;
@property (nonatomic, strong) NSNumber  *storeId;
@property (nonatomic, copy) NSString    *storeName;
@property (nonatomic, copy) NSString    *listingName;
@property (nonatomic, strong) NSNumber  *listingPrice;
@property (nonatomic, copy) NSString    *className;
@property (nonatomic, copy) NSString    *listingImage;
@property (nonatomic, strong) NSNumber  *sessionId;
@property (nonatomic, strong) NSNumber  *merchantId;
@property (nonatomic, strong) NSNumber  *channelId;
@property (nonatomic, strong) NSNumber  *commission;
@property (nonatomic, strong) NSNumber  *commistion;
@property (nonatomic, strong) NSNumber  *instock;
@property (nonatomic, strong) NSNumber  *listingState;
@property (nonatomic, copy) NSString    *ylxdIsSave;//0-已同步 1-未同步
@property (nonatomic, copy) NSString *groupFlag; //拼团标签 1是 0否20180927


@end

@interface WebFavoriteData : NSObject
@property (nonatomic, strong) NSNumber  *total;
@property (nonatomic, strong) NSMutableArray    *favsListingListInfo;
@end

@interface WebFavoriteModel : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) WebFavoriteData   *data;


@end
