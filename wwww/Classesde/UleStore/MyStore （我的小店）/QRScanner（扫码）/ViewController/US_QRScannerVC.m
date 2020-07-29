//
//  US_QRScannerVC.m
//  u_store
//
//  Created by chenzhuqing on 2019/3/6.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_QRScannerVC.h"
#import "US_SearchCategoryVC.h"
#import "WebDetailViewController.h"
#import "US_NetworkExcuteManager.h"
#import "US_QRScannerModel.h"
#import "UleModulesDataToAction.h"
#import <UIViewController+UleExtension.h>
@interface US_QRScannerVC ()

@property (nonatomic, strong) UleNetworkExcute * client;

@end

@implementation US_QRScannerVC

- (void)dealloc{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString * title= [self.m_Params objectForKey:@"title"];
    if (title.length>0) {
        [self setNativeTitle:title];
    }
    self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"Scan"];
    //检查摄像头权限
    [self checkMediaAuthorization];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [LogStatisticsManager onPageStart:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [LogStatisticsManager onPageEnd:self];
}

- (void)checkMediaAuthorization{
    // 先判断摄像头硬件是否好用
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        // 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            UIAlertAction *confirmAction=[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if ([[UIDevice currentDevice].systemVersion floatValue]>=10) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        if (@available(iOS 10.0, *)) {
                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) { }];
                        }
                    }
                }else{
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:@"摄像头访问受限,前往设置" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:confirmAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        //        else{
        //            // 这里是摄像头可以使用的处理逻辑
        //        }
    } else {
        // 硬件问题提示
        //        UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        //        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:nil message:@"摄像头硬件出现问题" preferredStyle:UIAlertControllerStyleAlert];
        //        [alertController addAction:action];
        //        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma mark - <Override>
- (void)resultMethod {
    if (self.resultString && ![self.resultString isEqualToString:@""]) {
        self.resultString= [self.resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        //如果包含特定链接，则调用服务端接口获取事件
        NSString * scannerHtml=[NSString stringWithFormat:@"%@/event/qr/scan.html?",[UleStoreGlobal shareInstance].config.ulecomDomain];
        if ([self.resultString rangeOfString:scannerHtml].location!=NSNotFound) {
            //TODO:
            [self startReqeustScannerInfoWithCode:[self parselScannerInfo:self.resultString]];
        }else if([self.resultString rangeOfString:@"http://"].location!=NSNotFound||[self.resultString rangeOfString:@"https://"].location!=NSNotFound){
            NSString * limitDomain=[US_UserUtility getLimitDomain];
            if (limitDomain.length>0) {
                NSArray * limitArray=[limitDomain componentsSeparatedByString:@"#"];
                if (limitArray.count>0) {
                    BOOL canPush=NO;
                    for (NSString * domain in limitArray) {
                        if ([self.resultString rangeOfString:domain].location!=NSNotFound) {
                            canPush=YES;
                            break;
                        }
                    }
                    if (canPush) {
                        [LogStatisticsManager shareInstance].srcid=Srcid_Scanner;
                        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:@{@"key":self.resultString}.mutableCopy];
                    }else{
                        [UleMBProgressHUD showHUDWithText:@"抱歉，当前二维码暂不支持此业务" afterDelay:3 withTarget:self dothing:@selector(HUDdelayDo)];
                    }
                }
            }else{
                [LogStatisticsManager shareInstance].srcid=Srcid_Scanner;
                [self pushNewViewController:@"WebDetailViewController"  isNibPage:NO withData:@{@"key":self.resultString}.mutableCopy];
            }
        }else{
            [UleMBProgressHUD showHUDWithText:@"抱歉，当前二维码暂不支持此业务" afterDelay:3 withTarget:self dothing:@selector(HUDdelayDo)];
        }
    }
}

- (void)HUDdelayDo{
     [self scanVCContinue:YES];
}

- (NSMutableDictionary *)parselScannerInfo:(NSString *)targetUrl{
    NSMutableDictionary * parmsDic=[[NSMutableDictionary alloc] init];
    NSArray *subArray = [targetUrl componentsSeparatedByString:@"?"];
    if (subArray.count>0) {
        NSString * paramStr=[subArray objectAt:1];
        NSArray * paramArray=paramStr.length>0?[paramStr componentsSeparatedByString:@"&"]:nil;
        for (int i=0; i<paramArray.count; i++) {
            NSString * codeStr=[paramArray objectAt:i];
            NSArray * codeArray=codeStr.length>0?[codeStr componentsSeparatedByString:@"="]:nil;
            if (codeArray.count>0) {
                NSString * key=[codeArray objectAt:0];
                NSString * value=[codeArray objectAt:1];
                [parmsDic setValue:NonEmpty(value) forKey:NonEmpty(key)];
            }
        }
    }

    return parmsDic;
}

- (void)deleteDim:(NSString *)str{
    //最后去掉空格
    str=[str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)startReqeustScannerInfoWithCode:(NSMutableDictionary *)params{
    UleRequest * request=[[UleRequest alloc] initWithApiName:API_scanQr andParams:params];
    request.baseUrl=[UleStoreGlobal shareInstance].config.serverDomain;
    @weakify(self);
    [self.client beginRequest:request success:^(id responseObject) {
        @strongify(self);
        [self fetchScannerDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        [self scanVCContinue:YES];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:[error.error.userInfo objectForKey:NSLocalizedDescriptionKey] afterDelay:2];
    }];
    
}

- (void)fetchScannerDicInfo:(NSDictionary *)dic{
    US_QRScannerModel * model=[US_QRScannerModel yy_modelWithDictionary:dic];
    if (model.data&&model.data.ios_action.length>0) {
        [UleMBProgressHUD hideHUDForView:self.view];
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:model.data.ios_action];
        [LogStatisticsManager shareInstance].srcid=Srcid_Scanner;
        [self pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        
    }else{
        [UleMBProgressHUD showHUDAddedTo:self.view withText:model.returnMessage afterDelay:2];
        [self scanVCContinue:YES];
    }
}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)client{
    if (!_client) {
        _client=[US_NetworkExcuteManager uleServerRequestClient];
    }
    return _client;
}
@end
