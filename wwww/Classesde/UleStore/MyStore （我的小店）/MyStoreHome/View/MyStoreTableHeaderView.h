//
//  MyStoreTableHeaderView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/20.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyStoreViewModel.h"
NS_ASSUME_NONNULL_BEGIN

#define KMSStrategyHight  KScreenScale(90)

@interface MyStoreTableHeaderView : UIView
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, strong) MyStoreViewModel * model;
@property (nonatomic, assign) BOOL  isShowPromoteBar;

- (void)showPromoteBar:(BOOL)show animate:(BOOL) animate;
@end

NS_ASSUME_NONNULL_END
