//
//  US_UserCenterAPI.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/5.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_UserCenterApi.h"
#import "US_Api.h"
#import "CalcKeyIvHelper.h"
#import "NSData+Base64.h"
#import <UleSecurityKit/Ule_SecurityKit.h>
#import "NSString+Addition.h"
#import "US_NetworkExcuteManager.h"

@implementation US_UserCenterApi
//通用请求 不带参数
+ (UleRequest *) buildCommonRequestWithApiName:(NSString *)apiName{
    UleRequest * request=[[UleRequest alloc] initWithApiName:apiName andParams:nil requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//请求我的钱包数据
+ (UleRequest *) buildWalletInfoRequest{
//    return [self buildCommonRequestWithApiName:API_walletInfo];
    return [self buildCommonRequestWithApiName:[UleStoreGlobal shareInstance].config.api_walletInfo];
}

//查询实名认证信息
+ (UleRequest *) buildQueryCertificationInfoRequest{
    return [self buildCommonRequestWithApiName:API_queryCertificationInfo];
}

//查询金豆数量
//+ (UleRequest *) buildGetGoldBeansCountRequest{
//    return [self buildCommonRequestWithApiName:API_getGoldPeasCount];
//}

//查询资产页列表显示配置
+ (UleRequest *) buildGetWalletListDataRequest{
    NSString * sectionKey=NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_wallet);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    urlString=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    UleRequest *request=[[UleRequest alloc]initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

//查询收益
+ (UleRequest *) buildGetIncomeRequestWithAccTypeId:(NSString *)accTypeId{
    NSMutableDictionary *params = @{
                                    @"accTypeId":accTypeId.length > 0 ? accTypeId : @""
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getCommissionIndex andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//查询交易中收益
+ (UleRequest *) buildGetIncomeTradingRequestWithStartPage:(NSString *)startPage{
    NSMutableDictionary *params = @{@"pageNo":NonEmpty(startPage)
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getTradingCommission andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//交易中收益发生扣除时查询当日取消单订单
+ (UleRequest *) buildGetCancelIncomeTradingRequestWithStartPage:(NSString *)startPage{
    NSMutableDictionary *params = @{@"pageIndex":NonEmpty(startPage),
                                    @"pageSize":@"10"}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getTodayCancelOrder andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//捐赠
+ (UleRequest *) buildDonationRequestWithOrgProvince:(NSString *)orgProvince OrgProvinceName:(NSString *)orgProvinceName TransMoney:(NSString *)transMoney{
    NSMutableDictionary *params = @{@"orgProvince":NonEmpty(orgProvince),
                                    @"orgProvinceName":NonEmpty(orgProvinceName),
                                    @"transMoney":NonEmpty(transMoney)
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_commissionDonation andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//查询提现记录
+ (UleRequest *) buildGetWithdrawRecordRequestWithStartPage:(NSString *)startPage accTypeId:(NSString *)accTypeId{
    NSMutableDictionary *params = @{@"pageIndex":NonEmpty(startPage),
                                    @"pageSize":@"10",
                                    @"accTypeId":accTypeId.length > 0 ? accTypeId : @""
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getWithdrawSummary andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//请求收益明细列表
+ (UleRequest *) buildGetIncomeListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize PageFlag:(NSString *)pageFlag accTypeId:(NSString *)accTypeId BeginDate:(NSString *)beginDate EndDate:(NSString *)endDate{
    NSMutableDictionary *params = @{@"pageIndex":NonEmpty(startPage),
                                    @"pageSize":NonEmpty(pageSize),
                                    @"transFlag":NonEmpty(pageFlag),
                                    @"accTypeId":accTypeId.length > 0 ? accTypeId : @"",
                                    }.mutableCopy;
    if (beginDate&&beginDate.length>0) {
        [params setObject:beginDate forKey:@"beginTime"];
    }
    if (endDate&&endDate.length>0) {
        [params setObject:endDate forKey:@"endTime"];
    }
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getAccountTransDetail andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

/* 奖励金明细 */
//查询奖励金明细头部
+ (UleRequest *) buildGetRewardHeadRequest{
    NSMutableDictionary *params = @{@"clientCallType":@"APP"
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getRewardHead andParams:params];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//奖励金明细列表
+ (UleRequest *) buildGetRewardListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize transFlag:(NSString *)transFlag{
    NSMutableDictionary *params = @{@"pageIndex":NonEmpty(startPage),
                                    @"pageSize":NonEmpty(pageSize),
                                    @"transFlag":NonEmpty(transFlag)
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getRewardList andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//查询绑定银行卡列表
+ (UleRequest *) buildGetBindCardListRequest{
    return [self buildCommonRequestWithApiName:API_listBindingCard];
}

//解绑银行卡
+ (UleRequest *) buildDeleteCardWithCardNumber:(NSString *)cardNumber{
    NSMutableDictionary *params = @{@"cardNo":NonEmpty(cardNumber)}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_untyingBankCard andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//获取绑卡短信验证码
+ (UleRequest *) buildGetBindingCardSMSCodeRequestWithAccountName:(NSString *)accountName CardNumber:(NSString *)cardNumber IDCardNum:(NSString *)idCardNum MobileNum:(NSString *)mobileNum{
    
    NSMutableDictionary *params = @{@"account_name":NonEmpty(accountName),
                                    @"account_number":NonEmpty(cardNumber),
                                    @"account_id":@"1",
                                    @"account_idNumber":NonEmpty(idCardNum),
                                    @"account_mobile":NonEmpty(mobileNum),
                                    @"card_type":@"D"}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_sendCodeSMS andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//绑定邮储卡
+ (UleRequest *) buildBindingCardRequestWithAccountName:(NSString *)accountName CardNumber:(NSString *)cardNumber IDCardNum:(NSString *)idCardNum MobileNum:(NSString *)mobileNum ValidateCode:(NSString *)validateCode{
    
    NSMutableDictionary *params = @{@"account_name":NonEmpty(accountName),
                                    @"account_number":NonEmpty(cardNumber),
                                    @"account_id":@"1",
                                    @"account_idNumber":NonEmpty(idCardNum),
                                    @"account_mobile":NonEmpty(mobileNum),
                                    @"card_type":@"D",
                                    @"account_validatecode":NonEmpty(validateCode),
                                    @"bank_code":@"psbc"}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_bindingPSBCBackCard andParams:params requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取绑定的邮乐列表
+ (UleRequest *) buildGetUleCardListRequest{
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getUleCardList andParams:nil requsetMethod:RequestMethod_Post];
    //请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildWithdrawProcessInfo
{
    NSString * sectionKey= NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_ProceedInfo);
    NSMutableDictionary *params = @{@"sectionKeys":sectionKey,
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_FeaturedGet andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

+ (UleRequest *)buildAuthSmsCodeWithUserName:(NSString *)userName idCardNum:(NSString *)idCard bankCardNum:(NSString *)bankCard mobileNum:(NSString *)mobileStr bankChooseType:(NSString *)type
{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //获取密钥和向量字符串
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSDictionary *clearParamDic = @{@"cardNo":[bankCard stringByReplacingOccurrencesOfString:@" " withString:@""],
                                    @"userName":userName,
                                    @"idcardNo":[idCard stringByReplacingOccurrencesOfString:@" " withString:@""],
                                    @"mobileNumber":NonEmpty(mobileStr)};
    
    NSMutableDictionary *params = @{@"cardType":@"D",
                                    @"idcardType":@"1",
                                    @"channelType":@"1003",
                                    @"type":type}.mutableCopy;
    [params setValuesForKeysWithDictionary:[US_NetworkExcuteManager getEncryptedParamsWithDic:clearParamDic andKey:o_key andIV:o_Iv]];
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_getAuthSMSCode andParams:params];
    request.headParams = @{@"X-Emp-Token":NonEmpty(token),
                           @"X-Emp-Signature":NonEmpty(signStr),
                           @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+(UleRequest *)buildAuthorizeRealWithUserName:(NSString *)userName idCardNum:(NSString *)idCard bankCardNum:(NSString *)bankCard mobileNum:(NSString *)mobileStr smsCodeNum:(NSString *)smsCode bankChooseType:(NSString *)type
{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //获取密钥和向量字符串
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSDictionary *clearParamDic = @{@"cardNo":[bankCard stringByReplacingOccurrencesOfString:@" " withString:@""],
                                    @"userName":NonEmpty(userName),
                                    @"idcardNo":[idCard stringByReplacingOccurrencesOfString:@" " withString:@""],
                                    @"mobileNumber":NonEmpty(mobileStr)};
    
    NSMutableDictionary *params = @{@"bankCode":@"PSBC",
                                    @"cardType":@"D",
                                    @"idcardType":@"1",
                                    @"channelType":@"1003",
                                    @"uleProtocol":@"1",
                                    @"accountValidatecode":NonEmpty(smsCode),
                                    @"type":NonEmpty(type)}.mutableCopy;
    [params setValuesForKeysWithDictionary:[US_NetworkExcuteManager getEncryptedParamsWithDic:clearParamDic andKey:o_key andIV:o_Iv]];
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_AuthrizeRealName andParams:params];
    request.headParams = @{@"X-Emp-Token":NonEmpty(token),
                           @"X-Emp-Signature":NonEmpty(signStr),
                           @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildWithdrawApplyWithPhoneNum:(NSString *)phoneStr bankCodeNum:(NSString *)bankCode transMoneyNum:(NSString *)transMoney accTypeId:(NSString *)accTypeId
{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //获取密钥和向量字符串
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSDictionary *clearParamDic = @{@"phone":NonEmpty(phoneStr)};
    NSMutableDictionary *params = @{@"bankCode":NonEmpty(bankCode),
                                    @"transMoney":NonEmpty(transMoney),
                                    @"accTypeId":accTypeId.length > 0 ? accTypeId : @"A002",
                                    @"bankOrgan":@"中国邮政储蓄银行",
                                    @"transTypeId":@"T102",
                                    @"transFlag":@"E"
                                    }.mutableCopy;
    [params setValuesForKeysWithDictionary:[US_NetworkExcuteManager getEncryptedParamsWithDic:clearParamDic andKey:o_key andIV:o_Iv]];
    UleRequest *request = [[UleRequest alloc]initWithApiName:API_accountWithdrawApply andParams:params];
    request.headParams = @{@"X-Emp-Token":NonEmpty(token),
                           @"X-Emp-Signature":NonEmpty(signStr),
                           @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildCouponListInfoWithStatus:(NSString *)status pageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize{
    NSMutableDictionary *params = @{@"status":NonEmpty(status),
                                    @"pageSize":NonEmpty(pageSize),
                                    @"pageIndex":NonEmpty(pageIndex),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_GetListingCoupon andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取可使用优惠券商品列表
+ (UleRequest *)buildCouponUseListWithId:(NSString *)batchId pageIndex:(NSString *)pageIndex sortType:(NSString *)sortType andSortOrder:(NSString *)sortOrder{
    NSString * pageSize=@"10";
    NSMutableDictionary *params = @{@"couponBatchId":NonEmpty(batchId),
                                    @"pageSize":NonEmpty(pageSize),
                                    @"pageIndex":NonEmpty(pageIndex),
                                    @"sortType":NonEmpty(sortType),
                                    @"sortOrder":NonEmpty(sortOrder)
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_GetUseableListing andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestCouponBacthId:batchId pageIndex:pageIndex andPageSize:pageSize];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}


//请求客户列表
+ (UleRequest *) buildMemberListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize SearchType:(NSString *)searchType CustomerName:(NSString *)customerName{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    
    NSMutableDictionary *params = @{@"villageNo":[US_UserUtility sharedLogin].m_orgCode,
                                    @"cpage":NonEmpty(startPage),
                                    @"perpage":NonEmpty(pageSize),
                                    @"searchType":NonEmpty(searchType),
                                    @"customerName":NonEmpty(customerName)}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_MemberList andParams:params requsetMethod:RequestMethod_Post];
    //签名
    NSString *signString = [NSString stringWithFormat:@"CUSTOMERNAME%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",customerName,m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//上传客户头像图片
+ (UleRequest *)buildUploadMemberImageWithStreamData:(NSString *)imageStream{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmssssssssssss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",currentDateStr];
    NSMutableDictionary *params = @{@"imageBase64":NonEmpty(imageStream),
                                    @"imageName":NonEmpty(imageName),
                                    @"villageNo":[US_UserUtility sharedLogin].m_orgType
                                    }.mutableCopy;
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"IMAGENAME%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",imageName,m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    NSMutableDictionary *hparams = @{@"X-Emp-Token":NonEmpty(token),
                                     @"X-Emp-Signature":NonEmpty(signStr),
                                     @"X-Emp-Timestamp":NonEmpty(m_time),
                                     }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_uploadPic andParams:params];
    request.headParams=hparams;
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//修改客户信息
+ (UleRequest *)buildUpdateMemberInfoRequestWithDateDic:(NSDictionary *)dic{
    NSMutableDictionary *params = dic.mutableCopy;
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    //签名
    NSString *signString = [NSString stringWithFormat:@"CARDNUM%@IDCARD%@MOBILE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",dic[@"cardNum"],dic[@"idcard"],dic[@"mobile"],m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_UpdateMemberInfo andParams:params];
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//修改密码下发短信
+ (UleRequest *) buildSendSMSCodeForChangePwdRequestWithPhoneNum:(NSString *)phoneNum{
    NSString *token = [Ule_SecurityKit Random_Number:32];
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = phoneNum;
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    NSMutableDictionary *params = @{@"mobile":NonEmpty(en_str)}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_smsResetPwd andParams:params requsetMethod:RequestMethod_Post];
    //签名
    NSString *signString = [NSString stringWithFormat:@"MOBILE%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",phoneNum,m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//修改登录密码
+ (UleRequest *) buildChangePwdRequestWithPhoneNum:(NSString *)phoneNum SMSCode:(NSString *)smsCode NewPwd:(NSString *)newPwd{
    NSString *token=@"";
    if ([US_UserUtility sharedLogin].mIsLogin) {
        token=[US_UserUtility sharedLogin].m_userToken;
    }
    else{
        token=[Ule_SecurityKit Random_Number:32];
    }
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = @{@"mobile":NonEmpty(phoneNum),
                                 @"validateCode":NonEmpty(smsCode),
                                 @"newPwd":NonEmpty(newPwd)}.mutableCopy;
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:dic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_ResetPwd andParams:params requsetMethod:RequestMethod_Post];
    //签名
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@",m_time,token];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//查询是否设置过支付密码
+ (UleRequest *) buildChackPayPwdStatusRequest{
    return [self buildCommonRequestWithApiName:API_isSetPaySecurity];
}

//修改支付密码下发短信
+ (UleRequest *) buildSendReplacePayPwdSMSCodeRequest{
    return [self buildCommonRequestWithApiName:API_smsReplacePayPwd];
}

//修改支付密码接口
+ (UleRequest *) buildReplacePayPwdRequestWithSMSCode:(NSString *)SMSCode NewPwd:(NSString *)newpwd OldPwd:(NSString *)oldPwd{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = @{@"randomCode":NonEmpty(SMSCode),
                                 @"newpwd":NonEmpty(newpwd),
                                 @"oldpwd":NonEmpty(oldPwd)
                                 }.mutableCopy;
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:dic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    NSMutableDictionary *params = @{@"p":en_str}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_replacePayPwd andParams:params requsetMethod:RequestMethod_Post];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//重置支付密码下发短信
+ (UleRequest *) buildSendResetPayPwdSMSCodeRequest{
    return [self buildCommonRequestWithApiName:API_smsResetPayPwd];
}

//重置支付密码接口
+ (UleRequest *) buildResetPayPwdRequestWithSMSCode:(NSString *)SMSCode NewPwd:(NSString *)newpwd{
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    NSMutableDictionary *dic = @{@"randomCode":NonEmpty(SMSCode),
                                 @"newpwd":NonEmpty(newpwd)
                                 }.mutableCopy;
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:dic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    NSMutableDictionary *params = @{@"p":NonEmpty(en_str)}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_resetPayPwd andParams:params requsetMethod:RequestMethod_Post];
    //签名
    NSString *signString = [NSString stringWithFormat:@"X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *) buildSuggestSubmitRequest:(NSString *)suggestText{
    if (suggestText.length <= 0) {
        return nil;
    }
    NSMutableDictionary *passDic = @{@"content":suggestText}.mutableCopy;
    NSString *token = [US_UserUtility sharedLogin].m_userToken;
    //获取时间戳
    NSString *m_time = [CalcKeyIvHelper getTimestamp];
    //获取密钥和向量字符串
    NSString *o_key = [[CalcKeyIvHelper shared] getKeyString:token timestamp:m_time];
    NSString *o_Iv = [[CalcKeyIvHelper shared] getIvString:token];
    //获取向量的byte数组
    NSData *IvData = [o_Iv dataUsingEncoding: NSUTF8StringEncoding];
    
    //参数P，原本的参数转化成字符串然后AES加密生成新的字符串
    NSString *passStr = [NSString jsonStringWithDictionary:passDic];
    NSData *data = [passStr dataUsingEncoding:NSUTF8StringEncoding];
    NSData *m_data = [Ule_SecurityKit M_EncryptWithData:data WithKey:o_key WithIV:[IvData bytes]];
    NSString *en_str = [m_data base64EncodedString];
    
    NSMutableDictionary *params = @{@"p":NonEmpty(en_str),
                                    @"content":NonEmpty(suggestText),}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_doFeedback andParams:params requsetMethod:RequestMethod_Post];
    //签名
    NSString *signString = [NSString stringWithFormat:@"CONTENT%@X-EMP-TIMESTAMP%@X-EMP-TOKEN%@X-EMP-U%@",suggestText,m_time,token,[US_UserUtility sharedLogin].m_userId];
    NSString *signStr = [Ule_SecurityKit encodeHash:o_key text:signString];
    //加请求头
    request.headParams=@{@"X-Emp-Token":NonEmpty(token),
                         @"X-Emp-Signature":NonEmpty(signStr),
                         @"X-Emp-Timestamp":NonEmpty(m_time)};
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//获取邀请人列表
+ (UleRequest *) buildGetInviterListRequestWithStartPage:(NSString *)startPage PageSize:(NSString *)pageSize{
    
    NSMutableDictionary *params = @{@"pageIndex":NonEmpty(startPage),
                                    @"pageSize":NonEmpty(pageSize)
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getInviterList andParams:params requsetMethod:RequestMethod_Post];
    //加请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//获取邀请人详情
+ (UleRequest *) buildGetInviterDetailRequestWithInviterId:(NSString *)inviterId{
    
    NSMutableDictionary *params = @{@"ownerId":NonEmpty(inviterId)
                                    }.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getInviterDetail andParams:params requsetMethod:RequestMethod_Post];
    //加请求头
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *) buildGetInviteUrlReuqest{
    
    NSMutableDictionary *headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    NSMutableDictionary *bodyParams= @{@"clientType":NonEmpty([UleStoreGlobal shareInstance].config.clientType)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getInvitationUrl andParams:bodyParams];
    request.headParams=headParams;
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetInviteOpenBackroundImage{
    NSString * sectionKey=NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_Invited);
    NSString * urlString= [NSString stringWithFormat:@"%@/0/%@/null/null/null/null/null.html",API_cdnFeaturedGet,sectionKey];
    UleRequest * request=[[UleRequest alloc] initWithApiName:urlString andParams:nil requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.cdnServerDomain;
    return request;
}

+ (UleRequest *) buildGetMyStoreUrlRequest
{
    NSMutableDictionary *headParams = [US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    NSString *shareLink = [NSString stringWithFormat:@"%@/mxiaodian/store/index.html",[UleStoreGlobal shareInstance].config.mUleDomain];
    NSMutableDictionary *params = @{@"shareType":@"5",
                                    @"shareLink":shareLink
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_ShareStoreInfo andParams:params];
    request.headParams=headParams;
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetFenxiaoMyStoreUrlRequest{
    NSDictionary *params=@{@"subType":@"3",
                           @"shareType":@"61",
                           @"zoneId":[US_UserUtility getPixiaoZoneIdWithComma]};
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_fx_shareStoreURL andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}


//获取购物车数量
+ (UleRequest *)buildGetShopCartCount{
    
    NSMutableDictionary *params = @{@"yxdId":[US_UserUtility sharedLogin].m_userId}.mutableCopy;
    //创建请求
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_getCartCount andParams:params requsetMethod:RequestMethod_Post];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
//获取我的模块信息
+ (UleRequest *)buildUserCenterRequest{
//    UleRequest * request=[[UleRequest alloc] initWithApiName:kUserCenterList andParams:nil requsetMethod:RequestMethod_Get];
//    request.baseUrl=KAPIServiceUrl;
    NSMutableDictionary *params = @{@"sectionKeys":NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_UserCenter),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_FeaturedGet andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

//自有商品货款提示
+ (UleRequest *)buildOwnGoodsTips
{
    NSMutableDictionary *params = @{@"sectionKeys":NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_ownGoodstips),
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_FeaturedGet andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    return request;
}

@end
