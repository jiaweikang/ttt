//
//  OrganizeCollectionCellViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/26.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OrganizeCollectionViewCellBlock)(NSString *organizeName, NSString *organizeId, NSIndexPath *tableIndexPath, NSIndexPath *lastTableIndexPath);

@interface OrganizeCollectionCellViewModel : UleBaseViewModel
@property (nonatomic, copy)OrganizeCollectionViewCellBlock  mViewModelCellDidSelectBlock;

/**
 *
 *return 导航边栏的数据源
**/
- (NSMutableArray *)setCollectionCellViewTableviewData:(NSMutableArray *)mTableViewData;

@end

NS_ASSUME_NONNULL_END
