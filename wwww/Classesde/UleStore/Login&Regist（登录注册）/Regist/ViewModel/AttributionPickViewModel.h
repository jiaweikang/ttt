//
//  AttributionPickViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AttributionPickViewModelBlock)(NSString *name, NSString *code);

@interface AttributionPickViewModel : UleBaseViewModel
@property (nonatomic, copy)AttributionPickViewModelBlock    didSelectCellBlock;

- (void)loadEnterpriseInfo;

- (void)loadOrganizeInfoWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName andPostOrgType:(NSString *)postOrgType;

@end

NS_ASSUME_NONNULL_END
