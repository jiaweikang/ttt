//
//  UleStoreConfigure.m
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/13.
//

#import "UleStoreConfigure.h"
#import <UleUtility/FileController.h>
#import "DeviceInfoHelper.h"
#import "US_Api.h"
@implementation UleStoreConfigure
//
//+ (instancetype) shareInstance{
//    static UleStoreConfigure * manager=nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        manager=[[UleStoreConfigure alloc] init];
//    });
//    return manager;
//}
//
//+ (void)loadUleStoreInfo:(NSString *)infoFile appLogKey:(nonnull NSString *)appKey  andEnvService:(NSInteger)env{
//     UleStoreConfigure * manager = [UleStoreGlobal shareInstance].config;
//    if (manager) {
//        NSDictionary * appInfo= [FileController loadNSDictionaryForProduct:infoFile];
//        UleStoreConfigure * storeInfo=[UleStoreConfigure yy_modelWithDictionary:appInfo];
//        unsigned int outCount, i;
//        objc_property_t *properties = class_copyPropertyList([UleStoreConfigure class], &outCount);
//        for (i=0;i<outCount;i++) {
//            objc_property_t property = properties[i];
//            const char* char_f =property_getName(property);
//            NSString *propertyName = [NSString stringWithUTF8String:char_f];
//            id value = [storeInfo valueForKey:propertyName];
//            if (value) {
//                [manager setValue:value forKey:propertyName];
//            }
//        }
//        manager.envSer=env;
//        manager.logAppKey=appKey;
//        NSLog(@"%@",appInfo);
//        if (manager.envSer == 1) {
//            manager.apiDomain=@"http://api.ule.com";
//            manager.serverDomain=@"http://service.ule.com";
//            manager.wholesaleDomain=@"http://wholesale-api.ule.com";
//            manager.livechatDomain=@"https://livechat.ule.com";
//            manager.trackDomain=@"http://track.ule.com";
//            manager.commodityDomain=@"my.ule.com";
//            manager.cdnServerDomain=@"https://ustatic.ulecdn.com";
//            manager.ulecomDomain=@"https://www.ule.com";
//            manager.pixiao_appID=@"10017";
//            manager.pixiao_secret=@"3a11a4047695275f";
//            manager.appKey=@"2d4a9f19594abb04";
//            manager.fupinDomain=@"wx.zgshfp.com.cn";
//            manager.tencentDomain=@"https://apis.map.qq.com";
//        }else{
//            manager.apiDomain=@"http://api.beta.ule.com";
//            manager.serverDomain=@"http://service.beta.ule.com";
//            manager.wholesaleDomain=@"http://wholesale-api.beta.ule.com";
//            manager.livechatDomain=@"https://livechat.beta.ule.com";
//            manager.trackDomain=@"http://track.beta.ule.com";
//            manager.commodityDomain=@"my.beta.ule.com";
//            manager.cdnServerDomain=@"https://ustatic.beta.ulecdn.com";
//            manager.ulecomDomain=@"https://www.beta.ule.com";
//            manager.pixiao_appID=@"10025";
//            manager.pixiao_secret=@"f30077624b2757de";
//            manager.appKey=@"5aebc6036243eb4e";
//            manager.fupinDomain=@"fpmai.com";
//            manager.tencentDomain=@"https://apis.map.qq.com";
//        }
//    }
//}


#pragma mark - <getter>
- (NSString *)appLogoUrl{
    return @"https://pic.ule.com/item/user_0102/desc20171101/b985c19dfe417a7c_-1x-1.png";
}
- (NSString *)appKey{
    switch (self.envSer) {
        case 0:
            return @"5aebc6036243eb4e";
            break;
        case 1:
            return @"2d4a9f19594abb04";
            break;
        case 2:
            return @"49e6c43afe0059e8";
            break;
        default:
            return @"2d4a9f19594abb04";
            break;
    }
}

- (NSString *)pixiao_appID{
    return self.envSer?@"10017":@"10025";
}

- (NSString *)pixiao_secret{
    return self.envSer?@"3a11a4047695275f":@"f30077624b2757de";
}

- (NSString *)apiDomain{
    switch (self.envSer) {
        case 0:
            return @"https://api.beta.ule.com";
            break;
        case 1:
            return @"https://api.ule.com";
            break;
        case 2:
            return @"https://api.testing.ule.com";
            break;
        default:
            return @"https://api.ule.com";
            break;
    }
}
- (NSString *)vpsDomain{
    switch (self.envSer) {
        case 0:
            return @"https://vps.beta.ule.com";
            break;
        case 1:
            return @"https://vps.ule.com";
            break;
        case 2:
            return @"https://vps.testing.ule.com";
            break;
        default:
            return @"https://vps.ule.com";
            break;
    }
}
- (NSString *)serverDomain{
    switch (self.envSer) {
        case 0:
            return @"https://service.beta.ule.com";
            break;
        case 1:
            return @"https://service.ule.com";
            break;
        case 2:
            return @"https://service.testing.ule.com";
            break;
        default:
            return @"https://service.ule.com";
            break;
    }
}

- (NSString *)wholesaleDomain{
    switch (self.envSer) {
        case 0:
            return @"https://wholesale-api.beta.ule.com";
            break;
        case 1:
            return @"https://wholesale-api.ule.com";
            break;
        case 2:
            return @"https://wholesale-api.testing.ule.com";
            break;
        default:
            return @"https://wholesale-api.ule.com";
            break;
    }
}

- (NSString *)livechatDomain{
    switch (self.envSer) {
        case 0:
            return @"https://livechat.beta.ule.com";
            break;
        case 1:
            return @"https://livechat.ule.com";
            break;
        case 2:
            return @"https://livechat.testing.ule.com";
            break;
        default:
            return @"https://livechat.ule.com";
            break;
    }
}

- (NSString *)trackDomain{
    switch (self.envSer) {
        case 0:
            return @"https://track.beta.ule.com";
            break;
        case 1:
            return @"https://track.ule.com";
            break;
        case 2:
            return @"https://track.testing.ule.com";
            break;
        default:
            return @"https://track.ule.com";
            break;
    }
}

- (NSString *)commodityDomain{
    switch (self.envSer) {
        case 0:
            return @"https://my.beta.ule.com";
            break;
        case 1:
            return @"https://my.ule.com";
            break;
        case 2:
            return @"https://my.testing.ule.com";
            break;
        default:
            return @"https://my.ule.com";
            break;
    }
}

- (NSString *)cdnServerDomain{
    switch (self.envSer) {
        case 0:
            return @"https://ustatic.beta.ulecdn.com";
            break;
        case 1:
            return @"https://ustatic.ulecdn.com";
            break;
        case 2:
            return @"https://ustatic.testing.ulecdn.com";
            break;
        default:
            return @"https://ustatic.ulecdn.com";
            break;
    }
}

- (NSString *)ulecomDomain{
    switch (self.envSer) {
        case 0:
            return @"https://www.beta.ule.com";
            break;
        case 1:
            return @"https://www.ule.com";
            break;
        case 2:
            return @"https://www.testing.ule.com";
            break;
        default:
            return @"https://www.ule.com";
            break;
    }
}

- (NSString *)fupinDomain{
    return self.envSer?@"wx.zgshfp.com.cn":@"fpmai.com";
}

- (NSString *)tencentDomain{
    return @"https://apis.map.qq.com";
}

- (NSString *)mUleDomain{
    switch (self.envSer) {
        case 0:
            return @"https://m.beta.ule.com";
            break;
        case 1:
            return @"https://m.ule.com";
            break;
        case 2:
            return @"https://m.testing.ule.com";
            break;
        default:
            return @"https://m.ule.com";
            break;
    }
}

- (NSString *)userProvinceIdOrProvinceName{
    return [US_UserUtility getUserOrLocationProvinceName];
}

- (NSString *)isShowGoodsSourceBtn{
    return @"1";
}

- (NSString *)sectionKey_GoodsSourceTab{
    return @"poststore_index_tab";
}
- (NSString *)sectionKey_StoreButtonList{
    return @"poststore_store";
}
- (NSString *)sectionKey_GuidePage{
    return @"poststore_guide_page";
}

- (NSString *) sectionKey_Tabbar{
    return @"poststore_bottom_new_1";
}
- (NSString *) sectionKey_Dialog{
    return @"poststore_activity_dialog";
}
- (NSString *) sectionKey_Invited{
    return @"poststore_store_invited";
}
- (NSString *) sectionKey_Update{
    return @"poststore_shopkeeper_ios_update";
}
- (NSString *) sectionKey_UserCenter{
    return @"poststore_usercenter_new";
}
- (NSString *) sectionKey_CancelReason{
    return @"ule_cancel_reason_new";
}
- (NSString *) sectionKey_EvaluateLabels{
    return @"poststore_evaluate_labels";
}
- (NSString *) sectionKey_ProceedInfo{
    return @"poststore_proceeds_info";
}
- (NSString *) sectionKey_toutiao_list{
    return @"poststore_toutiao_list";
}
- (NSString *) sectionKey_bottom_banner{
    return @"poststore_index_bottom_banner";
}
- (NSString *) sectionKey_index_storey{
    return @"poststore_index_storey_1st";
}
- (NSString *) sectionKey_index_storeySecond{
    return @"poststore_index_storey_2nd";
}
- (NSString *) sectionKey_HomeRefresh{
    return @"poststore_index_refresh";
}
- (NSString *) sectionKey_DropDownRefresh{
    return @"poststore_home_refresh";
}
- (NSString *) sectionKey_insurance{
    return @"poststore_index_insurance";
}
- (NSString *) sectionKey_ownGoodstips{
    return @"poststore_selfgoods_income_tips";
}
- (NSString *) sectionKey_homeBottomRecommend{
    return @"poststore_index_bottom_recommend";
}
- (NSString *) sectionKey_wallet{
    return @"poststore_wallet";
}
- (NSString *) sectionKey_OrderList{
    return @"poststore_order_list";
}
- (NSString *) sectionKey_ShareImage{
    return @"poststore_share_image";
}
- (NSString *) sectionKey_wholesaleList{
    return @"poststore_wholesale_list";
}

- (NSString *) api_walletInfo{
    return API_walletInfo;
}
- (NSString *) api_searchGoodSource{
    return API_SearchGoodSource;
}

@end
