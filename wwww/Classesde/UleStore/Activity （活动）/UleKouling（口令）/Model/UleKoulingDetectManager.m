//
//  UleKoulingDetectOManager.m
//  UleApp
//
//  Created by ZERO on 2019/2/20.
//  Copyright © 2019年 ule. All rights reserved.
//

#import "UleKoulingDetectManager.h"
#import "US_NetworkExcuteManager.h"
#import "US_Api.h"
#import "NSObject+YYModel.h"
#import "UleKouLingView.h"
#import "UIView+ShowAnimation.h"
#import "UleKoulingData.h"
#import "UleMbLogOperate.h"
#import "UleModulesDataToAction.h"
#import "USCustomAlertViewManager.h"

@interface UleKoulingDetectManager()

@property (nonatomic,strong) UleNetworkExcute *koulingClient;

@end

@implementation UleKoulingDetectManager
/** 单例 */
+ (instancetype)sharedManager {
    
    static UleKoulingDetectManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[UleKoulingDetectManager alloc] init];
            
        });
    }
    return sharedManager;
}

- (BOOL)isNeedRequestKouling{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string.length > 0 && ![self.localKouLing isEqualToString:pasteboard.string]) {
        NSArray *strArray = [pasteboard.string componentsSeparatedByString:@"ξ"];
        if (strArray.count > 1) {
            return YES;
        }
    }
    return NO;
}

- (void)detectPasteBoard{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (pasteboard.string.length > 0 && ![self.localKouLing isEqualToString:pasteboard.string]) {
        NSArray *strArray = [pasteboard.string componentsSeparatedByString:@"ξ"];
        if (strArray.count > 1) {
            self.isValidKouLing = YES;
            NSString *kouling = [strArray objectAtIndex:1];
            [self startRequestKouling:kouling];
        }else{
            [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
        }
    }else{
        [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
    }
}

- (void)startRequestKouling:(NSString*)kouling{
    NSString *clientType = @"";
    if ([NonEmpty([UleStoreGlobal shareInstance].config.clientType) isEqualToString:@"ule"]) {
        clientType = @"ylw";
    } else{
        clientType = @"ylxd";
    }
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    NonEmpty(kouling), @"watchword",
                                    NonEmpty(clientType), @"clientType",
                                    NonEmpty([UleStoreGlobal shareInstance].config.versionNum), @"version",
                                    @"ios", @"type",
                                    nil];
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_GetKoulingInfo andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    @weakify(self);
    [self.koulingClient beginRequest:request success:^(id responseObject) {
        @strongify(self);
        [self fetchKoulingDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        self.isValidKouLing = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"initUniversalAlertView" object:nil];
        [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
    }];
}

- (void)fetchKoulingDicInfo:(NSDictionary *)dic{
    UleKoulingData *data = [UleKoulingData yy_modelWithDictionary:dic];
    self.koulingData = data;
    
    if ([data.type isEqualToString:@"2"]) {
        self.isValidKouLing = NO;
        [self iosAction:data.buttonInfo.iosAction];
        [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
        //清空剪贴板内容
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"";
        //统计
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"口令跳转" moduledesc:data.sceneCode networkdetail:@""];
        
    } else {
        UleKouLingView *koulingView = [[UleKouLingView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        koulingView.orderNum = UnitAlertOrderKoulin;
        if ([[CustomAlertViewManager sharedManager] addCustomAlertView:koulingView identify:@"口令Alert"]) {
            [[USCustomAlertViewManager sharedManager] leaveApplicationAlertRequestGroup];
        }
    }
}


/**
 *  iosAction跳转
 */
- (void)iosAction:(NSString *)iosActionStr {
    if (!iosActionStr || [iosActionStr isEqualToString:@""]) return;
    // 得到key value字符串数组
    NSArray *actions = [iosActionStr componentsSeparatedByString:@"&&"];
    // 将除控制器类名外的所有参数 加入字典
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 1; i < [actions count]; i ++) {
        [dataDic setValuesForKeysWithDictionary:[UleModulesDataToAction parseWebKey_Value:actions[i] withOuter:@"##" withInner:@":"]];
    }
    if (!actions || actions.count == 0) return;
    // 传递参数 除去两个不需要的参数
    NSMutableArray *dataArray = [actions[0] componentsSeparatedByString:@":"].mutableCopy;
    
    if (!dataArray || dataArray.count <= 0) return;
    // 跳转
    if ([dataArray[0] isEqualToString:@"XiaoNengChat"]) {
        //小能客服
        NSString *chatUrl=[dataDic objectForKey:@"key"];
        if (chatUrl&&chatUrl.length>0) {
            chatUrl=[NSString stringWithFormat:@"%@?userName=%@&mobile=%@", chatUrl, [US_UserUtility sharedLogin].m_userName, [US_UserUtility sharedLogin].m_mobileNumber];
            [dataDic setObject:chatUrl forKey:@"key"];
        }
        [dataArray replaceObjectAtIndex:0 withObject:@"WebDetailViewController"];
    }
    
    if (dataArray.count <= 1){
        [[UIViewController currentViewController] pushNewViewController:dataArray[0] isNibPage:NO withData:dataDic];
    }
    else{
        [[UIViewController currentViewController] pushNewViewController:dataArray[0] isNibPage:[dataArray[1] boolValue] withData:dataDic];
    }
}

- (BOOL)isCanShow:(NSString*)ver
{
    BOOL isCan = NO;
    NSArray *versions = [ver componentsSeparatedByString:@";"];
    if (versions.count > 3) {
        NSString *ylwStr = [versions objectAtIndex:1];
        NSString *ylxdStr = [versions objectAtIndex:3];
        NSArray *uleVersions = [ylwStr componentsSeparatedByString:@","];
        NSArray *ulxdVersions = [ylxdStr componentsSeparatedByString:@","];
        if ([NonEmpty([UleStoreGlobal shareInstance].config.clientType) isEqualToString:@"ule"]) {
            if (uleVersions.count > 2) {
                NSString *ylwVer = [uleVersions objectAtIndex:2];
                if ([NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue] > [ylwVer integerValue]) {
                    isCan = YES;
                }
            }
        }else{
            if (ulxdVersions.count > 2) {
                NSString *ylxdVer = [ulxdVersions objectAtIndex:2];
                if ([NonEmpty([UleStoreGlobal shareInstance].config.appVersion) integerValue] > [ylxdVer integerValue]) {
                    isCan = YES;
                }
            }
        }
    }
    return isCan;
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)koulingClient{
    if (!_koulingClient) {
        _koulingClient=[US_NetworkExcuteManager uleServerRequestClient];
    }
    return _koulingClient;
}
@end
