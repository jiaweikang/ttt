//
//  US_MenuPopOverView.m
//  u_store
//
//  Created by zemengli on 2019/6/21.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import "US_MenuPopOverView.h"
#import <UIView+SDAutoLayout.h>

#define kLableHeight KScreenScale(85)
#define kPopOverVieWidth KScreenScale(200)
@interface US_MenuPopOverView ()
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSString * selectTitle;
@end

@implementation US_MenuPopOverView

- (instancetype)initWithSuperView:(UIView *)superView MunuListArray:(NSArray *)munuListArray SelectTitle:(NSString *)selectTitle{
    self.titleArray = munuListArray;
    self.selectTitle = selectTitle;
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    CGPoint point =[superView convertPoint:CGPointMake(superView.width_sd/2+KScreenScale(70), superView.height_sd+KScreenScale(10)) toView:window];
    self= [super initWithOrigin:point Width:kPopOverVieWidth Height:kLableHeight*munuListArray.count Direction:WBArrowDirectionUp3];
    if (self) {
        [self setUI];
    }
    [self popViewAtSuperView:window];
    return self;
}
- (void)setUI{
    self.backView.backgroundColor=[UIColor whiteColor];
    self.backView.layer.cornerRadius=KScreenScale(10);

    for (int i=0; i<self.titleArray.count; i++) {
        NSString * titleStr = [self.titleArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, kLableHeight*i, kPopOverVieWidth, kLableHeight)];
        if ([titleStr isEqualToString:self.selectTitle]) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [button.titleLabel setFont:[UIFont systemFontOfSize:KScreenScale(30)]];
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:button];
        if (i<2) {
            UIView * lineView = [UIView new];
            [lineView setBackgroundColor:[UIColor convertHexToRGB:@"e6e6e6"]];
            [lineView setFrame:CGRectMake(KScreenScale(40), kLableHeight*(i+1), kPopOverVieWidth-KScreenScale(80), 1)];
            [self.backView addSubview:lineView];
        }
        
    }
}

- (void)buttonClick:(UIButton *)button{
    if (self.clickBlock) {
        self.clickBlock(button.titleLabel.text);
    }
    [self dismiss];
}

//覆盖父类方法
-(void)dismiss{
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    NSArray *result=[self.backView subviews];
    for (UIView *view in result) {
        
        [view removeFromSuperview];
        
    }
    
    //动画效果淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.backView.frame = CGRectMake(self.origin.x, self.origin.y, 0, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            
        }
    }];
    
    
    
}
@end
