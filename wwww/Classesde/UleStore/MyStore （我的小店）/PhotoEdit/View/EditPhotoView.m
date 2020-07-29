//
//  EditPhotoView.m
//  自定义相机测试
//
//  Created by chenxiaoqiang on 2/14/14.
//  Copyright (c) 2014 ule. All rights reserved.
//

#import "EditPhotoView.h"

@interface EditPhotoView ()
{
    CGPoint point_01;
    CGPoint point_02;
    CGPoint point_03;
    CGPoint point_04;
}
@end

@implementation EditPhotoView

- (id)initWithFrame:(CGRect)frame andSizeForChangeView:(CGSize)size
{
    self = [super initWithFrame:frame];
    if(self)
    {
        float change_x = (CGRectGetWidth(frame) - size.width) /2;
        float change_y = (CGRectGetHeight(frame)- size.height)/2;
        float change_maxX = change_x + size.width;
        float change_maxY = change_y + size.height;
        point_01 = CGPointMake(change_x, change_y);
        point_02 = CGPointMake(change_maxX, change_y);
        point_03 = CGPointMake(change_maxX, change_maxY);
        point_04 = CGPointMake(change_x, change_maxY);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //获得处理的上下文
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设直线条样式
    CGContextSetLineWidth(context, 1.0);
    //设置线条宽度
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    //设置线条颜色
    
    CGContextBeginPath(context);
    //开始一个起始路径
    
    CGContextMoveToPoint(context, point_01.x, point_01.y);
    //起始点设置坐标
    CGContextAddLineToPoint(context, point_02.x, point_02.y);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, point_03.x, point_03.y);
    CGContextAddLineToPoint(context, point_04.x, point_04.y);
    CGContextAddLineToPoint(context, point_01.x, point_01.y);
    CGContextSetRGBFillColor(context, 225, 225, 225, 0.2);
    CGContextFillPath(context);
    CGContextStrokePath(context);
    
}

@end
