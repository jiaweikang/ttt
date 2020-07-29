//
//  UleSearchKeyObject.h
//  UleApp
//
//  Created by chenzhuqing on 2017/10/25.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchKeyWordItem:NSObject
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * attribute1;
@property (nonatomic,strong) NSString * attribute2;
@property (nonatomic,strong) NSString * attribute3;
@property (nonatomic,strong) NSString * attribute4;
@property (nonatomic,strong) NSString * attribute5;
@property (nonatomic,strong) NSString * checkListingIds;
@property (nonatomic,strong) NSString * checkPrice;
@property (nonatomic,strong) NSString * checkStoreIds;
@property (nonatomic,strong) NSString * createTime;
@property (nonatomic,strong) NSString * imgUrl;
@property (nonatomic,strong) NSString * link;
@property (nonatomic,strong) NSString * modifyTime;
@property (nonatomic,strong) NSString * priority;
@property (nonatomic,strong) NSString * publishTime;
@property (nonatomic,strong) NSString * sectionId;
@property (nonatomic,strong) NSString * taskRunTime;
@property (nonatomic,strong) NSString * title;

@end

@interface UleSearchKeyObject : NSObject

@property (nonatomic, strong) NSMutableArray * wap_searchkeyword;
@end
