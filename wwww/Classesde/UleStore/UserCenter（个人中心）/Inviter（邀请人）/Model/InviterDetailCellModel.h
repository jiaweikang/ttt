//
//  InviterDetailCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InviterDetailCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString *listingId;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *listingName;
@property (nonatomic, copy) NSString *salePrice;
@property (nonatomic, copy) NSString *prdCommission;
@property (nonatomic, copy) NSString *orderCount;
//@property (nonatomic, copy) NSString *escOrderId;
//@property (nonatomic, copy) NSString *recordId;
@end

NS_ASSUME_NONNULL_END
