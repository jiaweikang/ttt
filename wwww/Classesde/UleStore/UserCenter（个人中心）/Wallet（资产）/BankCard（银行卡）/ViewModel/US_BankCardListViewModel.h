//
//  US_BankCardListViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/12.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN
@class US_WalletBindingCardInfo;
@interface US_BankCardListViewModel : UleBaseViewModel
@property (nonatomic, copy)void(^cellSelectBlock)(US_WalletBindingCardInfo *cardInfo);
//组装成sectionModel 数组用于显示
- (void)fetchBankCardListWithData:(NSDictionary *)dic;
- (void)setBankCardListEdit:(BOOL)isEditing;
@end

NS_ASSUME_NONNULL_END
