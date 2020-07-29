//
//  WebDetailViewController.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "dsbridge.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebDetailViewController : UleBaseViewController
@property (nonatomic, strong) DWKWebView *wk_mWebView;
- (void)runJsFunction:(NSString *)functionName andParams:(NSArray *)params;
@end

NS_ASSUME_NONNULL_END
