//
//  MB_LOG.h
//  ule_statistics
//
//  Created by bobo on 13-10-11.
//  Copyright (c) 2013年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>



//点击事件表
@interface MB_LOG_CLICK : NSObject

@property(nonatomic,copy)NSString* CLIENT_TYPE;
@property(nonatomic,copy)NSString* PARAMS;
@property(nonatomic,copy)NSString* MODULE_ID;
@property(nonatomic,copy)NSString* MODULE_DESC;
@property(nonatomic,copy)NSString* MARKET_ID;
@property(nonatomic,copy)NSString* USER_ID;
@property(nonatomic,copy)NSString* VERSION;
@property(nonatomic,copy)NSString* DEVICE_TYPE;
@end





//重要事件表
@interface MB_LOG_ACTION : NSObject

@property(nonatomic,copy) NSString* CLIENT_TYPE;
@property(nonatomic,copy) NSString* APPKEY;
@property(nonatomic,copy) NSString* ACTION_TYPE;
@property(nonatomic,copy) NSString* ACTION_NAME;
@property(nonatomic,copy) NSString* CONSUME_TIME;
@property(nonatomic,copy) NSString* PARAMS;
@property(nonatomic,copy) NSString* MARKET_ID;
@property(nonatomic,copy) NSString* USER_ID;
@property(nonatomic,copy) NSString* VERSION;
@property(nonatomic,copy) NSString* DEVICE_TYPE;

@end



//页面切换表
@interface MB_LOG_OPERATE : NSObject

@property(nonatomic,copy) NSString* CLIENT_TYPE;
@property(nonatomic,copy) NSString* VERSION;
@property(nonatomic,copy) NSString* PARAMS;
@property(nonatomic,copy) NSString* USER_ID;
@property(nonatomic,copy) NSString* VIEW_PAGE;
@property(nonatomic,copy) NSString* PRE_VP_CONSTIME;
@property(nonatomic,copy) NSString* PRE_VIEW_PAGE;
@property(nonatomic,copy) NSString* DEVICE_TYPE;
@property(nonatomic,copy) NSString* MARKET_ID;

@end


//设备表
@interface MB_LOG_DEVICE : NSObject

@property(nonatomic,copy)NSString* MARKET_ID;
@property(nonatomic,copy)NSString* VERSION;
@property(nonatomic,copy)NSString* CLIENT_TYPE;
@property(nonatomic,copy)NSString* DEVICE_TYPE;
@property(nonatomic,copy)NSString* USER_ID;
@property(nonatomic,copy)NSString* LAT_LON;
@property(nonatomic,copy)NSString* OLD_VERSION;
@property(nonatomic,copy)NSString* OS_VERSION;
@property(nonatomic,copy)NSString* BRAND;
@property(nonatomic,copy)NSString* MODEL;
@property(nonatomic,copy)NSString *RESOLUTION;

@end




//启动纪录表
@interface MB_LOG_LAUNCH : NSObject

@property(nonatomic,copy)NSString* CLIENT_TYPE;
@property(nonatomic,copy)NSString* DEVICE_TYPE;
@property(nonatomic,copy)NSString* USER_ID;
@property(nonatomic,copy)NSString* VERSION;
@property(nonatomic,copy)NSString* LAT_LON;
@property(nonatomic,copy)NSString* MARKET_ID;

@end



