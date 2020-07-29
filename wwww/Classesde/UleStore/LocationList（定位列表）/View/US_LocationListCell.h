//
//  US_LocationListCell.h
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/14.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentLBS/TencentLBS.h>
#import "UleCellBaseModel.h"
#import "UleSectionBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_LocationListCellModel : UleCellBaseModel
@property (nonatomic, strong) id data;
@property (nonatomic, assign) bool showBtn;

@end


@interface US_LocationListCell : UITableViewCell
@property (nonatomic, strong) UleCellBaseModel * model;
@end

@interface US_locationHead : UITableViewHeaderFooterView
@property (nonatomic, strong) UleSectionBaseModel * model;

@end
NS_ASSUME_NONNULL_END
