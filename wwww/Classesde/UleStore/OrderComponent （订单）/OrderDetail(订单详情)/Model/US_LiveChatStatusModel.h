//
//  US_LiveChatStatusModel.h
//  UleStoreApp
//
//  Created by mac_chen on 2020/3/24.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_LiveChatStatusInfo : NSObject
@property (nonatomic, strong) NSString *merchantId;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *status;
@end

@interface US_LiveChatStatusModel : NSObject
@property (nonatomic, strong) NSString *returnCode;
@property (nonatomic, strong) NSString *returnMessage;
@property (nonatomic, strong) US_LiveChatStatusInfo *data;
@end

NS_ASSUME_NONNULL_END
