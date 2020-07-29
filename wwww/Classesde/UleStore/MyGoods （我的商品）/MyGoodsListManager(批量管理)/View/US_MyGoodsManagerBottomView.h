//
//  US_MyGoodsManagerBottomView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol US_MyGoodsManagerBottomDelegate <NSObject>

- (void)seletAllGoods:(BOOL)isSelected;

- (void)deleteSeletedGoods;

- (void)upTopSelectedGoods;

- (void)removeSeletedGoods;
@end


@interface US_MyGoodsManagerBottomView : UIView
@property (nonatomic, weak) id<US_MyGoodsManagerBottomDelegate>delegate;
@property (nonatomic, assign) BOOL onlyDeleteGoods;//只有删除商品
- (void) setAllSelected:(BOOL)isAllSelected;
@end

NS_ASSUME_NONNULL_END
