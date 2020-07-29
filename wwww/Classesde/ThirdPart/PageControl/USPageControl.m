//
//  USPageControl.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "USPageControl.h"
#import "USCircleLayer.h"

@interface USPageControl ()
@property (nonatomic, strong) USCircleLayer *circleLayer;
@end

@implementation USPageControl

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.lineLayer = [USLineLayer layer];
        self.lineLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
        self.lineLayer.bindingScrollView = self.bindingScrollView;
        [self.layer addSublayer:self.lineLayer];
        
        self.circleLayer = [USCircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    
    if (_currentPage != currentPage) {
        _currentPage = currentPage;
        self.lineLayer.currentPage = _currentPage;
        self.circleLayer.currentPage = _currentPage;
    }
}

- (void)setContentOffset_x:(CGFloat)contentOffset_x {
    
    if (_contentOffset_x != contentOffset_x) {
        _contentOffset_x = contentOffset_x;
        self.circleLayer.contentOffset_x = self.contentOffset_x;
        [self calculateProgress];
    }
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    
    _numberOfPages = numberOfPages;
    self.lineLayer.numberOfPages = _numberOfPages;
    self.circleLayer.numberOfPages = _numberOfPages;
}

- (void)setLastContentOffset_x:(CGFloat)lastContentOffset_x {
    
    _lastContentOffset_x = lastContentOffset_x;
    self.circleLayer.lastContentOffset_x = _lastContentOffset_x;
}

- (void)calculateProgress {
    
    CGFloat pageWidth = self.bindingScrollView.frame.size.width;
    int currentPage = floor((self.contentOffset_x - pageWidth * .5) / pageWidth) + 2;
    self.currentPage = currentPage;
}

- (void)setBindingScrollView:(UIScrollView *)bindingScrollView {
    
    _bindingScrollView = bindingScrollView;
    self.circleLayer.bindingScrollViewWidth = _bindingScrollView.frame.size.width;
    self.circleLayer.contentOffset_x = 0;
    
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    
    _selectedColor = selectedColor;
    self.circleLayer.selectedColor = _selectedColor;
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    
    _unSelectedColor = unSelectedColor;
    self.lineLayer.unSelectedColor = unSelectedColor;
}

@end

