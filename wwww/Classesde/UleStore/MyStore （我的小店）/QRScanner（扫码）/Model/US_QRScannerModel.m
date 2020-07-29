//
//  US_QRScannerModel.m
//  u_store
//
//  Created by chenzhuqing on 2019/3/6.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_QRScannerModel.h"

@implementation US_ScannerAction



@end

@implementation US_QRScannerModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [US_ScannerAction class]
             };
}
@end
