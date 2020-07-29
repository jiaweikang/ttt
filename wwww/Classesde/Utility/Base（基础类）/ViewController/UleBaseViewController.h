//
//  UleBaseViewController.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleCustemNavigationBar.h"
#import <UIView+SDAutoLayout.h>
#import <UleMBProgressHUD.h>
#import <UleNetworkExcute.h>
#import <MJRefresh/MJRefresh.h>
#import "UIImage+USAddition.h"

@protocol US_RefreshProtocol <NSObject>

@optional
- (void)beginRefreshHeader;

- (void)beginRefreshFooter;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UleBaseViewController : UIViewController<US_RefreshProtocol>
@property (nonatomic, strong) UleCustemNavigationBar * uleCustemNavigationBar;
@property (nonatomic, strong) NSMutableDictionary* m_Params;
@property (nonatomic, strong) MJRefreshGifHeader * mRefreshHeader;
@property (nonatomic, strong) MJRefreshFooter * mRefreshFooter;

/*********网络请求**********/
@property (nonatomic, strong) UleNetworkExcute * networkClient_VPS;
@property (nonatomic, strong) UleNetworkExcute * networkClient_API;
@property (nonatomic, strong) UleNetworkExcute * networkClient_CDN;
@property (nonatomic, strong) UleNetworkExcute * networkClient_Ule;
@property (nonatomic, strong) UleNetworkExcute * networkClient_UstaticCDN;
//Client-Type=application/json
@property (nonatomic, strong) UleNetworkExcute * networkClient_JsonWithoutDomain;

//提示错误信息
- (void)showErrorHUDWithError:(UleRequestError *)error;
- (void)showAlertNormal:(NSString *)message;
/*********隐藏/显示导航栏**********/
- (void)hideCustomNavigationBar;
- (void)showCustomNavigationBar;

@end

NS_ASSUME_NONNULL_END
