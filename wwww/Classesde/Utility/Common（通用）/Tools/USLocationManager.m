//
//  USLocationManager.m
//  UleMarket
//
//  Created by xulei on 2019/1/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USLocationManager.h"
#import "UserDefaultManager.h"
#import "US_LocationFailedVC.h"
#import "US_HomeEmptyVC.h"
#import "UleBaseNaviViewController.h"
#import <ModuleYLXD/UleCTMediator+ModuleYLXD.h>
#import "DeviceInfoHelper.h"
static NSString *const USLocationKey_province    = @"USLocationKey_province";
static NSString *const USLocationKey_city        = @"USLocationKey_city";
static NSString *const USLocationKey_proDetail   = @"USLocationKey_proDetail";
static NSString *const USLocationKey_address     = @"USLocationKey_address";
static NSString *const USLocationKey_coordinate  = @"USLocationKey_coordinate";
static NSString *const USLocationKey_latitude    = @"USLocationKey_latitude";
static NSString *const USLocationKey_longitude   = @"USLocationKey_longitude";
static NSString *const USLocationKey_adcode      = @"USLocationKey_adcode";
static NSString *const USLocationKey_name        = @"USLocationKey_name";

@interface USLocationManager ()<CLLocationManagerDelegate,TencentLBSLocationManagerDelegate>
@property (nonatomic, strong)USLocationBlock    mCurrentBlock;
@property (readwrite, nonatomic, strong) TencentLBSLocationManager *locationManager;

@end

@implementation USLocationManager

+ (instancetype)sharedLocation
{
    static dispatch_once_t predicate;
    static USLocationManager *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [[USLocationManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.lastProvince = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_province]];
        self.lastCity = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_city]];
        self.lastProDetail = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_proDetail]];
        self.lastAddress = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_address]];
        self.lastLatitude = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_latitude]];
        self.lastLongitude = [NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_longitude]];
        self.lastCoordinate = CLLocationCoordinate2DMake([self.lastLatitude floatValue], [self.lastLongitude floatValue]);
        self.adcode=[NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_adcode]];
        self.lastName=[NSString isNullToString:[UserDefaultManager getLocalDataString:USLocationKey_name]];
        [self configLocationManager];
    }
    return self;
}

#pragma mark - Action Handle

- (void)configLocationManager {
    
    self.locationManager = [[TencentLBSLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager setApiKey:[UleStoreGlobal shareInstance].config.tencentAppKey];
    [self.locationManager setRequestLevel:TencentLBSRequestLevelName];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

// 单次定位
- (void)startTencentSingleLocation {
    @weakify(self);
    [self.locationManager requestLocationWithCompletionBlock:
        ^(TencentLBSLocation *location, NSError *error) {
        @strongify(self);
        if ([self respondsToSelector:@selector(usLocationManagerDidComplete:error:)]) {
            [self usLocationManagerDidComplete:location error:error];
        }
        if (!error&&self.mCurrentBlock) {
            self.mCurrentBlock(location);
        }
        self.mCurrentBlock = nil;
    }];
}



- (void)saveLocationInfo:(TencentLBSLocation *)location{
    //保存
    self.adcode=location.code;
    self.locationCode=location.code;
    self.poiList=location.poiList;
    self.lastProvince = location.province;
    self.lastCity = location.city;
    self.lastProDetail = location.province;
    self.lastAddress = location.address;
    self.lastName=location.name;
    self.currentPoi=location.poiList.firstObject;
    self.lastLatitude = [NSString stringWithFormat:@"%.10lf", location.location.coordinate.latitude];
    self.lastLongitude = [NSString stringWithFormat:@"%.10lf", location.location.coordinate.longitude];
    self.lastCoordinate = CLLocationCoordinate2DMake(location.location.coordinate.latitude, location.location.coordinate.longitude);

    [UserDefaultManager setLocalDataString:self.lastProvince key:USLocationKey_province];
    [UserDefaultManager setLocalDataString:self.lastCity key:USLocationKey_city];
    [UserDefaultManager setLocalDataString:self.lastProDetail key:USLocationKey_proDetail];
    [UserDefaultManager setLocalDataString:self.lastAddress key:USLocationKey_address];
    [UserDefaultManager setLocalDataString:self.lastLatitude key:USLocationKey_latitude];
    [UserDefaultManager setLocalDataString:self.lastLongitude key:USLocationKey_longitude];
    [UserDefaultManager setLocalDataString:self.adcode key:USLocationKey_adcode];
    [UserDefaultManager setLocalDataString:self.lastName key:USLocationKey_name];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
}
//保存POI 信息
- (void)saveLocationPoi:(TencentLBSPoi *)poi andCode:(NSString *)adcode{
    self.currentPoi=poi;
    self.adcode=adcode;
    self.lastAddress=poi.address;
    self.lastName=poi.name;
    self.lastLatitude=[NSString stringWithFormat:@"%.10lf",poi.latitude];
    self.lastLongitude=[NSString stringWithFormat:@"%.10lf",poi.longitude];
    [UserDefaultManager setLocalDataString:self.lastCity key:USLocationKey_city];
    [UserDefaultManager setLocalDataString:self.lastAddress key:USLocationKey_address];
    [UserDefaultManager setLocalDataString:self.lastLatitude key:USLocationKey_latitude];
    [UserDefaultManager setLocalDataString:self.lastLongitude key:USLocationKey_longitude];
    [UserDefaultManager setLocalDataString:self.adcode key:USLocationKey_adcode];
    [UserDefaultManager setLocalDataString:self.lastName key:USLocationKey_name];
}

- (void)saveoldLocationInfo:(TencentLBSLocation *)location{
    TencentLBSPoi * poi=[[TencentLBSPoi alloc] init];
    poi.name=self.lastName;
    poi.address=self.lastAddress;
    self.currentPoi=poi;
    self.poiList=location.poiList;
    self.locationCode=location.code;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
}

- (void)getCurrentLocation:(USLocationBlock)locationtBlock{
    self.mCurrentBlock =[locationtBlock copy];
    [self startTencentSingleLocation];
}

- (BOOL)checkLocationAuthorizationWithAlertMessage:(NSString *)msg cancelActionBlock:(nonnull void (^)(void))cancelBlock{
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"打开【定位服务】来允许【%@】确定您的位置",[DeviceInfoHelper getAppName]] message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启)" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:cancelAction];
        [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
        return NO;
    }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([[UIDevice currentDevice].systemVersion floatValue]>=10) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) { }];
                    }
                }
            }else{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
        UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }];
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [[UIViewController currentViewController] presentViewController:alertController animated:YES completion:nil];
        return NO;
    }
    return YES;
}

#pragma mark - TencentLBSLocationManagerDelegate
//定位权限状态改变
- (void)tencentLBSLocationManager:(TencentLBSLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"用户还未决定授权");
            break;
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"访问受限");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"获得前后台授权");
            [self startTencentSingleLocation];
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"获得前台授权");
            [self startTencentSingleLocation];
            break;
        }
        default:
            break;
    }
}

#pragma mark  -<展示定位失败，以及空页面>
+ (void)showLocationFailedVC{
    US_LocationFailedVC * vc=[[US_LocationFailedVC alloc] init];
    UleBaseNaviViewController * nav=[[UleBaseNaviViewController alloc] initWithRootViewController:vc];
    [UIApplication sharedApplication].delegate.window.rootViewController=nav;
}

+ (void)showEmptyVC{
    US_HomeEmptyVC * vc=[[US_HomeEmptyVC alloc] init];
    UleBaseNaviViewController * nav=[[UleBaseNaviViewController alloc] initWithRootViewController:vc];
    [UIApplication sharedApplication].delegate.window.rootViewController=nav;
}

+ (void)dismissFromVC:(UIViewController *)viewController{
    [[UleCTMediator sharedInstance] uleMediator_presentMainView];
}

@end
