//
//  US_MenuPopOverView.h
//  u_store
//
//  Created by zemengli on 2019/6/21.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import "WBPopOverView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ViewClickBlock)(NSString *clickTitle);
typedef void(^ViewDismissBlock)(void);
@interface US_MenuPopOverView : WBPopOverView
- (instancetype)initWithSuperView:(UIView *)superView MunuListArray:(NSArray *)munuListArray SelectTitle:(NSString *)selectTitle;


@property (nonatomic, strong) ViewClickBlock clickBlock;
@property (nonatomic, strong) ViewDismissBlock dismissBlock;
@end

NS_ASSUME_NONNULL_END
