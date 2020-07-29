//
//  US_EnterpriseSectionModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseSectionModel.h"
#import "US_EnterpriseDataModel.h"

@implementation US_EnterpriseSectionModel



- (void)setSectionHeaderHeight:(US_EnterpriseBannerData *)bannerData
{
    if (bannerData&&[bannerData.wh_rate floatValue]>0) {
        self.headHeight = __MainScreen_Width/[bannerData.wh_rate floatValue];
    }else {
        self.headHeight = __MainScreen_Width/2.14;
    }
}


#pragma mark - <getters>
- (NSMutableArray *)mDataArray
{
    if (!_mDataArray) {
        _mDataArray = [NSMutableArray array];
    }
    return _mDataArray;
}

@end
