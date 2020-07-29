//
//  US_GoodsSectionModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleSectionBaseModel.h"
#import "US_HomeBtnData.h"
#import "US_GoodsCellModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, US_CustemLayoutType) {
    US_CustemLinearLayout=1,//自定义线性横向布局（从左到右）
    US_CustemFlowLayout,//自定义瀑布流布局
};

@interface US_GoodsSectionModel : UleSectionBaseModel

@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, copy) NSString * groupid;
@property (nonatomic, copy) NSString * groupsort;
@property (nonatomic, assign) NSInteger maxShowNum;//最大显示数
@property (nonatomic, assign) US_CustemLayoutType layoutType;



@end

NS_ASSUME_NONNULL_END
