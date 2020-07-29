//
//  US_SegmentBarView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/1.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_SegmentBarView : UIView

@property (nonatomic, strong) UIScrollView * obserScrollView;

- (instancetype)initWithItmes:(NSArray *)items obserScrollView:(UIScrollView *)scrollView;


- (instancetype)initWithItmes:(NSArray *)items obserScrollView:(UIScrollView *)scrollView currentPage:(NSInteger) currentPage;

- (void)segmentSelectAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
