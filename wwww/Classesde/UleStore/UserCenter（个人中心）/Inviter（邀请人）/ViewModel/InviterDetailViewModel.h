//
//  InviterDetailViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"
#import "InviterDetailData.h"
NS_ASSUME_NONNULL_BEGIN

@interface InviterDetailViewModel : UleBaseViewModel
@property (nonatomic, weak) UITableView * rootTableView;
//解析数据
- (void)fetchInviterDetailValueWithData:(InviterDetailData *) inviterData;
@end

NS_ASSUME_NONNULL_END
