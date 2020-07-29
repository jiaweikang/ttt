//
//  US_RewardListViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"
#import "US_WalletTotalIncomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_RewardListViewModel : UleBaseViewModel
@property (nonatomic, assign) BOOL isEndRefreshFooter;
//组装成sectionModel 数组用于显示
- (void)fetchRewardListWithData:(US_WalletTotalIncomeModel *)incomeData WithStartPage:(NSInteger)startPage DetailViewName:(NSString *)detailViewName;
@end

NS_ASSUME_NONNULL_END
