//
//  UleStoreConfigure.h
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/13.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
NS_ASSUME_NONNULL_BEGIN

@protocol UleStoreConfigureProtocol <NSObject>

@required
- (NSString *) clientType;
- (NSString *) appName;
- (NSString *) agentPrefix;
- (NSString *) agentClientTracklog;
- (NSString *) appKey;
- (NSString *) appVersion;
- (NSString *) versionNum;
- (NSString *) appLogoUrl;
- (NSString *) AppGroupsID;
- (NSString *) appChannelID;
- (NSString *) appSecretKey;
- (NSString *) pixiao_appID;
- (NSString *) pixiao_secret;
- (NSString *) logAppKey;
- (NSString *) UMAppKey;
- (NSString *) buglyAppID;
- (NSString *) tencentAppKey;
- (NSString *) wxAppKeyPay;
- (NSString *) wxAppKeyShare;
- (NSString *) universalLink;
- (NSString *) storeScheme;
- (NSString *) alipayScheme;
- (NSString *) unionScheme;
- (NSString *) shanyanAppID;
- (NSString *) shanyanAppKey;
- (NSString *) serverProtocol;
- (NSString *) isShowRegistBtn;
- (NSInteger) envSer;
- (NSString *) userProvinceIdOrProvinceName;
- (NSString *) messageChannel;
- (NSString *) messageType;

@optional

- (NSString *)sectionKey_GoodsSourceTab;
- (NSString *)sectionKey_StoreButtonList;
- (NSString *)sectionKey_GuidePage;

- (NSString *) sectionKey_Tabbar;
- (NSString *) sectionKey_Dialog;
- (NSString *) sectionKey_Invited;
- (NSString *) sectionKey_Update;
- (NSString *) sectionKey_UserCenter;
- (NSString *) sectionKey_CancelReason;
- (NSString *) sectionKey_EvaluateLabels;
- (NSString *) sectionKey_ProceedInfo;
- (NSString *) sectionKey_toutiao_list;
- (NSString *) sectionKey_bottom_banner;
- (NSString *) sectionKey_index_storey;
- (NSString *) sectionKey_index_storeySecond;
- (NSString *) sectionKey_HomeRefresh;
- (NSString *) sectionKey_DropDownRefresh;
- (NSString *) sectionKey_insurance;
- (NSString *) sectionKey_ownGoodstips;
- (NSString *) sectionKey_homeBottomRecommend;
- (NSString *) sectionKey_wallet;
- (NSString *) sectionKey_OrderList;
- (NSString *) sectionKey_ShareImage;
- (NSString *) sectionKey_wholesaleList;

- (NSString *) api_walletInfo;
- (NSString *) api_searchGoodSource;

@end

@interface UleStoreConfigure : NSObject
/**App 信息**/
@property (nonatomic, copy,readonly) NSString * clientType;//接口请求的clientType
@property (nonatomic, copy,readonly) NSString * cookie_clientType;//写入cookie的clientType
@property (nonatomic, copy,readonly) NSString * appName;//appName
@property (nonatomic, copy,readonly) NSString * agentClientTracklog;//userAgent日志的客户端类型
@property (nonatomic, copy,readonly) NSString * agentPrefix;//userAgent的前部
@property (nonatomic, copy,readonly) NSString * appKey;
@property (nonatomic, copy,readonly) NSString * appVersion;
@property (nonatomic, copy,readonly) NSString * versionNum;
@property (nonatomic, copy,readonly) NSString * appLogoUrl;//app的icon链接
@property (nonatomic, copy,readonly) NSString * AppGroupsID;
@property (nonatomic, copy,readonly) NSString * appChannelID;
@property (nonatomic, copy,readonly) NSString * appSecretKey;
@property (nonatomic, copy,readonly) NSString * pixiao_appID;
@property (nonatomic, copy,readonly) NSString * pixiao_secret;
@property (nonatomic, copy,readonly) NSString * logAppKey;
@property (nonatomic, copy,readonly) NSString * UMAppKey;
@property (nonatomic, copy,readonly) NSString * buglyAppID;
@property (nonatomic, copy,readonly) NSString * tencentAppKey;
@property (nonatomic, copy,readonly) NSString * userProvinceIdOrProvinceName;

/**微信**/
@property (nonatomic, copy,readonly) NSString * wxAppKeyPay;
@property (nonatomic, copy,readonly) NSString * wxAppKeyShare;
/**universal link**/
@property (nonatomic, copy,readonly) NSString * universalLink;
/**Scheme**/
@property (nonatomic, copy,readonly) NSString * storeScheme;
@property (nonatomic, copy,readonly) NSString * alipayScheme;
@property (nonatomic, copy,readonly) NSString * unionScheme;

//闪验
@property (nonatomic, copy,readonly) NSString * shanyanAppID;
@property (nonatomic, copy,readonly) NSString * shanyanAppKey;

//服务协议
@property (nonatomic, copy,readonly) NSString * serverProtocol;
//是否需要显示注册按钮
@property (nonatomic, copy,readonly) NSString * isShowRegistBtn;
//是否需要显示货源市场按钮
@property (nonatomic, copy,readonly) NSString * isShowGoodsSourceBtn;
//是否显示小店模块 当日取消收益
@property (nonatomic, copy,readonly) NSString * isShowCancelCommissionBtn;
//首页消息中心channel
@property (nonatomic, copy,readonly) NSString * messageChannel;
//首页消息中心type
@property (nonatomic, copy,readonly) NSString * messageType;

/**App 网络推荐位**/
@property (nonatomic, assign,readonly) NSInteger envSer;
@property (nonatomic, copy,readonly) NSString * apiDomain;
@property (nonatomic, copy,readonly) NSString * vpsDomain;
@property (nonatomic, copy,readonly) NSString * serverDomain;
@property (nonatomic, copy,readonly) NSString * cdnServerDomain;
@property (nonatomic, copy,readonly) NSString * wholesaleDomain;
@property (nonatomic, copy,readonly) NSString * livechatDomain;
@property (nonatomic, copy,readonly) NSString * trackDomain;
@property (nonatomic, copy,readonly) NSString * commodityDomain;
@property (nonatomic, copy,readonly) NSString * ulecomDomain;
@property (nonatomic, copy,readonly) NSString * tencentDomain;
@property (nonatomic, copy,readonly) NSString * mUleDomain;
//扶贫域名
@property (nonatomic, copy,readonly) NSString * fupinDomain;


@property (nonatomic, copy,readonly) NSString * sectionKey_GoodsSourceTab;
@property (nonatomic, copy,readonly) NSString * sectionKey_StoreButtonList;
@property (nonatomic, copy,readonly) NSString * sectionKey_GuidePage;
@property (nonatomic, copy,readonly) NSString * sectionKey_Tabbar;
@property (nonatomic, copy,readonly) NSString * sectionKey_Dialog;
@property (nonatomic, copy,readonly) NSString * sectionKey_Invited;
@property (nonatomic, copy,readonly) NSString * sectionKey_Update;
@property (nonatomic, copy,readonly) NSString * sectionKey_UserCenter;
@property (nonatomic, copy,readonly) NSString * sectionKey_CancelReason;
@property (nonatomic, copy,readonly) NSString * sectionKey_EvaluateLabels;
@property (nonatomic, copy,readonly) NSString * sectionKey_ProceedInfo;
@property (nonatomic, copy,readonly) NSString * sectionKey_toutiao_list;
@property (nonatomic, copy,readonly) NSString * sectionKey_bottom_banner;
@property (nonatomic, copy,readonly) NSString * sectionKey_index_storey;
@property (nonatomic, copy,readonly) NSString * sectionKey_index_storeySecond;
@property (nonatomic, copy,readonly) NSString * sectionKey_HomeRefresh;
@property (nonatomic, copy,readonly) NSString * sectionKey_DropDownRefresh;
@property (nonatomic, copy,readonly) NSString * sectionKey_insurance;
@property (nonatomic, copy,readonly) NSString * sectionKey_ownGoodstips;
@property (nonatomic, copy,readonly) NSString * sectionKey_homeBottomRecommend;
@property (nonatomic, copy,readonly) NSString * sectionKey_wallet;
@property (nonatomic, copy,readonly) NSString * sectionKey_OrderList;
@property (nonatomic, copy,readonly) NSString * sectionKey_ShareImage;
@property (nonatomic, copy,readonly) NSString * sectionKey_wholesaleList;

/**接口**/
@property (nonatomic, copy,readonly) NSString * api_walletInfo;
@property (nonatomic, copy,readonly) NSString * api_searchGoodSource;

//+ (instancetype) shareInstance;
//
//+ (void)loadUleStoreInfo:(NSString *)infoFile appLogKey:(NSString *)appKey andEnvService:(NSInteger)env;
@end

NS_ASSUME_NONNULL_END
