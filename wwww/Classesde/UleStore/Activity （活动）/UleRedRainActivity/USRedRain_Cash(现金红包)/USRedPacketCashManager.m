//
//  USRedPacketCashManager.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/9.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USRedPacketCashManager.h"
#import "US_NetworkExcuteManager.h"
#import "US_RedPacketApi.h"
#import "USDrawLotteryResultView.h"
#import <UIView+ShowAnimation.h>
#import "UleRedPacketRainLocalManager.h"
#import "USRedPacketCashStartView.h"
#import <UleShareSDK/Ule_ShareView.h>
#import "UleTabBarViewController.h"

@interface USRedPacketCashManager ()
@property (nonatomic,copy)DrawLotteryResultBlock    successBlock;
@property (nonatomic,copy)DrawLotteryResultBlock    errorBlock;
@property (nonatomic, strong) UleNetworkExcute * networkClient_Service;
@end

@implementation USRedPacketCashManager

+ (instancetype)sharedManager{
    static USRedPacketCashManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[USRedPacketCashManager alloc]init];
        });
    }
    return sharedManager;
}

#pragma mark - <红包雨形式抽现金红包>
- (void)requestCashRedPacketByRedRain
{
    UleRedPacketRainModel *cashFieldModel=[UleRedPacketRainLocalManager sharedManager].cashRedFieldInfo;
    if (![UleRedPacketRainLocalManager sharedManager].isRedRainActivity||!cashFieldModel||cashFieldModel.activityCode.length<=0||cashFieldModel.fieldId.length<=0) {
        return;
    }
    //超过日请求数
    if ([US_UserUtility isLimitedForRedPacket]) {
        return;
    }
    NSString *cashActivityCode=[NSString stringWithFormat:@"%@", cashFieldModel.activityCode];
    NSString *cashFieldCode=[NSString stringWithFormat:@"%@", cashFieldModel.fieldId];
    
    @weakify(self);
    USRedPacketCashStartView *startView = [[USRedPacketCashStartView alloc]init];
    startView.confirmActionBlock = ^{
        //开始下红包雨 （用现金活动场次）
        UleRedPacketRainModel *rainModel=[[UleRedPacketRainModel alloc]init];
        rainModel.activityCode=cashActivityCode;
        rainModel.fieldId=cashFieldCode;
        rainModel.channel=UleRedPacketRainChannel;
        rainModel.userId=[US_UserUtility sharedLogin].m_userId;
        rainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
        rainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
        rainModel.orgCode=[US_UserUtility sharedLogin].m_orgType;
        rainModel.activityDate=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.interval;
        rainModel.wishes=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.failText;
        [UleRedPacketRainManager startUleRedPacketRainWithModel:rainModel environment:[UleStoreGlobal shareInstance].config.envSer>0?YES:NO increaseCashDarw:YES ClickEvent:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
            @strongify(self);
            switch (event) {
                case UleRedpacketRainEventShare:
                    [self showShareViewWithDataArray:obj andShareText:[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.shareText];
                    break;
                case UleRedpacketRainEventToHomePage:
                    [self uleRedPacketGotoHomePage];
                    break;
                case UleRedpacketRainEventToMain:
                    [self uleRedPacketGotoMainVenue];
                    break;
                case UleRedpacketRainEventToUse:
                    [self uleRedPacketGotoUse];
                    break;
                case UleRedpacketRainEventOneMore:
                    
                    break;
                default:
                    break;
            }
        }];
    };
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [startView showViewWithAnimation:AniamtionAlert];
    });
}

#pragma mark - <调用现金抽奖接口>
- (void)requestCashRedPacket {
    UleRedPacketRainModel *cashFieldModel=[UleRedPacketRainLocalManager sharedManager].cashRedFieldInfo;
    
    if (![UleRedPacketRainLocalManager sharedManager].isRedRainActivity||!cashFieldModel||cashFieldModel.activityCode.length<=0||cashFieldModel.fieldId.length<=0) {
        return;
    }
    //超过日请求数
    if ([US_UserUtility isLimitedForRedPacket]) {
        [self showShareBackViewType:USDrawLotteryResultTypeFail dataDic:nil];
        return;
    }
    
    NSString *cashActivityCode=cashFieldModel.activityCode;
    NSString *cashFieldCode=cashFieldModel.fieldId;
    
    [self requestCashRedPacketWithActivityCode:cashActivityCode andFieldId:cashFieldCode increaseDrawCount:YES successBlock:nil errorBlock:nil];
}

- (void)requestCashRedPacketWithActivityCode:(NSString *)activityCode andFieldId:(NSString *)fieldId increaseDrawCount:(BOOL)isIncrease successBlock:(__nullable DrawLotteryResultBlock)mSuccessBlock errorBlock:(__nullable DrawLotteryResultBlock)mErrorBlock{
    if (!activityCode||activityCode.length==0) {
        return;
    }
    self.successBlock = [mSuccessBlock copy];
    self.errorBlock = [mErrorBlock copy];
    
    @weakify(self);
    [self.networkClient_Service beginRequest:[US_RedPacketApi buildLotteryRequestWithActivityCode:activityCode andFieldId:fieldId] success:^(id responseObject) {
        USLog(@"现金抽奖成功 %@",responseObject);
        @strongify(self);
        [self parseDrawAwardData:responseObject increaseCount:isIncrease];
    } failure:^(UleRequestError *error) {
        USLog(@"现金抽奖失败 %@", error);
        @strongify(self);
        [self showShareBackViewType:USDrawLotteryResultTypeFail dataDic:error.responesObject];
    }];
}

#pragma mark - <红包雨结果处理>
//分享
-(void)showShareViewWithDataArray:(NSArray *)dataArr andShareText:(NSString *)shareText{
    UleAwardCellModel *maxModel=nil;
    CGFloat maxMoney=0.0;
    for (UleAwardCellModel *item in dataArr) {
        CGFloat currentF=[item.money floatValue];
        if (currentF>maxMoney) {
            maxModel=item;
            maxMoney=currentF;
        }
    }
    if (maxModel==nil || shareText.length <= 0) {
        return ;
    }
    
    NSArray * shareTextArr = [shareText componentsSeparatedByString:@"&&"];
    if ([shareTextArr count] < 2) {
        return;
    }
    NSString * titlesStr=[shareTextArr firstObject];
    NSString * contentsStr=[shareTextArr objectAtIndex:1];
    NSArray * titlesArr = [titlesStr componentsSeparatedByString:@"##"];
    NSArray * contentsArr = [contentsStr componentsSeparatedByString:@"##"];
    if ([titlesArr count] == 0 || [contentsArr count] == 0) {
        return;
    }
    NSString *shareTitle = @"";
    NSString *shareContent = @"";
    if ([titlesArr count] == 1) {
        shareTitle = [titlesArr firstObject];
    }
    else{
        shareTitle = [titlesArr objectAtIndex:[self getRandomNumberFrom:0 to:[titlesArr count]-1]];
    }
    if ([contentsArr count] == 1) {
        shareContent = [contentsArr firstObject];
    }
    else{
        shareContent = [contentsArr objectAtIndex:[self getRandomNumberFrom:0 to:[contentsArr count]-1]];
    }
    NSString * host=[UleStoreGlobal shareInstance].config.ulecomDomain;
    NSString * linkUrl=[NSString stringWithFormat:@"%@%@?prizeMoney=%@&prizeType=%@",host,kRedRainShareUrl,maxModel.money.length>0?maxModel.money:@"",maxModel.awardTypeStr.length>0?maxModel.awardTypeStr:@""];
    NSString * title=[shareTitle stringByReplacingOccurrencesOfString:@"<P_AMOUNT>" withString:maxModel.money];
    NSString * shareImgUrl = [UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_4.shareImage;
    if (!shareImgUrl||shareImgUrl.length==0) {
        shareImgUrl = kRedRainShareImageUrl;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shareLine:linkUrl andLinkTitle:title andLinkDescription:shareContent imageUrl:shareImgUrl andShareType:@"010"];
    });
}

- (void)shareLine:(NSString *)linkURL andLinkTitle:(NSString *)linkTitle andLinkDescription:(NSString *)linkDescription imageUrl:(NSString * )imageUrl andShareType:(NSString *)mShareType {
    
    Ule_ShareModel *shareModel=[[Ule_ShareModel alloc]initWithTitle:linkTitle content:linkDescription imageUrl:imageUrl linkUrl:linkURL shareType:mShareType];
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [[Ule_ShareView shareViewManager]shareWithModel:shareModel withViewController:[UIViewController currentViewController].tabBarController viewTitle:@"和好友一起分享红包雨" resultBlock:^(NSString *shareType, NSString *result) {
        if ([result isEqualToString:SV_Success]) {
            //展示去使用弹框
            //            [self showSuccessAlertView];//取消弹框 20181102 by 朱建峰
            //调用抽奖接口
//                        [self requestCashRedPacket];//红包雨分享取消调抽奖 姜山说的--20180905
            
            //记录
            [UleMbLogOperate addMbLogClick:@""
                                  moduleid:@"SHARE_SUCCESS"
                                moduledesc:[linkURL urlEncodedString]
                             networkdetail:@""];
        }
    }];
}

-(NSInteger)getRandomNumberFrom:(NSInteger)from to:(NSInteger)to
{
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

//去主会场
- (void)uleRedPacketGotoMainVenue{
    NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
    [dic setObject:kRedRainMainExpoUrl forKey:@"key"];
    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
    //记录日志
    [UleRedPacketRainLocalManager sharedManager].redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.channel=UleRedPacketRainChannel;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
    [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsGoMainVenue" environment:[UleStoreGlobal shareInstance].config.envSer withModel:[UleRedPacketRainLocalManager sharedManager].redRainModel];
}

//去使用
- (void)uleRedPacketGotoUse{
    //跳转我的资产
    [[UIViewController currentViewController] pushNewViewController:@"US_MyWalletVC" isNibPage:NO withData:nil];
    
    [UleRedPacketRainLocalManager sharedManager].redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.channel=UleRedPacketRainChannel;
    [UleRedPacketRainLocalManager sharedManager].redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
    // 结果页去使用点击日志
    [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsGoUse" environment:[UleStoreGlobal shareInstance].config.envSer withModel:[UleRedPacketRainLocalManager sharedManager].redRainModel];
}

//回首页
- (void)uleRedPacketGotoHomePage{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIViewController currentViewController]&&[UIViewController currentNavigationViewController].viewControllers.count>1) {
            [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:YES];
        }
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([UIViewController currentViewController]&&[UIViewController currentViewController].tabBarController.viewControllers.count>0) {
            UleTabBarViewController *tabbarVC = (UleTabBarViewController *)[UIViewController currentViewController].tabBarController;
            if (tabbarVC&&tabbarVC.selectedIndex!=0) {
                [tabbarVC selectTabBarItemAtIndex:0 animated:YES];
            }
        }
    });
}


#pragma mark - <parse data>
- (void)parseDrawAwardData:(NSDictionary *)dic increaseCount:(BOOL)isIncrease{
    if (isIncrease) {
        //增加次数
        [US_UserUtility increaseLimitForRedPacket];
    }
    
    if (dic&&dic[@"content"]&&[dic[@"code"] isEqualToString:@"0000"]) {
        if (self.successBlock) {
            self.successBlock(nil);
        }
        [self showShareBackViewType:USDrawLotteryResultTypeSuccess dataDic:dic];
    }else{
        [self showShareBackViewType:USDrawLotteryResultTypeFail dataDic:dic];
    }
}

-(void)showShareBackViewType:(USDrawLotteryResultType)viewType dataDic:(NSDictionary *)dataDic
{
    if (viewType==USDrawLotteryResultTypeSuccess) {
        NSDictionary * content=dataDic[@"content"];
        NSArray * prizeInfos=content[@"prizeInfos"];
        NSDictionary * dic=[prizeInfos firstObject];
        USDrawLotteryResultModel *resultModel = [USDrawLotteryResultModel yy_modelWithDictionary:dic];

        USDrawLotteryResultView *result = [[USDrawLotteryResultView alloc]init];
        [result setModel:resultModel];
        [result showViewWithAnimation:AniamtionAlert];
    }else {
        if (self.errorBlock) {
            NSString *errorStr=@"网络不稳定，请稍后再试";
            NSString *errorMsg = [NSString isNullToString:dataDic[@"message"]];
            if (errorMsg.length>0) {
                errorStr=errorMsg;
            }
            self.errorBlock(errorStr);
        }
    }
}

#pragma mark - <getters>
- (UleNetworkExcute *)networkClient_Service{
    if (!_networkClient_Service) {
        _networkClient_Service = [US_NetworkExcuteManager uleServerRequestClient];
    }
    return _networkClient_Service;
}

@end
