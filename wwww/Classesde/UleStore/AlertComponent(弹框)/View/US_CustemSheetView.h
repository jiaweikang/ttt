//
//  US_CustemSheetView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/6/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+ShowAnimation.h>
NS_ASSUME_NONNULL_BEGIN

@interface US_CustemSheetView : UIView
/**
 确定
 */
@property (nonatomic, copy) void (^sureBlock)(NSInteger);

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray *)buttons;
@end

NS_ASSUME_NONNULL_END
