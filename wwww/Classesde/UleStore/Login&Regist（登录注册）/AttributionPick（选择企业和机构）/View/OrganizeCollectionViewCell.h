//
//  OrganizeCollectionViewCell.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizeCollectionCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrganizeCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy)OrganizeCollectionViewCellBlock  tableCellDidSelectBlock;

- (void)setTableviewData:(NSMutableArray *)mData;


@end

NS_ASSUME_NONNULL_END
