//
//  US_RewardHeadView.h
//  u_store
//
//  Created by mac_chen on 2019/6/26.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalRewardsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBtnBlock)(NSString *transFlag);

@interface US_RewardHeadView : UITableViewHeaderFooterView

@property (nonatomic, strong) TotalRewardsHeadData * model;

@property (nonatomic, copy) ChooseBtnBlock chooseBtnBlock;

@end

NS_ASSUME_NONNULL_END
