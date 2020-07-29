//
//  Ule_LockIndicator.m
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "Ule_LockIndicator.h"
#import "Ule_LockConst.h"

@interface Ule_LockIndicator ()

/**
 *  需要显示的点
 */
@property (nonatomic, strong) NSMutableArray *tipsArray;

@end

@implementation Ule_LockIndicator

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.clipsToBounds = YES;
        [self initCircles];
    }
    return self;
}

- (void)initCircles {
    self.tipsArray = [NSMutableArray array];
    // 初始化圆点
    for (int i=0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int x = (i%3) * (kIndicatorDiameter+kIndicatorMargin);
        int y = (i/3) * (kIndicatorDiameter+kIndicatorMargin);
        [button setFrame:CGRectMake(x, y, kIndicatorDiameter, kIndicatorDiameter)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button setBackgroundImage:[UIImage bundleImageNamed:@"lock_sign_none"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage bundleImageNamed:@"lock_sign_select"] forState:UIControlStateSelected];
        button.userInteractionEnabled= NO;//禁止用户交互
        button.tag = i + kIndicatorDiameter + 1; // tag从基数+1开始,
        [self addSubview:button];
        [self.tipsArray addObject:button];
    }
    self.backgroundColor = [UIColor clearColor];
}

- (void)rectPasswordString:(NSString*)string {
    for (UIButton* button in self.tipsArray) {
        [button setSelected:NO];
    }
    NSMutableArray* numbers = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (NSInteger i = 0; i < string.length; i ++) {
        NSRange range = NSMakeRange(i, 1);
        NSNumber *number = [NSNumber numberWithInt:[string substringWithRange:range].intValue-1]; // 数字是1开始的
        [numbers addObject:number];
        [self.tipsArray[number.integerValue] setSelected:YES];
    }
}

@end
