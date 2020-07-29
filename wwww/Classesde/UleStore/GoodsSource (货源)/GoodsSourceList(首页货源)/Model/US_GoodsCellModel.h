//
//  US_GoodsCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/7.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "US_HomeBtnData.h"
#import "FeatureModel_HomeRecommend.h"
#import "FeatureModel_HomeBanner.h"
#import "FeatureModel_UleHome.h"
#import "US_GoodsCatergoryListData.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsCellModel : UleCellBaseModel
@property (nonatomic, strong) HomeBtnItem * item;
@property (nonatomic, assign) CGFloat minLinSpace;
@property (nonatomic, assign) CGFloat minItemSpace;
@property (nonatomic, assign) CGFloat minCellOffset;
@property (nonatomic, copy) NSString * iconImage;
@property (nonatomic, copy) NSString * imgeUrl;
@property (nonatomic, copy) NSString * listingId;
@property (nonatomic, copy) NSString * minPrice;
@property (nonatomic, copy) NSString * maxPrice;
@property (nonatomic, copy) NSString * commission;
@property (nonatomic, copy) NSString * listingName;
@property (nonatomic, copy) NSString * totalSold;
@property (nonatomic, assign) CGFloat commsisionWidth;//提前计算收益控件大小
@property (nonatomic, assign) BOOL      isSharedToday;//是否展示“已推广”
//积分商品
@property (nonatomic, assign) BOOL  isJifen;
@property (nonatomic, copy) NSString * jifenPrice;
@property (nonatomic, copy) NSString * jifenTitle;
//分享相关（）
@property (nonatomic, copy) NSString * logPageName;
@property (nonatomic, copy) NSString * logShareFrom;
@property (nonatomic, copy) NSString * shareFrom;
@property (nonatomic, copy) NSString * shareChannel;
//新增cs后台模块
@property (nonatomic, strong)NSMutableArray *btnsArray;
@property (nonatomic, copy) NSString * iosActionStr;
@property (nonatomic, copy) NSString * log_title;
@property (nonatomic, assign)CGFloat    currentOffsetX;//复用时跟着滚动问题
//底部推荐商品
@property (nonatomic, strong)NewHomeRecommendData   *bottomBannerModel;
//groupSort 不同的sort要换行显示
@property (nonatomic, copy) NSString * sortId;

//- (instancetype)initWithItem:(HomeBtnItem *)item;

- (instancetype)initWithRecommendItem:(NewHomeRecommendData *)item;

- (instancetype)initWithHomeBannerIndexInfo:(HomeBannerIndexInfo *)item;

- (instancetype)initWithYouLiaoItem:(UleIndexInfo *)item;

- (instancetype)initWithSecureDataItem:(NewHomeRecommendData *)item;

- (instancetype)initWithHomeCategoryListItem:(US_GoodsCatergoryListItem *)item;

- (instancetype)initWithStoreyBtns:(NSMutableArray *)array;

- (instancetype)initWithStoreyListItem:(HomeBannerIndexInfo *)item widthRatio:(CGFloat)ratio;

- (instancetype)initWithHomeBottomRecommend:(NSMutableArray *)array;

- (BOOL)saveSharedTodayByListID:(NSString *)listId;

- (CGFloat) calculateWidthWithColumn:(NSInteger)column;

@end

NS_ASSUME_NONNULL_END
