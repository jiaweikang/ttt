//
//  US_ReferrerData.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface ReferrerDataData : NSObject

@property (nonatomic, copy) NSString * usrOnlyid;
@property (nonatomic, copy) NSString * recommendUsrOnlyid;
@property (nonatomic, copy) NSString * recommendProvinceId;
@property (nonatomic, copy) NSString * recommendProvinceName;

@end
@interface US_ReferrerData : NSObject
@property (nonatomic, strong) ReferrerDataData * data;
@property (nonatomic, copy) NSString * returnCode;
@property (nonatomic, copy) NSString * returnMessage;
@end

NS_ASSUME_NONNULL_END
