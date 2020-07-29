//
//  WithdrawCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawCommissionCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString        *transMoneyStr;
@property (nonatomic, copy) void(^withdrawCommissionConfirmBlock)(void);
@end

NS_ASSUME_NONNULL_END
