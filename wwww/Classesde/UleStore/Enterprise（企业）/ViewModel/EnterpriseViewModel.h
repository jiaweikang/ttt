//
//  EnterpriseViewModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^EnterpriseViewModelBlock)(NSString *listId, NSString *zoneId);

@class US_EnterpriseBanner;
@class US_EnterpriseRecommendData, US_EnterpriseWholeSaleData;
@interface EnterpriseViewModel : UleBaseViewModel
@property (nonatomic, copy) EnterpriseViewModelBlock    recommendCellClickBlock;

- (void)handleEnterpriseRecommendData:(US_EnterpriseRecommendData *)recomModel isFirstPage:(BOOL)isFirst;

- (void)handleEnterpriseWholeSaleData:(US_EnterpriseWholeSaleData *)wholeSaleData isFirstPage:(BOOL)isFirst;

@end

NS_ASSUME_NONNULL_END
