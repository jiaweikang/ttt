//
//  UpdateUserPickCollectionCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
#import "UleSectionBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UpdateUserPickCollectionCellType) {
    UpdateUserPickCollectionCellTypeNone=0,//关联值不可变动
    UpdateUserPickCollectionCellTypeProvince,
    UpdateUserPickCollectionCellTypeCity,
    UpdateUserPickCollectionCellTypeCountry,
    UpdateUserPickCollectionCellTypeSubStation
};

@class AttributionPickCellModel;
typedef void(^UpdateUserPickCollectionCellSelectBlock)(AttributionPickCellModel *selectCellModel);

@interface UpdateUserPickCollectionCellModel : UleCellBaseModel
@property (nonatomic, assign)UpdateUserPickCollectionCellType   mCellType;
@property (nonatomic, strong)NSMutableArray    *tableviewDataArray;
@property (nonatomic, copy)UpdateUserPickCollectionCellSelectBlock    collectionCellSelectBlock;
@end

NS_ASSUME_NONNULL_END
