//
//  WithdrawSummaryCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/4/1.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawSummaryCellModel : UleCellBaseModel
@property (nonatomic, copy) void(^withdrawSummaryRecordBlock)(void);

@end

NS_ASSUME_NONNULL_END
