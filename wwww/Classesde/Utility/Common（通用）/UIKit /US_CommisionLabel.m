//
//  US_CommisionLabel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/21.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CommisionLabel.h"
#import <UIView+SDAutoLayout.h>
#import "UIImage+USAddition.h"
#import <UIImage+Extension.h>
@implementation US_CommisionLabel

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight
                              | UIRectCornerBottomRight cornerRadii:CGSizeMake(self.height_sd*0.5, self.height_sd*0.5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

//- (void) addCorner:(CGFloat) corner toSize:(CGSize) viewsize{
//    UIImageView * imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewsize.width, viewsize.height)];
//    imageView.backgroundColor=[UIColor clearColor];
//    UIView * backView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewsize.width, viewsize.height)];
//    backView.backgroundColor= kNavBarBackColor;
//    UIImage * image=[UIImage makeImageWithView:backView];
//    imageView.image=[[image imageWithSize:viewsize UIRectCorner:UIRectCornerTopRight|UIRectCornerBottomRight andCornerRadius:corner] stretchableImageWithLeftCapWidth:2 topCapHeight:0];
//    [self insertSubview:imageView atIndex:0];
//    imageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
//}
@end
