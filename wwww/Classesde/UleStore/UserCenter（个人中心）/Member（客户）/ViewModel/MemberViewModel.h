//
//  MemberViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/27.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberViewModel : UleBaseViewModel
@property (nonatomic, weak) UITableView * rootTableView;
@property (nonatomic, assign) NSInteger startPage;
//解析数据
- (void)fetchValueSuccessWithModel:(NSDictionary *) dic;
@end

NS_ASSUME_NONNULL_END
