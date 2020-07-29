//
//  US_MessageListCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleCellBaseModel.h"
#import "US_MessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MessageListCell : UITableViewCell
@property (nonatomic, strong) UleCellBaseModel * model;

@end

@interface US_OrderMessageListCell : UITableViewCell
@property (nonatomic, strong) UleCellBaseModel * model;

@end

NS_ASSUME_NONNULL_END
