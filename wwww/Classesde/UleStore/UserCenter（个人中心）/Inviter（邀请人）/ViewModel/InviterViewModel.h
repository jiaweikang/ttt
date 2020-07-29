//
//  InviterViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InviterViewModel : UleBaseViewModel
@property (nonatomic, weak) UITableView * rootTableView;
@property (nonatomic, assign) NSInteger startPage;
//解析数据
- (void)fetchInviterValueWithModel:(NSDictionary *) dic;
@end

NS_ASSUME_NONNULL_END
