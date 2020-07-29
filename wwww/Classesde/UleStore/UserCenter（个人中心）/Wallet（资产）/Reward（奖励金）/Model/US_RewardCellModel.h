//
//  IncomeCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_RewardCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * colorValue;
@property (nonatomic, strong) NSString * incomeDesc;
@property (nonatomic, strong) NSString * amount;
@property (nonatomic, strong) NSString * orderID;
@property (nonatomic, strong) NSString * creatOrderTime;
@property (nonatomic, strong) NSString * timeTitle;
@property (nonatomic, strong) NSString * detailTime;
@property (nonatomic, strong) NSString * detailDesc;
@property (nonatomic, copy) NSString *effectiveTime;// 奖励金明细有效期
@property (nonatomic, copy) NSString *iconUrl;//图标

@end

NS_ASSUME_NONNULL_END
