//
//  US_BankCardListCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/12.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_BankCardListCellModel : UleCellBaseModel
@property (nonatomic, strong) NSMutableAttributedString * bankName;
@property (nonatomic, strong) NSMutableAttributedString * cardNum;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * mobileNum;
@property (nonatomic, strong) NSString * cardNumber;//卡号 解除绑定用
@property (nonatomic, assign) BOOL isEditing;
@end

NS_ASSUME_NONNULL_END
