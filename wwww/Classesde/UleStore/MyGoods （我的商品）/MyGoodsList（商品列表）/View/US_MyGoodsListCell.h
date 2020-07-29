//
//  US_MyGoodsListCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_MyGoodsListCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol US_MyGoodsListCellDelegate <NSObject>

@optional
- (void)didSelectedListCellForModel:(US_MyGoodsListCellModel *)model;
- (void)didLongPressedForModel:(US_MyGoodsListCellModel *)model;
@end

@interface US_MyGoodsListCell : UITableViewCell
@property (nonatomic, strong) US_MyGoodsListCellModel * model;
@property (nonatomic, weak) id<US_MyGoodsListCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
