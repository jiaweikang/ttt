//
//  UleMbLogOperate.m
//  UleApp
//
//  Created by chenzhuqing on 2017/2/24.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UleMbLogOperate.h"
#import "MB_LOG.h"
#import "USLocationManager.h"

@implementation UleMbLogOperate
+ (void)addMBLogLaunchList{
    MB_LOG_LAUNCH * launch = [[MB_LOG_LAUNCH alloc] init];
    launch.CLIENT_TYPE = NonEmpty([UleStoreGlobal shareInstance].config.clientType);
    launch.DEVICE_TYPE = @"iphone";
    launch.USER_ID = [US_UserUtility sharedLogin].m_userId;
    launch.VERSION = NonEmpty([UleStoreGlobal shareInstance].config.appVersion);
    launch.MARKET_ID = NonEmpty([UleStoreGlobal shareInstance].config.appChannelID);
    if ([USLocationManager sharedLocation].lastLongitude.length>0&&[USLocationManager sharedLocation].lastLatitude.length>0) {
        launch.LAT_LON = [NSString stringWithFormat:@"%@,%@", [USLocationManager sharedLocation].lastLongitude, [USLocationManager sharedLocation].lastLatitude];
    }
    [ule_statistics addLog:launch];
}

+ (void)addMBLogDeviceList{
    MB_LOG_DEVICE * device = [[MB_LOG_DEVICE alloc] init];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    if ([USLocationManager sharedLocation].lastLongitude.length>0&&[USLocationManager sharedLocation].lastLatitude.length>0) {
        device.LAT_LON = [NSString stringWithFormat:@"%@,%@", [USLocationManager sharedLocation].lastLongitude, [USLocationManager sharedLocation].lastLatitude];
    }
    device.MARKET_ID = NonEmpty([UleStoreGlobal shareInstance].config.appChannelID);
    device.VERSION = NonEmpty([UleStoreGlobal shareInstance].config.versionNum);
    device.CLIENT_TYPE = NonEmpty([UleStoreGlobal shareInstance].config.clientType);
    device.DEVICE_TYPE = @"iphone";
    device.USER_ID = [US_UserUtility sharedLogin].m_userId;
    device.RESOLUTION = [NSString stringWithFormat:@"%.0f*%.0f",width*scale_screen,height*scale_screen];
    device.OLD_VERSION = [US_UserUtility sharedLogin].oldVersion;
    device.OS_VERSION = [NSString stringWithFormat:@"%f",kSystemVersion];
    device.BRAND = @"apple";
    device.MODEL = [[UIDevice currentDevice] model];
    [ule_statistics addLog:device];
}

+ (void)addOperateList:(NSString *)viewPage andPreViewPage:(NSString *)preViewPage;{
    
    MB_LOG_OPERATE * opeate = [[MB_LOG_OPERATE alloc]init];
    opeate.CLIENT_TYPE = NonEmpty([UleStoreGlobal shareInstance].config.clientType);
    opeate.VERSION = NonEmpty([UleStoreGlobal shareInstance].config.versionNum);
    opeate.USER_ID = [US_UserUtility sharedLogin].m_userId;
    opeate.VIEW_PAGE = viewPage;//@"CART";
    opeate.PRE_VP_CONSTIME = @"";
    opeate.PRE_VIEW_PAGE = preViewPage;
    opeate.DEVICE_TYPE = @"iphone";
    opeate.MARKET_ID = NonEmpty([UleStoreGlobal shareInstance].config.appChannelID);
    opeate.PARAMS = @"";
    [ule_statistics addLog:opeate];
    
}

+ (void) addMbLogClick:(NSString*) params
                           moduleid:(NSString*) moduleId
                         moduledesc:(NSString*) moduleDesc
                      networkdetail:(NSString*) networkDetail{
    
    MB_LOG_CLICK * mbClick = [[MB_LOG_CLICK alloc]init];
    mbClick.CLIENT_TYPE = NonEmpty([UleStoreGlobal shareInstance].config.clientType);
    mbClick.PARAMS = params;
    mbClick.MODULE_ID = moduleId;
    mbClick.MODULE_DESC = [moduleDesc stringByReplacingOccurrencesOfString:@"&" withString:@"_"];
    mbClick.MARKET_ID = NonEmpty([UleStoreGlobal shareInstance].config.appChannelID);
    mbClick.VERSION=NonEmpty([UleStoreGlobal shareInstance].config.appVersion);
    mbClick.DEVICE_TYPE=@"iphone";
    mbClick.USER_ID=[US_UserUtility sharedLogin].m_userId.length>0?[US_UserUtility sharedLogin].m_userId:@"";
    [ule_statistics addLog:mbClick];
    
}

+ (void) addMbLogAction:(NSString *) actionType
                actionName:(NSString *) actionName
                    params:(NSString *) params
               consumeTime:(NSString *) time
             networkdetail:(NSString*)  networkDetail{
    
    MB_LOG_ACTION * mbAction = [[MB_LOG_ACTION alloc]init];
    mbAction.CLIENT_TYPE = NonEmpty([UleStoreGlobal shareInstance].config.clientType);
    mbAction.APPKEY = NonEmpty([UleStoreGlobal shareInstance].config.appKey);
    mbAction.ACTION_TYPE = actionType;
    mbAction.ACTION_NAME = actionName;
    mbAction.CONSUME_TIME = time.length>0?time:@"";
    mbAction.PARAMS = params;
    mbAction.MARKET_ID = NonEmpty([UleStoreGlobal shareInstance].config.appChannelID);
    mbAction.USER_ID=[US_UserUtility sharedLogin].m_userId;
    mbAction.VERSION=NonEmpty([UleStoreGlobal shareInstance].config.appVersion);
    mbAction.DEVICE_TYPE=@"iphone";
    [ule_statistics addLog:mbAction];
}



@end
