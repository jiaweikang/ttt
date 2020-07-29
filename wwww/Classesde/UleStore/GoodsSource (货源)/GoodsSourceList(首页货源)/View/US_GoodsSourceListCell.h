//
//  US_GoodsSourceListCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_GoodsCellModel.h"
#import "USShareView.h"
@protocol US_GoodsSourceListCellDelegate <NSObject>

@optional

- (void)didAddGoodswithListId:(NSString * _Nullable )listId;

- (void)didShareGoodsWithListId:(NSString *_Nullable)listId;

@end

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceListCell : UICollectionViewCell

@property (nonatomic, strong) US_GoodsCellModel * model;
@property (nonatomic, weak) id <US_GoodsSourceListCellDelegate>delegate;

@end



NS_ASSUME_NONNULL_END
