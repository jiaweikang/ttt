//
//  US_GoodsSourceSuspendBarView.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/16.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeaturedModel_HomeScrollBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceSuspendBarView : UIView
@property (nonatomic, strong)NSMutableArray<FeaturedModel_HomeScrollBarIndex *> * mDataArray;
- (void)stopTimer;
- (void)startTimer;
@end

NS_ASSUME_NONNULL_END
