//
//  US_MyGoodsBatchDeleteVC.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"

@protocol US_MyGoodsBatchDeleteVCDelegate <NSObject>

- (void)didDismissed;

@end
NS_ASSUME_NONNULL_BEGIN

@interface US_MyGoodsBatchDeleteVC : UleBaseViewController
@property (nonatomic, weak) id<US_MyGoodsBatchDeleteVCDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
