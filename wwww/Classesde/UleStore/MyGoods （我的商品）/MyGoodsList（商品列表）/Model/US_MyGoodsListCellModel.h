//
//  US_MyGoodsListCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "US_MyGoodsRecommend.h"
#import "MyFavoritesLists.h"
#import "US_SearchGoodsSourceModel.h"
#import "WebFavoriteModel.h"
#import "US_MyGoodsListVC.h"

static NSString *const kPageName_MyGoods=@"我的商品";
static NSString *const kPageName_MyWholesaleGoods=@"我的分销商品";
static NSString *const kPageName_GoodsSearch=@"货源";

NS_ASSUME_NONNULL_BEGIN

@class US_EnterpriseRecommendList;
@class TakeSelfIndexInfo,EnterpriseWholeSaleList;
@interface US_MyGoodsListCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString * listId;
@property (nonatomic, copy) NSString * commission;
@property (nonatomic, copy) NSString * salePrice;
@property (nonatomic, copy) NSString * marketPrice;
@property (nonatomic, copy) NSString * listName;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * sellTotal;
@property (nonatomic, copy) NSString * addTime;
//分销商品
@property (nonatomic, assign)BOOL       isFenXiao;//是否分销商品
@property (nonatomic, assign)BOOL       isFenxiaoOutStock;//分销商品是否下架
@property (nonatomic, copy) NSString * zoneId;//专区id
@property (nonatomic, copy) NSString * packageSpec;//规格
//分享相关
@property (nonatomic, copy) NSString * logPageName;
@property (nonatomic, copy) NSString * logShareFrom;
@property (nonatomic, copy) NSString * shareFrom;
@property (nonatomic, copy) NSString * shareChannel;
@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * srcid;

@property (nonatomic, assign)BOOL hiddenAddBtn;//隐藏添加按钮
@property (nonatomic, assign)BOOL hiddenShareBtn;//隐藏分享按钮
//@property (nonatomic, strong) NSMutableAttributedString * listNameAttribute;
@property (nonatomic, strong) NSString * listingState;
@property (nonatomic, strong) NSString * instock;
@property (nonatomic, strong) NSString * synced;
@property (nonatomic, strong) NSString * groupbuyFlag;
@property (nonatomic, assign) BOOL showSalesPromotion;//是否显示促销标志
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isEditStatus;
@property (nonatomic, assign) BOOL isAdded;//是否是已经添加过的商品
@property (nonatomic, assign) BOOL isMyGoodsSearch;//是否是我的商品搜索列表
@property (nonatomic, assign) CGFloat commissionWidth;
@property (nonatomic, copy) NSString * commissionStr;//用于显示的收益
@property (nonatomic, copy) NSString * listingType;//商品类型 103为自有商品
//所在列表类型
@property (nonatomic, assign) US_MyGoodsListType    myGoodsListType;
@property (nonatomic, weak) id delegate;
//标签 20190807
@property (nonatomic, strong) NSMutableAttributedString    *listMarkAttribute;

- (instancetype)initWithRecommendData:(US_MyGoodsRecommendDetail *)recommend andCellName:(NSString *)cellName;

- (instancetype)initWithFavorites:(Favorites *) favorites andCellName:(NSString *)cellName;
//分销收藏列表
- (instancetype)initWithFenxiaoFavorites:(Favorites *)favorites andCellName:(NSString *)cellName;

- (instancetype)initWithEnterprise:(US_EnterpriseRecommendList *)enterRecommend andCellName:(NSString *)cellName;

- (instancetype)initWithSearchGoods:(RecommendModel *)recommend;

- (instancetype)initWithUleSyncWebFavorite:(WebFavoriteList *)webFavorite;

- (instancetype)initWithTakeSelfData:(TakeSelfIndexInfo *)takself;

//企业模块批销商品列表
- (instancetype)initWithEnterpriseWholeSale:(EnterpriseWholeSaleList *)wholeSaleList;
@end

NS_ASSUME_NONNULL_END
