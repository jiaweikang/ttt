//
//  BtnImgAndTitle.m
//  u_store
//
//  Created by mac_chen on 2018/2/2.
//  Copyright © 2018年 yushengyang. All rights reserved.
//

#import "BtnImgAndTitle.h"
#import <UIView+SDAutoLayout.h>
@implementation BtnImgAndTitle


-(void)layoutSubviews {
    [super layoutSubviews];
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2.0;
    center.y = (self.frame.size.height-self.titleLabel.frame.size.height)/2;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0.0;
    newFrame.origin.y = self.imageView.bottom_sd + self.titleLabel.frame.size.height/3;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)heightForLabel:(NSString *)text labelWidth:(CGFloat)labelWidth {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(labelWidth + 2, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont  systemFontOfSize:KScreenScale(23)]} context:nil];
    
    return rect.size.height;
}

@end

