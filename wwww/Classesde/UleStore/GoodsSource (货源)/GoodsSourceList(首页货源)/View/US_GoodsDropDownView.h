//
//  US_GoodsDropDownView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/5/23.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DropDownViewSelect)(id obj);
typedef void(^DropDownViewHidden)(void);

@interface US_GoodsDropDownView : UIView
@property (nonatomic, strong) NSString * selectedTitle;
@property (nonatomic, strong) DropDownViewSelect selectBlock;
@property (nonatomic, strong) DropDownViewHidden hiddenClick;

- (instancetype)initWithTitles:(NSArray *)titles andSelectedTitle:(NSString *)selectedTitle;

- (void)showAtView:(UIView *)rootView belowView:(UIView *)topView;

- (void)hiddenView:(UIGestureRecognizer * __nullable)recognize;
@end

NS_ASSUME_NONNULL_END
