//
//  UleRedPacketRain.m
//  UleRedRainDemo
//
//  Created by chenzhuqing on 2018/7/24.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleRedPacketRain.h"
#import "UleRedPacketConfig.h"
#define kTimes   11   //倒计时 时间长度

@interface ClickImageView : UIImageView

@end

@implementation ClickImageView

- (void)disMiss{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha=0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

@end


@interface UleLEDView:UIImageView
@property (nonatomic, strong) UILabel * contentTopLabel;
@property (nonatomic, strong) UILabel * contentBottomLabel;
@property (nonatomic, strong) NSString * imageName;
@property (nonatomic, strong) NSArray * contentArray;
@property (nonatomic, strong) NSMutableArray * lableArray;
@property (nonatomic, assign) NSInteger countNum;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation UleLEDView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.layer.masksToBounds=YES;
    [self setupView];
    return self;
}

- (void)dealloc{
    NSLog(@"__%s",__FUNCTION__);
    [self closeLEDtimer];
}

- (void)closeLEDtimer{
    if (self.timer) {
        dispatch_source_cancel(_timer);
        _timer=NULL;
    }
}

- (void)setupView{
    CGFloat labelHeight=self.frame.size.height-30;
    _contentTopLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-HORIZONTA(20), labelHeight)];
    _contentTopLabel.textColor=[UIColor whiteColor];
    _contentTopLabel.font=[UIFont systemFontOfSize:HORIZONTA(13)];
    _contentTopLabel.textAlignment=NSTextAlignmentCenter;
    _contentTopLabel.adjustsFontSizeToFitWidth=YES;
    _contentBottomLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight, self.frame.size.width-HORIZONTA(20), labelHeight)];
    _contentBottomLabel.textColor=[UIColor whiteColor];
    _contentBottomLabel.textAlignment=NSTextAlignmentCenter;
    _contentBottomLabel.font=[UIFont systemFontOfSize:HORIZONTA(13)];
    _contentBottomLabel.adjustsFontSizeToFitWidth=YES;
    _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height-labelHeight)/2.0, self.frame.size.width, labelHeight)];
    _contentView.layer.masksToBounds=YES;
    [_contentView addSubview:_contentTopLabel];
    [_contentView addSubview:_contentBottomLabel];
    [self addSubview:_contentView];
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray=[contentArray copy];
    if (_contentArray.count>1) {
        _contentTopLabel.text=[self creatRandomAwardListstring];
        _contentBottomLabel.text=[self creatRandomAwardListstring];
    }else if(_contentArray.count==1){
        _contentTopLabel.text=[self creatRandomAwardListstring];
    }
}

- (NSString *)creatRandomAwardListstring{
    NSArray * phoneArray=@[@"13",@"15",@"16",@"17",@"18",@"19",];
    NSString *phone=phoneArray[arc4random()%phoneArray.count];
    NSMutableString * phoneNumber=[[NSMutableString alloc] initWithString:@"恭喜 "];
    [phoneNumber appendString:phone];
    for (int i=0; i<8; i++) {
        NSInteger random=arc4random()%9;
        if (i==1||i==2||i==3) {
            [phoneNumber appendString:@"*"];
        }else{
            [phoneNumber appendString:[NSString stringWithFormat:@"%@",@(random)]];
        }
    }
    NSInteger num=self.contentArray.count;
    if (num>0) {
        num=arc4random()%num;
    }
    NSString * awardStr=self.contentArray[num];
    [phoneNumber appendString:[NSString stringWithFormat:@" 获得%@",awardStr]];
    return [phoneNumber copy];
}

- (void) startScrollLabelTimer{
    _countNum=0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),2.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self swapLabels];
        });
    });
    dispatch_resume(_timer);
}

- (void)swapLabels{
    if (self.contentArray==nil||self.contentArray.count<=1) {
        return;
    }
    _countNum=_countNum%self.contentArray.count;
    [UIView animateWithDuration:0.8 animations:^{
        for (UILabel * subLabel in self.contentView.subviews) {
            subLabel.frame=CGRectMake(0, subLabel.frame.origin.y-subLabel.frame.size.height, subLabel.frame.size.width, subLabel.frame.size.height);
        }
        
    } completion:^(BOOL finished) {
        for (UILabel * subLabel in self.contentView.subviews) {
            if (subLabel.frame.origin.y<0) {
                subLabel.frame=CGRectMake(0,subLabel.frame.size.height, subLabel.frame.size.width, subLabel.frame.size.height);
                subLabel.text=[self creatRandomAwardListstring];
            }
        }
        self.countNum++;
    }];
}

@end


@interface UleRedPacketRain()
@property (nonatomic, strong) UILabel * countDownLabel;
@property (nonatomic, strong) UIView * touchView;
@property (nonatomic, strong) UIImageView * packetRainView;
@property (nonatomic, strong) UIImageView * preView;
@property (nonatomic, strong) UIImageView * preCountDownImageView;
//@property (nonatomic, strong) UleLEDView * mLEDView;        //中奖名单列表
//@property (nonatomic, strong) CAShapeLayer * progressBar;   //倒计时进度条
@property (nonatomic, strong) NSMutableArray * clickedPackets;//点中过的红包
@property (nonatomic, strong) dispatch_source_t preTimer;   //3秒预告倒计时
@property (nonatomic, strong) dispatch_source_t coundDownTimer;//倒计时数字定时器
@property (nonatomic, strong) dispatch_source_t redpacktTimer;//创建红包定时器
@property (nonatomic, strong) RedPacketRainFinishd finishblock;
@property (nonatomic, strong) RedPackectRainCountDown countDownBlock;
@property (nonatomic, strong) RedPackectRainClickLog clickLogBlock;
@property (nonatomic, assign) BOOL hadRecordLog;//是否记录过日志
@end

@implementation UleRedPacketRain

+ (void)showRedPacketReinWithWinners:(NSArray<NSString *> *)winnerList packetPreShowEnd:(RedPackectRainCountDown) preShowEnd packetRainFinished: (RedPacketRainFinishd) finishBlock redpacketRainClickLog:(RedPackectRainClickLog) clickBlock{
    UleRedPacketRain * redpacketRain=[[UleRedPacketRain alloc] initWithRedPacketWinnersList:winnerList];
    [redpacketRain showRedPacketRain];
    redpacketRain.finishblock = [finishBlock copy];
    redpacketRain.countDownBlock = [preShowEnd copy];
    redpacketRain.clickLogBlock = [clickBlock copy];
}



- (instancetype)initWithRedPacketWinnersList:(NSArray *)winnerList{
    self = [[UleRedPacketRain alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if (self) {
        _clickedPackets=[[NSMutableArray alloc] init];
        
//        self.mLEDView.contentArray=winnerList;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"__%s",__FUNCTION__);
    [self closeAllTimer];
}
//关闭所有开启过的定时器
- (void)closeAllTimer{
    if (self.coundDownTimer) {
        dispatch_source_cancel(_coundDownTimer);
        _coundDownTimer=NULL;
    }
    if (self.redpacktTimer) {
        dispatch_source_cancel(self.redpacktTimer);
        self.redpacktTimer=NULL;
    }
    if (self.preTimer) {
        dispatch_source_cancel(self.preTimer);
        self.preTimer=NULL;
    }
//    [self.mLEDView closeLEDtimer];
}


- (void)loadView{
    //    [self addSubview:[self buildRedPacketRainView]];
    [self addSubview:[self buildPrePacketRainView]];
}

- (UIImageView * )buildPrePacketRainView{
    _preView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _preView.image=LoadBundleImage(@"背景图片");
    _preView.contentMode=UIViewContentModeScaleAspectFill;
    UIImageView * countDownBg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HORIZONTA(384))];
    [countDownBg setContentScaleFactor:[[UIScreen mainScreen] scale]];
    countDownBg.center=CGPointMake(_preView.center.x, _preView.center.y);
    countDownBg.image=LoadBundleImage(@"倒计时");
    [_preView addSubview:countDownBg];
    _preCountDownImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0.0, HORIZONTA(70), HORIZONTA(70))];
    _preCountDownImageView.image=LoadBundleImage(@"倒计时3");
    _preCountDownImageView.center=countDownBg.center;
    [_preView addSubview:_preCountDownImageView];
    return _preView;
}

- (UIImageView *)buildRedPacketRainView{
    _packetRainView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _packetRainView.image=LoadBundleImage(@"背景图片");
    _packetRainView.contentMode=UIViewContentModeScaleAspectFill;
    _packetRainView.userInteractionEnabled=YES;
    _touchView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_packetRainView addSubview:_touchView];
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRed:)];
    [_touchView addGestureRecognizer:tap];
    
    UIImageView * miaobiaoView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 0,HORIZONTA(70), HORIZONTA(130))];
    miaobiaoView.image=LoadBundleImage(@"秒表");
    [_packetRainView addSubview:miaobiaoView];
    
    _countDownLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,HORIZONTA(34), HORIZONTA(70), HORIZONTA(60))];
    _countDownLabel.font=[UIFont systemFontOfSize:HORIZONTA(23)];
    _countDownLabel.textAlignment=NSTextAlignmentCenter;
    _countDownLabel.textColor=[UIColor whiteColor];
    [miaobiaoView addSubview:_countDownLabel];
    UIButton * close=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, kStatusBarHeight, 32, 32)];
    [close setImage:LoadBundleImage(@"关闭") forState:UIControlStateNormal];
    close.backgroundColor=[UIColor clearColor];
    [close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [_packetRainView addSubview:close];
//    [_packetRainView addSubview:self.mLEDView];
    return _packetRainView;
}

#pragma mark - <显示和隐藏>
- (void)showRedPacketRain{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    [self loadView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startPreTimer];
    });
    
}

- (void)hiddenRedPacketRain{
    [self closeAllTimer];
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self removeFromSuperview];
}

- (void)close:(id)sender{
    [self hiddenRedPacketRain];
}
#pragma mark - <定时器>
//开启3秒预告倒计时
- (void)startPreTimer{
    __block int preCount = 4;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _preTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_preTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_preTimer, ^{
        preCount--;
        if (preCount<=0) {
            dispatch_source_cancel(self.preTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addSubview:[self buildRedPacketRainView]];
                [self startTime];
                [self startRedPackerts];
                [self.preView removeFromSuperview];
//                [self.mLEDView startScrollLabelTimer];
                self.hadRecordLog=NO;
                if (self.countDownBlock) {
                    self.countDownBlock();
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * name=[NSString stringWithFormat:@"倒计时%@",@(preCount)];
                self.preCountDownImageView.image=LoadBundleImage(name);
                [self beginScaleAnimaitionAt:self.preCountDownImageView];
            });
        }
        
    });
    dispatch_resume(_preTimer);
}
//红包雨倒计时开始
- (void)startTime{
    __block int timeout = kTimes;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _coundDownTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_coundDownTimer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_coundDownTimer, ^{
        timeout--;
        if ( timeout < 0 ){
            dispatch_source_cancel(self.coundDownTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endAnimation];
            });
        }
        else{
            NSString * titleStr = [NSString stringWithFormat:@"%d",timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.countDownLabel.text = titleStr;
            });
        }
    });
    dispatch_resume(_coundDownTimer);
}
//开启创建红包定时器
- (void)startRedPackerts{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _redpacktTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_redpacktTimer,dispatch_walltime(NULL, 0),0.4*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_redpacktTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showRain];
        });
    });
    dispatch_resume(_redpacktTimer);
}

#pragma mark - <动画>
//倒计时数字放大缩小动画开始
- (void)beginScaleAnimaitionAt:(UIView *) targetView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 1;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    animation.values = values;
    animation.timingFunction =  [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [targetView.layer addAnimation:animation forKey:nil];
}

- (void)showRain{
    UIImageView * imageV = [UIImageView new];
    NSInteger random=arc4random()%4+1;
    NSString * imageName=[NSString stringWithFormat:@"红包%@",@(random)];
    imageV.image = LoadBundleImage(imageName);
    imageV.frame = CGRectMake(0, 0, HORIZONTA(70),HORIZONTA(70));
    CALayer * moveLayer = [CALayer new];
    moveLayer.bounds = imageV.frame;
    CATransform3D rotationTransform = CATransform3DIdentity;
    moveLayer.transform=CATransform3DRotate(rotationTransform, 30.0f * M_PI / 180.0f, 0.0f, 0.0f, 1.0f);
    moveLayer.anchorPoint = CGPointMake(0, 0);
    moveLayer.position = CGPointMake(0, -HORIZONTA(70));
    moveLayer.contents = (id)imageV.image.CGImage;
    [self.touchView.layer addSublayer:moveLayer];
    [self addAnimationToLayer:moveLayer];
}

- (void)addAnimationToLayer:(CALayer *)movelayer{
    CAKeyframeAnimation * moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGFloat x=arc4random() % ((int)SCREEN_WIDTH);
    NSValue * A = [NSValue valueWithCGPoint:CGPointMake(x, -HORIZONTA(70))];
    NSValue * B = [NSValue valueWithCGPoint:CGPointMake(arc4random() %((int)SCREEN_WIDTH), SCREEN_HEIGHT+40)];
    moveAnimation.values = @[A,B];
    moveAnimation.duration = 3.5;
    moveAnimation.repeatCount = 1;
    [moveAnimation setFillMode:kCAFillModeForwards];
    [moveAnimation setRemovedOnCompletion:NO];
    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [movelayer addAnimation:moveAnimation forKey:@"move"];
}

- (void)endAnimation{
    if (self.redpacktTimer) {
        dispatch_source_cancel(self.redpacktTimer);
    }
    for (NSInteger i = 0; i < self.touchView.layer.sublayers.count ; i ++){
        CALayer * layer = self.touchView.layer.sublayers[i];
        [layer removeAllAnimations];
    }
    if (self.finishblock) {
        self.finishblock(self, @(self.clickedPackets.count));
        self.finishblock = nil;
    }
}

- (void)clickRed:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:self.touchView];
    for (int i = 0 ; i < self.touchView.layer.sublayers.count ; i ++){
        CALayer * layer = self.touchView.layer.sublayers[i];
        if ([[layer presentationLayer] hitTest:point] != nil){
            //            NSLog(@"%@=%@",NSStringFromCGRect([layer presentationLayer].frame),self.clickedPackets);
            ClickImageView * imageView=[[ClickImageView alloc] init];
            CGRect rect=[layer presentationLayer].frame;
            imageView.frame=rect;
            [self.clickedPackets addObject:imageView];
            NSInteger random=arc4random()%5;//随机生成六个
            switch (random) {
                case 0:
                    imageView.image=LoadBundleImage(@"金猪报喜");
                    break;
                case 1:
                    imageView.image=LoadBundleImage(@"金猪拱财");
                    break;
                case 2:
                    imageView.image=LoadBundleImage(@"金猪贺岁");
                    break;
                default:
                    imageView.image=LoadBundleImage(@"金猪送福");
                    break;
            }
            imageView.transform=CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            [layer removeAnimationForKey:@"move"];
            [layer removeFromSuperlayer];
            [self.packetRainView addSubview:imageView];
            [imageView disMiss];
            //只要点击了红包就记录日志，只记一次
            if (self.hadRecordLog==NO) {
                if (self.clickLogBlock) {
                    self.hadRecordLog=YES;
                    self.clickLogBlock();
                }
            }
            break;
        }
    }
}

//- (void)showLabelAtPoint:(CGPoint)point withText:(NSString *)text{
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(point.x - 50, point.y, 100, 30)];
//    label.font = [UIFont systemFontOfSize:19];
//    label.textColor = [UIColor yellowColor];
//    label.text=text;
//    [self.packetRainView addSubview:label];
//    [UIView animateWithDuration:1 animations:^{
//        label.alpha = 0;
//        label.frame = CGRectMake(point.x- 50, point.y - 100, 100, 30);
//    } completion:^(BOOL finished) {
//        [label removeFromSuperview];
//    }];
//}

#pragma mark - <setter and getter>
//- (UleLEDView *)mLEDView{
//    if (!_mLEDView) {
//        _mLEDView=[[UleLEDView alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-HORIZONTA(60)-20, SCREEN_WIDTH-20, HORIZONTA(60))];
//        _mLEDView.image=LoadBundleImage(@"LED公告栏");
//        _mLEDView.layer.zPosition=100;
//    }
//    return _mLEDView;
//}

@end
