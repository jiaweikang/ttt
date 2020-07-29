//
//  US_GoodsSourceBannerView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceBannerView.h"
#import <UIView+SDAutoLayout.h>
#import <SDCycleScrollView.h>
#import "UleControlView.h"
#import "UleModulesDataToAction.h"
#import <UMAnalytics/MobClick.h>

@implementation US_GoodsSourceBannerViewModel

- (instancetype) initWithHomeItemData:(NewHomeRecommendData *)recommend{
    self = [super init];
    if (self) {
        NSString * imgeUrl=@"";
        if (recommend.imgUrl.length > 0) {
            imgeUrl=recommend.imgUrl;
        }else if (recommend.customImgUrl.length>0){
            imgeUrl=recommend.customImgUrl;
        }
        self.needUpdate=YES;
        self.imegUrl=imgeUrl;
        self.ios_action=recommend.ios_action;
        self._id=recommend.ID;
        self.log_title=recommend.log_title;
    }
    return self;
}

- (instancetype)initWithCategoryBannerData:(HomeBannerIndexInfo *)bannnerData{
    self = [super init];
    if (self) {
        NSString * imgeUrl=@"";
        if (bannnerData.imgUrl.length > 0) {
            imgeUrl=bannnerData.imgUrl;
        }
        self.needUpdate=YES;
        self.imegUrl=imgeUrl;
        self.ios_action=bannnerData.ios_action;
        self._id=bannnerData._id;
        self.log_title=bannnerData.log_title;
    }
    return self;
}

@end

@implementation US_GoodsSourceBannerSectionModel

- (NSMutableArray<US_GoodsSourceBannerViewModel *> *)bannerImageModels{
    if (!_bannerImageModels) {
        _bannerImageModels=[NSMutableArray array];
    }
    return _bannerImageModels;
}

@end

@implementation US_GoodsSourceBannerCell

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!self.onlyDisplayText) {
        self.imageView.frame=CGRectMake(KScreenScale(20), 0, self.imageView.frame.size.width-KScreenScale(40), self.imageView.frame.size.height);
        self.imageView.layer.masksToBounds=YES;
        self.imageView.layer.cornerRadius=10;
    }
}

@end

@interface US_GoodsSourceBannerView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) YYAnimatedImageView   *backgroundImgView;
@property (nonatomic, strong) SDCycleScrollView * mScrollView;
@end

@implementation US_GoodsSourceBannerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview:self.backgroundImgView];
        [self addSubview:self.mScrollView];
        self.backgroundImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.mScrollView.sd_layout.leftSpaceToView(self, 0)
        .topSpaceToView(self, KScreenScale(10))
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0);
    }
    return self;
}

- (void)setModel:(US_GoodsSourceBannerSectionModel *)model{
    if (_model==model) {
        return;
    }
    _model=model;
    if (model.currentViewType==USGoodsSourceBannerTypeHomeBanner) {
        self.mScrollView.sd_layout.topSpaceToView(self, KScreenScale(10));
        if ([NSString isNullToString:model.backgroundImageUrlStr].length>0) {
            [self.backgroundImgView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:model.backgroundImageUrlStr]] placeholder:[UIImage bundleImageNamed:@"homeBanner_bg_default"]];
        }else [self.backgroundImgView setImage:[UIImage bundleImageNamed:@"homeBanner_bg_default"]];
    }else if (model.currentViewType==USGoodsSourceBannerTypeGoodsList) {
        self.mScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    if (model.bannerImageModels.count>0) {
        NSMutableArray *imgUrls=[NSMutableArray array];
        for (US_GoodsSourceBannerViewModel * listItem in model.bannerImageModels) {
            [imgUrls addObject:listItem.imegUrl];
            listItem.needUpdate=NO;
        }
        [self.mScrollView setImageURLStringsGroup:imgUrls];
    }
}


/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    US_GoodsSourceBannerViewModel * seletItem=self.model.bannerImageModels[index];
    [MobClick event:@"homeBanner_click" attributes:@{@"ID":[NSString stringWithFormat:@"%@", seletItem._id]}];
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", seletItem._id] moduleid:NonEmpty(seletItem.moduleId) moduledesc:seletItem.log_title networkdetail:@""];
    UleUCiOSAction *action=[UleModulesDataToAction resolveModulesActionStr:seletItem.ios_action];
    NSString * linkurl=action.mParams[@"key"];
    NSString * urle=@"";
    if ([linkurl containsString:@"?"]) {
        urle=[NSString stringWithFormat:@"%@&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }else{
        urle=[NSString stringWithFormat:@"%@?&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }
    [action.mParams setObject:urle forKey:@"key"];
    if (seletItem.log_title>0) {
        [LogStatisticsManager shareInstance].srcid=seletItem.log_title;
    }
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

-(Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    if (self.model.currentViewType==USGoodsSourceBannerTypeHomeBanner) {
        return [US_GoodsSourceBannerCell class];
    }else if (self.model.currentViewType==USGoodsSourceBannerTypeGoodsList) {
        return [SDCollectionViewCell class];
    }
    return [SDCollectionViewCell class];
}

#pragma mark - <setter and getter>
- (SDCycleScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _mScrollView.backgroundColor=[UIColor clearColor];
        _mScrollView.autoScrollTimeInterval=3.0;
        _mScrollView.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
        _mScrollView.currentPageDotImage=[UIImage bundleImageNamed:@"goods_icon_page_select"];
        _mScrollView.pageDotImage=[UIImage bundleImageNamed:@"goods_icon_page_normal"];
    }
    return _mScrollView;
}
- (YYAnimatedImageView *)backgroundImgView{
    if (!_backgroundImgView) {
        _backgroundImgView=[YYAnimatedImageView new];
    }
    return _backgroundImgView;
}

@end
