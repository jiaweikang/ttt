//
//  US_UserUtility.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDefaultManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_UserUtility : NSObject

@property (nonatomic, assign) BOOL mIsLogin;
@property (nonatomic, copy)NSString * m_loginName;//用户登录名
@property (nonatomic, copy)NSString * m_userName;//用户名
@property (nonatomic, copy)NSString * m_userId;//userid
@property (nonatomic, copy)NSString * m_stationName;// 店名
@property (nonatomic, copy)NSString * m_storeDesc;//店铺分享介绍
@property (nonatomic, copy)NSString * m_mobileNumber;//村邮站账号 -- 手机号
@property (nonatomic, copy)NSString * m_userHeadImgUrl;//头像链接
@property (nonatomic, strong)UIImage* m_userHeadImage;//头像
@property (nonatomic, copy)NSString * m_userToken;//userToken
@property (nonatomic, copy)NSString * m_deviceToken;//deviceToken
@property (nonatomic, copy)NSString * m_isUserProtocol;
@property (nonatomic, copy)NSString * m_protocolUrl;
@property (nonatomic, copy)NSString * m_carInsurance;
@property (nonatomic, copy)NSString * m_lockFlag;
@property (nonatomic, copy)NSString * m_donateFlag;
@property (nonatomic, copy)NSString * qualificationFlag;//1-开通了自有商品
@property (nonatomic, copy)NSString * identifiedFlag;//0-非认证员工 1-认证员工
@property (nonatomic, copy)NSString * m_yzgFlag;//是否邮掌柜用户0-未开通 1-开通

@property (nonatomic, copy)NSString * m_websiteType;//网点类型-标记移动掌柜类型
@property (nonatomic, copy)NSString * m_userReferrerId;//推荐人id
@property (nonatomic, copy)NSString * openUDID;
@property (nonatomic, copy)NSString * m_mallCookie;
//open接口专用，退出/注销不清除
@property (nonatomic, copy)NSString * open_userId;
//是否第一次在此设备登录（为了补open接口数据缺失）
@property (nonatomic, assign)BOOL   isUserFirstLogin;

//用户地址信息
@property (nonatomic, copy) NSString    *m_orgType; //企业类型code --chenhan
@property (nonatomic, copy) NSString    *m_orgCode;
@property (nonatomic, copy) NSString    *m_orgName; //企业名称
@property (nonatomic, copy) NSString    *m_provinceCode;
@property (nonatomic, copy) NSString    *m_provinceName;
@property (nonatomic, copy) NSString    *m_cityCode;
@property (nonatomic, copy) NSString    *m_cityName;
@property (nonatomic, copy) NSString    *m_areaCode;
@property (nonatomic, copy) NSString    *m_areaName;
@property (nonatomic, copy) NSString    *m_townCode;
@property (nonatomic, copy) NSString    *m_townName;
@property (nonatomic, copy) NSString    *m_lastOrgId;
@property (nonatomic, copy) NSString    *m_lastOrgName;
@property (nonatomic, assign) BOOL      enterpriseFlag;//"0"表示为邮乐用户  "1"表示为集团+各省（排除邮乐相关机构）

@property (nonatomic, strong) NSArray   *pixiaoZoneId;//批销的专区号

@property (nonatomic, copy) NSString    *myStoreLink;
@property (nonatomic, assign)BOOL       isShowOrderSendout;//是否展示发货按钮

@property (nonatomic, copy) NSString    *bankCardCount;//银行卡数量
//我的钱包是否显示金豆
@property (nonatomic, assign) BOOL      isShowGoldBean;
@property (nonatomic, copy) NSString    *goldBeanAction;//金豆红包的跳转链接

@property (nonatomic, copy) NSString    *oldVersion;

@property (nonatomic, copy)NSString * payPwdStatus;//是否设置过支付密码
@property (nonatomic, assign) BOOL    isUserRederrerRequested;//推荐人是否请求成功过
@property (nonatomic, copy)NSString * redPacketLimitCount;//一天约束的抽奖次数
@property (nonatomic, strong)NSDate * notificationAlertShowedDate;//通知提示框显示的时间
@property (nonatomic, strong)NSDate * versionUpdateAlertShowedDate;//版本更新显示时间
@property (nonatomic, strong)NSDate * userMallCookieRequestedDate;//mallCookie请求成功的时间
@property (nonatomic, strong) NSString *enterpriseMark; //当前展示企业还是掌柜模块  1掌柜 2企业


/* 非本地保存 */
@property (nonatomic, assign) BOOL isPushOwnListDetail; //自有商品货款是否跳转详情页面，详情页面返回不刷新列表
@property (nonatomic, assign) BOOL hasCSzg; //cs后台是否配置掌柜模块
@property (nonatomic, assign) BOOL hasCSqy; //cs后台是否配置企业模块

+ (instancetype)sharedLogin;

//退出登录
+ (void)logoutSuccess;
/** 账号注销 */
+ (void)accountCancellationSuccess;
//UUID
+ (void)saveOpenUDID;
//是否登录
+ (void)saveIsUserLogin:(BOOL)isLogin;
// 用户登录名
//+ (void)saveLoginName:(NSString *)loginName;
//用户名
+ (void)saveUserName:(NSString *)loginName;
// userId
+ (void)saveUserId:(NSString *)userId;
//店名
+ (void)saveStationName:(NSString *)stationName;
//店铺分享介绍
+ (void)saveStoreDesc:(NSString *)storeDesc;
//手机号
//+ (void)saveMobileNumber:(NSString *)mobileNumber;
//头像
+ (void)saveUserHeadImgUrl:(NSString *)userHeadImgUrl;
//userToken
+ (void)saveUserToken:(NSString *)userToken;
//deviceToken
+ (void)saveDeviceToken:(NSString *)deviceToken;

//isUserProtocol
+ (void)saveIsUserProtocol:(NSString *)isUserProtocol;
//protocolUrl
+ (void)saveProtocolUrl:(NSString *)protocolUrl;

//+ (void)saveWebsiteType:(NSString *)websiteType;

+ (void)saveUserReferrerId:(NSString *)userReferrerId;

+ (void)saveUserMallCookie:(NSString *)mallCookie;

+ (void)savePayPwdStatus:(NSString *)payPwdStatus;

+ (void)setUserRealNameAuthorization:(BOOL)isAuthorized;

+ (BOOL)isUserRealNameAuthorized;

+ (NSString *)getLocalPreviewUrl;

+ (void)saveLocalPreviewUrl:(NSString *)urlStr;

//批销专区id
+ (void)savePixiaoZoneId:(NSArray * __nullable)pixiaoZoneId;

/**扫码域名限制**/
+ (void)saveLimitDomain:(NSString *)domainStr;

+ (NSString *)getLimitDomain;

//最低一级的机构名称
+ (NSString *)getLowestOrganizationName;

+ (BOOL)isNeedGetUleFavoritList;

+ (void)setIsNeedGetUleFavoritList:(BOOL)isNeedShowCollect;

//红包一天抽奖次数限制
+ (BOOL)isLimitedForRedPacket;
+ (void)increaseLimitForRedPacket;
//提醒开启通知的弹框
+ (BOOL)isNeedShowNotificationAlertView;
//版本更新弹框 非强制更新 一天弹出一次
+ (BOOL)isNeedShowVersionUpdateAlertView;
//保存时间
+(void)saveCurrentdateWithKey:(NSString *)key;
+(BOOL)isTodaySavedForKey:(NSString *)savedKey;

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
              yzgFlag:(NSString *)p_yzgFlag;

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
  enterpriseOrgFlag:(NSString *)p_enterpriseFlag;

+ (void)saveLastOrgId:(NSString *)p_lastOrgId;
+ (void)saveLastOrgName:(NSString *)p_lastOrgName;

+ (void)recordVersion;

+ (void)updataVersion;

+ (void)saveCommsionTitle:(NSString *)title;
+ (NSString *)commisionTitle;

+ (void)saveHomeListingFlag:(NSString *)flag;
+ (NSString *)homeListingFlag;

+ (void)setPoststore_my_update:(NSString *)poststore_my_update;

+ (NSString *)poststore_my_update;

+ (NSString *)getUserOrLocationProvinceName;

//获取批销zoneId拼接的字符串，以逗号分隔
+ (NSString *)getPixiaoZoneIdWithComma;
@end

NS_ASSUME_NONNULL_END
