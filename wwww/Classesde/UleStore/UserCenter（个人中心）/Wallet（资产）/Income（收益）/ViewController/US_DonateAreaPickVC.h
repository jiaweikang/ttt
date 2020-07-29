//
//  US_DonateAreaPickVC.h
//  UleStoreApp
//
//  Created by zemengli on 2019/4/8.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleBaseViewController.h"
#import "US_PostOrigModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol US_DonateAreaPickVCDelegate <NSObject>
@optional

- (void)organizationSelect:(US_postOrigData *)listData;

@end
@interface US_DonateAreaPickVC : UleBaseViewController
@property (assign, nonatomic)id <US_DonateAreaPickVCDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
