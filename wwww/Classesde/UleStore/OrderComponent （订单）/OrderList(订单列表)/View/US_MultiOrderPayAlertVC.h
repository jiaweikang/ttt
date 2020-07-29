//
//  US_ MultiOrderPayAlertVC.h
//  UleStoreApp
//
//  Created by 李泽萌 on 2020/4/13.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^US_MultiOrderPayAlertConfirmBlock)(NSString *orderIds);
@interface US_MultiOrderPayAlertVC : UleBaseViewController
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, copy)US_MultiOrderPayAlertConfirmBlock  confirmBlock;
@end

NS_ASSUME_NONNULL_END
