//
//  FeatureModel_Insurance.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface InsuranceIndexInfo : NSObject
@property (nonatomic, copy) NSString *min_version;
@property (nonatomic, copy) NSString *insurance_unit;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *insurance_commission;
@property (nonatomic, copy) NSString *sectionId;
@property (nonatomic, copy) NSString *priority;
@property (nonatomic, copy) NSString *title;//保险名字
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *showProvince;
@property (nonatomic, copy) NSString *insurance_type;//险种类型
@property (nonatomic, copy) NSString *max_version;
@property (nonatomic, copy) NSString *insurance_price;
@property (nonatomic, copy) NSString *insurance_income;
@property (nonatomic, copy) NSString *insurance_content;
@property (nonatomic, copy) NSString *android_action;
@property (nonatomic, copy) NSString *ios_action;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *wh_rate;

@property (nonatomic, assign) BOOL isImgLoaded;//
@end

@interface FeatureModel_Insurance : NSObject
@property (nonatomic, copy) NSString *returnCode;
@property (nonatomic, copy) NSString *returnMessage;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray *indexInfo;
@end

NS_ASSUME_NONNULL_END
