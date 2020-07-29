//
//  US_SMSCodeButton.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/5.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_SMSCodeButton.h"

@interface US_SMSCodeButton ()

@property (strong, nonatomic) NSTimer *timer;

@property (copy  , nonatomic) ClickBlock clickBlock;
@property (copy  , nonatomic) FinishedBlock finishedBlock;

@end

@implementation US_SMSCodeButton

- (void)startWithSecond:(int)totalSecond
{
    _second = totalSecond;
    if (!self.timer||![self.timer isValid]) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeStart) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self timeStart];
    _isCounting=YES;
}

- (void)addClickBlock:(ClickBlock)clickBlock finishedBlock:(FinishedBlock)finishedBlcok
{
    self.clickBlock = [clickBlock copy];
    self.finishedBlock = [finishedBlcok copy];
    [self addTarget:self action:@selector(clickBlockAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)stop
{
    _isCounting=NO;
    self.userInteractionEnabled = YES;
    if (self.timer) {
        if ([self.timer respondsToSelector:@selector(isValid)]) {
            [self.timer invalidate];
        }
    }
    
    if (_finishedBlock) {
        NSString *title = _finishedBlock(self,self.second);
        if (_btnNormalColor!=nil) {
            self.backgroundColor=_btnNormalColor;
        }
        if (title.length > 0) {
            [self setTitle:title forState:UIControlStateNormal];
            if (_normalColor) {
                [self setTitleColor:_normalColor forState:UIControlStateNormal];
            }
        } else {
            [self setTitle:@"重来一遍" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - click events
- (void)timeStart
{
    self.userInteractionEnabled = NO;
    if (_second == 0) {
        [self stop];
    } else {
        _second --;
        NSString *defaultStr = [NSString stringWithFormat:@"%ds",_second];
        if (_preTitle!=nil && _preTitle.length>0) {
            defaultStr  = [NSString stringWithFormat:@"%@(%@s)",_preTitle,@(_second)];
        }
        if (_btnCountDownColor!=nil) {
            defaultStr=[NSString stringWithFormat:@"%d秒后重新获取",_second];
            self.backgroundColor=_btnCountDownColor;
        }
        [self setTitle:defaultStr forState:UIControlStateNormal];
        if (_countDownColor) {
            [self setTitleColor:_countDownColor forState:UIControlStateNormal];
        }
    }
}

- (void)clickBlockAction:(US_SMSCodeButton *)sender
{
    if (self.clickBlock) {
        _clickBlock(sender);
    }
}

-(void)setBtnNormalColor:(UIColor *)btnNormalColor
{
    _btnNormalColor=btnNormalColor;
    self.backgroundColor=_btnNormalColor;
}


@end
