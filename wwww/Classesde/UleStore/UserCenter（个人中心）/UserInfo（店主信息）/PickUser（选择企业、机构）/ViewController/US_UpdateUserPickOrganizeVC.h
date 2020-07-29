//
//  US_UpdateUserPickOrganizeVC.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "UpdateUserHeaderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_UpdateUserPickOrganizeVC : UleBaseViewController
- (instancetype)initWithOrgType:(NSString *)pickOrgType andOrgName:(NSString *)orgName andUserType:(UpdateUserType)userType identifierTips:(NSString *)identifierTips;
@end

NS_ASSUME_NONNULL_END
