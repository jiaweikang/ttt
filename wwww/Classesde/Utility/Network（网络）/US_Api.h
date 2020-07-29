//
//  US_Api.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/5.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#ifndef US_Api_h
#define US_Api_h

/**
 *  推荐位
 */
#define KCDNDefaultValue       @"null"
#define API_FeaturedGet        @"api/mobile/indexFeaturedGet.do"

#define API_cdnFeaturedGet      @"mobilead/v2/recommend/indexFeaturedGet/app"

//#define API_ylxdIndexRecommend3        @"yxdcdn/v2/recommend/ylxdRecommends3" //2019.07.29
#define API_ylxdIndexRecommend4        @"yxdcdn/v2/recommend/ylxdRecommends4/app" //2019.08.13
//首页个人推荐商品
#define API_findIndexListing            @"ylxditem/item/findIndexListings.do"
/**
 * 首页滚动条
 */
#define API_homePageScrolling @"yxdcdn/v2/item/homePageScrolling/app"
//首页底部推荐商品
#define API_homeBottomRecommend    @"yxdcdn/v2/recommend/qryIndexBottomRecommend/app"

//首页请求未读消息总数
#define API_totalNewMsgNum          @"im/msgCenter/totalNewMsgNum"

//企业页面的banner
#define API_ylxdEnterpriseRecommend    @"yxdcdn/v2/recommend/ylxdRecommends/app" //2019.07.29

//企业页面推荐商品
#define API_dgRecommend        @"mobilead/v2/recommend/dgRecommend/app"

/**
 * 新红包雨活动主题查询
 */
#define API_NewRedPacketRain_GetTheme           @"yxdcdn/v2/act/redenvelopes/getTheme/app"

/**
 * 新红包雨活动场次信息查询
 */
#define API_NewRedPacketRain_GetActivityInfo    @"yxdcdn/v2/act/redenvelopes/getActivityInfos/app"
/**
 *  获取用户信息
 */
#define API_getUserInfo         @"ylxduser/user/getUserInfo.do"

/**
 *  会员列表
 */
#define API_MemberList          @"ylxduser/customer/searchCustomerV2.do"
/**
 *  会员头像上传
 */
#define API_memberUploadImg     @"ylxduser/customer/uploadPic.do"
/**
 *  会员修改
 */
#define API_UpdateMemberInfo    @"ylxduser/customer/updateCustomer.do"
/**
 *  忘记密码/修改登录密码下发短信
 */
#define API_smsResetPwd         @"ylxduser/sms/resetPwd.do"
/**
 * 重置登录密码
 */
#define API_ResetPwd            @"ylxduser/user/resetPwd.do"
///**
// *  我的钱包（新）
// */
#define API_walletInfo          @"yzgApiWAR/wallet/getNewWalletIndex.do"

/**
 *  查询实名认证信息
 */
#define API_queryCertificationInfo @"yzgApiWAR/wallet/queryRealnameCertificationInfo.do"

/**
 *  实名认证发送短信接口
 */
#define API_getAuthSMSCode    @"yzgApiWAR/wallet/sendRandomCode.do"

/**
 *  开通实名认证接口
 */
#define API_AuthrizeRealName  @"yzgApiWAR/wallet/openRealnameCertification.do"

/**
 *  查询金豆数量
 */
//#define API_getGoldPeasCount    @"yzgApiWAR/wallet/goldPeasCount.do"

/**
 *  查询收益
 */
#define API_getCommissionIndex  @"yzgApiWAR/wallet/getCommissionIndex.do"
/**
 *  省市县支局机构获取
 */
#define API_postOrgUnit          @"yzgApiWAR/ylxd/chinaPostOrgUnit/findChinaPostOrgUnit.do"
/**
 *  捐赠
 */
#define API_commissionDonation  @"yzgApiWAR/ylxd/wallet/commissionDonation.do"
/**
 *  查询提现成功 和 提现申请审核中的记录
 */
#define API_getWithdrawSummary  @"yzgApiWAR/wallet/getWithdrawSummary.do"
/**
 *  账户提现申请接口
 */
#define API_accountWithdrawApply @"yzgApiWAR/wallet/accountWithdrawApply.do"
/**
 *  查询交易中收益
 */
#define API_getTradingCommission @"yzgApiWAR/wallet/findTradingCommission.do"
/**
 *  交易中收益发生扣除时查询当日取消单订单
 */
#define API_getTodayCancelOrder @"yzgApiWAR/ylxd/wallet/todayCancelOrder.do"
/**
 *  查询账户交易明细
 */
#define API_getAccountTransDetail @"yzgApiWAR/wallet/queryAccountTransDetail.do"
/**
 *  查询奖励金明细
 */
#define API_getRewardList       @"yzgApiWAR/ylxd/wallet/queryRewardDetailList.do"
/**
 *  查询奖励总额
 */
#define API_getRewardHead @"yzgApiWAR/ylxd/wallet/queryRewardTotal.do"

/**
 *  查询是否设置支付密码
 */
#define API_isSetPaySecurity    @"ylxduser/user/isSetPaySecurity.do"
/**
 *  修改支付密码下发短信
 */
#define API_smsReplacePayPwd    @"ylxduser/user/sendMobileCode.do"
/**
 *  修改支付密码
 */
#define API_replacePayPwd       @"ylxduser/user/changeAccPwd.do"
/**
 *  重置支付密码下发短信
 */
#define API_smsResetPayPwd      @"ylxduser/user/sendValifyCodeForResetPWD.do"
/**
 *  重置密码
 */
#define API_resetPayPwd         @"ylxduser/user/changeFindpwdByMobile.do"
/**
 *  提交意见
 */
#define API_doFeedback          @"yzgApiWAR/feedback/addFeedback.do"
/**
 *  获取邀请人列表
 */
#define API_getInviterList      @"ylxduser/user/queryRecomendUserByUserId.do"
/**
 *  获取邀请人详情
 */
#define API_getInviterDetail    @"ylxduser/user/queryRecomendUserDetailByUserId.do"

/**
 *  登录下发短信
 */
#define API_smsCodeByLogin      @"ylxduser/sms/V2/sendSmsCode.do"

/**
 *  注册下发短信
 */
#define API_smsCodeByRegist     @"ylxduser/sms/V2/sendRegisterCode.do"

/**
 *  快捷登录
 */
#define API_quickLogin          @"ylxduser/user/quickLoginAuto.do"

/**
 *  验证码登录
 */
#define API_loginBySmsCode      @"ylxduser/user/V2/quickLogin.do"

/**
 *  密码登录
 */
#define API_loginByPasswd       @"ylxduser/user/v2/login.do"

/**
 *  预注册邮乐网账号
 */
#define API_preRegist           @"ylxduser/user/checkRegister.do"

/**
 *  注册小店
 */
#define API_registStore         @"ylxduser/user/postMobileVps.do"

/**
 *  企业信息获取
 * */
#define API_postEnterpriseUnit @"yzgApiWAR/ylxd/chinaPostOrgUnit/getAllEnterpriseOrgunit.do"

/**
 *  账号注销前权益信息查询
 */
#define API_getUserLoggedOffDetail @"yzgApiWAR/user/userLoggedOffDetail.do"
/**
 *  账号注销接口
 */
#define API_UserLoggedOff         @"ylxduser/user/userLoggedOff.do"

/**
 *  修改店主信息
 */
//#define API_updateUserInfo @"ylxduser/user/updateUserInfo.do"
#define API_updateUserInfo @"ylxduser/user/updateUserOrgInfo.do"//20190726更换

/**
 *  查询用户战队信息
 */
#define API_editBeforeCheck @"ylxduser/user/editBeforeCheck2.do"


#define API_contractSign        @"ylxduser/user/contractSign.do"

#define API_getJsonItem         @"ylxditem/item/getJsonItem.do"

#define API_shareListingURL    @"ylxditem/item/shareListingURL.do"

#define API_shareDealIndex     @"appxiaodian/recommendPortrait/getCommodityTurnoverIndex"

//首页弹窗分享链接
#define API_shareActListingURL   @"ylxditem/item/shareActListingURL.do"

#define API_insuranceShareURL  @"ylxditem/item/shareMicroInsuranceURL.do"

/**
 *  邀请开店链接
 */
#define API_getInvitationUrl   @"ylxduser/user/getInvitationUrl.do"

/**
 *  分享店铺链接
 */
#define API_ShareStoreInfo     @"ylxditem/item/getShareURL.do"

#define API_GetCookiehelper     @"/api/user/cookiehelper.do"

/**
 *  用户绑卡列表查询
 */
#define API_listBindingCard     @"yzgApiWAR/wallet/listBindingCard.do"
/**
 *  用户解绑银行卡
 */
#define API_untyingBankCard     @"yzgApiWAR/ylxd/wallet/closeQuickPay.do"

/**
 *  获取绑卡-邮储验证码
 */
#define API_sendCodeSMS         @"yzgApiWAR/wallet/sendCodeSMS.do"
/**
 *  绑定邮储卡接口
 */
#define API_bindingPSBCBackCard @"yzgApiWAR/wallet/signSubmit.do"

/**
 * 查询佣金
 */
#define API_getCanCarryAmount     @"yzgApiWAR/wallet/getCanCarryAmount.do"//首页的查询佣金 20170907

/**
 * 获取用户PV/UV
 */
//#define API_shareInfo           @"ylxduser/user/shareInfo.do" //更换接口 20180710
//当日访客量 20200327
#define API_shareInfoVisitCount      @"ylxduser/user/visitCount.do"
//当日订单量 20200327
#define API_shareInfoOrderCount      @"ylxduser/user/orderCount.do"
/**
 * 查询未读消息数量
 */
#define API_newPushMessageNumber  @"yzgApiWAR/ylxd/msg/hasNewPushMsg.do"
/**
 *查询推荐人信息
 */
#define API_searchReferrer      @"ylxduser/user/findUsrReferralByUsrId.do"
/**
 *我的小店 新闻动态
 */
#define API_mNewsList         @"https://youle.tom.com/export/youzg_m/json/show.json"//首页新闻
/**
 * 获取小店信息
 */
#define API_findStoreInfo     @"ylxditem/store/findStoreInfo.do"
/**
 *  上传头像
 */
#define API_uploadPic        @"ylxduser/user/uploadPic.do"

/**
 *  店铺名称及描述修改
 */
#define API_ModifyStoreInfo   @"ylxduser/user/updateStore.do"

/**
 * 热销商品列表
 */
#define  API_findRecListingAround   @"yxdcdn/v2/recommend/findRecListingAround/app"//更换接口 2019.07.29
/**

 * 推送消息列表
 */
#define API_MessageList      @"yzgApiWAR/ylxd/msg/broadcast.do"

#define API_CategoryMessageList      @"appxiaodian/msg/list.do"

/**
 * 我要扶贫（推荐位）
 */
#define API_getIndexRecommendItem   @"ylxditem/item/getIndexRecommendItem.do" //更换接口

/**
 获取商品预览Url
 */
#define API_getPreviewUrl    @"ylxditem/item/getPreviewUrl.do" //更换接口 20180710


/**
 获取商品分类（无数量）
 */
#define API_getItemClassify  @"ylxditem/category/getItemClassifyCache.do"
/**
 获取商品分类（有数量）
 */
#define API_getItemClassifyDetail  @"ylxditem/category/getItemClassify.do"

/**
排序商品分类&批量修改商品分类名称
 */
#define API_sortCategory       @"ylxditem/category/batchUpdateCategory.do"
/**
删除商品分类
 */
#define API_deleteCategory     @"ylxditem/category/deleteCategory.do"

/**
新增商品分类
 */
#define API_createNewCategory  @"ylxditem/category/createCategory.do"
/**
 添加喜爱的商品
 */
#define API_saveFavsListing   @"ylxditem/item/saveFavsListing.do" //更换接口 20180710

/**
 获取我的商品所有商品列表
 */
#define API_findStoreItems   @"ylxditem/item/findStoreItems.do"
/**
 获取用户单个分类商品列表
 */
#define API_getCategoryList  @"ylxditem/item/findCategoryListing.do"  //更换接口 2018.09.28

/**
 获取用户未分类商品列表
 */
#define API_getNoCategoryList @"ylxditem/item/findNotCategoryListing.do" //更换接口 2018.09.28

/**
 获取邮乐网大网收藏夹

 */
#define API_getFavoriteListings @"ylxditem/item/getFavoriteListings.do" //更换接口 20180710

//批量同步大网数据
#define API_synFavoriteListings @"ylxditem/item/synFavoriteListings.do" //更换接口 20180710

/**
 批量删除失效商品
 */
#define API_deleteFavsListing  @"ylxditem/item/deleteFavsListing.do" //更换接口 20180710
/**
 *批量移除分类中的商品
 */
#define API_removeFavsListing  @"ylxditem/category/removeListingCategory.do"

//我的商品置顶接口(最多十条)
#define API_batchListingStick  @"ylxditem/item/batchListingStick.do" //更换接口 20180710

//添加商品
#define API_saveCategroyLists  @"ylxditem/category/saveListingCategory.do"

//获取用户订单数量
#define API_getOrderCount @"appxiaodian/order/getCustomerOrderCount.do"
/**
 *  我的订单
 */
#define API_getAllOrders     @"appxiaodian/order/list" //更换接口 20181023
/**
 *  接龙订单
 */
#define API_freshOrders     @"appxiaodian/fresh/order/customerOrderList.do"
/**
 *  订单详情
 */
#define API_getOrderDetail      @"appxiaodian/order/detail"

/**
 *  删除订单
 */
#define API_deleteOrder     @"appxiaodian/order/deleteOrder" //更换接口 20181023
/**
 *  确认签收
 */
#define API_signOrder         @"appxiaodian/order/confirmWaitSignOrder" //更换接口 20181023

/**
*  取消订单
*/
#define API_cancelBuyerOrder       @"appxiaodian/order/cancelOrder" //更换接口 20181023

/**
 *  去支付获取链接
 */
#define API_orderPay               @"yzgApiWAR/ylxd/pay/orderPay.do"

/**
 *  使用跨店铺优惠券订单支付获取所有订单信息 用于提示显示
 */
#define API_queryMultiStoreOrder  @"appxiaodian/order/queryMultiStoreOrder"


/**
 *  包裹物流信息查询
 */
#define API_expressSearch         @"appxiaodian/order/expressSearch" //更换接口 20181023
/**
 *  评论上传图片接口
 */
#define API_uploadCommentImges    @"appxiaodian/order/updOrdCommentImg"

/**
 *  提交评论接口
 */
#define API_AddComment        @"appxiaodian/order/addComment" //更换接口 20181023

/**
 *  提醒发货接口
 */
#define API_deliverReminder      @"appxiaodian/order/deliverReminder"

/**
 *  获取分享记录的接口
 */
#define API_FindMyShare       @"ylxditem/item/queryShareRecord.do" //更换接口 20180710

/**
 *商家店铺首页接口
 */
#define API_getStoreDetailList   @"ylxditem/item/findingUleStoreListing.do" //2019.01.23 商家店铺首页接口

/**
 * 查找货源
 */
#define API_SearchGoodSource  @"ylxditem/item/findingListing.do" //更换接口 20180710
/**
 *  邮乐卡余额明细查询
 */
#define API_getUleCardList     @"yzgApiWAR/wallet/getUleCardList.do"

/**
 * 店铺优惠券列表查询接口
 */
#define API_GetListingCoupon    @"ylxditem/store/listingCoupon.do"

/**
 * 查询可用优惠券的商品列表
 */
#define API_GetUseableListing        @"ylxditem/coupon/serchUsableListing.do"

/**
 * 关键字联想列表
 */
#define API_SearchSuggestion   @"appitem/item/searchSuggestions.do"

/**
 * Launch上传
 */
#define API_apiLogLaunch        @"apiLog/app/openAndDevice/%@.do"

/**
 *  推送总开关
 */
#define kAPIPushSwitch      @"pushmsg-api/app/saveAppDeviceInfo.do"

/**
 * 推送点击
 */
#define API_PushmsgClick      @"pushmsg-api/pushmsg/pushmsgClick.do"
/**
 * 扫码自提
 */
#define API_scanQr                @"appcommon/qr/scanQr"

/**
 * 解析口令
 */
#define API_GetKoulingInfo        @"appact/watchword/analysis"
/**
 *  自提列表
 */
#define API_TakesSelfServiceList        @"yxdcdn/v2/recommend/ylxdSelfServiceListing/app"
/**
 * 获取服务器时间
 */
#define API_getSysTime @"yzgApiWAR/ylxd/system/getSysTime.do"
/**
 * 汽车销售
 */
#define API_get4SAddressList @"yxdcdn/v2/address/get4SAddress/app"

/**
 * 查询订单支付信息
 */
#define kAPI_getPaymentInfo     @"appxiaodian/order/getPaymentInfo.do"

/**
* 自有订单查询商家信息
*/
#define kAPI_queryMerchantInfo @"ylxduser/user/queryMerchantInfo.do"

/**
 * 汽车订单二维码
 */
#define kAPI_generateCar    @"appxiaodian/qr/generateCar"

/**
 * 同城订单 取消/退换货提示信息
*/
#define kAPI_getRefundTip @"appxiaodian/order/getRefundTip"

/**
 * 修改真实姓名
 */
#define kAPI_updateUserName    @"ylxduser/user/updateUserTrueName.do"

/**
 * 获取客服状态（在线/离线）
 */
#define kAPI_getChatStatus     @"uleImService/imService/custServOnlineStatu"
/**
 *一键登录
 */
#define kAPI_oneKeyLogin        @"ylxduser/user/oneKeyLogin"

/**
 获取分销专区id
 */
#define kAPI_fx_findZoneByXD  @"basecfgservice/zoneOrg/findZoneByXD"
/**
 获取分销列表
 */
#define kAPI_fx_yzgList      @"itemservice/api/tags/yzgList"
/**
    获取分享分销店铺链接
 */
#define API_fx_shareStoreURL        @"ylxditem/fx/item/shareStoreURL.do"
/**
 添加分销商品到收藏列表
 */
#define API_fx_saveFxListing    @"ylxditem/fx/item/saveFxListing.do"
/**
获取分销收藏列表
*/
#define API_fx_queryFxListing     @"ylxditem/fx/item/queryFxListing.do"
/**
 获取分销商品分享链接
 */
#define API_fx_shareListingURL  @"ylxditem/fx/item/shareListingURL.do"
/**
删除分销商品收藏列表的商品
*/
#define API_fx_deleteFxListing  @"ylxditem/fx/item/deleteFxListing"

#define API_getCartCount       @"mxiaodian/cart/getCartCount.html"

#define API_suggestAdress     @"ws/place/v1/suggestion"


#endif /* US_Api_h */
