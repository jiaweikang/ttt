//
//  US_Color.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/27.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#ifndef US_Color_h
#define US_Color_h
#import <UIColor+ColorUtility.h>

#define SETCOLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kDarkTextColor  @"666666"
#define kLightTextColor  @"999999"
#define kBlackTextColor     @"333333"
#define kGrayLineColor  @"e6e6e6"
#define kGreenColor     @"36a4f1"
#define kViewCtrBackColor   [UIColor convertHexToRGB:@"f2f2f2"]
#define kNavWhiteColor      [UIColor colorWithWhite:0.97 alpha:0.8]
#define kNavTitleColor      [UIColor convertHexToRGB:@"ffffff"]
#define kNavBarBackColor    [UIColor convertHexToRGB:@"ef3b39"]
#define kCommonRedColor     [UIColor convertHexToRGB:@"ef3b39"]

#endif /* US_Color_h */
