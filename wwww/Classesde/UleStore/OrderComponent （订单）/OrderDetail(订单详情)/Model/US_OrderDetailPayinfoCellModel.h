//
//  US_OrderDetailPayinfoCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/2.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "MyWaybillOrderInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailPayinfoCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString        *titleName;
@property (nonatomic, copy) NSString        *contentName;
@property (nonatomic, assign)BOOL           isFirstCell;
@end

NS_ASSUME_NONNULL_END
