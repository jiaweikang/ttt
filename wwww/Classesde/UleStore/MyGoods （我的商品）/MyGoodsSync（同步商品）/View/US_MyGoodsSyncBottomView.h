//
//  US_MyGoodsSyncBottomView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol US_MyGoodsSyncDelegate <NSObject>

- (void)seletAllGoods:(BOOL)isSelected;

- (void)syncSeletedGoods;


@end

@interface US_MyGoodsSyncBottomView : UIView
@property (nonatomic, strong) id<US_MyGoodsSyncDelegate> delegate;
- (void) setAllSelected:(BOOL)isAllSelected;
@end

NS_ASSUME_NONNULL_END
