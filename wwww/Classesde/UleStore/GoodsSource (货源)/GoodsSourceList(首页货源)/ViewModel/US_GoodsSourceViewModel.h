//
//  US_GoodsSourceViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"
#import "US_GoodsSectionModel.h"
#import "US_GoodsCatergoryListData.h"
#import "UserDefaultManager.h"
#import "UleCustemNavigationBar.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^US_HomeGifRefreshCallBack)(NSData * __nullable refreshData, NSData * __nullable gifData);

@interface US_GoodsSourceViewModel : UleBaseViewModel
//@property (nonatomic, strong) UleCustemNavigationBar * uleCustemNavigationBar;
@property (nonatomic, strong) US_HomeGifRefreshCallBack gifRefreshUpdate;
@property (nonatomic, strong) NSMutableArray<US_GoodsSectionModel *> * modulesArray;
@property (nonatomic, strong) NSMutableArray * scrollBarArray;//滚动条
@property (nonatomic, copy) NSString       * bannerBgViewUrlStr;//
//@property (nonatomic, copy) void (^collectionViewScrollBlock)(CGFloat offsetY) ;

- (void)handleCatergoryListData:(US_GoodsCatergoryListData *)catergoryList refreshData:(BOOL)refresh;

- (void)fetchCatergoryBannerDicInfo:(NSDictionary *)dic bannerKey:(NSString *)bannerKey;

- (void)fetchHomeRecommendDicInfor:(NSDictionary *)dic;

- (void)fetchHomeYouliaoDicInfo:(NSDictionary *)dic;

- (void)fetchHomeStoreyDicInfo:(NSDictionary *)dic;

- (void)fetchHomeScrollBarDicInfo:(NSDictionary *)dic;

- (void)fetchHomeBottomRecommendDicInfo:(NSDictionary *)dic;

- (void)fetchSelfRecommendGoodsDicInfo:(NSDictionary *)dic;

- (void)structureCellModelsIsHomeRecommend:(BOOL)isSelf;

- (void)fetchHomeGIFRefreshDicInfo:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
