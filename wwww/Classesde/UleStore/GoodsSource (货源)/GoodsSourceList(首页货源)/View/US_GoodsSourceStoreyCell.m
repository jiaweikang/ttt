//
//  US_GoodsSourceStoreyCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/8/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceStoreyCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_GoodsCellModel.h"
#import <SDWebImage/SDWebImage.h>
#import "UleControlView.h"
#import "UleModulesDataToAction.h"
//#import <SMPageControl/SMPageControl.h>
#import "USLinePageControl.h"

@interface US_GoodsSourceStoreyCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView          *mScrollView;
@property (nonatomic, strong) USLinePageControl         *pageControl;
@property (nonatomic, strong) YYAnimatedImageView   *backGroundImgView;
@property (nonatomic, strong) US_GoodsCellModel     *mModel;
@property (nonatomic, strong) NSMutableArray        *mBtnsArray;
@end
@implementation US_GoodsSourceStoreyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
//        self.contentView.backgroundColor=[UIColor whiteColor];
        [self.contentView sd_addSubviews:@[self.backGroundImgView,self.mScrollView,self.pageControl]];
        self.backGroundImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.mScrollView.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(2*KScreenScale(136)+KScreenScale(26));
        self.pageControl.sd_layout.leftSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, KScreenScale(10))
        .rightSpaceToView(self.contentView, 0)
        .heightIs(KScreenScale(30));
    }
    return self;
}

- (void)setModel:(US_GoodsCellModel *)model{
    if (self.mModel==model) {
        return;
    }
    for (UIView *view in self.mBtnsArray) {
        [view removeFromSuperview];
    }
    [self.mBtnsArray removeAllObjects];
    self.mModel=model;
    NSInteger totalCount=model.btnsArray.count;
    NSInteger singleLineCount=totalCount<5?totalCount:5;
    CGFloat scrollViewHeight=KScreenScale(136)*2+KScreenScale(26);
    if (totalCount<=5) {
        scrollViewHeight=KScreenScale(136);
        self.mScrollView.sd_layout.heightIs(scrollViewHeight);
    }
    
    CGFloat  btnWidth=__MainScreen_Width/singleLineCount;
    CGFloat  btnHeight=KScreenScale(136);
    for (int i=0;i<model.btnsArray.count;i++) {
        HomeBannerIndexInfo *item=[model.btnsArray objectAt:i];
        if (i==0&&[NSString isNullToString:item.background_url_new].length>0) {
            [self.backGroundImgView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:item.background_url_new]] placeholder:nil];
        }
        UleControlView * btn=[[UleControlView alloc] initWithFrame:CGRectMake((i%singleLineCount)*btnWidth+(i/10)*__MainScreen_Width,((i%10)/singleLineCount)*btnHeight>0?((i%10)/singleLineCount)*(btnHeight+KScreenScale(26)):0, btnWidth, btnHeight)];
        [btn.mImageView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:item.imgUrl]] placeholder:nil];
        btn.mImageView.sd_layout.centerXEqualToView(btn)
        .topSpaceToView(btn, KScreenScale(10))
        .heightIs(KScreenScale(90)).widthIs(KScreenScale(90));
        btn.mTitleLabel.sd_layout.centerXEqualToView(btn)
        .bottomSpaceToView(btn, 0)
        .heightIs(KScreenScale(26)).maxWidthIs(btnWidth);
        btn.mTitleLabel.text=[NSString isNullToString:item.title];
        if ([NSString isNullToString:item.titlecolor]) {
            btn.mTitleLabel.textColor=[UIColor convertHexToRGB:[NSString isNullToString:item.titlecolor]];
        }else{
            btn.mTitleLabel.textColor=[UIColor blackColor];
        }
        btn.mTitleLabel.font=[UIFont systemFontOfSize:11];
        btn.mTitleLabel.adjustsFontSizeToFitWidth=YES;
        [btn.mTitleLabel setSingleLineAutoResizeWithMaxWidth:btnWidth];
        //气泡
        //计算字体宽度
//        NSString *bubbleStr=[NSString isNullToString:item.bubble_title];
//        if (bubbleStr.length>0) {
//            btn.mBubbleLabel.adjustsFontSizeToFitWidth=YES;
//            btn.mBubbleLabel.font=[UIFont systemFontOfSize:KScreenScale(20)>10?10:KScreenScale(20)];
//            btn.mBubbleLabel.text=bubbleStr;
//            if ([NSString isNullToString:item.bubble_backImg].length>0) {
//                [btn.mBubbleImageView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:item.bubble_backImg]] placeholder:nil];
//            }else {
//                [btn.mBubbleImageView setImage:[UIImage bundleImageNamed:@"goods_bubble_default"]];
//            }
//
//            CGFloat bubbleWidth=[bubbleStr widthForFont:btn.mBubbleLabel.font];
//            CGFloat maxBubbleWidth=btnWidth*0.5+KScreenScale(55)-KScreenScale(20);
//            bubbleWidth=bubbleWidth>maxBubbleWidth?maxBubbleWidth:bubbleWidth;
//            btn.mBubbleImageView.sd_layout.bottomSpaceToView(btn.mImageView, -KScreenScale(24))
//            .rightSpaceToView(btn.mImageView, -KScreenScale(100))
//            .heightIs(KScreenScale(42))
//            .widthIs(bubbleWidth+KScreenScale(20));
//            btn.mBubbleLabel.sd_layout.topSpaceToView(btn.mBubbleImageView, KScreenScale(7))
//            .centerXEqualToView(btn.mBubbleImageView)
//            .widthIs(bubbleWidth)
//            .heightIs(KScreenScale(20));
//            if ([NSString isNullToString:item.bubble_titleColor].length>0) {
//                btn.mBubbleLabel.textColor=[UIColor convertHexToRGB:[NSString isNullToString:item.bubble_titleColor]];
//            }
//        }
        [btn addTouchTarget:self action:@selector(btnClick:)];
        btn.tag=2000+i;
        [self.mScrollView addSubview:btn];
        [self.mBtnsArray addObject:btn];
    }
    self.mScrollView.contentSize=CGSizeMake(__MainScreen_Width*((totalCount-1)/10+1), scrollViewHeight);
    [self.mScrollView updateLayout];
    [self.mScrollView setContentOffset:CGPointMake(model.currentOffsetX, self.mScrollView.contentOffset.y)];
    self.pageControl.numberOfPages=(totalCount-1)/10+1;
    self.pageControl.scrollView=self.mScrollView;
    self.pageControl.currentPage=model.currentOffsetX/__MainScreen_Width;
    self.pageControl.hidden=self.pageControl.numberOfPages<2;
}

- (void)btnClick:(UIButton *)sender{
    NSInteger indexNum=sender.tag-2000;
    HomeBannerIndexInfo *item=[self.mModel.btnsArray objectAt:indexNum];
    if ([NSString isNullToString:item.ios_action].length>0) {
        NSString *iosAction=[NSString isNullToString:item.ios_action];
        if ([iosAction containsString:@"TABSELECT"]&&![iosAction containsString:@"http"]) {
            NSString *selectPage=@"1";
            NSArray *keyValueArray=[iosAction componentsSeparatedByString:@"::"];
            if (keyValueArray.count>1) {
                selectPage=[keyValueArray objectAt:1];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HomeStoreyAction object:nil userInfo:@{@"selectPageNum":selectPage}];
        }else {
            UleUCiOSAction *commonAction=[UleModulesDataToAction resolveModulesActionStr:[NSString isNullToString:item.ios_action]];
            [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
        }
    }
    if ([NSString isNullToString:item.log_title].length>0) {
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"ustore_home_storey" moduledesc:[NSString isNullToString:item.log_title] networkdetail:@""];
    }
}

#pragma mark - <srollview Delegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.mModel.currentOffsetX=scrollView.contentOffset.x;
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.pageControl.currentPage = currentPage;
}

#pragma mark - getters
- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView=[[UIScrollView alloc]initWithFrame:CGRectZero];
        _mScrollView.backgroundColor=[UIColor clearColor];
        _mScrollView.pagingEnabled=YES;
        _mScrollView.delegate=self;
        _mScrollView.showsHorizontalScrollIndicator=NO;
    }
    return _mScrollView;
}

-(USLinePageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[USLinePageControl alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(30)) indicatorMargin:5.0 indicatorWidth:3.0 currentIndicatorWidth:15.0 indicatorHeight:3.0];
        _pageControl.pageIndicatorColor=[UIColor convertHexToRGB:@"E6E6E6"];
        _pageControl.currentPageIndicatorColor=[UIColor convertHexToRGB:@"EC3D3F"];
    }
    return _pageControl;
}

- (YYAnimatedImageView *)backGroundImgView{
    if (!_backGroundImgView) {
        _backGroundImgView=[[YYAnimatedImageView alloc]init];
        _backGroundImgView.userInteractionEnabled=YES;
        _backGroundImgView.contentMode=UIViewContentModeScaleToFill;
    }
    return _backGroundImgView;
}
- (NSMutableArray *)mBtnsArray{
    if (!_mBtnsArray) {
        _mBtnsArray=[NSMutableArray array];
    }
    return _mBtnsArray;
}
@end


@interface US_GoodsSourceStoreyCell1 ()
@property (nonatomic, strong) YYAnimatedImageView   *mImageView;
@property (nonatomic, strong) US_GoodsCellModel *mModel;
@end
@implementation US_GoodsSourceStoreyCell1

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor=[UIColor whiteColor];
    [self.contentView sd_addSubviews:@[self.mImageView]];
    self.mImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setModel:(US_GoodsCellModel *)model{
    self.mModel=model;
    [self.mImageView yy_setImageWithURL:[NSURL URLWithString:model.imgeUrl] placeholder:nil];
}

- (void)tapGesAction{
    if (self.mModel.iosActionStr.length>0) {
        if ([self.mModel.iosActionStr containsString:@"TABSELECT"]&&![self.mModel.iosActionStr containsString:@"http"]) {
            NSString *selectPage=@"1";
            NSArray *keyValueArray=[self.mModel.iosActionStr componentsSeparatedByString:@"::"];
            if (keyValueArray.count>1) {
                selectPage=[keyValueArray objectAt:1];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_HomeStoreyAction object:nil userInfo:@{@"selectPageNum":selectPage}];
        }else {
            UleUCiOSAction *commonAction=[UleModulesDataToAction resolveModulesActionStr:self.mModel.iosActionStr];
            [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
        }
    }
    if (self.mModel.log_title.length>0) {
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"ustore_home_storey" moduledesc:[NSString isNullToString:self.mModel.log_title] networkdetail:@""];
    }
}

- (YYAnimatedImageView *)mImageView{
    if (!_mImageView) {
        _mImageView=[[YYAnimatedImageView alloc]init];
        _mImageView.userInteractionEnabled=YES;
        _mImageView.contentMode=UIViewContentModeScaleToFill;
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
        [_mImageView addGestureRecognizer:tapGes];
    }
    return _mImageView;
}

@end
