//
//  US_Const.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#ifndef US_Const_h
#define US_Const_h
#import "US_Color.h"
typedef enum : NSUInteger {
    UnitAlertOrderNormal,
    UnitAlertOrderActivity,
    UnitAlertOrderKoulin,
    UnitAlertOrderProtocol,
    UnitAlertOrderVersionUpdate,
} UnitAlertOrder;//弹框优先级顺序

/*订单相关*/
typedef enum : NSUInteger{
    OrderListTypeNone,
    OrderListTypeOwn,
    OrderListTypeUle,
    OrderListTypeAll
}US_OrderListType;
static NSString *const carOrderStatus=@"100011";//汽车订单
static NSString *const ownOrderStatus=@"100013";//自有订单
static NSString *const selfTakeOrderStatus=@"100008";//自提订单
static NSString *const sameCityOrderStatus=@"100019";//同城订单
static NSString *const multiStoreOrderStatus=@"100020";//跨店铺优惠券订单
static NSString *const preferenceOrderType=@"1701";//businessType 邮特惠订单


//// 三方SDKkey
////Bugly
//#define BuglyAppID                  @"d0cb091726"
//#define UM_AppKey                   @"5af502dbf43e482cb10000a0"

//static NSString * const kServerProtcol   =@"https://www.ule.com/event/2019/0801/xieyi.html";
#define kSectionKey_homeShared [NSString stringWithFormat:@"%@_homeSharedGoods",[US_UserUtility sharedLogin].m_userId]

//*缓存文件名*//
static NSString * const kCacheFile_GoodsSourceTab   =  @"homeClassift1.plist";
//static NSString * const kCacheFile_HomeRecommend    =  @"HomeRecommendData.plist";
static NSString * const kCacheFile_MyStore          =  @"USMyStoreData_new.plist";
static NSString * const kCacheFile_UserCenterList   =  @"UserCenterNew.plist";// -- 我的模块列表
static NSString * const TemplateCachePlist          =  @"templateData.plist";  //分享模板
static NSString * const TabbarListName_local        =  @"USTabbarData.plist";//本地文件
static NSString * const TabbarListName_update       =  @"USTabbarDataUpdate.plist";//推荐位数据
static NSString * const kCacheFile_homeShared       =  @"USHomeSharedGoods.plist";
static NSString * const kCacheFile_WalletList       =  @"UleStoreApp.bundle/USMyWalletList.plist";// -- 资产列表
static NSString * const kCacheFile_HomeTabIndex     =  @"UleStoreApp.bundle/USHomeTabIndex.plist";// -- 首页tab

#define kCacheFile_DetailCategoryCache [NSString stringWithFormat:@"%@_detailCategoryList.plist",[US_UserUtility sharedLogin].m_userId]
//*NSUserDefault key*//
//请求邮乐网收藏夹商品数量成功保存时间
static NSString * const kUserDefault_UleFavaritList = @"collectSucDate";
static NSString * const kUserDefault_ShowBatchDeletView= @"batchShowHintDate";
static NSString * const kUserDefault_serverTimeRequestDate = @"saveSystemTimeDate";

static NSString * const kUserDefault_SearchRecord  = @"uleStoreSearchRecord";
static NSString * const kUserDefault_HomeGifView   = @"uleStoreHomeGifView";
static NSString * const kUserDefault_HomeRefreshView= @"uleStoreHomeRefreshView";
static NSString * const kUserDefault_dropDownGifView= @"uleStoreDropDownRefreshView";
static NSString * const kUserDefault_launchApiSuc = @"launchApiSucDate";
static NSString * const kUSerDefault_ReqeustEnterpirse = @"ReqeustEnterpirseDate";
//
#define KNeedShowNav @"hasnavi"

//*推送相关*//
//*通知相关*//
static NSString * const AppWillEnterForeground      = @"appWillEnterForeground";//后台进前台
static NSString * const AppDidBecomeActive          = @"applicationDidBecomeActive";//程序进入前台
static NSString * const AppWillResignActive         = @"applicationWillResignActive";//程序将要挂起

static NSString * const NOTI_UserInfoRequest_Success= @"userInfoRequestSuccessNotification";
static NSString * const NOTI_EnterprisePickConfirm  = @"EnterprisePickConfirmNotification";
static NSString * const NOTI_OrganizePickConfirm    = @"OrganizePickConfirmNotification";

static NSString * const Notify_EditStoreInfo        = @"MODIFYSHARECONTEXT";
static NSString * const NOTI_RefreshMemberPage      = @"refreshMemberPage";

static NSString * const NOTI_REFRESHMYORDER         = @"noti_refreshMyOrder";

static NSString * const NOTI_MyGoodsListRefresh     = @"favoriteListRefresh";
static NSString * const NOTI_FenxiaoMyGoodsListRefresh   = @"fenxiaoFavListRefresh";

static NSString * const NOTI_CategroyNameChanged    = @"CategroyName_TextChanged";
static NSString * const NOTI_CategoryUpdate         = @"UpdateManageListFromLocal";
static NSString * const NOTI_UpdateOrderList        = @"UpdateOrderList";
static NSString * const NOTI_UpdateUserInfo         = @"UpdateUserInfo";

static NSString * const NOTI_SelectBankcardDone     = @"SelectBankcardDone";
static NSString * const NOTI_RefreshIncomeData      = @"RefreshIncomeData";
static NSString * const NOTI_RefreshWithdrawView    = @"RefreshWithdrawView";
static NSString * const NOTI_DragViewShow           = @"homeGetDragWindowInfoSuccess";
static NSString * const NOTI_UpdateTabBarVC         = @"updataTabBarViewController";
static NSString * const NOTI_UpdateUserCenter       = @"refreshUserCenterList";
static NSString * const NOTI_UpdateUserPickConfirm  = @"updateUserPickConfirm";
static NSString * const NOTI_HomeStoreyAction       = @"homeStoreyAction";
//static NSString * const NOTI_HomeTopBGImageDone     = @"homeTopBgImageViewDone";
static NSString * const NOTI_HomeNaviBGImageDone    = @"homeNaviBGImageDone";
static NSString * const NOTI_MemberDidSearch        = @"memberListDidSearch";
//批销添加商品 跳转至企业模块 选中分销
static NSString * const NOTI_ReloadEnterpriseRoot   = @"reloadEnterpriseRoot";
//universal links
//static NSString * const USStore_UniversalLink  =   @"https://wechat.ule.com/uleStoreApp/";
//*支付分享*//
//static NSString * const WXAPPID_PAY        =   @"wx50fce49d9bdada80";
//static NSString * const WXAPPID_SHARE      =   @"wxd05bbdfe56d4c813";
//static NSString * const WXAPP_SECRET       =   @"d4624c36b6795d1d99dcf0547af5443d";
//static NSString * const AliPayScheme       =   @"usalipay";
//static NSString * const USUnionScheme      =   @"UstoreUnionPay";
//static NSString * const USSMSJmpScheme     =   @"uzgStorejmp";
//static NSString * const USStoreScheme      =   @"uzgStore";
//static NSString * const WXH5PAYScheme_fupin_test=@"ustore.fpmai.com";
//static NSString * const WXH5PAYScheme_fupin_prd=   @"ustore.wx.zgshfp.com.cn";

//*图片格式大小后缀名*//
static NSString * const kImageUrlType_M    =   @"m";
static NSString * const kImageUrlType_L    =   @"l";
static NSString * const kImageUrlType_SL   =   @"sl";
static NSString * const kImageUrlType_XL   =   @"xl";
static NSString * const kImageUrlType_S    =   @"s";

//*资产页各个条目functionId*//
static NSString * const kWallet_ShareAmount     =   @"Wallet_ShareAmount";//分享赚取
static NSString * const kWallet_AwardAmount     =   @"Wallet_AwardAmount";//奖励金(帅康用户不显示)
static NSString * const kWallet_BankCardCount   =   @"Wallet_BankCardCount";//银行卡数量
static NSString * const kWallet_UleCardAmount   =   @"Wallet_UleCardAmount";//邮乐卡余额
static NSString * const kWallet_CouponCount     =   @"Wallet_CouponCount";//优惠券数量
static NSString * const kWallet_Authorize       =   @"Wallet_Authorize";//是否实名
static NSString * const kWallet_RedAmount       =   @"Wallet_RedAmount";//红包余额(金额大于0显示)
static NSString * const kWallet_SelfGoodsAmount =   @"Wallet_SelfGoodsAmount";//自有商品货款(开通自有商品显示)

//*客服在线状态*//
static NSString * const NOTI_LiveChatStatus     =   @"NOTI_liveChatStatus";//分享赚取



#define uleQuickPayServicePolicyUrl         @"http://ule.com/ulewap/pay_agreement.html?isHead=no"//邮乐快捷支付服务及相关协议
#define psbcQuickPayServicePolicyUrl        @"http://ule.com/ulewap/onLine_agreement.html?isHead=no"//中国邮政储蓄银行借记卡快捷支付业务线上服务协议


#endif /* US_Const_h */
