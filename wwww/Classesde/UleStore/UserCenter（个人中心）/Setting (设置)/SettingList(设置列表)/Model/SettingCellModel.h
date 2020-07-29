//
//  SettingCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingCellModel : UleCellBaseModel

@property (nonatomic, strong) NSString * iconStr;
@property (nonatomic, strong) NSString * leftTitleStr;
@property (nonatomic, strong) NSString * leftSubTitleStr;
@property (nonatomic, strong) NSString * rightTitleStr;
@property (nonatomic, strong) NSString * switchState;
@property (nonatomic, assign) BOOL showRightArrow;

@end

NS_ASSUME_NONNULL_END
