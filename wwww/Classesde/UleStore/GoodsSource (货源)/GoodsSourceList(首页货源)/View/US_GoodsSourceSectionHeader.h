//
//  US_GoodsSourceSectionHeader.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeatureModel_HomeRecommend.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceSectionHeader : UICollectionReusableView
@property (nonatomic, strong) NewHomeRecommendData * model;
@end

@interface US_GoodsSourceFooter : UICollectionReusableView

@end

@interface US_GoodsSourceRecommendHeader : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END
