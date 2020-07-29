//
//  US_OrderListInfoVC.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderListInfoVC : UleBaseViewController

- (void)requestOrderListForKeyWords:(NSString *) keyword;
@end

NS_ASSUME_NONNULL_END
