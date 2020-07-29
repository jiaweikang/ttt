//
//  US_OrderPayModel.h
//  u_store
//
//  Created by xulei on 2018/6/14.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US_OrderPayData : NSObject
@property (nonatomic, strong) NSString  *reqNo;
@property (nonatomic, strong) NSString  *payReqNo;
@property (nonatomic, strong) NSString  *payUrl;

@end

@interface US_OrderPayModel : NSObject
@property (nonatomic, strong) NSString  *returnCode;
@property (nonatomic, strong) NSString  *returnMessage;
@property (nonatomic, strong) US_OrderPayData  *data;

@end
