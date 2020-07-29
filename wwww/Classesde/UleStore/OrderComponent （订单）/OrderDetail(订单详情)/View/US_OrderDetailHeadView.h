//
//  US_OrderDetailHeadView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleSectionBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailHeadViewModel : NSObject
@property (nonatomic, strong) NSString * statuImageName;
@property (nonatomic, strong) NSString * statuStr;
@property (nonatomic, strong) NSString * subStatusStr;
@end

@interface US_OrderDetailHeadView : UIView

@property (nonatomic, strong) US_OrderDetailHeadViewModel * model;
@end

@class US_OrderDetailSectionModel;
@interface US_OrderDetailSectionHeadView : UITableViewHeaderFooterView
@property (nonatomic, strong) US_OrderDetailSectionModel * model;
@end


@interface US_OrderDetailSectionFootView : UITableViewHeaderFooterView
@property (nonatomic, strong) UleSectionBaseModel * model;
@end

NS_ASSUME_NONNULL_END
