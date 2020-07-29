//
//  MineTableViewCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleTableViewCellProtocol.h"
#import "MineCellModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MineTableViewCell : UITableViewCell<UleTableViewCellProtocol>
@property(nonatomic, strong) MineCellModel * model;
@end

NS_ASSUME_NONNULL_END
