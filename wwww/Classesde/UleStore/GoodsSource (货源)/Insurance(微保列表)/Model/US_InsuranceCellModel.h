//
//  US_InsuranceCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "FeatureModel_Insurance.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_InsuranceCellModel : UleCellBaseModel
//分享相关（）
@property (nonatomic, copy) NSString * logPageName;
@property (nonatomic, copy) NSString * logShareFrom;
@property (nonatomic, copy) NSString * shareFrom;
@property (nonatomic, copy) NSString * shareChannel;
@property (nonatomic, copy) NSString * tel;

- (instancetype)initWithInsuranceItem:(InsuranceIndexInfo *)indexInfo;

@end

NS_ASSUME_NONNULL_END
