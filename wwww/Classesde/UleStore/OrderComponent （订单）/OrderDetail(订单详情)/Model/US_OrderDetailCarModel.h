//
//  US_CarModel.h
//  u_store
//
//  Created by MickyChiang on 2019/5/20.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OrderDetailCarList : NSObject
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *storeAddr;
@property (nonatomic, copy) NSString *storeLogo;
@end

@interface US_OrderDetailCarModel : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, strong) OrderDetailCarList *data;
@end

