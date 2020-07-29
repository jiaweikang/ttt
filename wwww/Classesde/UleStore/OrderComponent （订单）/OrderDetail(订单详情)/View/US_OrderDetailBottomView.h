//
//  US_OrderDetailBottomView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_OrderListSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol US_OrderDetailBottomViewDelegate <NSObject>

- (void)footButtonClick:(OrderButtonState) state;

@end

@interface US_OrderDetailBottomView : UIView

@property (nonatomic, strong) US_OrderListFooterModel * model;
@property (nonatomic, weak) id<US_OrderDetailBottomViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
