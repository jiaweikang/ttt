//
//  US_StoreDetailListCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/11.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USStoreDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_StoreDetailListCell : UICollectionViewCell

@property (nonatomic, strong) USStoreDetailListingItem * model;
@end

NS_ASSUME_NONNULL_END
