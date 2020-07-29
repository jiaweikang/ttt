//
//  USLocationManager.h
//  UleMarket
//
//  Created by xulei on 2019/1/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentLBS/TencentLBS.h>
#import "US_SearchAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^USLocationBlock)(TencentLBSLocation *currentLocation);

@protocol USLocationManagerDelegate <NSObject>
@optional
- (void)usLocationManagerDidComplete:(TencentLBSLocation *)location error:(NSError *)error;
@end

@interface USLocationManager : NSObject<USLocationManagerDelegate>
@property (nonatomic,strong) NSString *lastProvince;//省
@property (nonatomic,strong) NSString *lastCity;//市
@property (nonatomic,strong) NSString *lastAddress;//详细地址
@property (nonatomic,strong) NSString *lastProDetail;//上一次省市区
@property (nonatomic,strong) NSString *lastName;//
@property (nonatomic,strong) NSArray * poiList;

@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property(nonatomic,copy)NSString *lastLatitude;
@property(nonatomic,copy)NSString *lastLongitude;
@property(nonatomic,strong) TencentLBSPoi * currentPoi;
@property (nonatomic, copy) NSString * adcode;//定位中区域code(地址搜索，选择地址会修改)
@property (nonatomic, copy) NSString * locationCode;//定位的code（保存定位时code）
@property (nonatomic, assign) BOOL isManuaLocation;//是否手动重新定位

+ (instancetype)sharedLocation;

/**
*  腾讯定位
*/
- (void)startTencentSingleLocation;

/**
*  检查权限
*/
- (BOOL)checkLocationAuthorizationWithAlertMessage:(NSString *)msg cancelActionBlock:(void (^)(void))cancelBlock;

/**
 *  获取坐标
 *
 *  @param locationtBlock locationtBlock description
 */
- (void)getCurrentLocation:(USLocationBlock) locationtBlock;


/// 显示定位失败
+ (void)showLocationFailedVC;

/// 显示空页面
+ (void)showEmptyVC;

/// 退出
/// @param viewController vc
+ (void)dismissFromVC:(UIViewController *)viewController;


- (void)saveLocationPoi:(TencentLBSPoi *)poi andCode:(NSString *)adcode;

- (void)saveLocationInfo:(TencentLBSLocation *)location;

- (void)saveoldLocationInfo:(TencentLBSLocation *)location;
@end

NS_ASSUME_NONNULL_END
