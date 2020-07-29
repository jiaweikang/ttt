//
//  MyStoreGroupOneCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupOneCell.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>
#import "UleModulesDataToAction.h"
#import "USLinePageControl.h"
#import "USInviteShareManager.h"
#import "UIView+Shade.h"

#define kGroupOneImageHeight KScreenScale(80)
static CGFloat const kGroupOneTitelHeight = 20;
static CGFloat const kGroupOneMargin = 10;

#define kCellHeight kGroupOneImageHeight+kGroupOneTitelHeight+kGroupOneMargin

@interface MyStoreGroupOneCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView        * mBgView;
@property (nonatomic, strong) UIScrollView  * mScrollView;
@property (nonatomic, strong) USLinePageControl         *pageControl;
@end

@implementation MyStoreGroupOneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        CGFloat  height=3*kGroupOneMargin+kGroupOneTitelHeight+kGroupOneImageHeight;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.mBgView];
        self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, KScreenScale(20))
        .rightSpaceToView(self.contentView, KScreenScale(20))
        .heightIs(2*(height+kGroupOneMargin));
        [self.contentView addSubview:self.mScrollView];
        self.mScrollView.sd_layout.leftSpaceToView(self.contentView, KScreenScale(20))
        .topSpaceToView(self.contentView, kGroupOneMargin)
        .rightSpaceToView(self.contentView, KScreenScale(20))
        .heightIs(2*height);
        
        [self.contentView addSubview:self.pageControl];
//        self.pageControl.sd_layout.topSpaceToView(self.mScrollView, kGroupOneMargin-KScreenScale(30))
//        .leftSpaceToView(self.contentView, KScreenScale(20))
//        .rightSpaceToView(self.contentView, KScreenScale(20))
//        .heightIs(KScreenScale(30));
        [self setupAutoHeightWithBottomView:self.mScrollView bottomMargin:kGroupOneMargin];
        
        //添加圆角
        CGRect bounds=CGRectMake(0, 0, KScreenScale(710), self.mScrollView.height_sd+kGroupOneMargin*2);
        self.mBgView.layer.mask=[UIView drawCornerRadiusWithRect:bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight size:CGSizeMake(5,5)];
    }
    return self;
}

- (void)layoutModuleViewWithList:(NSArray<HomeBtnItem*> *) listArray{
    for (UleControlView * btn in self.mScrollView.subviews) {
        [btn removeFromSuperview];
    }
    CGFloat  width=(__MainScreen_Width-KScreenScale(40))/4.0;
    CGFloat  height=3*kGroupOneMargin+kGroupOneTitelHeight+kGroupOneImageHeight;
    for (int i=0; i<listArray.count; i++) {
        HomeBtnItem * item=listArray[i];
        UleControlView * btn=[[UleControlView alloc] initWithFrame:CGRectMake((i%4)*width+(i/8)*(__MainScreen_Width-KScreenScale(40)),((i%8)/4)*height, width, height)];
        [btn.mImageView yy_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholder:nil];
        btn.mImageView.sd_layout.centerXEqualToView(btn)
        .topSpaceToView(btn, kGroupOneMargin)
        .heightIs(kGroupOneImageHeight).widthIs(kGroupOneImageHeight);
        btn.mTitleLabel.sd_layout.centerXEqualToView(btn)
        .topSpaceToView(btn.mImageView, kGroupOneMargin)
        .heightIs(kGroupOneTitelHeight).autoWidthRatio(1);
        btn.mTitleLabel.text=item.title;
        btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        btn.mTitleLabel.font=[UIFont systemFontOfSize:13];
        [btn.mTitleLabel setSingleLineAutoResizeWithMaxWidth:width];
        btn.backgroundColor=[UIColor whiteColor];
        [btn addTouchTarget:self action:@selector(btnClick:)];
        btn.tag=i;
        [self.mScrollView addSubview:btn];
    }
    self.mScrollView.sd_layout.heightIs(height*2);
    self.mScrollView.contentSize=CGSizeMake((__MainScreen_Width-KScreenScale(40))*((listArray.count-1)/8+1), height*2);
    [self.mScrollView updateLayout];
    self.pageControl.numberOfPages=(listArray.count-1)/8+1;
    self.pageControl.scrollView=self.mScrollView;
    self.pageControl.currentPage=self.model.currentOffsetX/(__MainScreen_Width-KScreenScale(40));
    self.pageControl.hidden=self.pageControl.numberOfPages<2;
}

- (void)btnClick:(UleControlView*)sender{
    NSInteger tag=sender.tag;
    if (self.model.indexInfo&&self.model.indexInfo.count>tag) {
        HomeBtnItem * item=self.model.indexInfo[sender.tag];        
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
        if ([NSString isNullToString:item.log_title].length>0) {
            [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
        }
        if ([action.mViewControllerName isEqualToString:@"InviteOpenStore"]) {
            [[USInviteShareManager sharedManager] inviteShareToOpenStore];
        }else{
            [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(US_MystoreCellModel *)model{
    _model=model;
    [self layoutModuleViewWithList:model.indexInfo];
}
#pragma mark - <srollview Delegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.model.currentOffsetX=scrollView.contentOffset.x;
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}
#pragma mark - <setter and getter>
- (UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]init];
        _mBgView.backgroundColor=[UIColor whiteColor];
    }
    return _mBgView;
}
- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _mScrollView.pagingEnabled=YES;
        _mScrollView.delegate=self;
        _mScrollView.showsHorizontalScrollIndicator=NO;
    }
    return _mScrollView;
}
-(USLinePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[USLinePageControl alloc]initWithFrame:CGRectMake(KScreenScale(20), 2*(4*kGroupOneMargin+kGroupOneTitelHeight+kGroupOneImageHeight)-KScreenScale(30), __MainScreen_Width-KScreenScale(40), KScreenScale(30)) indicatorMargin:5.0 indicatorWidth:3.0 currentIndicatorWidth:15.0 indicatorHeight:3.0];
        _pageControl.pageIndicatorColor=[UIColor convertHexToRGB:@"E6E6E6"];
        _pageControl.currentPageIndicatorColor=[UIColor convertHexToRGB:@"EC3D3F"];
    }
    return _pageControl;
}

@end
