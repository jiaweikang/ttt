//
//  US_ExpressInfo.h
//  u_store
//
//  Created by admin on 16/8/8.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface US_ExpressDataMap : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *dealCompany;
@property (nonatomic, copy) NSString *dealTime;
@end

@interface US_ExpressListMap : NSObject
@property (nonatomic, strong) US_ExpressDataMap *map;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isLast;
@end

@interface US_ExpressDataData : NSObject
@property (nonatomic, strong) NSMutableArray *myArrayList;
@end

@interface US_MemoryMap: NSObject
@property (nonatomic, copy) NSString *expressCode;
@property (nonatomic, copy) NSString *expressId;
@property (nonatomic, copy) NSString *expressName;
@property (nonatomic, copy) NSString *packageNo;
@property (nonatomic, strong) US_ExpressDataData *expressData;
@end

@interface US_ExpressData : NSObject
@property (nonatomic, strong) US_MemoryMap *map;
@end

@interface US_ExpressInfo : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, strong) US_ExpressData *data;
@end
