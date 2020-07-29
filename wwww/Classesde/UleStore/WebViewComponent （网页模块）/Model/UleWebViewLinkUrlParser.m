//
//  UleWebViewLinkUrlParser.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/10.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleWebViewLinkUrlParser.h"
#import "US_NetworkExcuteManager.h"
#import "ShareParseTool.h"
#import "USShareView.h"
#import "US_UserCenterApi.h"
#import "USImagePicker.h"
#include "sys/stat.h"
#import <NSData+Base64.h>
#import "US_MystoreManangerApi.h"
#import "UserHeadImg.h"
#import "UleRedPacketRainLocalManager.h"
#import "UleRedPacketRainManager.h"
#import "USRedPacketCashManager.h"
#import "PosterShareStyleView.h"
#import "USInviteShareManager.h"
#import "TeamInviteModel.h"
#import "DeviceInfoHelper.h"
#import "UleTabBarViewController.h"
@interface UleWebViewLinkUrlParser ()
@property (nonatomic, strong) UleNetworkExcute * networkClient_API;
@property (nonatomic, strong) PosterShareStyleView * teamShareView;
@end

@implementation UleWebViewLinkUrlParser



- (BOOL)action_popView:(NSString *)linkUrl{
    [self.webViewController.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (BOOL)action_gotoHomeViewController:(NSString *)linkUrl{
    //    [self.webViewController.navigationController popToRootViewControllerAnimated:YES];
    [[UIViewController currentNavigationViewController] popToRootViewControllerAnimated:NO];
    UleTabBarViewController *tabbarVC = (UleTabBarViewController *)[UIViewController currentViewController].tabBarController;
    if (tabbarVC&&tabbarVC.selectedIndex!=0) {
        [tabbarVC selectTabBarItemAtIndex:0 animated:YES];
    }

    return NO;
}

- (BOOL)action_gotoVipManager:(NSString *)linkUrl{
    NSArray *messageArr = [linkUrl componentsSeparatedByString:@"_"];
    NSArray *methodArr = [[messageArr lastObject] componentsSeparatedByString:@"&"];
    if ([[methodArr firstObject] isEqualToString:@"openVipManage"]) {
        [self.webViewController pushNewViewController:@"US_MemberRootVC" isNibPage:NO withData:nil];
    }
    return NO;
}

- (BOOL)action_share:(NSString *)linkUrl{
    NSString * strShare=@"";
    if ([[linkUrl lowercaseString] rangeOfString:US_share].location !=NSNotFound) {
        NSRange range=[linkUrl rangeOfString:@"_"];
        NSInteger location=range.location;
        strShare=[linkUrl substringFromIndex:location+1];
    }else{
        strShare=linkUrl;
    }
    NSArray * shareArray=[strShare componentsSeparatedByString:@"&&"];
    NSString *InforStr=[shareArray objectAtIndex:0];
    Ule_ShareModel * shareModel= [ShareParseTool frechJsonStrToModel:InforStr];
    shareModel.shareType=@"110";
    if ([shareArray count]>=2) {
        shareModel.jsCallbackFunc=[NSString stringWithFormat:@"%@()",[shareArray objectAtIndex:1]];
    }
    @weakify(shareModel)
    @weakify(self);
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [[Ule_ShareView shareViewManager] shareWithModel:shareModel withViewController:self.webViewController viewTitle:@"通过社交软件分享才能获得更多客流哟" resultBlock:^(NSString *name, NSString *result) {
        @strongify(shareModel);
        @strongify(self);
        if ([result isEqualToString:SV_Success]) {
            if (shareModel.jsCallbackFunc.length>0) {
                [self shareCallBackWithJSFunction:shareModel.jsCallbackFunc];
            }
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
        }
    }];
    return NO;
}

- (BOOL)action_ylxdnewShare:(NSString *)linkUrl{
    NSString * strShare=@"";
    if ([[linkUrl lowercaseString] rangeOfString:US_ylxdShare].location !=NSNotFound) {
        NSRange range=[linkUrl rangeOfString:@"_"];
        NSInteger location=range.location;
        strShare=[linkUrl substringFromIndex:location+1];
    }else{
        strShare=linkUrl;
    }
    NSArray * shareArray=[strShare componentsSeparatedByString:@"&&"];
    NSString *InforStr=[shareArray objectAtIndex:0];
    USShareModel * shareModel= [USShareModel yy_modelWithJSON:InforStr];
    if ([shareArray count]>=2) {
        shareModel.jsFunction=[NSString stringWithFormat:@"%@()",[shareArray objectAtIndex:1]];
    }
    [self webShareWithShareModel:shareModel];
    return NO;
}

- (BOOL)action_updataImage:(NSString *)linkUrl{
    @weakify(self);
    [USImagePicker startWKImagePicker:self.webViewController cameraFailCallBack:^(NSInteger code){
        @strongify(self);
        switch (code) {
            case 1:
                [UleMBProgressHUD showHUDAddedTo:self.webViewController.view withText:@"该设备不支持拍照" afterDelay:1.5];
                break;
            case 2:
                //相机权限不通过
                [self.webViewController showAlertNormal:[NSString stringWithFormat: @"相机开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"相机\">\"%@\"",[DeviceInfoHelper getAppName]]];
                break;
            default:
                break;
        }
    } photoAlbumFailCallBack:^{
        //相册权限不通过
        [self.webViewController showAlertNormal:[NSString stringWithFormat:@"相册开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"照片\">\"%@\"",[DeviceInfoHelper getAppName]]];
    } chooseCallBack:^(NSDictionary<NSString *,id> *info) {
        if(![[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
            [UleMBProgressHUD showHUDAddedTo:self.webViewController.view withText:@"只能上传图片" afterDelay:1.5];
            return;
        }
        UIImage *original = [info objectForKey:UIImagePickerControllerEditedImage];
        [self uploadPhotoImage:original];
    } cancelCallBack:^{
    }];
    return NO;
}

- (BOOL)action_withdrawclaim:(NSString *)linkUrl{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateOrderList object:nil];
    return NO;
}

- (BOOL)action_invitefriends:(NSString *)linkUrl{
    [[USInviteShareManager sharedManager] inviteShareToOpenStore];
    return NO;
}

- (BOOL)action_jumpVC:(NSString *)linkUrl{
    NSString *jumpStr = [linkUrl substringFromIndex:[[linkUrl lowercaseString]rangeOfString:US_jumpVC].location+US_jumpVC.length];
    NSString *className = [NSString string];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if ([jumpStr hasPrefix:@"WEBVIEW"]) {
        className = NSStringFromClass([WebDetailViewController class]);
    }
    else{
        className = [[jumpStr componentsSeparatedByString:@"&"]firstObject];
    }
    @try {
        NSString *datas = [[jumpStr componentsSeparatedByString:@"&"] lastObject];
        if ([jumpStr hasPrefix:@"WEBVIEW&"]) {
            datas = [jumpStr substringFromIndex:8];
        }else if ([jumpStr hasPrefix:@"WebDetailViewController&"]) {
            datas = [jumpStr substringFromIndex:24];
        }
        NSArray *components = [datas componentsSeparatedByString:@"#"];
        for (NSInteger i = 0; i < [components count]; i ++) {
            NSArray *lastcomponents = [components[i] componentsSeparatedByString:@"|"];
            if ([lastcomponents count] == 2) {
                [dataDic setObject:[lastcomponents lastObject]?[lastcomponents lastObject]:@"" forKey:[lastcomponents firstObject]];
            }
        }
    }
    @catch (NSException *exception) {
    }
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"viewName" withExtension:@"plist"];
    NSDictionary * vcName = [NSDictionary dictionaryWithContentsOfURL:url];
    for (NSString *key in vcName.allKeys) {
        if ([className isEqualToString:[vcName objectForKey:key]]) {
            [self.webViewController pushNewViewController:key isNibPage:NO withData:dataDic];
            return NO;
        }
    }
    [self.webViewController pushNewViewController:className isNibPage:NO withData:dataDic];
    return NO;
}
- (BOOL)action_saveFavorite:(NSString *)linkUrl{
    //通知刷新商品列表
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MyGoodsListRefresh object:nil];
    return NO;
}

- (BOOL)action_inviteTeam:(NSString *)linkUrl{
    NSRange range=[linkUrl rangeOfString:@"_"];
    NSString *paramStr=[linkUrl substringFromIndex:range.location+1];
    TeamInviteModel *teamInviteModel = [TeamInviteModel yy_modelWithJSON:paramStr];
    if (self.teamShareView) {
        [self.teamShareView removeFromSuperview];
        self.teamShareView=nil;
    }
    self.teamShareView=[[PosterShareStyleView alloc] initWithShareType:TeamInviteType];
    [self.teamShareView loadModel:teamInviteModel];
    [self.teamShareView show];
    return NO;
}

- (BOOL)action_newDrawLottery:(NSString *)linkUrl{
    //ulemobile://newDrawCashLottery_activityCode::23423##fieldId::23423##type::2
    NSRange range=[linkUrl rangeOfString:@"_"];
    NSString *paramStr=[linkUrl substringFromIndex:range.location+1];
    [self drawCashLotteryRunning:paramStr];
    return NO;
}

- (BOOL)action_showRedpacketRain:(NSString *)linkUrl{
    //下红包雨
    //ulemobile://showRedpacketRain_activityCode::23423##fieldId::23423
    NSRange range=[linkUrl rangeOfString:@"_"];
    NSString *paramStr=[linkUrl substringFromIndex:range.location+1];
    [self redPackagesRuning:paramStr];
    return NO;
}

#pragma mark - <private>
- (void)shareCallBackWithJSFunction:(NSString *)jsFunc{
    NSString * jsfunction=jsFunc;
    if([jsfunction isEqualToString:@"needCallAfterShare"]) {
        jsfunction=@"afterShare";
    }
    jsfunction = [jsfunction stringByAppendingString:@"()"];
    [self.webViewController.wk_mWebView evaluateJavaScript:jsfunction completionHandler:nil];
}

- (void)uploadPhotoImage:(UIImage *)image{
    //将截好的图片存到本地
    NSError *err;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&err];
    }
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
    NSData *imageData;
    if([self fileSizeAtPath:filePath] > 512*512)
    {
        imageData = UIImageJPEGRepresentation(image, 512*512/[self fileSizeAtPath:filePath]);
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    NSString *hash = [imageData base64EncodedString];
    [UleMBProgressHUD showHUDAddedTo:self.webViewController.view withText:@"正在上传头像"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MystoreManangerApi buildUploadImageWithStreamData:hash] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.webViewController.view withText:@"上传成功" afterDelay:2];
        UserHeadImg *headImg = [UserHeadImg yy_modelWithDictionary:responseObject];
        NSString *imageUrl = headImg.data.imageUrl ? headImg.data.imageUrl : headImg.data.picUrl;
        [US_UserUtility saveUserHeadImgUrl:imageUrl];
        NSString *js = [NSString stringWithFormat:@"catchPhoto('%@')",imageUrl];
        NSString *encodedJS = (__bridge_transfer NSString*)CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)js, NULL, NULL,  kCFStringEncodingUTF8 );
        [self.webViewController.wk_mWebView evaluateJavaScript:encodedJS completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notify_EditStoreInfo object:nil userInfo:@{@"headImage":NonEmpty(imageUrl)}];
    } failure:^(UleRequestError *error) {
        [self.webViewController showErrorHUDWithError:error];
    }];
}
//图片长度
- (long long) fileSizeAtPath:(NSString*) filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

- (BOOL) shareWithShareInfo:(NSString *)shareInfo{
    // 获取需要分享的平台类型
    NSArray *array = [shareInfo componentsSeparatedByString:@"&&"];
    if (array.count<=0) {
        return NO;
    }
    Ule_ShareModel *shareModel=[ShareParseTool frechJsonStrToModel:array[0]];
    shareModel.shareType=@"110";
    @weakify(shareModel)
    @weakify(self);
    [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
    [[Ule_ShareView shareViewManager] shareWithModel:shareModel withViewController:self.webViewController viewTitle:@"通过社交软件分享才能获得更多客流哟" resultBlock:^(NSString *name, NSString *result) {
        @strongify(shareModel);
        @strongify(self);
        if ([result isEqualToString:SV_Success]) {
            if (shareModel.jsCallbackFunc.length>0) {
                [self shareCallBackWithJSFunction:shareModel.jsCallbackFunc];
            }
            //抽奖
            [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
        }
    }];
    //日志
    NSString * logdesc=([shareModel.linkUrl rangeOfString:@"shareId"].location!=NSNotFound)?@"分享商品":@"分享店铺";
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"H5" moduledesc:logdesc networkdetail:@""];
    return NO;
}

//下红包雨
-(void)redPackagesRuning:(NSString *)paramsStr
{//ulemobile://showRedpacketRain_activityCode::23423##fieldId::23423
    NSMutableDictionary *paramDic=[self parseDicFromStr:paramsStr];
    
    UleRedPacketRainModel *rainModel=[[UleRedPacketRainModel alloc]init];
    rainModel.channel=UleRedPacketRainChannel;
    rainModel.userId=[US_UserUtility sharedLogin].m_userId;
    rainModel.activityCode=[paramDic objectForKey:@"activityCode"];
    rainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
    rainModel.fieldId=[paramDic objectForKey:@"fieldId"];
    rainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
    rainModel.orgCode=[US_UserUtility sharedLogin].m_orgType;
    rainModel.activityDate=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_4.interval;
    rainModel.wishes=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_4.failText;
    [UleRedPacketRainManager startUleRedPacketRainWithModel:rainModel environment:[UleStoreGlobal shareInstance].config.envSer increaseCashDarw:NO ClickEvent:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
        switch (event) {
            case UleRedpacketRainEventShare:
                [[USRedPacketCashManager sharedManager] showShareViewWithDataArray:obj andShareText:[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_4.shareText];
                break;
            case UleRedpacketRainEventToHomePage:
                [[USRedPacketCashManager sharedManager] uleRedPacketGotoHomePage];
                break;
            case UleRedpacketRainEventToMain:
                [[USRedPacketCashManager sharedManager] uleRedPacketGotoMainVenue];
                break;
            case UleRedpacketRainEventToUse:
                [[USRedPacketCashManager sharedManager] uleRedPacketGotoUse];
                break;
            case UleRedpacketRainEventOneMore:
                
                break;
            default:
                break;
        }
    }];
}

//抽奖结果页
-(void)drawCashLotteryRunning:(NSString *)paramsStr
{
    @weakify(self);
    NSMutableDictionary *paramDic=[self parseDicFromStr:paramsStr];
    if ([[NSString isNullToString:paramDic[@"type"]] isEqualToString:@"2"]) {
        [[USRedPacketCashManager sharedManager]requestCashRedPacketWithActivityCode:[paramDic objectForKey:@"activityCode"] andFieldId:[paramDic objectForKey:@"fieldId"] increaseDrawCount:NO successBlock:^(NSString *str) {
            @strongify(self);
            [self.webViewController.wk_mWebView evaluateJavaScript:@"pkRefresh()" completionHandler:nil];
        } errorBlock:^(NSString *str) {
            @strongify(self);
            [UleMBProgressHUD showHUDAddedTo:self.webViewController.view withText:str afterDelay:1.5];
        }];
    }else {
        UleRedPacketRainModel *rainModel=[[UleRedPacketRainModel alloc]init];
        rainModel.channel=UleRedPacketRainChannel;
        rainModel.userId=[US_UserUtility sharedLogin].m_userId;
        rainModel.activityCode=[paramDic objectForKey:@"activityCode"];
        rainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
        rainModel.fieldId=[paramDic objectForKey:@"fieldId"];
        rainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
        rainModel.orgCode=[US_UserUtility sharedLogin].m_orgType;
        rainModel.activityDate=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.interval;
        rainModel.wishes=[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.failText;
        [UleRedPacketRainManager showRedRainResultWithModel:rainModel environment:[UleStoreGlobal shareInstance].config.envSer>0?YES:NO increaseCashDarw:NO ClickEvent:^(UleRedpacketRainClickEventType event, NSArray<UleAwardCellModel *> *obj) {
            //更新奖励金金额
            [self.webViewController.wk_mWebView evaluateJavaScript:@"getRedPackageBalance()" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                NSLog(@"%@", error);
            }];
            switch (event) {
                case UleRedpacketRainEventShare:
                    [[USRedPacketCashManager sharedManager] showShareViewWithDataArray:obj andShareText:[UleRedPacketRainLocalManager sharedManager].mRedRainThemeModel_1.shareText];
                    break;
                case UleRedpacketRainEventToHomePage:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoHomePage];
                    break;
                case UleRedpacketRainEventToMain:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoMainVenue];
                    break;
                case UleRedpacketRainEventToUse:
                    [[USRedPacketCashManager sharedManager] uleRedPacketGotoUse];
                    break;
                case UleRedpacketRainEventOneMore:
                    
                    break;
                default:
                    break;
            }
        }];
    }
}

- (BOOL)webShareWithShareModel:(USShareModel *)shareModel{
    shareModel.isNeedSaveQRImage=YES;
    if ([shareModel.gameFlag isEqualToString:@"1"]) {
        shareModel.isNeedSaveQRImage=NO;
    }
    if (shareModel.listImage.count > 0) {
        shareModel.shareImageUrl=[shareModel.listImage firstObject];
    }
    @weakify(self);
    if ([[shareModel.insuranceFlag description] isEqualToString:@"1"]) {
        //shareModel.shareType=@"1100";
        shareModel.shareOptions=@"0##1";
        [USShareView insuranceShareWithModel:shareModel success:^(id  _Nonnull response) {
            @strongify(self);
            if (shareModel.jsFunction.length>0) {
                [self shareCallBackWithJSFunction:shareModel.jsFunction];
            }
        }];
        return NO;
    }
    if ([shareModel.isOldShareMode integerValue]==1) {
        Ule_ShareModel * oldShareModel= [[Ule_ShareModel alloc] init];
        oldShareModel.shareType=@"110";
        oldShareModel.title=shareModel.shareTitle;
        oldShareModel.content=shareModel.shareContent;
        oldShareModel.imageUrl=shareModel.shareImageUrl;
        oldShareModel.linkUrl=shareModel.shareUrl;
        oldShareModel.jsCallbackFunc=shareModel.jsFunction;
        [[Ule_ShareView shareViewManager]registWeChatForAppKey:[UleStoreGlobal shareInstance].config.wxAppKeyShare andUniversalLink:[UleStoreGlobal shareInstance].config.universalLink];
        [[Ule_ShareView shareViewManager] shareWithModel:oldShareModel withViewController:self.webViewController viewTitle:@"通过社交软件分享才能获得更多客流哟" resultBlock:^(NSString *name, NSString *result) {
            @strongify(self);
            if ([result isEqualToString:SV_Success]) {
                if (oldShareModel.jsCallbackFunc.length>0) {
                    [self shareCallBackWithJSFunction:oldShareModel.jsCallbackFunc];
                }
                //抽奖
                [[USRedPacketCashManager sharedManager] requestCashRedPacketByRedRain];
            }
        }];
        return NO;
    }
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
        @strongify(self);
        if (shareModel.jsFunction.length>0) {
            [self shareCallBackWithJSFunction:shareModel.jsFunction];
        }
    }];
    return NO;
}


-(NSMutableDictionary *)parseDicFromStr:(NSString *)str{
    NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
    NSArray *keyValuesArr=[str componentsSeparatedByString:@"##"];
    for (NSString *item in keyValuesArr) {
        NSArray *contentArr = [item componentsSeparatedByString:@"::"];
        if (contentArr.count>1) {
            [paramDic setObject:contentArr[1] forKey:contentArr[0]];
        }
    }
    return paramDic;
}
#pragma mark - <setter and getter>
- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}
@end
