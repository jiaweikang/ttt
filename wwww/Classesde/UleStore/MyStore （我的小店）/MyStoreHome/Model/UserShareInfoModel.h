//
//  UserShareInfoModel.h
//  u_store
//
//  Created by xstones on 2017/2/22.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserShareInfolList : NSObject
@property (nonatomic, strong) NSNumber      *_id;
@property (nonatomic, copy) NSString        *shareDay;
@property (nonatomic, copy) NSString        *shareMonth;
@property (nonatomic, copy) NSString        *sharePV;
@property (nonatomic, copy) NSString        *shareUV;
@property (nonatomic, copy) NSString        *shareYear;
@property (nonatomic, copy) NSString        *storeName;
@property (nonatomic, copy) NSString        *storepName;
@property (nonatomic, copy) NSString        *shareOQ;//订单量
@end

@interface UserShareInfoData : NSObject
@property (nonatomic, strong) UserShareInfolList    *today;

@end


@interface UserShareInfoModel : NSObject
@property (nonatomic, copy) NSString    *returnCode;
@property (nonatomic, copy) NSString    *returnMessage;
@property (nonatomic, strong) UserShareInfoData     *data;;
@end

//订单量
@interface UserShareInfoOrderData: NSObject
@property (nonatomic, copy) NSString    *ylxdOrderCount;
@property (nonatomic, copy) NSString    *fxOrderCount;
@property (nonatomic, copy) NSString    *orderCount;
@end

@interface UserShareInfoOrderModel : NSObject
@property (nonatomic, copy) NSString    *code;
@property (nonatomic, copy) NSString    *msg;
@property (nonatomic, strong)UserShareInfoOrderData *data;
@end
