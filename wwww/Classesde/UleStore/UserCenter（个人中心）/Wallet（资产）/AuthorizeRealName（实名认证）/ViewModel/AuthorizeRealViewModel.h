//
//  AuthorizeRealViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class CertificationInfo;
@interface AuthorizeRealViewModel : UleBaseViewModel

- (void)handleAuthorizeInfo:(CertificationInfo *)info;

@end

NS_ASSUME_NONNULL_END
