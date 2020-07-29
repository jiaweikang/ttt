//
//  UpdateUserPickCollectionViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN
@class AttributionPickCellModel,UpdateUserPickCollectionCellModel;
typedef void(^UpdateUserPickCollectionTableCellSecectBlock)(AttributionPickCellModel *selectCellModel);
@interface UpdateUserPickCollectionViewModel : UleBaseViewModel
@property (nonatomic, copy)UpdateUserPickCollectionTableCellSecectBlock didSelectCellBlock;
@property (nonatomic, strong)NSMutableArray     *sideBarDataArray;
- (void)fetchTableCellModel:(UpdateUserPickCollectionCellModel *)itemModel;
@end

NS_ASSUME_NONNULL_END
