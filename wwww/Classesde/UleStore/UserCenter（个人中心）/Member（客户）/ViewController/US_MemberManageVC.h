//
//  US_MemberManageVC.h
//  UleStoreApp
//
//  Created by zemengli on 2018/12/25.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^MemberManageDidScrollEndBlock)(void);

@interface US_MemberManageVC : UleBaseViewController
@property (nonatomic, copy)MemberManageDidScrollEndBlock didScrollEndBlock;

@end

NS_ASSUME_NONNULL_END
