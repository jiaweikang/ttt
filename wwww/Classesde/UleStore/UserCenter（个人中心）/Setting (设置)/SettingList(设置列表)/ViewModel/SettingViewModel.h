//
//  SettingViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingViewModel : UleBaseViewModel
@property (nonatomic, weak) UIViewController * rootViewController;
@property (nonatomic, weak) UITableView * rootTableView;
@end

NS_ASSUME_NONNULL_END
