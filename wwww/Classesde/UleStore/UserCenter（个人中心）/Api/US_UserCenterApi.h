//
//  US_UserCenterAPI.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/5.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UleRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_UserCenterApi : NSObject

/************* 客户相关API *************/
//请求客户列表
+ (UleRequest *) buildMemberListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize SearchType:(NSString *)searchType CustomerName:(NSString *)customerName;
//上传h客户头像图片
+ (UleRequest *)buildUploadMemberImageWithStreamData:(NSString *)imageStream;
//修改客户信息
+ (UleRequest *)buildUpdateMemberInfoRequestWithDateDic:(NSDictionary *)dic;
/************* 客户相关API *************/

/************* 设置页相关API *************/
//修改登录密码下发短信
+ (UleRequest *) buildSendSMSCodeForChangePwdRequestWithPhoneNum:(NSString *)phoneNum;
//修改登录密码
+ (UleRequest *) buildChangePwdRequestWithPhoneNum:(NSString *)phoneNum SMSCode:(NSString *)smsCode NewPwd:(NSString *)newPwd;
//查询是否设置过支付密码
+ (UleRequest *) buildChackPayPwdStatusRequest;
//修改支付密码下发短信
+ (UleRequest *) buildSendReplacePayPwdSMSCodeRequest;
//修改支付密码接口
+ (UleRequest *) buildReplacePayPwdRequestWithSMSCode:(NSString *)SMSCode NewPwd:(NSString *)newpwd OldPwd:(NSString *)oldPwd;
//重置支付密码下发短信
+ (UleRequest *) buildSendResetPayPwdSMSCodeRequest;
//重置支付密码接口
+ (UleRequest *) buildResetPayPwdRequestWithSMSCode:(NSString *)SMSCode NewPwd:(NSString *)newpwd;
//问题反馈
+ (UleRequest *) buildSuggestSubmitRequest:(NSString *)suggestText;
/************* 设置页相关API *************/

/************* 资产 相关API *************/
//请求我的钱包数据
+ (UleRequest *) buildWalletInfoRequest;
//查询实名认证信息
+ (UleRequest *) buildQueryCertificationInfoRequest;
//查询金豆数量
//+ (UleRequest *) buildGetGoldBeansCountRequest;
//查询资产页列表显示配置
+ (UleRequest *) buildGetWalletListDataRequest;
//查询收益
+ (UleRequest *) buildGetIncomeRequestWithAccTypeId:(NSString *)accTypeId;
//查询交易中收益
+ (UleRequest *) buildGetIncomeTradingRequestWithStartPage:(NSString *)startPage;
//交易中收益发生扣除时查询当日取消单订单
+ (UleRequest *) buildGetCancelIncomeTradingRequestWithStartPage:(NSString *)startPage;
//捐赠
+ (UleRequest *) buildDonationRequestWithOrgProvince:(NSString *)orgProvince OrgProvinceName:(NSString *)orgProvinceName TransMoney:(NSString *)transMoney;
//查询提现记录
+ (UleRequest *) buildGetWithdrawRecordRequestWithStartPage:(NSString *)startPage accTypeId:(NSString *)accTypeId;
//请求收益明细列表
+ (UleRequest *) buildGetIncomeListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize PageFlag:(NSString *)pageFlag accTypeId:(NSString *)accTypeId BeginDate:(NSString *)beginDate EndDate:(NSString *)endDate;
/* 奖励金明细 */
//查询奖励金明细头部
+ (UleRequest *) buildGetRewardHeadRequest;
//查询奖励金明细列表
+ (UleRequest *) buildGetRewardListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize transFlag:(NSString *)transFlag;
//用户绑卡列表查询
+ (UleRequest *) buildGetBindCardListRequest;
//解绑银行卡
+ (UleRequest *) buildDeleteCardWithCardNumber:(NSString *)cardNumber;
//获取绑卡短信验证码
+ (UleRequest *) buildGetBindingCardSMSCodeRequestWithAccountName:(NSString *)accountName CardNumber:(NSString *)cardNumber IDCardNum:(NSString *)idCardNum MobileNum:(NSString *)mobileNum;
//绑定邮储卡
+ (UleRequest *) buildBindingCardRequestWithAccountName:(NSString *)accountName CardNumber:(NSString *)cardNumber IDCardNum:(NSString *)idCardNum MobileNum:(NSString *)mobileNum ValidateCode:(NSString *)validateCode;
//获取绑定的邮乐列表
+ (UleRequest *)buildGetUleCardListRequest;
//获取优惠券列表
+ (UleRequest *)buildCouponListInfoWithStatus:(NSString *)status pageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize;
//获取可使用优惠券商品列表
+ (UleRequest *)buildCouponUseListWithId:(NSString *)batchId pageIndex:(NSString *)pageIndex sortType:(NSString *)sortType andSortOrder:(NSString *)sortOrder;
//获取提现提示文案
+ (UleRequest *) buildWithdrawProcessInfo;
//实名认证获取验证码
+ (UleRequest *) buildAuthSmsCodeWithUserName:(NSString *)userName idCardNum:(NSString *)idCard bankCardNum:(NSString *)bankCard mobileNum:(NSString *)mobileStr bankChooseType:(NSString *)type;
//实名认证接口
+ (UleRequest *) buildAuthorizeRealWithUserName:(NSString *)userName idCardNum:(NSString *)idCard bankCardNum:(NSString *)bankCard mobileNum:(NSString *)mobileStr smsCodeNum:(NSString *)smsCode bankChooseType:(NSString *)type;
//提现申请
+ (UleRequest *)buildWithdrawApplyWithPhoneNum:(NSString *)phoneStr bankCodeNum:(NSString *)bankCode transMoneyNum:(NSString *)transMoney accTypeId:(NSString *)accTypeId;
//自有商品货款提示
+ (UleRequest *)buildOwnGoodsTips;
/************* 资产 相关API *************/

/************* 邀请人 相关API *************/
//获取邀请人列表
+ (UleRequest *) buildGetInviterListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize;
//获取邀请人详情
+ (UleRequest *) buildGetInviterDetailRequestWithInviterId:(NSString *)inviterId;
//邀请开店
+ (UleRequest *) buildGetInviteUrlReuqest;
//邀请开店 二维码分享背景图片 (cs后台推荐位)
+ (UleRequest *) buildGetInviteOpenBackroundImage;
//分享店铺
+ (UleRequest *) buildGetMyStoreUrlRequest;
//分享分销店铺
+ (UleRequest *) buildGetFenxiaoMyStoreUrlRequest;
/************* 邀请人 相关API *************/

//获取购物车数量
+ (UleRequest *) buildGetShopCartCount;
//获取我的模块信息
+ (UleRequest *)buildUserCenterRequest;

@end

NS_ASSUME_NONNULL_END
