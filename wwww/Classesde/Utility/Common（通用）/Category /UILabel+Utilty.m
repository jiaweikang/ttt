//
//  UILabel+Utilty.m
//  UleApp
//
//  Created by chenzhuqing on 2017/1/5.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "UILabel+Utilty.h"
#import "UIColor+ColorUtility.h"

@implementation UILabel (Utilty)
+ (UILabel *)initWithTextColor:(NSString *)color andFontSize:(CGFloat)fontSize{
    UILabel * label=[[UILabel alloc] init];
    label.textColor=[UIColor convertHexToRGB:color];
    label.font=[UIFont systemFontOfSize:fontSize];
    return label;
}
@end
