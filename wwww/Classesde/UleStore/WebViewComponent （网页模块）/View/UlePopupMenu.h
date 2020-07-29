//
//  UlePopupMenu.h
//  UleNavgationBarPop
//
//  Created by uleczq on 2017/7/28.
//  Copyright © 2017年 uleczq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UlePopupMenuDelegate <NSObject>

- (void)didClickAtIndex:(NSInteger)index;

@end

@interface UlePopupMenu : UIView
@property (nonatomic, weak) id<UlePopupMenuDelegate> delegate;

+ (instancetype)showOnView:(UIView *)view titles:(NSArray *)titles icons:(NSArray *)icons delegate:(id<UlePopupMenuDelegate>)mdelegate;
@end
