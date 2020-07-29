//
//  AttributionPickSideBar.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^AttributionPickSideBarBlock)(NSInteger index);

@interface AttributionPickSideBar : UIView

@property (nonatomic, copy)AttributionPickSideBarBlock  didSelectBlock;

- (instancetype)initWithFrame:(CGRect)frame dataArr:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
