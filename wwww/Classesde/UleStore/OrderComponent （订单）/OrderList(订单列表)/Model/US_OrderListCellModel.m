//
//  US_OrderListCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListCellModel.h"

@implementation US_OrderListCellModel
- (instancetype) initWithOrderListData:(PrdInfo *)prdInfo{
    self = [super initWithCellName:@"US_OrderListCell"];
    if (self) {
        self.data=prdInfo;
        self.imageUrlStr=[self getImageUrlString:prdInfo.product_pic];
        self.listNameStr=prdInfo.product_name;
        self.priceStr=[NSString stringWithFormat:@"¥%.2f", prdInfo.sal_price.doubleValue];
        NSString *attribute = [[NSString stringWithFormat:@"%@", prdInfo.attributes] stringByReplacingOccurrencesOfString:@"|.|" withString:@"  "];
        self.sizeStr = [NSString stringWithFormat:@"%@", attribute];
        self.numberStr = [NSString stringWithFormat:@"x%@", prdInfo.product_num];
        self.isCanReplace=prdInfo.isCanReplace;
    }
    return self;
}

//根据返回的图片url获取分隔符|*|分割的第一个imageUrl
- (NSString *)getImageUrlString:(NSString *)imageUrl {
    NSArray * imgUrlArr = [imageUrl componentsSeparatedByString:@"|*|"];
    return imgUrlArr.firstObject;
}

@end
