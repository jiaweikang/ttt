//
//  US_UserUtility.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_UserUtility.h"
#import "UserDefaultManager.h"
#import <OpenUDID/OpenUDID.h>
#import <SDWebImageManager.h>
#import "NSDate+USAddtion.h"
#import "USCookieHelper.h"
#import "UleRedPacketRainLocalManager.h"
#import "US_LocalNotification.h"
#import "ShareParseTool.h"
#import "USLocationManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CL_ShanYanSDK/CL_ShanYanSDK.h>
#import "USAuthorizetionHelper.h"
static NSString *const keyUserData_isLogin=@"ustore_isLogin";
static NSString *const keyUserData_loginName=@"us_loginName";
static NSString *const keyUserData_userName=@"us_username";
static NSString *const keyUserData_userId=@"us_usrOnlyid";
static NSString *const keyUserData_stationName=@"us_stationName";
static NSString *const keyUserData_storeDesc=@"us_storeDesc";
static NSString *const keyUserData_mobileNumber=@"us_mobileNumber";
static NSString *const keyUserData_userHeadImgUrl=@"us_headImgUrl";
static NSString *const keyUserData_userHeadImage=@"us_headImage";
static NSString *const keyUserData_userToken=@"ShopstoreToken";
static NSString *const keyUserData_openUDID=@"us_openUdid";
static NSString *const keyUserData_deviceToken=@"us__deviceToken";
static NSString *const keyUserData_isUserProtocol=@"us_isUserProtocol";
static NSString *const keyUserData_protocolUrl=@"us_protocolUrl";
static NSString *const keyUserData_carInsurance=@"us_carInsurance";
static NSString *const keyUserData_websiteType=@"us_websiteType";
static NSString *const keyUserData_lockFlag=@"us_lockFlag";
static NSString *const keyUserData_donateFlag=@"us_donateFlag";
static NSString *const keyUserData_qualificationFlag=@"us_qualificationFlag";
static NSString *const keyUserData_identifiedFlag=@"us_identifiedFlag";
static NSString *const keyUserData_yzgFlag=@"us_yzgFlag";
static NSString *const keyUserData_userReferrerId=@"us_userReferrerId";
static NSString *const keyUserData_mallCookie=@"us_mallCookieValue";

static NSString *const keyUserData_orgType=@"us_orgType";
static NSString *const keyUserData_orgCode=@"us_orgCode";
static NSString *const keyUserData_orgName=@"us_orgName";
static NSString *const keyUserData_orgProvinceCode=@"us_provinceCode";
static NSString *const keyUserData_orgProvinceName=@"us_provinceName";
static NSString *const keyUserData_orgCityCode=@"us_cityCode";
static NSString *const keyUserData_orgCityName=@"us_cityName";
static NSString *const keyUserData_orgAreaCode=@"us_areaCode";
static NSString *const keyUserData_orgAreaName=@"us_areaName";
static NSString *const keyUserData_orgTownCode=@"us_townCode";
static NSString *const keyUserData_orgTownName=@"us_townName";
static NSString *const keyUserData_lastOrgId=@"us_lastOrgId";
static NSString *const keyUserData_lastOrgName=@"us_lastOrgName";
static NSString *const keyUserData_enterpriseOrgFlag=@"us_isEnterprise";
static NSString *const keyUserData_pixiaoZoneId=@"us_pixiaoZoneId";
static NSString *const keyUserData_previewUrl=@"PreviewUrlNeedRequest";
static NSString *const keyUserData_limitDomain  = @"usLocal_limitDomain";
static NSString *const keyUserData_notificationAlertShowedDate = @"notificationAlertShowedDate";
static NSString *const keyUserData_versionUpdateAlertShowedDate = @"versionUpdateAlertShowedDate";
static NSString *const keyUserData_userMallCookieRequestedDate = @"userMallCookieRequestedDate";
static NSString *const keyUserData_commisionTitle =@"us_commisionTitle";
static NSString *const keyUserData_homeListingFlag=@"us_homeListingFlag";
//open接口专用
static NSString *const keyUserData_open_userId=@"usOpen_usrOnlyid";

@implementation US_UserUtility

+ (instancetype)sharedLogin
{
    static US_UserUtility *loginUtility=nil;
    if (!loginUtility) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            loginUtility=[[US_UserUtility alloc]init];
        });
    }
    return loginUtility;
}

- (id)init {
    if (self = [super init]) {
    }
    // 是否登录
    self.mIsLogin = [UserDefaultManager getLocalDataBoolen:keyUserData_isLogin];
    //用户登录名
    self.m_loginName = [UserDefaultManager getLocalDataString:keyUserData_loginName];
    self.m_loginName = self.m_loginName ? self.m_loginName : @"";
    //用户名
    self.m_userName = [UserDefaultManager getLocalDataString:keyUserData_userName];
    self.m_userName = self.m_userName ? self.m_userName : @"";
    //用户ID
    self.m_userId = [UserDefaultManager getLocalDataString:keyUserData_userId];
    self.m_userId = self.m_userId ? self.m_userId : @"";
    //店铺名
    self.m_stationName = [UserDefaultManager getLocalDataString:keyUserData_stationName];
    self.m_stationName = self.m_stationName ? self.m_stationName : @"";
    //店铺分享介绍
    self.m_storeDesc = [UserDefaultManager getLocalDataString:keyUserData_storeDesc];
    self.m_storeDesc = self.m_storeDesc ? self.m_storeDesc : @"";
    //手机号
    self.m_mobileNumber = [UserDefaultManager getLocalDataString:keyUserData_mobileNumber];
    self.m_mobileNumber = self.m_mobileNumber ? self.m_mobileNumber : @"";
    //头像链接
    self.m_userHeadImgUrl = [UserDefaultManager getLocalDataString:keyUserData_userHeadImgUrl];
    self.m_userHeadImgUrl = self.m_userHeadImgUrl ? self.m_userHeadImgUrl : @"";
    //头像
    NSData *headData = [UserDefaultManager getLocalDataObject:keyUserData_userHeadImage];
    self.m_userHeadImage = headData.length>0?[UIImage imageWithData:headData]:nil;
    //userToken
    self.m_userToken = [UserDefaultManager getLocalDataString:keyUserData_userToken];
    self.m_userToken = self.m_userToken ? self.m_userToken : @"";
    //uuid
    _openUDID = [UserDefaultManager getLocalDataString:keyUserData_openUDID];
    _openUDID = _openUDID ? _openUDID : @"";
    //uuid
    self.m_deviceToken = [UserDefaultManager getLocalDataString:keyUserData_deviceToken];
    self.m_deviceToken = self.m_deviceToken ? self.m_deviceToken : @"";
    //isUserProtocol
    self.m_isUserProtocol = [UserDefaultManager getLocalDataString:keyUserData_isUserProtocol];
    //protocolUrl
    self.m_protocolUrl = [UserDefaultManager getLocalDataString:keyUserData_protocolUrl];
    self.m_protocolUrl = self.m_protocolUrl ? self.m_protocolUrl : @"";
    //carInsurance
    self.m_carInsurance = [UserDefaultManager getLocalDataString:keyUserData_carInsurance];
    self.m_carInsurance = self.m_carInsurance ? self.m_carInsurance : @"";
    //lockFlag
    self.m_lockFlag = [UserDefaultManager getLocalDataString:keyUserData_lockFlag];
    self.m_lockFlag = self.m_lockFlag ? self.m_lockFlag : @"";
    //donateFlag
    self.m_donateFlag = [UserDefaultManager getLocalDataString:keyUserData_donateFlag];
    self.m_donateFlag = self.m_donateFlag ? self.m_donateFlag : @"";
    //qualificationFlag
    self.qualificationFlag = [UserDefaultManager getLocalDataString:keyUserData_qualificationFlag];
    self.qualificationFlag = self.qualificationFlag ? self.qualificationFlag : @"";
    //identifiedFlag
    self.identifiedFlag = [UserDefaultManager getLocalDataString:keyUserData_identifiedFlag];
    self.identifiedFlag = self.identifiedFlag ? self.identifiedFlag : @"0";
    //yzgFlag
    self.m_yzgFlag = [UserDefaultManager getLocalDataString:keyUserData_yzgFlag];
    self.m_yzgFlag = self.m_yzgFlag ? self.m_yzgFlag : @"";
    //m_websiteType
    self.m_websiteType = [UserDefaultManager getLocalDataString:keyUserData_websiteType];
    self.m_websiteType = self.m_websiteType ? self.m_websiteType : @"";
    //推荐人id
    self.m_userReferrerId = [UserDefaultManager getLocalDataString:keyUserData_userReferrerId];
    self.m_userReferrerId = self.m_userReferrerId ? self.m_userReferrerId : @"";
    //mall_cookie
    self.m_mallCookie = [UserDefaultManager getLocalDataString:keyUserData_mallCookie];
    self.m_mallCookie = self.m_mallCookie ? self.m_mallCookie : @"";
    
    //orgType
    self.m_orgType = [UserDefaultManager getLocalDataString:keyUserData_orgType];
    self.m_orgType = self.m_orgType ? self.m_orgType : @"";
    //orgCode
    self.m_orgCode = [UserDefaultManager getLocalDataString:keyUserData_orgCode];
    self.m_orgCode = self.m_orgCode ? self.m_orgCode : @"";
    //orgName
    self.m_orgName = [UserDefaultManager getLocalDataString:keyUserData_orgName];
    self.m_orgName = self.m_orgName ? self.m_orgName : @"";
    //orgProvinceCode
    self.m_provinceCode = [UserDefaultManager getLocalDataString:keyUserData_orgProvinceCode];
    self.m_provinceCode = self.m_provinceCode ? self.m_provinceCode : @"";
    //orgProvinceName
    self.m_provinceName = [UserDefaultManager getLocalDataString:keyUserData_orgProvinceName];
    self.m_provinceName = self.m_provinceName ? self.m_provinceName : @"";
    //orgCityCode
    self.m_cityCode = [UserDefaultManager getLocalDataString:keyUserData_orgCityCode];
    self.m_cityCode = self.m_cityCode ? self.m_cityCode : @"";
    //orgCityName
    self.m_cityName = [UserDefaultManager getLocalDataString:keyUserData_orgCityName];
    self.m_cityName = self.m_cityName ? self.m_cityName : @"";
    //orgAreaCode
    self.m_areaCode = [UserDefaultManager getLocalDataString:keyUserData_orgAreaCode];
    self.m_areaCode = self.m_areaCode ? self.m_areaCode : @"";
    //orgAreaName
    self.m_areaName = [UserDefaultManager getLocalDataString:keyUserData_orgAreaName];
    self.m_areaName = self.m_areaName ? self.m_areaName : @"";
    //orgTownCode
    self.m_townCode = [UserDefaultManager getLocalDataString:keyUserData_orgTownCode];
    self.m_townCode = self.m_townCode ? self.m_townCode : @"";
    //orgTownName
    self.m_townName = [UserDefaultManager getLocalDataString:keyUserData_orgTownName];
    self.m_townName = self.m_townName ? self.m_townName : @"";
    //lastAddressId
    self.m_lastOrgId = [UserDefaultManager getLocalDataString:keyUserData_lastOrgId];
    self.m_lastOrgId = self.m_lastOrgId ? self.m_lastOrgId : @"";
    //lastAddressName
    self.m_lastOrgName = [UserDefaultManager getLocalDataString:keyUserData_lastOrgName];
    self.m_lastOrgName = self.m_lastOrgName ? self.m_lastOrgName : @"";
    //orgEnterpriseOrgFlag
    self.enterpriseFlag = [UserDefaultManager getLocalDataBoolen:keyUserData_enterpriseOrgFlag];
    //批销专区id
    self.pixiaoZoneId = [UserDefaultManager getLocalDataObject:keyUserData_pixiaoZoneId];
    //
    NSString *openUserID=[UserDefaultManager getLocalDataString:keyUserData_open_userId];
    if (self.m_userId.length>0) {
        self.isUserFirstLogin=NO;
    }else {
        self.isUserFirstLogin=[NSString isNullToString:openUserID].length>0?NO:YES;
    }
    //open接口专用
    self.open_userId=self.m_userId.length>0?self.m_userId:openUserID;
    self.open_userId = self.open_userId ? self.open_userId : @"";
    
    return self;
}

+ (void)logoutSuccess{
    [self saveIsUserLogin:NO];
    [self saveUserId:@""];
    [self saveMobileNumber:@""];
    [self saveUserHeadImgUrl:@""];
    [self saveUserHeadImageData:nil];
    [self saveUserToken:@""];
    [self saveUserName:@""];
    [self saveStationName:@""];
    [self saveStoreDesc:@""];
    [self saveIsUserProtocol:@""];
    [self saveProtocolUrl:@""];
    [self saveCarInsurance:@""];
    [self saveWebsiteType:@""];
    [self saveLockFlag:@""];
    [self saveDonateFlag:@""];
    [self saveQualificationFlag:@""];
    [self saveIdentifiedFlag:@""];
    [self saveUserReferrerId:@""];
    [self savePixiaoZoneId:nil];
    [US_UserUtility sharedLogin].isUserRederrerRequested = NO;
#warning test 清除数据
    //清除cookie
    [[USCookieHelper sharedHelper] removeDiskCache];
    //清除用户选择的分享模板
    [ShareParseTool clearUserPickTemplate];
    //停止首页定时器
    //[[UleRedPacketRainLocalManager sharedManager] countDownStop];
    //取消本地推送
    //[[US_LocalNotification sharedManager] cancelRedPacketRainLocalNotification:UleRedPacketNotiKeys];
    //一键登录需要重新初始化
    [CLShanYanSDKManager initWithAppId:[UleStoreGlobal shareInstance].config.shanyanAppID complete:^(CLCompleteResult * _Nonnull completeResult) {
        NSLog(@"%@",completeResult);
    }];
}

/** 账号注销 */
+ (void)accountCancellationSuccess{
    //***** 比退出登录 多删除一个本地登录名 *****
    [self saveLoginName:@""];
}

- (void)setIsUserRederrerRequested:(BOOL)isUserRederrerRequested
{
    [UserDefaultManager setLocalDataBoolen:isUserRederrerRequested key:[NSString stringWithFormat:@"%@_userReferRequested", [US_UserUtility sharedLogin].m_userId]];
}

- (BOOL)isUserRederrerRequested{
   return [UserDefaultManager getLocalDataBoolen:[NSString stringWithFormat:@"%@_userReferRequested", [US_UserUtility sharedLogin].m_userId]];
}

-(NSString *)payPwdStatus{
    NSString *payPwdStatus=[UserDefaultManager getLocalDataString:[NSString stringWithFormat:@"%@_payPwStatus", self.m_userId]];
    return payPwdStatus?payPwdStatus:@"";
}

+ (void)savePayPwdStatus:(NSString *)payPwdStatus{
    [UserDefaultManager setLocalDataString:payPwdStatus?payPwdStatus:@"" key:[NSString stringWithFormat:@"%@_payPwStatus", [US_UserUtility sharedLogin].m_userId]];
}

- (NSString *)enterpriseMark
{
    NSString *enterpriseMark=[UserDefaultManager getLocalDataString:[NSString stringWithFormat:@"%@_enterpriseMark", [US_UserUtility sharedLogin].m_userId]];
    return enterpriseMark;
}

- (void)setEnterpriseMark:(NSString *)enterpriseMark
{
    [UserDefaultManager setLocalDataString:enterpriseMark?enterpriseMark:@"" key:[NSString stringWithFormat:@"%@_enterpriseMark", [US_UserUtility sharedLogin].m_userId]];
}

+ (void)saveOpenUDID{
    NSString *openUDID = [UserDefaultManager getLocalDataString:keyUserData_openUDID];
    if ([NSString isNullToString:openUDID].length==0) {
        [UserDefaultManager setLocalDataString:[OpenUDID value] key:keyUserData_openUDID];
    }
}
-(NSString *)openUDID{
    if ([NSString isNullToString:_openUDID].length==0) {
        _openUDID=[OpenUDID value];
        if (_openUDID.length<=0) {
            _openUDID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
        [UserDefaultManager setLocalDataString:_openUDID key:keyUserData_openUDID];
    }
    return _openUDID;
}

+ (void)saveIsUserLogin:(BOOL)isLogin {
    [UserDefaultManager setLocalDataBoolen:isLogin key:keyUserData_isLogin];
    [US_UserUtility sharedLogin].mIsLogin = isLogin;
}

+ (void)saveLoginName:(NSString *)loginName{
    [UserDefaultManager setLocalDataString:loginName key:keyUserData_loginName];
    [US_UserUtility sharedLogin].m_loginName = loginName;
}

+ (void)saveUserName:(NSString *)loginName{
    [UserDefaultManager setLocalDataString:loginName key:keyUserData_userName];
    [US_UserUtility sharedLogin].m_userName = loginName;
}

+ (void)saveUserId:(NSString *)userId{
    [UserDefaultManager setLocalDataString:userId key:keyUserData_userId];
    [US_UserUtility sharedLogin].m_userId = userId;
    [UserDefaultManager setLocalDataString:userId key:keyUserData_open_userId];
    [US_UserUtility sharedLogin].open_userId = userId;
}

+ (void)saveStationName:(NSString *)stationName{
    if ([NSString isNullToString:stationName].length==0) {
        stationName=[NSString stringWithFormat:@"%@的小店", [US_UserUtility sharedLogin].m_userName];
    }
    [UserDefaultManager setLocalDataString:stationName key:keyUserData_stationName];
    [US_UserUtility sharedLogin].m_stationName = stationName;
}

+ (void)saveStoreDesc:(NSString *)storeDesc{
    if ([NSString isNullToString:storeDesc].length==0) {
        storeDesc=@"有一家不错的店铺！分享给你们";
    }
    [UserDefaultManager setLocalDataString:storeDesc key:keyUserData_storeDesc];
    [US_UserUtility sharedLogin].m_storeDesc = storeDesc;
}

+ (void)saveMobileNumber:(NSString *)mobileNumber{
    mobileNumber=mobileNumber?mobileNumber:@"";
    [UserDefaultManager setLocalDataString:mobileNumber key:keyUserData_mobileNumber];
    [US_UserUtility sharedLogin].m_mobileNumber = mobileNumber;
}

+ (void)saveUserHeadImgUrl:(NSString *)userHeadImgUrl
{
    if ([NSString isNullToString:userHeadImgUrl].length>0&&![userHeadImgUrl isEqualToString:[US_UserUtility sharedLogin].m_userHeadImgUrl]) {
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:userHeadImgUrl] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            // 保存数据
            if (image&&data.length>0) {
                [self saveUserHeadImageData:data];
            }
        }];
    }
    [UserDefaultManager setLocalDataString:userHeadImgUrl key:keyUserData_userHeadImgUrl];
    [US_UserUtility sharedLogin].m_userHeadImgUrl = userHeadImgUrl;
}

+ (void)saveUserHeadImageData:(NSData *)headImageData{
    
    [UserDefaultManager setLocalDataObject:headImageData key:keyUserData_userHeadImage];
    [US_UserUtility sharedLogin].m_userHeadImage = [UIImage imageWithData:headImageData];
}

+ (void)saveUserToken:(NSString *)userToken{
    [UserDefaultManager setLocalDataString:userToken key:keyUserData_userToken];
    [US_UserUtility sharedLogin].m_userToken = userToken?userToken:@"";
}

+ (void)saveDeviceToken:(NSString *)deviceToken{
    [UserDefaultManager setLocalDataString:deviceToken key:keyUserData_deviceToken];
    [US_UserUtility sharedLogin].m_deviceToken = deviceToken;
}

+ (void)saveIsUserProtocol:(NSString *)isUserProtocol{
    [UserDefaultManager setLocalDataString:isUserProtocol key:keyUserData_isUserProtocol];
    [US_UserUtility sharedLogin].m_isUserProtocol = isUserProtocol;
}

+  (void)saveProtocolUrl:(NSString *)protocolUrl{
    [UserDefaultManager setLocalDataString:protocolUrl key:keyUserData_protocolUrl];
    [US_UserUtility sharedLogin].m_protocolUrl = protocolUrl;
}

+ (void)saveCarInsurance:(NSString *)carInsurance{
    [UserDefaultManager setLocalDataObject:carInsurance key:keyUserData_carInsurance];
    [US_UserUtility sharedLogin].m_carInsurance = carInsurance;
}

+ (void)saveWebsiteType:(NSString *)websiteType{
    [UserDefaultManager setLocalDataString:websiteType key:keyUserData_websiteType];
    [US_UserUtility sharedLogin].m_websiteType = websiteType;
}

+ (void)saveLockFlag:(NSString *)lockFlag{
    [UserDefaultManager setLocalDataString:lockFlag key:keyUserData_lockFlag];
    [US_UserUtility sharedLogin].m_lockFlag = lockFlag;
}

+ (void)saveDonateFlag:(NSString *)donateFlag{
    [UserDefaultManager setLocalDataString:donateFlag key:keyUserData_donateFlag];
    [US_UserUtility sharedLogin].m_donateFlag = donateFlag;
}

+ (void)saveQualificationFlag:(NSString *)qualificationFlag{
    [UserDefaultManager setLocalDataString:qualificationFlag key:keyUserData_qualificationFlag];
    [US_UserUtility sharedLogin].qualificationFlag = qualificationFlag;
}

+ (void)saveIdentifiedFlag:(NSString *)identifiedFlag{
    if ([NSString isNullToString:identifiedFlag].length==0) {
        identifiedFlag=@"0";
    }
    [UserDefaultManager setLocalDataString:identifiedFlag key:keyUserData_identifiedFlag];
    [US_UserUtility sharedLogin].identifiedFlag = identifiedFlag;
}

+ (void)saveYzgFlag:(NSString *)yzgFlag{
    [UserDefaultManager setLocalDataString:yzgFlag key:keyUserData_yzgFlag];
    [US_UserUtility sharedLogin].m_yzgFlag = yzgFlag;
}

+ (void)saveUserReferrerId:(NSString *)userReferrerId{
    [UserDefaultManager setLocalDataString:userReferrerId key:keyUserData_userReferrerId];
    [US_UserUtility sharedLogin].m_userReferrerId = userReferrerId;
}

+ (void)saveUserMallCookie:(NSString *)mallCookie{
    [UserDefaultManager setLocalDataString:mallCookie key:keyUserData_mallCookie];
    [US_UserUtility sharedLogin].m_mallCookie = mallCookie;
}

+ (void)saveOrgType:(NSString *)orgType{
    [UserDefaultManager setLocalDataString:orgType key:keyUserData_orgType];
    [US_UserUtility sharedLogin].m_orgType = orgType;
}

+ (void)saveOrgCode:(NSString *)orgCode{
    [UserDefaultManager setLocalDataString:orgCode key:keyUserData_orgCode];
    [US_UserUtility sharedLogin].m_orgCode = orgCode;
}

+ (void)saveOrgName:(NSString *)orgName{
    if ([US_UserUtility sharedLogin].enterpriseFlag&&[NSString isNullToString:orgName].length==0){
        orgName=@"中国邮政集团公司";
    }
    [UserDefaultManager setLocalDataString:orgName key:keyUserData_orgName];
    [US_UserUtility sharedLogin].m_orgName = orgName;
}

+ (void)saveOrgProvinceCode:(NSString *)provinceCode{
    [UserDefaultManager setLocalDataString:provinceCode key:keyUserData_orgProvinceCode];
    [US_UserUtility sharedLogin].m_provinceCode = provinceCode;
}

+ (void)saveOrgProvinceName:(NSString *)provinceName{
    [UserDefaultManager setLocalDataString:provinceName key:keyUserData_orgProvinceName];
    [US_UserUtility sharedLogin].m_provinceName = provinceName;
}

+ (void)saveOrgCityCode:(NSString *)cityCode{
    [UserDefaultManager setLocalDataString:cityCode key:keyUserData_orgCityCode];
    [US_UserUtility sharedLogin].m_cityCode = cityCode;
}

+ (void)saveOrgCityName:(NSString *)cityName{
    [UserDefaultManager setLocalDataString:cityName key:keyUserData_orgCityName];
    [US_UserUtility sharedLogin].m_cityName = cityName;
}

+ (void)saveOrgAreaCode:(NSString *)areaCode{
    [UserDefaultManager setLocalDataString:areaCode key:keyUserData_orgAreaCode];
    [US_UserUtility sharedLogin].m_areaCode = areaCode;
}

+ (void)saveOrgAreaName:(NSString *)areaName{
    [UserDefaultManager setLocalDataString:areaName key:keyUserData_orgAreaName];
    [US_UserUtility sharedLogin].m_areaName = areaName;
}

+ (void)saveOrgTownCode:(NSString *)townCode{
    [UserDefaultManager setLocalDataString:townCode key:keyUserData_orgTownCode];
    [US_UserUtility sharedLogin].m_townCode = townCode;
}

+ (void)saveOrgTownName:(NSString *)townName{
    [UserDefaultManager setLocalDataString:townName key:keyUserData_orgTownName];
    [US_UserUtility sharedLogin].m_townName = townName;
}

+ (void)saveEnterpriseOrgFlag:(NSString *)enterpriseFlag{
    [UserDefaultManager setLocalDataBoolen:[enterpriseFlag boolValue] key:keyUserData_enterpriseOrgFlag];
    [US_UserUtility sharedLogin].enterpriseFlag = [enterpriseFlag boolValue];
}

+ (void)savePixiaoZoneId:(NSArray *)pixiaoZoneId{
    [UserDefaultManager setLocalDataObject:pixiaoZoneId key:keyUserData_pixiaoZoneId];
    [US_UserUtility sharedLogin].pixiaoZoneId = pixiaoZoneId;
}

+(NSString *)getLocalPreviewUrl{
    NSString *localUrlStr=[UserDefaultManager getLocalDataString:keyUserData_previewUrl];
    return localUrlStr?localUrlStr:@"";
}
+ (void)saveLocalPreviewUrl:(NSString *)urlStr{

    [UserDefaultManager setLocalDataString:urlStr key:keyUserData_previewUrl];
}

/**扫码域名限制**/
+ (void)saveLimitDomain:(NSString *)domainStr{
    [UserDefaultManager setLocalDataString:domainStr key:keyUserData_limitDomain];
}
+ (NSString *)getLimitDomain{
    NSString *locallimtDomain=[UserDefaultManager getLocalDataString:keyUserData_limitDomain];
    return locallimtDomain?locallimtDomain:@"";
}

#pragma mark - 实名认证
+ (void)setUserRealNameAuthorization:(BOOL)isAuthorized{
    [UserDefaultManager setLocalDataBoolen:isAuthorized key:[NSString stringWithFormat:@"REALNAME_%@",[US_UserUtility sharedLogin].m_userId]];
}
+ (BOOL)isUserRealNameAuthorized{
    BOOL isAuthorized=[UserDefaultManager getLocalDataBoolen:[NSString stringWithFormat:@"REALNAME_%@",[US_UserUtility sharedLogin].m_userId]];
    return isAuthorized;
}

+ (BOOL)isNeedGetUleFavoritList{
    BOOL hasUleFavoritList=[UserDefaultManager getLocalDataBoolen:[NSString stringWithFormat:@"isNeedShowCollect_%@",[US_UserUtility sharedLogin].m_userId]];
    return hasUleFavoritList;
}

+ (NSString *)getLowestOrganizationName
{
    NSString *lowestOrgName = [US_UserUtility sharedLogin].m_provinceName;
    if ([NSString isNullToString:[US_UserUtility sharedLogin].m_townName].length>0) {
        lowestOrgName = [US_UserUtility sharedLogin].m_townName;
    }else if ([NSString isNullToString:[US_UserUtility sharedLogin].m_areaName].length>0) {
        lowestOrgName = [US_UserUtility sharedLogin].m_areaName;
    }else if ([NSString isNullToString:[US_UserUtility sharedLogin].m_cityName].length>0) {
        lowestOrgName = [US_UserUtility sharedLogin].m_cityName;
    }
    return lowestOrgName;
}

+ (void)setIsNeedGetUleFavoritList:(BOOL)isNeedShowCollect{
    [UserDefaultManager setLocalDataBoolen:isNeedShowCollect key:[NSString stringWithFormat:@"isNeedShowCollect_%@",[US_UserUtility sharedLogin].m_userId]];
}

+ (BOOL)isLimitedForRedPacket{
    NSString *saveKey = [NSString stringWithFormat:@"redpacketCash_%@_%@", [US_UserUtility sharedLogin].m_userId, [NSDate GetCurrentDateByDay:[NSDate date]]];
    NSInteger savedCount = [UserDefaultManager getLocalDataInt:saveKey];
    NSString *serverLimitStr = [US_UserUtility sharedLogin].redPacketLimitCount;
    NSInteger serverCount = 3;//默认3次
    if (serverLimitStr&&serverLimitStr.length>0) {
        serverCount = [serverLimitStr integerValue];
    }
    USLog(@"今日抽奖已达%@次 限制%@次", @(savedCount), @(serverCount));
    return savedCount>=serverCount;
}

+ (void)increaseLimitForRedPacket{
    NSString *saveKey = [NSString stringWithFormat:@"redpacketCash_%@_%@", [US_UserUtility sharedLogin].m_userId, [NSDate GetCurrentDateByDay:[NSDate date]]];
    NSInteger savedCount = [UserDefaultManager getLocalDataInt:saveKey];
    savedCount++;
    [UserDefaultManager setLocalDataInt:savedCount key:saveKey];
}

- (NSDate *)notificationAlertShowedDate{
    return [UserDefaultManager getLocalDataObject:keyUserData_notificationAlertShowedDate];
}

- (void)setNotificationAlertShowedDate:(NSDate *)notificationAlertShowedDate{
    [UserDefaultManager setLocalDataObject:notificationAlertShowedDate key:keyUserData_notificationAlertShowedDate];
}

- (NSDate *)versionUpdateAlertShowedDate{
    return [UserDefaultManager getLocalDataObject:keyUserData_versionUpdateAlertShowedDate];
}

- (void)setVersionUpdateAlertShowedDate:(NSDate *)versionUpdateAlertShowedDate{
    [UserDefaultManager setLocalDataObject:versionUpdateAlertShowedDate key:keyUserData_versionUpdateAlertShowedDate];
}

- (NSDate *)userMallCookieRequestedDate{
    return [UserDefaultManager getLocalDataObject:keyUserData_userMallCookieRequestedDate];
}

- (void)setUserMallCookieRequestedDate:(NSDate *)userMallCookieRequestedDate{
    [UserDefaultManager setLocalDataObject:userMallCookieRequestedDate key:keyUserData_userMallCookieRequestedDate];
}

+ (BOOL)isNeedShowNotificationAlertView{
    BOOL isSameDay = [NSDate isSameDay:[NSDate date] date2:[US_UserUtility sharedLogin].notificationAlertShowedDate];
    return ![USAuthorizetionHelper currentNotificationAllowed]&&!isSameDay;
}

+ (BOOL)isNeedShowVersionUpdateAlertView{
    BOOL isSameDay = [NSDate isSameDay:[NSDate date] date2:[US_UserUtility sharedLogin].versionUpdateAlertShowedDate];
    return !isSameDay;
}

+(void)saveCurrentdateWithKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)isTodaySavedForKey:(NSString *)savedKey{
    NSDate *savedDate=[[NSUserDefaults standardUserDefaults]objectForKey:savedKey];
    if (savedDate==nil) {
        return NO;
    }else return [NSDate isSameDay:savedDate date2:[NSDate date]];
}

+ (void)saveLoginName:(NSString *)p_loginName
           usrOnlyid:(NSString *)p_usrOnlyid
        mobileNumber:(NSString *)p_mobileNumber
             headImg:(NSString *)p_headImg
           userToken:(NSString *)p_userToken
         stationName:(NSString *)p_stationName
            storeDesc:(NSString *)p_storeDesc
            userName:(NSString *)p_userName
      isUserProtocol:(NSString *)p_isUserProtocol
         protocolUrl:(NSString *)p_protocolUrl
        carInsurance:(NSString *)p_carInsurance
         websiteType:(NSString *)p_websiteType
            lockFlag:(NSString *)p_lockFlag
          donateFlag:(NSString *)p_donateFlag
    qualificationFlag:(NSString *)p_qualificationFlag
       identifiedFlag:(NSString *)p_identifiedFlag
              yzgFlag:(NSString *)p_yzgFlag
{
    [self saveLoginName:p_loginName];
    [self saveUserId:p_usrOnlyid];
    [self saveMobileNumber:p_mobileNumber];
    [self saveUserHeadImgUrl:p_headImg];
    [self saveUserToken:p_userToken];
    [self saveUserName:p_userName];
    [self saveStationName:p_stationName];
    [self saveStoreDesc:p_storeDesc];
    [self saveIsUserProtocol:p_isUserProtocol];
    [self saveProtocolUrl:p_protocolUrl];
    [self saveCarInsurance:p_carInsurance];
    [self saveWebsiteType:p_websiteType];
    [self saveLockFlag:p_lockFlag];
    [self saveDonateFlag:p_donateFlag];
    [self saveQualificationFlag:p_qualificationFlag];
    [self saveIdentifiedFlag:p_identifiedFlag];
    [self saveYzgFlag:p_yzgFlag];
    [LogStatisticsManager addUserId:p_usrOnlyid];
}

+ (void)saveOrgType:(NSString *)p_orgType
            orgCode:(NSString *)p_orgCode
            orgName:(NSString *)p_orgName
    orgProvinceCode:(NSString *)p_provinceCode
    orgProvinceName:(NSString *)p_provinceName
        orgCityCode:(NSString *)p_cityCode
        orgCityName:(NSString *)p_cityName
        orgAreaCode:(NSString *)p_areaCode
        orgAreaName:(NSString *)p_areaName
        orgTownCode:(NSString *)p_townCode
        orgTownName:(NSString *)p_townName
  enterpriseOrgFlag:(NSString *)p_enterpriseFlag
{
    if ([p_enterpriseFlag isEqualToString:@"1"]&&[NSString isNullToString:p_orgName].length<=0) {
        p_orgName=@"中国邮政集团公司";
    }
    [self saveEnterpriseOrgFlag:p_enterpriseFlag];
    [self saveOrgType:p_orgType];
    [self saveOrgCode:p_orgCode];
    [self saveOrgName:p_orgName];
    [self saveOrgProvinceCode:p_provinceCode];
    [self saveOrgProvinceName:p_provinceName];
    [self saveOrgCityCode:p_cityCode];
    [self saveOrgCityName:p_cityName];
    [self saveOrgAreaCode:p_areaCode];
    [self saveOrgAreaName:p_areaName];
    [self saveOrgTownCode:p_townCode];
    [self saveOrgTownName:p_townName];
    [LogStatisticsManager addxdsCode:[US_UserUtility sharedLogin].m_townCode xdaCode:[US_UserUtility sharedLogin].m_areaCode xdcCode:[US_UserUtility sharedLogin].m_cityCode xdpCode:[US_UserUtility sharedLogin].m_provinceCode xdOrgCode:[US_UserUtility sharedLogin].m_orgCode xdorgType:[US_UserUtility sharedLogin].m_orgType];
}

+ (void)saveLastOrgId:(NSString *)p_lastOrgId{
    [UserDefaultManager setLocalDataString:p_lastOrgId key:keyUserData_lastOrgId];
    [US_UserUtility sharedLogin].m_lastOrgId = [NSString isNullToString:p_lastOrgId];
}
+ (void)saveLastOrgName:(NSString *)p_lastOrgName{
    [UserDefaultManager setLocalDataString:p_lastOrgName key:keyUserData_lastOrgName];
    [US_UserUtility sharedLogin].m_lastOrgName = [NSString isNullToString:p_lastOrgName];
}

+ (void)recordVersion{
    
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    NSString *versionString = [accountDefaults objectForKey:@"ule_version"];
    
    if (![versionString isEqualToString:@"0"]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *plistPath=[documentsDirectory stringByAppendingPathComponent:@"version.plist"];
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc] init];
        
        [dictplist setObject:NonEmpty([UleStoreGlobal shareInstance].config.versionNum) forKey:@"version"];
        [dictplist setObject:@"" forKey:@"old_version"];         // old：300
        [US_UserUtility sharedLogin].oldVersion = @"";
        
        [dictplist writeToFile:plistPath atomically:YES];
        
        //不再重复写入
        NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
        [accountDefaults setObject:@"0" forKey:@"ule_version"];
    }
    
}

+ (void)updataVersion{
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingPathComponent:@"version.plist"];
    NSMutableDictionary *applist = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] mutableCopy];
    NSString *ver_new = [applist objectForKey:@"version"];
    NSString *ver_old = [applist objectForKey:@"old_version"];
    if ([ver_new intValue] < [NonEmpty([UleStoreGlobal shareInstance].config.versionNum) intValue]) {
        
        NSString *ver_old = ver_new;
        ver_new = NonEmpty([UleStoreGlobal shareInstance].config.versionNum);
        
        [applist setObject:ver_new forKey:@"version"];
        [applist setObject:ver_old forKey:@"old_version"];
        [applist writeToFile:path atomically:YES];
    }
    [US_UserUtility sharedLogin].oldVersion = ver_old;
}

+ (void)saveCommsionTitle:(NSString *)title{
    [UserDefaultManager setLocalDataString:title key:keyUserData_commisionTitle];
}
+ (NSString *)commisionTitle{
    NSString * title=[UserDefaultManager getLocalDataString:keyUserData_commisionTitle];
    if (title==nil) {
        title=@"";
    }
    return title;
}

+ (void)saveHomeListingFlag:(NSString *)flag{
    [UserDefaultManager setLocalDataString:flag key:keyUserData_homeListingFlag];
}
+ (NSString *)homeListingFlag{
    NSString *flag=[NSString isNullToString:[UserDefaultManager getLocalDataString:keyUserData_homeListingFlag]];
    if (flag.length==0) {
        flag=@"0";
    }
    return flag;
}

+ (void)setPoststore_my_update:(NSString *)poststore_my_update {
    [UserDefaultManager setLocalDataString:poststore_my_update key:[NSString stringWithFormat:@"poststore_my_update_%@", [US_UserUtility sharedLogin].m_userId]];
}

+ (NSString *)poststore_my_update {
    return [UserDefaultManager getLocalDataString:[NSString stringWithFormat:@"poststore_my_update_%@", [US_UserUtility sharedLogin].m_userId]];
}

//获取省份名称，先取用户信息，用户信息没有取定位，没有定位返回空（全国）
+ (NSString *)getUserOrLocationProvinceName{
    NSString *provinceName = @"";
    if ([US_UserUtility sharedLogin].enterpriseFlag && [NSString isNullToString:[US_UserUtility sharedLogin].m_provinceName].length > 0) {
        provinceName = [US_UserUtility sharedLogin].m_provinceCode;
    } else if ([USLocationManager sharedLocation].lastProvince.length > 0) {
        provinceName = [USLocationManager sharedLocation].lastProvince;
    }
    return provinceName;
}

//获取批销zoneId拼接的字符串，以逗号分隔
+ (NSString *)getPixiaoZoneIdWithComma{
    NSString *zoneIdStr=@"";
    NSArray *localZoneIdArr=[US_UserUtility sharedLogin].pixiaoZoneId;
    if (localZoneIdArr) {
        for (int i=0;i<localZoneIdArr.count;i++) {
            zoneIdStr=[zoneIdStr stringByAppendingFormat:@"%@,",[localZoneIdArr objectAt:i]];
        }
    }
    zoneIdStr=[NSString removeTheLastOneStr:zoneIdStr];
    return zoneIdStr;
}

@end
