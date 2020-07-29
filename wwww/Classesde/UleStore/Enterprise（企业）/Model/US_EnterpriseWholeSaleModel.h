//
//  US_EnterpriseWholeSaleModel.h
//  UleStoreApp
//
//  Created by lei xu on 2020/3/24.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnterpriseWholeSaleInfo : NSObject
@property (nonatomic, strong)NSString *beginNum;
@end

@interface EnterpriseWholeSaleList : NSObject
@property (nonatomic, strong) NSNumber * brandId;
@property (nonatomic, strong) NSNumber * categoryId3;
@property (nonatomic, strong) NSString * defImgs;
@property (nonatomic, strong) NSNumber * defItemId;
@property (nonatomic, strong) NSNumber * itemNums;
@property (nonatomic, strong) NSNumber * listId;
@property (nonatomic, strong) NSString * listName;
@property (nonatomic, strong) NSNumber * merchantId;
@property (nonatomic, strong) NSString * packageSpec;
@property (nonatomic, strong) NSString * packageUnit;
@property (nonatomic, strong) NSNumber * packageCount;
@property (nonatomic, strong) NSNumber * sharePrice;
@property (nonatomic, strong) NSNumber * storageFlag;
@property (nonatomic, strong) NSString * videoUrl;
@property (nonatomic, strong) NSNumber * zonePrice;
@property (nonatomic, strong) NSNumber * zoneId;
@property (nonatomic, strong) EnterpriseWholeSaleInfo * tagInfo;
@end

@interface US_EnterpriseWholeSaleData : NSObject
@property (nonatomic, strong) NSNumber * total;
@property (nonatomic, strong) NSMutableArray * list;
@end

@interface US_EnterpriseWholeSaleModel : NSObject
@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) US_EnterpriseWholeSaleData * data;
@property (nonatomic, strong) NSString * msg;
@property (nonatomic, strong) NSString * remark;
@end

NS_ASSUME_NONNULL_END
