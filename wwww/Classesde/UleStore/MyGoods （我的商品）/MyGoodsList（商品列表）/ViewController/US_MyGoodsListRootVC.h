//
//  US_MyGoodsListRootVC.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "UleBasePageViewController.h"
NS_ASSUME_NONNULL_BEGIN

@protocol US_MyGoodsListRootVCDelegate <NSObject>
@optional
- (void) didScrollOlderOffset:(CGFloat)oldOffset newOffset:(CGFloat) newOffset;

@end

@interface US_MyGoodsListRootVC : UleBasePageViewController

@end

NS_ASSUME_NONNULL_END
