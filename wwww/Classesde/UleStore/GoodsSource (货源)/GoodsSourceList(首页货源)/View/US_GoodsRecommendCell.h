//
//  US_GoodsRecommendCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_GoodsCellModel.h"
#import "USShareView.h"
#import "FeatureModel_HomeRecommend.h"

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsHomeType1Cell : UICollectionViewCell
@property (nonatomic, strong) US_GoodsCellModel * model;
@end

//底部1图+3商品
@interface US_GoodsHomeType2Cell : UICollectionViewCell
@property (nonatomic, strong) US_GoodsCellModel * model;
@end
@interface GoodsSourceType2View : UIView
@property (nonatomic, strong)NewHomeRecommendData *model;
@property (nonatomic, copy) NSString * logPageName;
@property (nonatomic, copy) NSString * logShareFrom;
@property (nonatomic, copy) NSString * shareFrom;
@property (nonatomic, copy) NSString * shareChannel;
@end

//有料
@interface US_GoodsHomeType3Cell : UICollectionViewCell
@property (nonatomic, strong) US_GoodsCellModel * model;
@end

@interface US_GoodsHomeType4Cell : UICollectionViewCell
@property (nonatomic, strong) US_GoodsCellModel * model;
@end

NS_ASSUME_NONNULL_END
