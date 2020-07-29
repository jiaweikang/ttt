//
//  PaySecurityModel.h
//  u_store
//
//  Created by mac_chen on 2018/8/10.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaySecurityData : NSObject

@property (nonatomic, copy) NSString *status; //status 1 开通 0 未开通

@end

@interface PaySecurityModel : NSObject

@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) PaySecurityData *data;

@end
