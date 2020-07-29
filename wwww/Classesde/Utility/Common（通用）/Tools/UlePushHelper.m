//
//  UlePushHelper.m
//  u_store
//
//  Created by wangkun on 16/5/25.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "UlePushHelper.h"
#import "USApplicationLaunchManager.h"
#import <UIView+ShowAnimation.h>
#import "UleRedPacketRainManager.h"
#import "USApplicationLaunchApi.h"
#import "UleTabBarViewController.h"

static NSInteger const TAG_PUSHALERT_NOLOGIN=11111;
static NSInteger const TAG_PUSHALERT_FRONT=22222;

@interface UlePushHelper ()<UIAlertViewDelegate>
@property (nonatomic, strong) NSDictionary  *localInfoDic;
@property (nonatomic, strong) UleNetworkExcute * trackClient;
@end

@implementation UlePushHelper

+ (UlePushHelper *)shared {
    static UlePushHelper *sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[UlePushHelper alloc]init];
    });
    return sharedObject;
}

- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //    [UlePushHelper shared].pushInfo = nil;
    
//    StuPushMsgInfo * stuPushMsgInfo = [UlePushHelper shared].stuPushMsgInfo;
//    NSDictionary *dic =  [userInfo objectForKey:@"msg"];
//    stuPushMsgInfo.msgtype = [[dic objectForKey:@"type"] integerValue];
//    stuPushMsgInfo.msgtext = [dic objectForKey:@"text"];
//    stuPushMsgInfo.msgId = [dic objectForKey:@"id"];
    
    //    stuPushMsgInfo.msgtype = 6;
    //    stuPushMsgInfo.msgtext = @"WEBVIEW&key|http://ule.cn/afstgb#hasxib|0#title|标题#hasnavi|1";
    //    stuPushMsgInfo.msgId = @"123901";
    
    [UlePushHelper shared].pushAlertInfo=nil;
    if ([US_UserUtility sharedLogin].mIsLogin)
    {
        [self pushAction:userInfo];
    }
    else
    {
        if ([UlePushHelper shared].showPushAlert) return;
        //取出内容
        NSString *filtermessage=@"";
        NSDictionary *apsDictionary=[userInfo objectForKey:@"aps"];
        NSObject *alertObj = [apsDictionary objectForKey:@"alert"];
        if ([alertObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=(NSDictionary *)alertObj;
            filtermessage=[dic objectForKey:@"body"];
        }else if ([alertObj isKindOfClass:[NSString class]]) {
            filtermessage=[apsDictionary objectForKey:@"alert"];
        }
        //取出pushAction
        NSString *pushStr=[[userInfo objectForKey:@"msg"] objectForKey:@"text"];
        BOOL isPushAction=pushStr&&pushStr.length>0;
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"推送消息" message:filtermessage delegate:self cancelButtonTitle:isPushAction?@"取消":@"我知道啦" otherButtonTitles:isPushAction?@"登录后查看":nil,nil];
        alert.delegate=self;
        alert.tag=TAG_PUSHALERT_NOLOGIN;
        if ([USApplicationLaunchManager sharedManager].isGuideViewShowed) {
            //在广告页面
            [UlePushHelper shared].pushAlertInfo=userInfo;
        }else{
            [alert show];
            self.localInfoDic=userInfo;
            [UlePushHelper shared].showPushAlert=YES;
        }
    }
}

- (void)pushAction:(NSDictionary *)userInfo {
    
    //应用处于前台时，需要手动处理
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        //取出内容
        NSString *filtermessage=@"";
        NSString *title=@"";
        NSDictionary *apsDictionary=[userInfo objectForKey:@"aps"];
        NSObject *alertObj = [apsDictionary objectForKey:@"alert"];
        if ([alertObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=(NSDictionary *)alertObj;
            filtermessage=[dic objectForKey:@"body"];
            title=[dic objectForKey:@"title"];
        }else if ([alertObj isKindOfClass:[NSString class]]) {
            filtermessage=[apsDictionary objectForKey:@"alert"];
        }
        //取出pushAction
        NSString *pushStr=[[userInfo objectForKey:@"msg"] objectForKey:@"text"];
        BOOL isPushAction=pushStr&&pushStr.length>0;
        //如果是在前台，必须给出alert.不然会很奇怪
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title.length>0?title:@"推送消息" message:filtermessage delegate:self cancelButtonTitle:isPushAction?@"取消":@"我知道啦" otherButtonTitles:isPushAction?@"点击查看":nil,nil];
        alert.delegate=self;
        alert.tag=TAG_PUSHALERT_FRONT;
        if ([USApplicationLaunchManager sharedManager].isGuideViewShowed) {
            //在广告页面
            [UlePushHelper shared].pushAlertInfo=userInfo;
        }else {
            [alert show];
            self.localInfoDic=userInfo;
            [UlePushHelper shared].showPushAlert=YES;
        }
    }
    //当应用在后台进入前台的时候，直接进入相关的信息详情
    else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
    {
        [UlePushHelper shared].pushInfo=userInfo;
    }
}

#pragma mark - 处理推送
- (void)handlePushAction:(NSDictionary *)userInfo
{
    [UlePushHelper shared].pushInfo=nil;
    NSString *context = nil;
    if (userInfo) {
        context = [[userInfo objectForKey:@"msg"] objectForKey:@"text"];
    }
    if (!context || context.length==0) {
        return;
    }
    NSString *alertContStr=@"";
    NSDictionary *apsDictionary=[userInfo objectForKey:@"aps"];
    NSObject *alertObj = [apsDictionary objectForKey:@"alert"];
    if ([alertObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic=(NSDictionary *)alertObj;
        alertContStr=[dic objectForKey:@"body"];
    }else if ([alertObj isKindOfClass:[NSString class]]) {
        alertContStr=[apsDictionary objectForKey:@"alert"];
    }
    [self handlePushParams:context alertStr:alertContStr];
}

-(void)handlePushParams:(NSString *)context alertStr:(NSString *)alertStr{
    if (!context || context.length==0) {
        return;
    }
    [UlePushHelper shared].msgInfo=nil;
    NSMutableArray *dataArray=[NSMutableArray arrayWithArray:[context componentsSeparatedByString:@"##"]];
    NSString *abbName=[dataArray firstObject];//缩写的类名
    if (abbName.length>0) {
        //红包雨消失
        [UleRedPacketRainManager hiddenUleRdPacketRain];
    }
    //从红包雨推送进入
    if ([abbName isEqualToString:@"REDPACKETRAIN"]) {
        return;
    }
    
    UleUCiOSAction *commonAction=[UleModulesDataToAction resolveNotificationModulesStr:context];
    //跳转到tabbar
    if ([commonAction.mViewControllerName isEqualToString:@"HO"]) {
        NSString *tabbarIndex=@"0";
        if ([NSString isNullToString:[commonAction.mParams objectForKey:@"INDEX"]].length>0) {
            tabbarIndex=[NSString isNullToString:[commonAction.mParams objectForKey:@"INDEX"]];
        }
        UleTabBarViewController *tabbarVC=(UleTabBarViewController*)[UIViewController currentViewController].tabBarController;
        if (tabbarVC&&[tabbarIndex integerValue]>=0&&[tabbarIndex integerValue]<tabbarVC.viewControllers.count) {
            [tabbarVC selectTabBarItemAtIndex:[tabbarIndex integerValue] animated:YES];
        }
        return;
    }
    //如果当前在要跳转的页面,就不跳转(web页除外)
    NSString *showClassName = NSStringFromClass([[UIViewController currentViewController] class]);
    if (![abbName isEqualToString:@"H5"]&&![abbName isEqualToString:@"WV"]&&[commonAction.mViewControllerName isEqualToString:showClassName]) {
        return;
    }
    
    UIViewController *currentVC=[UIViewController currentViewController];
    if(currentVC.presentedViewController != nil) {
        [currentVC.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [currentVC pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==TAG_PUSHALERT_NOLOGIN) {
        [UlePushHelper shared].showPushAlert=NO;
        if (buttonIndex==1) {
            //点击登陆后查看
            [UlePushHelper shared].pushInfo=self.localInfoDic;
            //应用在前台
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
                [self clickRemoteNotificationWithUserInfo:self.localInfoDic];
            }
        }
    }else if (alertView.tag==TAG_PUSHALERT_FRONT) {
        if (buttonIndex==1) {
            [UlePushHelper shared].showPushAlert=NO;
            if ([USApplicationLaunchManager sharedManager].isGuideViewShowed) {
                //在广告页面
                [UlePushHelper shared].pushInfo=self.localInfoDic;
            }else{
                [self handlePushAction:self.localInfoDic];
            }
            //应用在前台
            [self clickRemoteNotificationWithUserInfo:self.localInfoDic];
            //
            [LogStatisticsManager shareInstance].srcid=Srcid_Push;
        }
    }
}
-(void)noLoginAlertClicked {
    
}

/** 点击推送通知 */
- (void)clickRemoteNotificationWithUserInfo:(NSDictionary *)userInfo{
    // 处理有效数据
    if (!userInfo || userInfo.count == 0 ) {
        return;
    }
    NSDictionary *msgDictionary = [userInfo objectForKey:@"msg"];
    NSString * msgID = [NSString stringWithFormat:@"%@",[msgDictionary objectForKey:@"id"]];
    //没有msgID就不调接口 有msgID的是广播推送 才需要显示小圆点
    if (msgID.length <=0) {
        return;
    }
    [self.trackClient beginRequest:[USApplicationLaunchApi buildPushMsgClickRequestWithBatchId:msgID] success:^(id responseObject) {
        
    } failure:nil];
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)trackClient{
    if (!_trackClient) {
        _trackClient=[US_NetworkExcuteManager uleTrackRequestClient];
    }
    return _trackClient;
}
@end
