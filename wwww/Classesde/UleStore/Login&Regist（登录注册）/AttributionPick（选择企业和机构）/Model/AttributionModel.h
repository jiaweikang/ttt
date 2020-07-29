//
//  AttributionModel.h
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttributionData : NSObject
@property (nonatomic , assign) NSInteger              parentId;
@property (nonatomic , assign) NSInteger              rootId;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , assign) NSInteger              _id;
@property (nonatomic , copy) NSString              * firstLetter;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * updateTime;
@property (nonatomic , assign) NSInteger              delFlag;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , assign) NSInteger              operatorId;

@end

@interface AttributionModel : NSObject
@property (nonatomic , copy) NSString              * returnMessage;
@property (nonatomic , copy) NSString              * returnCode;
@property (nonatomic , copy) NSArray<AttributionData *>              * data;
@end

NS_ASSUME_NONNULL_END
