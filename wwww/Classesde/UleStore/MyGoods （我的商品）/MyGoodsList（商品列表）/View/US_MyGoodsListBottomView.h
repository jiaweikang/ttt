//
//  US_MyGoodsListBottomView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleControlView.h"

@protocol US_MyGoodsListBottomViewDelegate <NSObject>

@optional;
- (void)searchProductClick;

- (void)batchManagerClick;

- (void)addNewProductClick;
@end

NS_ASSUME_NONNULL_BEGIN

@interface US_MyGoodsListBottomView : UIView
@property (nonatomic, weak) id<US_MyGoodsListBottomViewDelegate>delegate;
@property (nonatomic, strong) UIView * redDotView;
@property (nonatomic, strong) UleControlView * leftButton;
@property (nonatomic, strong) UleControlView * rightButton;
@property (nonatomic, assign) BOOL addNewGoods;

-(void)showPopView;
-(void)setRightButtonCanClick:(BOOL)rightBtnCanClick;
-(void)setRightButtonTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END

