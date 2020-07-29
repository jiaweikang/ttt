//
//  US_StoreManagerCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

typedef enum : NSUInteger {
    US_StoreManagerCellType0,
    US_StoreManagerCellType1,
    US_StoreManagerCellType2,
} US_StoreManagerCellType;

NS_ASSUME_NONNULL_BEGIN

@interface US_StoreManagerCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * imagePath;
@property (nonatomic, strong) NSString * leftTitle;
@property (nonatomic, strong) NSString * rightTitle;
@property (nonatomic, assign) US_StoreManagerCellType cellType;
@end

NS_ASSUME_NONNULL_END
