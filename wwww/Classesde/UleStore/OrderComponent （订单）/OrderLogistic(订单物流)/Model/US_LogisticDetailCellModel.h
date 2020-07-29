//
//  US_LogisticDetailCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "US_ExpressInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_LogisticDetailCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * packageInfo;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * states;

- (instancetype)initWithLogiticMapInfo:(US_ExpressListMap *)express;

@end

NS_ASSUME_NONNULL_END
