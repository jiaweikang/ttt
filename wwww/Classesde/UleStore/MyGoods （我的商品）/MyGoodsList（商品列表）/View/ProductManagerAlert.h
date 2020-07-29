//
//  ProductManagerAlert.h
//  TestGif
//
//  Created by uleczq on 2017/6/21.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ManageClickTypeCategory,  //分类点击
    ManageClickTypeAddCategory,//添加分类点击
    ManageClickTypeSearch,  //搜索点击
    ManageClickTypeNoCategory //未分类点击
} ManageClickType;

typedef void(^ProductManageClickBlock)(id obj,ManageClickType clickType);
typedef void(^ProductManageHidden)(void);

@interface ProductManagerAlert : UIView
@property (nonatomic, strong) ProductManageClickBlock selectBlock;
@property (nonatomic, strong) ProductManageHidden hiddenClick;
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) NSString * selectedTitle;
- (instancetype)initWithTitles:(NSArray *)titles andSelectTitle:(NSString *)tile;

- (void)showAtView:(UIView *)rootView belowView:(UIView *)topView;

- (void)hiddenView:(UIGestureRecognizer *)recognize;
@end
