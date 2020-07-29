//
//  US_OrderListSectionFooter.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_OrderListSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol US_OrderListSectionFooterDelegate <NSObject>

- (void)footButtonClick:(OrderButtonState) state sectionModel:(US_OrderListSectionModel *)sectionModel;

@end

@interface US_OrderListSectionFooter : UITableViewHeaderFooterView
@property (nonatomic, strong) US_OrderListSectionModel * model;
@property (nonatomic, weak) id<US_OrderListSectionFooterDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
