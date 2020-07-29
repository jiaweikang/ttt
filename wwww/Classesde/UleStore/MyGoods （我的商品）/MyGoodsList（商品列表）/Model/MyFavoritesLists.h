//
//  MyFavoritesLists.h
//  u_store
//
//  Created by shengyang_yu on 15/11/3.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionListModel : NSObject
@property (nonatomic, strong) NSNumber *_id;
@property (nonatomic, copy) NSString *name;

@end

@interface Favorites : NSObject

@property (nonatomic, copy)     NSString *salePrice;
@property (nonatomic, copy)     NSString *standardPrice;
@property (nonatomic, copy)     NSString *marketPrice;
@property (nonatomic, copy)     NSString *imgUrl;
@property (nonatomic, strong)   NSNumber *listId;
@property (nonatomic, strong)   NSString *updateTime; //全部商品列表时间
@property (nonatomic, copy)     NSString *listName;
@property (nonatomic, copy)     NSString *listingName;
@property (nonatomic, copy)     NSString *categoryName;
@property (nonatomic, strong)   NSNumber *categoryId;
@property (nonatomic, copy)     NSString *listDesc;
@property (nonatomic, copy)     NSString *commission;
@property (nonatomic, copy)     NSString *commistion;
@property (nonatomic, strong)   NSNumber *listingState;//0--上架售卖中,2--已下架,1--已删除
@property (nonatomic, strong)   NSNumber *instock;//库存
@property (nonatomic, copy)     NSString *saleRange;//限购区域
@property (nonatomic, strong)   NSNumber *limitWay;//限购数量
@property (nonatomic, strong)   NSNumber *limitNum;
@property (nonatomic, strong)   NSMutableArray *promotionList;
@property (nonatomic, copy)     NSString *promotionIds;
@property (nonatomic, copy)     NSString *listPromotionDesc;
@property (nonatomic, copy)     NSString *listPromotionName;

@property (nonatomic, strong) NSNumber *totalSold;//销量 20170425
@property (nonatomic, copy)   NSString *createTime;//收藏时间
@property (nonatomic, copy)   NSMutableArray *services;//包含7免运费  我的商品列表用merchantFreightPay
@property (nonatomic, copy)   NSString      *merchantFreightPay;//-1或者(null)是免运费 仅限我的商品列表
@property (nonatomic, assign) BOOL isSelected;
/*****强加******/
@property (nonatomic, copy)  NSString   *sharePrice;//为了分享强行加入,和salePrice等值
@property (nonatomic, copy)  NSString   *frameId;
@property (nonatomic, copy)  NSString   *salPrice;
@property (nonatomic, copy)  NSString   *content;
@property (nonatomic, assign)BOOL       isImgLoaded;//判断列表的图片是否加载出来，如果加载失败在微信分享时用占位图代替
@property (nonatomic, copy) NSString *categoryIds;
@property (nonatomic, copy) NSString * idForCate;
@property (nonatomic, assign) BOOL noCancelSelect;

@property (nonatomic, copy) NSString *groupFlag; //2018.09.27 新增团购标识 1是 0否
@property (nonatomic, strong) NSNumber *listingType;//商品类型 103为自有商品
@property (nonatomic, copy) NSString    *listingTag;
//批销专区id
@property (nonatomic, strong) NSNumber  *thirdPlatformId;
/*批销规格增加字段*/
// 0：不箱装 1：箱装
@property (nonatomic, copy) NSString    *boxSell;
//不装箱：   数量（取limitNum）单位（取sellUnitSingle）
//装箱：    realPackageCount+sellUnitSingle/sellUnit | limitNum+sellUnit起售
//30只/盒 | 5盒起售
@property (nonatomic, copy) NSString    *realPackageCount;
@property (nonatomic, copy) NSString    *sellUnitSingle;
@property (nonatomic, copy) NSString    *sellUnit;

@end

@interface MyFavoritesListData : NSObject
@property (nonatomic, strong) NSMutableArray    *result;
@property (nonatomic, strong) NSNumber          *pageSize;
@property (nonatomic, strong) NSNumber          *pageIndex;
@property (nonatomic, strong) NSNumber          *nextPageIndex;
@property (nonatomic, strong) NSNumber          *totalRecords;
@property (nonatomic, strong) NSNumber          *totalPages;

@end

@interface MyFavoritesLists : NSObject

@property (nonatomic, copy) NSString                *returnCode;
@property (nonatomic, copy) NSString                *returnMessage;
@property (nonatomic, strong) MyFavoritesListData   *data;

@end
