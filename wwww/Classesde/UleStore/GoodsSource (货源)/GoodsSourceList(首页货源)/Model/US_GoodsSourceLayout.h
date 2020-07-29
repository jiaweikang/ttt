//
//  US_GoodsSourceLayout.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_GoodsSectionModel.h"
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray<US_GoodsSectionModel*> * dataArray;
@end

NS_ASSUME_NONNULL_END
