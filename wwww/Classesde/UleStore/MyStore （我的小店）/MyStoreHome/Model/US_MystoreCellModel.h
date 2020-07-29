//
//  US_MystoreCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"
#import "UleSectionBaseModel.h"
#import "US_HomeBtnData.h"
NS_ASSUME_NONNULL_BEGIN

@interface US_MystoreSectionModel : UleSectionBaseModel
@property (nonatomic, copy) NSString * groupid;
@property (nonatomic, copy) NSString * groupsort;
@property (nonatomic, strong)UIColor  *headBackColor;
@end

@interface US_MystoreCellModel : UleCellBaseModel
@property (nonatomic, copy) NSString * groupid;
@property (nonatomic, copy) NSString * groupsort;
@property (nonatomic, strong) NSMutableArray<HomeBtnItem *> * indexInfo;
@property (nonatomic, strong) id extentInfo;
@property (nonatomic, assign) BOOL  isNewData;
//滚动条目
@property (nonatomic, assign) CGFloat   currentOffsetX;
//下方banner单图
@end

NS_ASSUME_NONNULL_END
