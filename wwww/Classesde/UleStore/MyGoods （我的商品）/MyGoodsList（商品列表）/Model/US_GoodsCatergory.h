//
//  US_GoodsCatergory.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategroyItem : NSObject
@property (nonatomic, copy) NSString * idForCate;
@property (nonatomic, copy) NSString * categoryName;
@property (nonatomic, copy) NSString * ownerId;
@property (nonatomic, copy) NSString * sortNum;
@property (nonatomic, copy) NSString * delFlag;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * totalRecords;
@end

@interface US_GoodsCatergoryData : NSObject
@property (nonatomic, copy) NSString * cost;
@property (nonatomic, strong) NSMutableArray * categoryItems;
@end


@interface US_GoodsCatergory : NSObject
@property (nonatomic, copy) NSString * returnCode;
@property (nonatomic, copy) NSString * returnMessage;
@property (nonatomic, strong) US_GoodsCatergoryData * data;
@end

NS_ASSUME_NONNULL_END
