//
//  US_StoreDetailHeadView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USStoreDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_StoreDetailHeadView : UIView
@property (nonatomic, strong) NSString *storeName;
@property (nonatomic, strong) USStoreDetailInfo *storeInfo;
@end

NS_ASSUME_NONNULL_END
