//
//  US_EnterpriseSectionModel.h
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UleSectionBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@class US_EnterpriseBannerData;
@interface US_EnterpriseSectionModel : UleSectionBaseModel
@property (nonatomic, strong) NSMutableArray        *mDataArray;

- (void)setSectionHeaderHeight:(US_EnterpriseBannerData *)bannerData;

@end

NS_ASSUME_NONNULL_END
