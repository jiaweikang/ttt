//
//  US_AddNewCategoryAlert.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/31.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^US_AddNewCategoryAlertBlock)(NSString * categoryName);
NS_ASSUME_NONNULL_BEGIN

@interface US_AddNewCategoryAlert : UIView

+ (instancetype)creatAlertWithConfirmBlock:(US_AddNewCategoryAlertBlock) comfirmBlock;
@end

NS_ASSUME_NONNULL_END
