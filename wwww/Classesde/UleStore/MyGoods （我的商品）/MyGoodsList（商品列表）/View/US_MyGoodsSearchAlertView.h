//
//  US_MyGoodsSearchAlertView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/23.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_MyGoodsListBottomView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^AlertDismissFinish)(void);
typedef void(^MyGoodsSearchAlertRightButtonClick)(void);

@interface US_MyGoodsSearchAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame RightButtonCanClick:(BOOL)rightBtnCanClick;
@property (nonatomic, strong) AlertDismissFinish dismissFinish;
@property (nonatomic, strong) MyGoodsSearchAlertRightButtonClick rightButtonClick;
- (void)show;
//- (void)dismiss;
@end

NS_ASSUME_NONNULL_END

