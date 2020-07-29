//
//  US_GoodsSourceNewsFlashView.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/14.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceNewsFlashView.h"
#import "BBCyclingLabel.h"
#import <UIView+SDAutoLayout.h>
#import "FeatureModel_HomeBanner.h"
#import "UleModulesDataToAction.h"
#import "USGoodsPreviewManager.h"

@implementation US_GoodsSourceNewsFlashModel
@end

@interface US_GoodsSourceNewsFlashView ()
@property (nonatomic, strong) UIView    *mBgView;
@property (nonatomic, strong) UIImageView   *leftImgView;
@property (nonatomic, strong) BBCyclingLabel    *mContentLabel;
@property (nonatomic, strong) UIImageView   *rightImgView;
@property (nonatomic, strong) US_GoodsSourceNewsFlashModel  *mModel;
@property (nonatomic, strong) NSTimer        *mTimer;
@property (nonatomic, assign) int    currentIndex;
@property (nonatomic, copy) NSString    *currentIosAction;
@property (nonatomic, copy) NSString    *currentListId;
@property (nonatomic, copy) NSString    *currentLogTitle;
@end

@implementation US_GoodsSourceNewsFlashView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self addSubview:self.mBgView];
    [self.mBgView sd_addSubviews:@[self.leftImgView,self.mContentLabel,self.rightImgView]];
    self.mBgView.sd_layout.topSpaceToView(self, KScreenScale(10))
    .leftSpaceToView(self, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(20))
    .bottomSpaceToView(self, 0);
    self.leftImgView.sd_layout.topSpaceToView(self.mBgView, 0)
    .bottomSpaceToView(self.mBgView, 0)
    .leftSpaceToView(self.mBgView, 10)
    .widthIs(45);
    self.rightImgView.sd_layout.centerYEqualToView(self.mBgView)
    .rightSpaceToView(self.mBgView, 10)
    .widthIs(5)
    .heightIs(9);
}

- (void)setModel:(US_GoodsSourceNewsFlashModel *)mModel{
    if ([self.mModel isEqual:mModel]) return;
    
    self.mModel=mModel;
    if (self.mModel.newsDataArr.count==1) {
        HomeBannerIndexInfo *itemModel=[self.mModel.newsDataArr firstObject];
        NSAttributedString *attributedStr=[[NSAttributedString alloc]initWithString:[NSString isNullToString:itemModel.title] attributes:@{NSForegroundColorAttributeName:[UIColor convertHexToRGB:@"333333"]}];
        [self.mContentLabel setText:attributedStr animated:NO];
        self.currentIosAction=[NSString isNullToString:itemModel.ios_action];
        self.currentListId=[NSString isNullToString:itemModel.listingId];
        self.currentLogTitle=[NSString isNullToString:itemModel.log_title];
    }else {
        self.currentIndex=0;
        [self addMTimer];
    }
}

-(void)addMTimer{
    if (!_mTimer) {
        _mTimer=[NSTimer timerWithTimeInterval:2.5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_mTimer forMode:NSRunLoopCommonModes];
        [_mTimer fire];
    }
}

- (void)timerAction{
    HomeBannerIndexInfo *itemModel=[self.mModel.newsDataArr objectAt:self.currentIndex];
    NSAttributedString *attributedStr=[[NSAttributedString alloc]initWithString:[NSString isNullToString:itemModel.title] attributes:@{NSForegroundColorAttributeName:[UIColor convertHexToRGB:@"333333"]}];
    [self.mContentLabel setText:attributedStr animated:YES];
    self.currentIosAction=[NSString isNullToString:itemModel.ios_action];
    self.currentListId=[NSString isNullToString:itemModel.listingId];
    self.currentLogTitle=[NSString isNullToString:itemModel.log_title];
    self.currentIndex++;
    if (self.currentIndex>=self.mModel.newsDataArr.count) {
        self.currentIndex=0;
    }
}

- (void)tapGesAction{
    //日志
    if (self.currentLogTitle.length>0) {
         [LogStatisticsManager shareInstance].srcid=self.currentLogTitle;
    }
    
    if (self.currentListId&&self.currentListId.length>0) {
        [[USGoodsPreviewManager sharedManager]pushToPreviewControllerWithListId:[NSString isNullToString:self.currentListId] andSearchKeyword:@"" andPreviewType:@"2" andHudVC:[UIViewController currentViewController]];
    }else if (self.currentIosAction.length>0) {
        UleUCiOSAction *commonAction=[UleModulesDataToAction resolveModulesActionStr:self.currentIosAction];
        [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
    }
}
#pragma mark - <getters>
- (UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]init];
        _mBgView.backgroundColor=[UIColor whiteColor];
        _mBgView.sd_cornerRadius=@(5);
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
        [_mBgView addGestureRecognizer:tapGes];
    }
    return _mBgView;
}
-(UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"homeNewsFlash_news"]];
    }
    return _leftImgView;
}
-(UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"homeNewsFlash_more"]];
    }
    return _rightImgView;
}
- (BBCyclingLabel *)mContentLabel{
    if (!_mContentLabel) {
        _mContentLabel=[[BBCyclingLabel alloc]initWithFrame:CGRectMake(60, 0, __MainScreen_Width-2*KScreenScale(20)-80, 30) andTransitionType:BBCyclingLabelTransitionEffectScrollUp];
        _mContentLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _mContentLabel.font=[UIFont systemFontOfSize:11];
        _mContentLabel.numberOfLines=1;
        //        _mContentView.lineBreakMode=NSLineBreakByTruncatingMiddle;
        //        _mContentView.adjustsFontSizeToFitWidth=YES;
        _mContentLabel.clipsToBounds=YES;
    }
    return _mContentLabel;
}
@end
