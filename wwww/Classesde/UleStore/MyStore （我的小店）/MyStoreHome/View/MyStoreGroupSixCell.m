//
//  MyStoreGroupSixCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupSixCell.h"
#import "UIView+Shade.h"
#import <UIView+SDAutoLayout.h>
#import "USLinePageControl.h"
#import "US_MystoreCellModel.h"
#import "UleControlView.h"
#import "UleModulesDataToAction.h"
#import "USInviteShareManager.h"

static NSInteger const PageControlTag = 20000;
@interface MyStoreGroupSixCell ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIView     *mBgView;
@property (nonatomic, strong)UIScrollView   *mScrollView;
@property (nonatomic, strong) USLinePageControl   *pageControl;
@property (nonatomic, strong)US_MystoreCellModel    *mModel;

@end

@implementation MyStoreGroupSixCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    [self.contentView sd_addSubviews:@[self.mBgView]];
    [self.mBgView sd_addSubviews:@[self.mScrollView,self.pageControl]];
    self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(KScreenScale(260));
    self.mScrollView.sd_layout.topSpaceToView(self.mBgView, 0)
    .leftSpaceToView(self.mBgView, 0)
    .rightSpaceToView(self.mBgView, 0)
    .heightIs(KScreenScale(230));
    self.pageControl.sd_layout.topSpaceToView(self.mScrollView, 0)
    .leftSpaceToView(self.mBgView, 0)
    .rightSpaceToView(self.mBgView, 0)
    .heightIs(KScreenScale(30));
//    [self setupAutoHeightWithBottomViewsArray:@[self.mScrollView,self.pageControl] bottomMargin:0];
    [self setupAutoHeightWithBottomView:self.mBgView bottomMargin:0];
}

- (void)setModel:(US_MystoreCellModel*)model{
    if ([self.mModel isEqual:model]) return;
    self.mModel=model;
    for (UIView *subview in self.mScrollView.subviews) {
        if (subview.tag!=PageControlTag) {
            [subview removeFromSuperview];
        }
    }
    NSInteger totalCount=model.indexInfo.count;
    CGFloat btnWidth=(__MainScreen_Width-KScreenScale(40))/(model.indexInfo.count>4?4:model.indexInfo.count);
    for (int i=0; i<model.indexInfo.count; i++) {
        HomeBtnItem *itemModel=model.indexInfo[i];
        UleControlView *btn=[[UleControlView alloc]init];
        btn.frame=CGRectMake(i*btnWidth, 0, btnWidth, KScreenScale(230));
        btn.mTitleLabel.font=[UIFont systemFontOfSize:13];
        btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        btn.mImageView.sd_layout.topSpaceToView(btn, KScreenScale(50))
        .centerXEqualToView(btn)
        .widthIs(KScreenScale(80))
        .heightIs(KScreenScale(80));
        btn.mTitleLabel.sd_layout.topSpaceToView(btn.mImageView, KScreenScale(30))
        .centerXEqualToView(btn)
        .heightIs(KScreenScale(KScreenScale(25)))
        .widthRatioToView(btn, 1.0);
        [btn addTouchTarget:self action:@selector(btnClick:)];
        btn.tag=10000+i;
        [self.mScrollView addSubview:btn];
        btn.mTitleLabel.text=[NSString isNullToString:itemModel.title];
        [btn.mImageView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:itemModel.imgUrl]] placeholder:nil];
        if ([NSString isNullToString:itemModel.titlecolor].length>0) {
            btn.mTitleLabel.textColor=[UIColor convertHexToRGB:[NSString isNullToString:itemModel.titlecolor]];
        }
    }
    NSInteger totalPage=(totalCount-1)/4+1;
    self.mScrollView.contentSize=CGSizeMake(KScreenScale(710)*totalPage, 0);
    [self.mScrollView setContentOffset:CGPointMake(model.currentOffsetX, self.mScrollView.contentOffset.y)];
    self.pageControl.numberOfPages=(totalCount-1)/4+1;
    self.pageControl.scrollView=self.mScrollView;
    self.pageControl.currentPage=model.currentOffsetX/KScreenScale(710);
    self.pageControl.hidden=self.pageControl.numberOfPages<2;
    if (self.pageControl.hidden) {
        self.mBgView.sd_layout.heightIs(KScreenScale(230));
    }
}

- (void)btnClick:(UleControlView*)sender{
    NSInteger tag=sender.tag-10000;
    if (self.mModel.indexInfo&&self.mModel.indexInfo.count>tag) {
        HomeBtnItem * item=self.mModel.indexInfo[tag];
        //日志
        if ([NSString isNullToString:item.log_title].length>0) {
            [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
        }
        
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
        if ([action.mViewControllerName isEqualToString:@"InviteOpenStore"]) {
            [[USInviteShareManager sharedManager] inviteShareToOpenStore];
        }else{
            [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        }
    }
}
#pragma mark - <scrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.mModel.currentOffsetX=scrollView.contentOffset.x;
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - <getters>
-(UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenScale(710), KScreenScale(260))];
        _mBgView.backgroundColor=[UIColor whiteColor];
        _mBgView.userInteractionEnabled=YES;
        _mBgView.layer.masksToBounds=YES;
        _mBgView.layer.mask=[UIView drawCornerRadiusWithRect:_mBgView.bounds corners:UIRectCornerBottomLeft|UIRectCornerBottomRight size:CGSizeMake(5, 5)];
    }
    return _mBgView;
}
- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView=[[UIScrollView alloc]init];
        _mScrollView.backgroundColor=[UIColor clearColor];
        _mScrollView.pagingEnabled=YES;
        _mScrollView.delegate=self;
        _mScrollView.showsHorizontalScrollIndicator=NO;
    }
    return _mScrollView;
}
-(USLinePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[USLinePageControl alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width-KScreenScale(40), KScreenScale(30)) indicatorMargin:5.0 indicatorWidth:3.0 currentIndicatorWidth:15.0 indicatorHeight:3.0];
        _pageControl.pageIndicatorColor=[UIColor convertHexToRGB:@"E6E6E6"];
        _pageControl.currentPageIndicatorColor=[UIColor convertHexToRGB:@"EC3D3F"];
        _pageControl.tag=PageControlTag;
    }
    return _pageControl;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
