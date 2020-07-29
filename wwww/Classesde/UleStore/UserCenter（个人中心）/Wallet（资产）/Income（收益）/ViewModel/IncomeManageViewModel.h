//
//  IncomeViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/2/19.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IncomeManageViewModel : NSObject<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView * rootTableView;
@property (nonatomic, weak) UIViewController * rootVC;

- (void)fetchValueWithData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
