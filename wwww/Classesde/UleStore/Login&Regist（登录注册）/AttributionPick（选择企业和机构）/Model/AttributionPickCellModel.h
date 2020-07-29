//
//  AttributionPickCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttributionPickCellModel : UleCellBaseModel
@property (nonatomic, copy)NSString     *contentStr;
@property (nonatomic, copy)NSString     *_id;
@property (nonatomic, assign)BOOL       isContentSelected;

@end

NS_ASSUME_NONNULL_END
