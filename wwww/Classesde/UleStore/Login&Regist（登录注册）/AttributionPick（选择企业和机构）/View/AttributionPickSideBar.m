//
//  AttributionPickSideBar.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/29.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "AttributionPickSideBar.h"

@interface AttributionPickSideBar ()

@property (nonatomic, strong)NSMutableArray     *btnsArray;

@end

@implementation AttributionPickSideBar

-(instancetype)initWithFrame:(CGRect)frame dataArr:(nonnull NSMutableArray *)array
{
    if (self=[super initWithFrame:frame]) {
        [self setUIWithDataArr:array];
    }
    return self;
}

- (void)setUIWithDataArr:(NSMutableArray *)dataArray
{
    if (dataArray.count==0) {
        return;
    }
    
    self.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAction:)];
    [self addGestureRecognizer:panGes];
    CGFloat btnWidth=CGRectGetWidth(self.frame);
    CGFloat btnHeight=CGRectGetHeight(self.frame)/dataArray.count;
    for (int i=0; i<dataArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, btnHeight*i, btnWidth, btnHeight)];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor convertHexToRGB:@"999999"] forState:UIControlStateNormal];
        [btn setTitle:dataArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:KScreenScale(30)]];
        btn.tag=i+20000;
        [self.btnsArray addObject:btn];
        [self addSubview:btn];
    }
}


-(void)panGesAction:(UIPanGestureRecognizer *)panGes{
    CGPoint touchPoint = [panGes locationInView:self];
    for (UIButton *btn in self.btnsArray) {
        if (CGRectContainsPoint(btn.frame, touchPoint)) {
            [self btnClickAction:btn];
        }
    }
}

- (void)btnClickAction:(UIButton *)sender
{
    NSInteger index = sender.tag-20000;
    if (self.didSelectBlock) {
        self.didSelectBlock(index);
    }
}

#pragma mark - <getter>
- (NSMutableArray *)btnsArray
{
    if (!_btnsArray) {
        _btnsArray=[NSMutableArray array];
    }
    return _btnsArray;
}


@end
