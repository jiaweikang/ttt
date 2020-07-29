//
//  US_MyGoodsListVC.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewController.h"
#import "US_MyGoodsListRootVC.h"

typedef enum : NSUInteger {
    US_MyGoodsListAllGoods=1, //全部商品
    US_MyGoodsListCategory, //分类商品
    US_MyGoodsListSearch,  //搜索结果
    US_MyGoodsFenXiao   //分销收藏列表
} US_MyGoodsListType;

NS_ASSUME_NONNULL_BEGIN
@interface US_MyGoodsListVC : UleBaseViewController
- (void)startSearchCategoryWithKeyWord:(NSString *)keyword;
@end

NS_ASSUME_NONNULL_END
