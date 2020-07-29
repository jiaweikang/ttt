//
//  US_LogisticTitleCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_LogisticTitleCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * escOrderId;
@property (nonatomic, strong) NSString * packageId;
@property (nonatomic, strong) NSString * logisticType;
@property (nonatomic, copy) NSString * name;//物流包裹供应商
@end

NS_ASSUME_NONNULL_END
