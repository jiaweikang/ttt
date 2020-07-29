//
//  US_CouponListCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "US_MyCoupons.h"
NS_ASSUME_NONNULL_BEGIN


@interface US_CouponListCellModel : UleCellBaseModel
@property (nonatomic, strong) NSMutableAttributedString * mCouponNameAttribute;
@property (nonatomic, strong) NSMutableAttributedString * mCouponMoneyAttribute;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * startTime;
@property (nonatomic, copy) NSString * descriStr;
@property (nonatomic, copy) NSString * colorStr;



- (instancetype)initWithCouponData:(MyCouponModel *)couponData;

@end

NS_ASSUME_NONNULL_END
