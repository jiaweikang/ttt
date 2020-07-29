//
//  MyStoreGroupThreeCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupThreeCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleModulesDataToAction.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "US_GoodsSourceBannerView.h"

@interface MyStoreGroupThreeCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView * mScrollView;
@end

@implementation MyStoreGroupThreeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.mScrollView];
        self.mScrollView.sd_layout.topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(0);
        [self setupAutoHeightWithBottomView:self.mScrollView bottomMargin:KScreenScale(20)];
    }
    return self;
}

- (void)setModel:(US_MystoreCellModel *)model{
    _model=model;
    NSMutableArray *imgsArray=[NSMutableArray array];
    for (HomeBtnItem *item in model.indexInfo) {
        [imgsArray addObject:item.imgUrl];
    }
    [self.mScrollView setImageURLStringsGroup:imgsArray];
    self.mScrollView.sd_layout.heightIs(model.height);
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    HomeBtnItem * item=[self.model.indexInfo objectAt:index];
    UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
    if ([NSString isNullToString:item.log_title].length>0) {
        [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
    }
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

-(Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    return [US_GoodsSourceBannerCell class];
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


@end
