//
//  US_MystoreManangerApi.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_MystoreManangerApi.h"
#import "CalcKeyIvHelper.h"
#import <Ule_SecurityKit.h>
#import "DeviceInfoHelper.h"
@implementation US_MystoreManangerApi

+ (UleRequest *)buildFindStoreInfoReqeust{
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_findStoreInfo andParams:nil];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildUploadImageWithStreamData:(NSString *)imageStream{
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[CalcKeyIvHelper getTimestamp]];
    NSMutableDictionary *params = @{@"imageBase64":NonEmpty(imageStream),
                                    @"imageName":NonEmpty(imageName),
                                    @"orgType":[US_UserUtility sharedLogin].m_orgType
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

+ (UleRequest *)buildUpdateStoreInfo:(NSString *)storeName shareText:(NSString *)shareText type:(NSString *)type{

    NSMutableDictionary *params = @{@"orgType":NonEmpty([US_UserUtility sharedLogin].m_orgType),
                                    @"storeNameOther":storeName.length>0?storeName:NonEmpty([DeviceInfoHelper getAppName])
                                    }.mutableCopy;
    if ([type isEqualToString:@"1"]) {
        [params setObject:shareText.length>0?shareText:@"有一家不错的店铺！分享给你们" forKey:@"storeNameDescribe"];
    }
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_ModifyStoreInfo andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetMessageListFromIndex:(NSInteger)startIndex{
    NSMutableDictionary *params = @{@"clientType":NonEmpty([UleStoreGlobal shareInstance].config.appName),
                                    @"version":NonEmpty([UleStoreGlobal shareInstance].config.versionNum),
                                    @"os":@"iphone",
                                    @"pageIndex":[NSString stringWithFormat:@"%@",@(startIndex)],
                                    @"pageSize":@"10",
                                    @"provinceCode":NonEmpty([US_UserUtility sharedLogin].m_provinceCode),
                                    @"cityCode":NonEmpty([US_UserUtility sharedLogin].m_cityCode),
                                    @"areaCode":NonEmpty([US_UserUtility sharedLogin].m_areaCode)}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_MessageList andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

+ (UleRequest *)buildGetCategroyMessageFromIndex:(NSInteger)startIndex category:(NSString *)category{
    NSMutableDictionary *params = @{@"appType":NonEmpty([UleStoreGlobal shareInstance].config.appName),
                                    @"channels":@"1",
                                    @"category":NonEmpty(category),
                                    @"page":[NSString stringWithFormat:@"%@",@(startIndex)],
                                    @"pageSize":@"10",
                                    @"userId":[US_UserUtility sharedLogin].m_userId}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_CategoryMessageList andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}

//修改用户姓名
+ (UleRequest *)buildUpdateUserName:(NSString *)userName {
    
    NSMutableDictionary *params = @{@"userName":userName
                                    }.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:kAPI_updateUserName andParams:params];
    request.headParams=[US_NetworkExcuteManager getRequestHeaderNormalSignParams];
    request.baseUrl=[UleStoreGlobal shareInstance].config.apiDomain;
    return request;
}
@end

