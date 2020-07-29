//
//  US_RewardChooseBtn.h
//  u_store
//
//  Created by mac_chen on 2019/6/26.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ChooseBtnViewDelegate <NSObject>

-(void)topViewDidSelectAtIndex:(NSInteger)index;

@end

@interface US_RewardChooseBtn : UITableViewHeaderFooterView
+(US_RewardChooseBtn *)topViewWithDelegate:(id<ChooseBtnViewDelegate>)delegate frame:(CGRect)frame;

-(void)selectBtnAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
