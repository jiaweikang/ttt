//
//  LoginGuideView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "LoginGuideView.h"
#import "USPageControl.h"
#import "DeviceInfoHelper.h"

@interface LoginGuideView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *mScrollView;
@property (nonatomic, strong) USPageControl *pageControl;

@end

@implementation LoginGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.mScrollView];
    [self addSubview:self.pageControl];
#warning 182 审核  去除两张引导图  原代码i < 4
    for (int i = 0; i < 2; i++) {
        CGFloat imageW = CGRectGetWidth(self.mScrollView.frame);
        CGFloat imageH = CGRectGetHeight(self.mScrollView.frame);
        CGFloat imageX = i * CGRectGetWidth(self.mScrollView.frame);
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(imageX, 0, imageW, imageH)];
        #warning 182 审核  去除两张引导图
        if (i == 1) {
            i += 1;
        }
        NSString *imgNameStr;
        switch ([DeviceInfoHelper currentResolution]) {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
                imgNameStr=[NSString stringWithFormat:@"guide_%@_1242x2208",@(i)];
                break;
            case 6:
            case 7:
            case 8:
                imgNameStr=[NSString stringWithFormat:@"guide_%@_1125x2436",@(i)];
                break;
            default:
                imgNameStr=[NSString stringWithFormat:@"guide_%@_1125x2436",@(i)];
                break;
        }
        [imgView setImage:[UIImage bundleImageNamed:imgNameStr]];
        [self.mScrollView addSubview:imgView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.contentOffset_x = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.pageControl.lastContentOffset_x = scrollView.contentOffset.x;
}
#pragma mark - getter
-(UIScrollView *)mScrollView
{
    if (!_mScrollView) {
        _mScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _mScrollView.backgroundColor=[UIColor clearColor];
        #warning 182 审核  去除两张引导图
        _mScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 2, CGRectGetHeight(self.frame));
//        _mScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * 4, CGRectGetHeight(self.frame));
        _mScrollView.pagingEnabled = YES;
        _mScrollView.bounces = NO;
        _mScrollView.showsHorizontalScrollIndicator = NO;
        _mScrollView.delegate = self;
    }
    return _mScrollView;
}

-(USPageControl *)pageControl
{
    if (!_pageControl) {
        CGFloat width = 4*25;
        self.pageControl = [[USPageControl alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - width)/2, CGRectGetHeight(self.frame) - KScreenScale(230), width, 30)];
        #warning 182 审核  去除两张引导图
        self.pageControl.numberOfPages = 2;
//        self.pageControl.numberOfPages = 4;
        self.pageControl.bindingScrollView = _mScrollView;
        self.pageControl.selectedColor = kCommonRedColor;
        self.pageControl.unSelectedColor = [UIColor convertHexToRGB:@"f9b1b0"];
        self.pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

@end
