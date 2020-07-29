//
//  USCookieHelper.m
//  u_store
//
//  Created by xstones on 2018/1/19.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "USCookieHelper.h"
#import "DESCrypt.h"
#import "DWKWebView.h"
#import "US_NetworkExcuteManager.h"
static Byte Iv[16] = {13, 8, 3, 16, 23, 6, 11, 5};//加密IV
@interface USCookieHelper ()
{
    NSData *ByteData;//加密
}
//@property (nonatomic, copy) USCookieHelperBlock mComBlock;
@property (nonatomic, strong) UleNetworkExcute * client;
@end

@implementation USCookieHelper

+(USCookieHelper *)sharedHelper
{
    static USCookieHelper *cookieHelper=nil;
    if (!cookieHelper) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cookieHelper=[[USCookieHelper alloc]init];
        });
    }
    return cookieHelper;
}

-(instancetype)init
{
    if (self=[super init]) {
        ByteData=[[NSData alloc]initWithBytes:Iv length:8];
    }
    return self;
}

- (WKProcessPool *)processPool{
    if (_processPool == nil) {
        _processPool = [[WKProcessPool alloc] init];
        
        [self sharedCookie];
    }
    return _processPool;
}

- (nullable id)sharedCookie {
    NSArray *arrCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    NSDictionary *dictCookies = [NSHTTPCookie requestHeaderFieldsWithCookies:arrCookies];
    
    return [dictCookies objectForKey:@"Cookie"];
}


//-(void)setCookieValue:(NSString *)cookieValue
//{
//    [[NSUserDefaults standardUserDefaults]setObject:cookieValue==nil?@"":cookieValue forKey:@"webCookieValue"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//-(NSString *)cookieValue
//{
//    NSString *m_cookie = [[NSUserDefaults standardUserDefaults]objectForKey:@"webCookieValue"];
//    return m_cookie?m_cookie:@"";
//}

-(void)requestMall_cookieComplete:(USCookieHelperBlock)comBlock{
    USCookieHelperBlock mCompleteBlock = [comBlock copy];
    NSLog(@"获取cookie");
    _client=[US_NetworkExcuteManager uleServerRequestClient];
    NSMutableDictionary *params = @{@"userId":[US_UserUtility sharedLogin].m_userId?[US_UserUtility sharedLogin].m_userId:@""}.mutableCopy;
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_GetCookiehelper andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    [self.client beginRequest:request success:^(id responseObject) {
        NSDictionary * dic=(NSDictionary *)responseObject;
        if (dic) {
            NSString *cookieValue = [dic objectForKey:@"value"];
            [US_UserUtility saveUserMallCookie:[NSString isNullToString:cookieValue]];
            [US_UserUtility sharedLogin].userMallCookieRequestedDate = [NSDate date];
            if (mCompleteBlock) {
                mCompleteBlock();
            }
        }
    } failure:^(UleRequestError *error) {
        NSLog(@"%@",error.error);
        if (mCompleteBlock) {
            mCompleteBlock();
        }
    }];
}


-(void)setMall_cookieComplete:(USCookieHelperBlock)comBlock
{
    USCookieHelperBlock mComBlock = [comBlock copy];
    NSString *m_cookie = [US_UserUtility sharedLogin].m_mallCookie;
    if (m_cookie != nil && ![m_cookie isEqualToString:@""]) {
        [self setMall_cookie];
        if (mComBlock) {
            mComBlock();
        }
    }else {
        @weakify(self);
        [self requestMall_cookieComplete:^{
            @strongify(self);
            [self setMall_cookie];
            if (mComBlock) {
                comBlock();
            }
        }];
    }
}

-(void)setMall_cookie{
    NSString *m_cookie = [US_UserUtility sharedLogin].m_mallCookie;
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"mall_cookie" forKey:NSHTTPCookieName];
    [cookieProperties setObject:NonEmpty(m_cookie) forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@".ule.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@".ule.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    
    NSMutableDictionary *cookieProperties1 = [NSMutableDictionary dictionary];
    [cookieProperties1 setObject:@"mall_cookie" forKey:NSHTTPCookieName];
    [cookieProperties1 setObject:NonEmpty(m_cookie) forKey:NSHTTPCookieValue];
    [cookieProperties1 setObject:@".ule.hk" forKey:NSHTTPCookieDomain];
    [cookieProperties1 setObject:@".ule.hk" forKey:NSHTTPCookieOriginURL];
    [cookieProperties1 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties1 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:cookieProperties1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    NSLog(@"setMall_cookie");
}

- (void)setCookie {
    
    //tom.com下DES加密后的usrOnlyid
    NSMutableDictionary *cookiePropertiesUser1 = [NSMutableDictionary dictionary];
    [cookiePropertiesUser1 setObject:@"usrOnlyid" forKey:NSHTTPCookieName];
    NSString *usrOnlyid = [DESCrypt encryptUseDES:[US_UserUtility sharedLogin].m_userId key:@"6fd4b7f4" iV:ByteData];
    [cookiePropertiesUser1 setObject:NonEmpty(usrOnlyid) forKey:NSHTTPCookieValue];
    [cookiePropertiesUser1 setObject:@".tom.com" forKey:NSHTTPCookieDomain];
    [cookiePropertiesUser1 setObject:@".tom.com" forKey:NSHTTPCookieOriginURL];
    [cookiePropertiesUser1 setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser1 setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookieuser1 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser1];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser1];
    
    NSArray *domainsArr=@[@".ule.com",@".ule.hk"];
    for (NSString *domain in domainsArr) {
        //ule.com下的vpsService_villageNo
        NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
        [cookiePropertiesUser setObject:@"vpsService_villageNo" forKey:NSHTTPCookieName];
        [cookiePropertiesUser setObject:[US_UserUtility sharedLogin].m_orgCode forKey:NSHTTPCookieValue];
        [cookiePropertiesUser setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        
        //ule.com下的websiteType
        NSMutableDictionary *cookiePropertiesUser2 = [NSMutableDictionary dictionary];
        [cookiePropertiesUser2 setObject:@"websiteType" forKey:NSHTTPCookieName];
        [cookiePropertiesUser2 setObject:[US_UserUtility sharedLogin].m_websiteType forKey:NSHTTPCookieValue];
        [cookiePropertiesUser2 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser2 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser2 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser2 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser2 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser2];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser2];
        
        //ule.com下DES加密后的usrOnlyid
        NSMutableDictionary *cookiePropertiesUser3 = [NSMutableDictionary dictionary];
        [cookiePropertiesUser3 setObject:@"usrOnlyid" forKey:NSHTTPCookieName];
        NSString *usrOnlyid1 = [DESCrypt encryptUseDES:[US_UserUtility sharedLogin].m_userId key:@"6fd4b7f4" iV:ByteData];
        [cookiePropertiesUser3 setObject:NonEmpty(usrOnlyid1) forKey:NSHTTPCookieValue];
        [cookiePropertiesUser3 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser3 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser3 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser3 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser3 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser3];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser3];
        
        //把appVersionNum写入cookie
        NSMutableDictionary *cookiePropertiesUser4 = [NSMutableDictionary dictionary];
        [cookiePropertiesUser4 setObject:@"appVersionNo" forKey:NSHTTPCookieName];
        [cookiePropertiesUser4 setObject:NonEmpty([UleStoreGlobal shareInstance].config.versionNum) forKey:NSHTTPCookieValue];
        [cookiePropertiesUser4 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser4 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser4 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser4 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser4 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser4];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser4];
        
        //把client_type写入cookie
        NSMutableDictionary *cookiePropertiesUser5 = [NSMutableDictionary dictionary];
        [cookiePropertiesUser5 setObject:@"client_type" forKey:NSHTTPCookieName];
        [cookiePropertiesUser5 setObject:NonEmpty([UleStoreGlobal shareInstance].config.cookie_clientType) forKey:NSHTTPCookieValue];
        [cookiePropertiesUser5 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser5 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser5 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser5 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser5 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser5];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser5];
        
        //把deviceId写入cookie
        NSMutableDictionary *cookiePropertiesUser6 = [NSMutableDictionary dictionary];
        [cookiePropertiesUser6 setObject:@"appDeviceId" forKey:NSHTTPCookieName];
        [cookiePropertiesUser6 setObject:NonEmpty([US_UserUtility sharedLogin].openUDID) forKey:NSHTTPCookieValue];
        [cookiePropertiesUser6 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUser6 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUser6 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUser6 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser6 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser6];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser6];
        
        //写入用户自己的provinceId
        NSMutableDictionary *cookieProperties_provinceId = [NSMutableDictionary dictionary];
        [cookieProperties_provinceId setObject:@"CurrentProvinceId" forKey:NSHTTPCookieName];
        if ([NSString isNullToString:[US_UserUtility sharedLogin].m_provinceCode].length > 0) {
            [cookieProperties_provinceId setObject:[US_UserUtility sharedLogin].m_provinceCode forKey:NSHTTPCookieValue];
        }
        [cookieProperties_provinceId setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_provinceId setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_provinceId setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_provinceId setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuser_provinceId = [NSHTTPCookie cookieWithProperties:cookieProperties_provinceId];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser_provinceId];
        
        //写入推荐人的provinceId
        NSMutableDictionary *cookiePropertiesUserORG_2 = [NSMutableDictionary dictionary];
        [cookiePropertiesUserORG_2 setObject:@"ReferrerProvinceId" forKey:NSHTTPCookieName];
        if ([NSString isNullToString:[US_UserUtility sharedLogin].m_userReferrerId].length > 0) {
            [cookiePropertiesUserORG_2 setObject:[US_UserUtility sharedLogin].m_userReferrerId forKey:NSHTTPCookieValue];
        }
        [cookiePropertiesUserORG_2 setObject:domain forKey:NSHTTPCookieDomain];
        [cookiePropertiesUserORG_2 setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookiePropertiesUserORG_2 setObject:@"/" forKey:NSHTTPCookiePath];
        [cookiePropertiesUserORG_2 setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookieuserORG_2 = [NSHTTPCookie cookieWithProperties:cookiePropertiesUserORG_2];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuserORG_2];
        
        //写入企业code orgType
        NSMutableDictionary *cookieProperties_orgtype = [NSMutableDictionary dictionary];
        [cookieProperties_orgtype setObject:@"orgType" forKey:NSHTTPCookieName];
        [cookieProperties_orgtype setObject:[US_UserUtility sharedLogin].m_orgType forKey:NSHTTPCookieValue];
        [cookieProperties_orgtype setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_orgtype setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_orgtype setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_orgtype setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie_orgtype = [NSHTTPCookie cookieWithProperties:cookieProperties_orgtype];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_orgtype];
        
        //写入userName (自提)
        NSMutableDictionary *cookieProperties_userName = [NSMutableDictionary dictionary];
        [cookieProperties_userName setObject:@"userName" forKey:NSHTTPCookieName];
        [cookieProperties_userName setObject:[[US_UserUtility sharedLogin].m_userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:NSHTTPCookieValue];
        [cookieProperties_userName setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_userName setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_userName setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_userName setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie_userName = [NSHTTPCookie cookieWithProperties:cookieProperties_userName];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_userName];
        
        //是否开通自有商品（开通商家）qualificationFlag
        NSMutableDictionary *cookieProperties_qualificationFlag = [NSMutableDictionary dictionary];
        [cookieProperties_qualificationFlag setObject:@"qualificationFlag" forKey:NSHTTPCookieName];
        [cookieProperties_qualificationFlag setObject:[US_UserUtility sharedLogin].qualificationFlag forKey:NSHTTPCookieValue];
        [cookieProperties_qualificationFlag setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_qualificationFlag setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_qualificationFlag setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_qualificationFlag setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie_qualificationFlag = [NSHTTPCookie cookieWithProperties:cookieProperties_qualificationFlag];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_qualificationFlag];
        //最低一级机构code
        NSMutableDictionary *cookieProperties_lowestOrgCode = [NSMutableDictionary dictionary];
        [cookieProperties_lowestOrgCode setObject:@"lowestOrgCode" forKey:NSHTTPCookieName];
        [cookieProperties_lowestOrgCode setObject:[US_UserUtility sharedLogin].m_lastOrgId forKey:NSHTTPCookieValue];
        [cookieProperties_lowestOrgCode setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_lowestOrgCode setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_lowestOrgCode setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_lowestOrgCode setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie_lowestOrgCode = [NSHTTPCookie cookieWithProperties:cookieProperties_lowestOrgCode];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_lowestOrgCode];
        //最低一级机构name
        NSMutableDictionary *cookieProperties_lowestOrgName = [NSMutableDictionary dictionary];
        [cookieProperties_lowestOrgName setObject:@"lowestOrgName" forKey:NSHTTPCookieName];
        [cookieProperties_lowestOrgName setObject:[[US_UserUtility sharedLogin].m_lastOrgName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:NSHTTPCookieValue];
        [cookieProperties_lowestOrgName setObject:domain forKey:NSHTTPCookieDomain];
        [cookieProperties_lowestOrgName setObject:domain forKey:NSHTTPCookieOriginURL];
        [cookieProperties_lowestOrgName setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties_lowestOrgName setObject:@"0" forKey:NSHTTPCookieVersion];
        NSHTTPCookie *cookie_lowestOrgName = [NSHTTPCookie cookieWithProperties:cookieProperties_lowestOrgName];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_lowestOrgName];
    }
}

- (void)deleteCookie {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie* cookie in cookies) {
    
        if ([cookie.name isEqualToString: @"vpsService_villageNo" ]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString: @"usrOnlyid"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"websiteType"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"appVersionNo"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"client_type"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"appDeviceId"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"orgCode"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"CurrentProvinceId"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"ReferrerProvinceId"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"orgType"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
        if ([cookie.name isEqualToString:@"userName"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

-(void)deleteMall_cookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie* cookie in cookies) {
        
        if ([cookie.name isEqualToString:@"mall_cookie"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

- (void)removeDiskCache{
    [self deleteCookie];
    [self deleteMall_cookie];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        if (@available(iOS 9.0, *)) {
            NSSet *websiteDataTypes = [NSSet setWithArray:@[ WKWebsiteDataTypeDiskCache,WKWebsiteDataTypeMemoryCache ]];
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                // Done
            }];
        } else {
            // Fallback on earlier versions
        }
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
    }
}

//获取缓存的cookie 并拼接为一个字符串
- (NSString *)appendCookieString {
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    //取出cookie
    NSMutableDictionary *cookieDic=[NSMutableDictionary dictionary];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        [cookieDic setValue:cookie.value forKey:cookie.name];
    }
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieString appendString:appendString];
    }
    return cookieString;
}

- (void)resetCookieToWebView:(WKWebView *)webView{
    //取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString *JSFuncString =KWKCOOKIEMETHOD;
    //拼凑js字符串
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@','%@', 1);", cookie.name, cookie.value,cookie.domain];
        [JSCookieString appendString:excuteJSString]; } //执行js
    [webView evaluateJavaScript:JSCookieString completionHandler:^(id obj, NSError * _Nullable error) {
        NSLog(@"%@",error);
    }];
}

- (NSString *)cookieJavaScriptString {
    NSMutableString *cookieString = [[NSMutableString alloc] init];
    // 取出cookie
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
        NSString *appendString = [NSString stringWithFormat:@"document.cookie='%@=%@;domain=%@;path=/';", cookie.name, cookie.value, cookie.domain];
        [cookieString appendString:appendString];
    }
    
    return cookieString;
}

@end
