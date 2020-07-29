//
//  US_BankCardListCell.h
//  UleStoreApp
//
//  Created by zemengli on 2019/3/12.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_BankCardListCellModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol US_BankCardListCellDelegate <NSObject>
- (void)deleteCardWithCardNum:(NSString *)cardNum;
@end
@interface US_BankCardListCell : UITableViewCell
@property (nonatomic, strong) US_BankCardListCellModel * model;
@property (nonatomic, weak) id<US_BankCardListCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
