//
//  EnterprisePickAlertView.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/20.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EnterprisePickAlertViewBlock)(NSInteger);

@interface EnterprisePickAlertView : UIView
@property (nonatomic, strong)UILabel    *titleLab;
@property (nonatomic, copy)EnterprisePickAlertViewBlock actionBlock;

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
