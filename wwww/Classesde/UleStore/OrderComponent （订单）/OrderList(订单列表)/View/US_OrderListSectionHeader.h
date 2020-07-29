//
//  US_OrderListSectionHeader.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_OrderListSectionModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol US_OrderListSectionHeaderDelegate <NSObject>

- (void)headViewClickWithSectionModel:(US_OrderListSectionModel *)sectionModel;

@end
@interface US_OrderListSectionHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) US_OrderListSectionModel * model;
@property (nonatomic, weak) id<US_OrderListSectionHeaderDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
