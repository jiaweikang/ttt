//
//  UILabel+DeleteLine.m
//  ule_v3
//
//  Created by Ulechenzhuqing on 15-6-8.
//  Copyright (c) 2015年 ule. All rights reserved.
//

#import "UILabel+DeleteLine.h"

@implementation UILabel (DeleteLine)

-(void) addDeleteLine{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange contentRange = {0, [content length]};
    [content addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0)} range:contentRange];
    self.attributedText = content;
}

@end
