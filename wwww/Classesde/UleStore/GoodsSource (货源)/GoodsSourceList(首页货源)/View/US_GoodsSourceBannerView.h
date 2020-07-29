//
//  US_GoodsSourceBannerView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_HomeBtnData.h"
#import "FeatureModel_HomeRecommend.h"
#import "FeatureModel_HomeBanner.h"
#import "UleSectionBaseModel.h"
#import <SDCollectionViewCell.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, USGoodsSourceBannerType) {
    USGoodsSourceBannerTypeHomeBanner,
    USGoodsSourceBannerTypeGoodsList
};

@interface US_GoodsSourceBannerViewModel : NSObject
@property (nonatomic, copy) NSString * imegUrl;
@property (nonatomic, copy) NSString * ios_action;
@property (nonatomic, copy) NSString * _id;
@property (nonatomic, copy) NSString * log_title;
@property (nonatomic, copy) NSString * moduleId;
@property (nonatomic, assign) BOOL needUpdate;//标记是否需要重新刷新

- (instancetype)initWithHomeItemData:(NewHomeRecommendData *)recommend;

- (instancetype)initWithCategoryBannerData:(HomeBannerIndexInfo *)bannnerData;
@end

@interface US_GoodsSourceBannerSectionModel : NSObject
@property (nonatomic, strong) NSMutableArray<US_GoodsSourceBannerViewModel *> * bannerImageModels;
@property (nonatomic, copy) NSString    *backgroundImageUrlStr;
@property (nonatomic, assign)USGoodsSourceBannerType    currentViewType;
@end

@interface US_GoodsSourceBannerCell : SDCollectionViewCell

@end

@interface US_GoodsSourceBannerView : UICollectionReusableView

@property (nonatomic, strong) US_GoodsSourceBannerSectionModel * model;

@end

NS_ASSUME_NONNULL_END
