//
//  US_GetCommissionIndex.h
//  u_store
//
//  Created by ZERO on 2016/12/12.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommissionData : NSObject
@property (nonatomic, copy) NSString    *unIssueCms;
@property (nonatomic, copy) NSString    *balance;

@end


@interface US_GetCommissionIndex : NSObject
@property (nonatomic, copy) NSString        *returnCode;
@property (nonatomic, copy) NSString        *returnMessage;
@property (nonatomic, strong) CommissionData *data;
@end
