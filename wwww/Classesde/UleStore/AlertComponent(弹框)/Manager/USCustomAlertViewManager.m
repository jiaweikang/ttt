//
//  USCustomAlertViewManager.m
//  UleStoreApp
//
//  Created by xulei on 2019/4/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USCustomAlertViewManager.h"
#import "UleKoulingDetectManager.h"
#import "USApplicationLaunchManager.h"
#import "ProtocolAlertView.h"
#import "UIView+ShowAnimation.h"
#import "UleRedPacketRainLocalManager.h"
#import "USUniversalAlertModelManager.h"
@interface USCustomAlertViewManager ()
@property (nonatomic, strong) dispatch_group_t  alertApiRequestGroup;

@end

@implementation USCustomAlertViewManager

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [[USCustomAlertViewManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoRequestedSuccess) name:NOTI_UserInfoRequest_Success object:nil];
       
    }
    return self;
}

#pragma mark - <网络请求>
- (void) startRequestAppicationAlertView{
    [[CustomAlertViewManager sharedManager].cacheViewsArray removeAllObjects];
    [CustomAlertViewManager sharedManager].cacheViewsArray=[[CustomAlertViewManager sharedManager].mViewsArray mutableCopy];
    if (!self.alertApiRequestGroup) {
        self.alertApiRequestGroup = dispatch_group_create();
    }
    size_t num = 3;
    if ([[UleKoulingDetectManager sharedManager] isNeedRequestKouling]){
        num = 4;
    }
    dispatch_apply(num, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        dispatch_group_enter(self.alertApiRequestGroup);
        switch (i) {
            case 0:{
                //版本更新
                [[USApplicationLaunchManager sharedManager] startReuestVersionUpdateInfoCompleteWithSuccess:^(UIView *view) {
                    if (view) {
                        [[CustomAlertViewManager sharedManager] addCustomAlertView:view identify:@"版本更新"];
                    }
                    [self leaveApplicationAlertRequestGroup];
                } failure:^{
                    [self leaveApplicationAlertRequestGroup];
                }];
            }
                break;
            case 1:{
                //用户信息//协议弹框
                [[USApplicationLaunchManager sharedManager] startRequestUserInfoInGroup:YES isSelectedAtLast:NO];
            }
                break;
            case 2:{
                //活动弹框
                [[USUniversalAlertModelManager sharedManager] startRequestActivityDialog];
            }
                break;
            case 3:{
                //口令
                [[UleKoulingDetectManager sharedManager] detectPasteBoard];
            }
                break;
                
            default:
                break;
        }
    });
    dispatch_group_notify(self.alertApiRequestGroup, dispatch_get_main_queue(), ^{
        if (![US_UserUtility sharedLogin].mIsLogin) {
            return ;
        }
        [CustomAlertViewManager sharedManager].isCancelShowAutomic=NO;
        [[CustomAlertViewManager sharedManager] sortCurrentAlertViews];
        [[CustomAlertViewManager sharedManager] showApplicationAlertView];
        self.alertApiRequestGroup = nil;
        [CustomAlertViewManager sharedManager].finishBlock = ^{
            [UleRedPacketRainLocalManager sharedManager].isPullDownRefresh = NO;
            [[UleRedPacketRainLocalManager sharedManager] requestRedPacketRainTheme];
            [[USApplicationLaunchManager sharedManager] showApplicationNotificationAlerView];
        };
    });
}
- (void)click:(UIButton *)btn{
    UIView * view=btn.superview;
    [view hiddenView];
}

- (void)startRequestAlertViewWillEnterForeground{
    [[CustomAlertViewManager sharedManager].cacheViewsArray removeAllObjects];
    [CustomAlertViewManager sharedManager].cacheViewsArray=[[CustomAlertViewManager sharedManager].mViewsArray mutableCopy];
    NSInteger oldAlertCount=[CustomAlertViewManager sharedManager].cacheViewsArray.count;
    if (!self.alertApiRequestGroup) {
        self.alertApiRequestGroup = dispatch_group_create();
    }
    size_t num = 1;
    if ([[UleKoulingDetectManager sharedManager] isNeedRequestKouling]){
        num = 2;
    }
    dispatch_apply(num, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        dispatch_group_enter(self.alertApiRequestGroup);
        switch (i) {
            case 0:{
                //版本更新
                [[USApplicationLaunchManager sharedManager] startReuestVersionUpdateInfoCompleteWithSuccess:^(UIView *view) {
                    if (view) {
                        [[CustomAlertViewManager sharedManager] addCustomAlertView:view identify:@"版本更新"];
                    }
                    [self leaveApplicationAlertRequestGroup];
                } failure:^{
                    [self leaveApplicationAlertRequestGroup];
                }];
            }
                break;
            case 1:{
                //口令
                [[UleKoulingDetectManager sharedManager] detectPasteBoard];
            }
                break;
                
            default:
                break;
        }
    });
    dispatch_group_notify(self.alertApiRequestGroup, dispatch_get_main_queue(), ^{
        [CustomAlertViewManager sharedManager].isCancelShowAutomic=NO;
        //如果后台回前台有新的Alert 则需要再次调用显示AlertView
        if (oldAlertCount<[CustomAlertViewManager sharedManager].cacheViewsArray.count) {
            [[CustomAlertViewManager sharedManager] sortCurrentAlertViews];
            [[CustomAlertViewManager sharedManager] showApplicationAlertView];
        }
        self.alertApiRequestGroup = nil;
        [CustomAlertViewManager sharedManager].finishBlock = ^{
            [UleRedPacketRainLocalManager sharedManager].isPullDownRefresh = NO;
            [[UleRedPacketRainLocalManager sharedManager] requestRedPacketRainTheme];
        };
    });
}

- (void)leaveApplicationAlertRequestGroup{
    if (self.alertApiRequestGroup) {
        dispatch_group_leave(self.alertApiRequestGroup);
    }
}


//- (BOOL)addCustomAlertView:(UIView *)alertView{
//    if (self.alertApiRequestGroup) {
//        return [super addCustomAlertView:alertView];
//    }else return NO;
//}
//
//- (BOOL)addCustomAlertView:(UIView *)alertView identify:(NSString *)identify{
//    if (self.alertApiRequestGroup) {
//        return [super addCustomAlertView:alertView identify:identify];
//    }
//    return NO;
//}


#pragma mark - <private methods>
- (void)userInfoRequestedSuccess{
    if (![[US_UserUtility sharedLogin].m_isUserProtocol isEqualToString:@"1"]) {
        ProtocolAlertView *alertView = [ProtocolAlertView protocolAlertView:^{
            if ([US_UserUtility sharedLogin].m_protocolUrl && [US_UserUtility sharedLogin].m_protocolUrl.length>0) {
                NSMutableDictionary *dic = @{
                                             KNeedShowNav: @YES,
                                             @"title": @"服务协议与隐私政策",
                                             @"protocol": [US_UserUtility sharedLogin].m_protocolUrl,
                                             @"isNeedSign":@"1"}.mutableCopy;
                [[UIViewController currentViewController] pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:dic];
            }
        }];
        alertView.orderNum = UnitAlertOrderProtocol;
        [[CustomAlertViewManager sharedManager] addCustomAlertView:alertView identify:@"协议Alert"];
    }
    [self leaveApplicationAlertRequestGroup];
}

@end
