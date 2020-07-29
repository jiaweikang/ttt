//
//  AuthorizeCellModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/3/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AuthorizeCellModel : UleCellBaseModel
@property (nonatomic, copy)NSString     *imageName;
@property (nonatomic, copy)NSString     *titleText;

@property (nonatomic, copy)NSString     *contentText;
@end

NS_ASSUME_NONNULL_END
