//
//  USInviteShareManager.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface USInviteShareManager : NSObject

+ (instancetype)sharedManager;

//邀请开店
- (void)inviteShareToOpenStore;

//分享店铺
- (void)inviteShareMyStore;

//分享分销店铺
- (void)shareFenxiaoMyStore;

@end

/*************MODEL*****************/
//小程序
@interface ShareMyStoreMiniWxInfo : NSObject
@property (nonatomic, copy) NSString *path;//小程序地址
@property (nonatomic, copy) NSString *originalId;//小程序id
@end

@interface ShareMyStoreInfo : NSObject
@property (nonatomic, copy) NSString *shareUrl4;
@property (nonatomic, copy) NSString *shareOptionsIndex;//店铺描述
@property (nonatomic, copy) NSString *shareOptions;
@property (nonatomic, copy) NSString *favsListingStr;
@property (nonatomic, copy) NSString *shareUrl3;
@property (nonatomic, copy) NSString *shareId;
@property (nonatomic, copy) NSString *sectionList;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *storeNameDescribe;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *usrName;
@property (nonatomic, strong) ShareMyStoreMiniWxInfo *miniWxShareInfo;
@end

@interface ShareMyStoreModel : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) ShareMyStoreInfo *data;

@end



NS_ASSUME_NONNULL_END
