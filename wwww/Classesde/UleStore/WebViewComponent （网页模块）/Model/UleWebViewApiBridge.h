//
//  UleWebViewApiBridge.h
//  UleApp
//
//  Created by uleczq on 2017/7/18.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebDetailViewController.h"
#import "UleModulesDataToAction.h"

@protocol UleWebViewBridgeDelegate <NSObject>

@optional
//设置导航栏title，以及右侧按键
- (void)loadNavigationBarWithTitle:(NSString *)title andRightButtons:(NSArray *)btns;
//调用JS方法
- (void)runJsFunction:(NSString *)functionName andParams:(NSArray *)params;
//处理旧版url，解析。
- (void)handleRequestUrl:(NSString *)actionUrl;
//扫码
- (void)jumpToScanViewController:(NSString*)jsAction;
//隐藏显示导航栏
- (void)hiddenNavigationBar:(BOOL)isHidden offSetStatus:(BOOL)offsetStatus animated:(BOOL)isAnimated;
//导航栏上添加搜索条
- (void)loadNavigationSearchBar;
//跳转到店铺搜索页面（特殊处理的情况）
- (void)gotoStoreSearchViewController:(NSString *)keywords;
//跳转到tab页面
- (void)gotoTabViewControllerAtIndex:(NSInteger)index;
//
- (void)setLeftBackButtonAction:(UleUCiOSAction *)action;
//分享
- (void)jsFunctionShareInWebview:(NSString *)shareJson;
//返回
- (void)popToHomeAction;
@end

@interface UleWebViewApiBridge : NSObject
@property (nonatomic, weak) id<UleWebViewBridgeDelegate> delegate;

- (id)setNativeSearchBar:(NSDictionary *)args;
@end
