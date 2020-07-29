//
//  US_OrderDetailSectionHeadModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/12/6.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "UleSectionBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_OrderDetailSectionModel : UleSectionBaseModel
@property (nonatomic, assign)US_OrderListType orderListType;
@property (nonatomic, copy)NSString     *ownOrderMerchantPhoneNum;//自有订单商家电话
@property (nonatomic, copy)void(^clickActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
