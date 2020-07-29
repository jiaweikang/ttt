//
//  InviterMemberCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InviterMemberCellModel : UleCellBaseModel
@property (nonatomic, strong) NSString * imageUrl;//图片
@property (nonatomic, strong) NSString * storeName;//店铺名
@property (nonatomic, strong) NSString * userName;//姓名
@property (nonatomic, strong) NSString * saleCount;//成交单量
@property (nonatomic, strong) NSString * lastShareTime;//开店时间
@property (nonatomic, strong) NSString * mobile; //手机号
@property (nonatomic, strong) NSString * provinceName; //机构名

@property (nonatomic, strong) NSString * inviterId;
@end

NS_ASSUME_NONNULL_END
