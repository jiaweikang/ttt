//
//  US_LoginApi.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UleRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_LoginApi : NSObject
/*********登录**********/
//获取登录验证码
+ (UleRequest *)buildLoginSMSCodeWithAccount:(NSString *)accountStr;

//验证码登录
+ (UleRequest *)buildLoginByCodeRequestWithAccount:(NSString *)accountStr smsCode:(NSString *)codeStr;

//密码登录
+ (UleRequest *)buildLoginByPasswordRequestWithAccount:(NSString *)accountStr password:(NSString *)passwdStr;

//口令登录
+ (UleRequest *)buildQuickLoginWithKouLing:(NSString *)kouLingString;

/**************注册*****************/
/**注册大网**/
+ (UleRequest *)buildRegistSMSCodeWithAccount:(NSString *)accountStr;

+ (UleRequest *)buildPreRegistByCodeRequestWithAccount:(NSString *)accountStr smsCode:(NSString *)codeStr;
/**注册小店**/
+ (UleRequest *)buildRegistStoreRequestWithJsonParam:(NSString *)jsonParamStr;

/********修改店主信息*********/
+ (UleRequest *)buildUpdateUserInfoWithParams:(NSDictionary *)paramDic;

/********获取省市县区*********/
+ (UleRequest *)buildPostOrganizationWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName andOrgType:(NSString *)orgType;

/********获取企业数据*********/
+ (UleRequest *)buildPostEnterpriseInfo;

/********获取战队数据*********/
+ (UleRequest *)buildTeamInfo;


//签署协议
+ (UleRequest *)buildContractSignRequest;

/********请求账号注销前权益信息*********/
+ (UleRequest *)buildGetUserLogOffDetailRequest;
/** 账号注销 */
+ (UleRequest *)buildUserLogOffRequest;

+ (UleRequest *)buildOnekeyLoginWithToken:(NSString *)onekeyToken;
@end

NS_ASSUME_NONNULL_END
