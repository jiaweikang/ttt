//
//  US_MultiOrderDetails.h
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/14.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface US_MultiOrderInfo : NSObject
@property (nonatomic, strong) NSString *escOrderIds;
@property (nonatomic, strong) NSString *orderAmount;
@property (nonatomic, strong) NSString *productNumTotal;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *storeName;
@end


@interface US_MultiOrderDetails : NSObject
@property (nonatomic, strong) NSString *returnCode;
@property (nonatomic, strong) NSString *returnMessage;
@property (nonatomic, strong) NSString *orderAmount;
@property (nonatomic, strong) NSString *productNumTotal;
@property (nonatomic, strong) NSString *escOrderIds;

@property (nonatomic , strong) NSMutableArray *details;
@end

NS_ASSUME_NONNULL_END
