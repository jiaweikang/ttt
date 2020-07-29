//
//  USCookieHelper.h
//  u_store
//
//  Created by xstones on 2018/1/19.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

#define KWKCOOKIEMETHOD @"function setCookie(name,value,domain,expires)\
{\
var oDate=new Date();\
oDate.setDate(oDate.getDate()+expires);\
document.cookie=name+'='+value+';expires='+oDate+';domain='+domain+';path=/'\
}\
function getCookie(name)\
{\
var arr = document.cookie.match(new RegExp('(^| )'+name+'=({FNXX==XXFN}*)(;|$)'));\
if(arr != null) return unescape(arr[2]); return null;\
}\
function delCookie(name)\
{\
var exp = new Date();\
exp.setTime(exp.getTime() - 1);\
var cval=getCookie(name);\
if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
}"

typedef void(^USCookieHelperBlock)(void);

@interface USCookieHelper : NSObject
@property (strong, nonatomic) WKProcessPool *processPool;
+(USCookieHelper *)sharedHelper;

- (void)requestMall_cookieComplete:(USCookieHelperBlock)comBlock;

- (void)setMall_cookieComplete:(USCookieHelperBlock)comBlock;

- (void)setCookie;

- (void)deleteMall_cookie;

- (void)deleteCookie;

- (void)removeDiskCache;

- (NSString *)appendCookieString;

- (void)resetCookieToWebView:(WKWebView *)webView;

- (NSString *)cookieJavaScriptString;
@end
