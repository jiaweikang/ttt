//
//  USGoodsPreviewManager.m
//  u_store
//
//  Created by xulei on 2018/8/28.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "USGoodsPreviewManager.h"
#import "US_MyGoodsApi.h"
#import "US_NetworkExcuteManager.h"
#import <NSString+LogStatistics.h>
//#import "GetPreviewInfo.h"

@interface USGoodsPreviewManager ()

@property (nonatomic, strong) UleNetworkExcute * network_api;
@property (nonatomic, weak) UleBaseViewController * rootVC;
@property (nonatomic, copy) NSString    *searchKeyword;//搜索拼接的keyword
@end

@implementation USGoodsPreviewManager

/** 单例 */
+ (instancetype)sharedManager {
    
    static USGoodsPreviewManager *sharedManager = nil;
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[USGoodsPreviewManager alloc] init];
        });
    }
    return sharedManager;
}

-(void)pushToPreviewControllerWithListId:(NSString *)listid andSearchKeyword:(NSString *)keyword andPreviewType:(NSString *)pType andHudVC:(UleBaseViewController *)currentVC{
    //
    if (!listid || listid.length<=0) {
        return;
    }
    self.rootVC=currentVC;
    NSString *encodedKeyword=@"";
    if ([NSString isNullToString:keyword].length>0) {
        encodedKeyword=[NSString LS_safeUrlBase64Encode:[NSString isNullToString:keyword]];
    }
    //@"https://m.ule.com/mxiaodian/item/preview/@@.html?storeid=##&imageType=xl"
    if ([NSString isNullToString:[US_UserUtility getLocalPreviewUrl]].length>0) {
        //拼链接
        NSString *pushUrl=[US_UserUtility getLocalPreviewUrl];
        pushUrl=[pushUrl stringByReplacingOccurrencesOfString:@"@@" withString:listid];
        pushUrl=[pushUrl stringByReplacingOccurrencesOfString:@"##" withString:[US_UserUtility sharedLogin].m_userId];
        //拼keyword
        if (encodedKeyword.length>0) {
            pushUrl=[self getPushUrlByAttachingKeyword:pushUrl encodeKeyord:encodedKeyword];
        }
        
        NSMutableDictionary *params=@{@"key":NonEmpty(pushUrl),
                                      KNeedShowNav:@"1",
                                      @"title":@"预览"
                                      }.mutableCopy;
        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
    }
    else {
        //请求接口
        [self getPreViewUrlWithListId:listid andEncodeKeyword:encodedKeyword andPreviewType:pType];
    }
}

- (NSString *)getPushUrlByAttachingKeyword:(NSString *)urlStr encodeKeyord:(NSString *)keyword{
    if ([urlStr containsString:@"?"]) {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"&keywords=%@",keyword]];
    }else {
        urlStr=[urlStr stringByAppendingString:[NSString stringWithFormat:@"?keywords=%@",keyword]];
    }
    return urlStr;
}

#pragma mark - 网络请求
/**
 *  获取预览url
 */
- (void)getPreViewUrlWithListId:(NSString *)listId andEncodeKeyword:(NSString *)keyword andPreviewType:(NSString *)type{
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在加载"];
    @weakify(self);
    [self.network_api beginRequest:[US_MyGoodsApi buildGoodsPreviewWithId:listId andType:type] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        NSDictionary * data=responseObject[@"data"];
        if (data) {
            NSString * previewUrl=data[@"previewUrl"];
            if ([previewUrl hasPrefix:@"商品描述"]) {
                [previewUrl substringFromIndex:5];
            }
            //拼接keyword
            if (keyword.length>0) {
                previewUrl=[self getPushUrlByAttachingKeyword:previewUrl encodeKeyord:keyword];
            }
            NSMutableDictionary *dic=@{@"key":NonEmpty(previewUrl),
                                       KNeedShowNav:@"1",
                                       @"title":@"预览"}.mutableCopy;
            [self.rootVC pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
        }
    } failure:^(UleRequestError *error) {
        if ([self.rootVC respondsToSelector:@selector(showErrorHUDWithError:)]) {
            [self.rootVC showErrorHUDWithError:error];
        }
    }];

}

#pragma mark - <setter and getter>
- (UleNetworkExcute *)network_api{
    if (!_network_api) {
        _network_api=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _network_api;
}


@end
