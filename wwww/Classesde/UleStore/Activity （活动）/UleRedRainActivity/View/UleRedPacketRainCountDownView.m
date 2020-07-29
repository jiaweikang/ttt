//
//  UleRedPacketRainCountDownView.m
//  UleApp
//
//  Created by zemengli on 2018/7/24.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleRedPacketRainCountDownView.h"
#import "UleRedPacketRainLocalManager.h"
#import "UIView+ShowAnimation.h"
#import "US_NotificationAlertView.h"
#import "UleRedPacketRainRuleView.h"
#import <UIView+SDAutoLayout.h>
#import "USAuthorizetionHelper.h"

#define KTimeLabelMargin 8
#define KTimeLabelWidth SCALEWIDTH(30)
#define KTimeLabelHeight SCALEWIDTH(45)
@interface UleRedPacketRainCountDownView (){
    NSTimeInterval  timeInterval;   //存放倒计时
    //BOOL isAddNotification;         //是否开启提醒
}
@property (nonatomic, strong) UIImageView * backImageView;
@property (nonatomic, strong) UIButton * closeButton;
@property (nonatomic, strong) UIButton * remindButton;

@property (nonatomic, strong) UILabel * hourLabel_s;
@property (nonatomic, strong) UILabel * hourLabel_g;
@property (nonatomic, strong) UILabel * minuteLabel_s;
@property (nonatomic, strong) UILabel * minuteLabel_g;
@property (nonatomic, strong) UILabel * secondLabel_s;
@property (nonatomic, strong) UILabel * secondLabel_g;

@property (nonatomic, strong) UIImageView * hourImage_s;
@property (nonatomic, strong) UIImageView * hourImage_g;
@property (nonatomic, strong) UIImageView * minuteImage_s;
@property (nonatomic, strong) UIImageView * minuteImage_g;
@property (nonatomic, strong) UIImageView * secondImage_s;
@property (nonatomic, strong) UIImageView * secondImage_g;
@property (nonatomic, assign) UleRedPacketRainViewType showType;

//@property (nonatomic, strong) NSTimer * countDownTime;
@property (nonatomic, strong) dispatch_source_t gcdCountDownTime;

@property (nonatomic, strong) UIImageView * gameEnterImage;
@end

@implementation UleRedPacketRainCountDownView

- (void)dealloc{
    [self closeTime];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithFrame:(CGRect)frame withType:(UleRedPacketRainViewType)type{
    self= [super initWithFrame:frame];
    self.showType=type;
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor=[UIColor clearColor];
    
    [self sd_addSubviews:@[self.backImageView,self.closeButton]];
    self.closeButton.sd_layout
    .topSpaceToView(self, 0)
    .centerXEqualToView(self)
    .widthIs(SCALEWIDTH(45))
    .heightIs(SCALEWIDTH(45));
    self.backImageView.sd_layout
    .topSpaceToView(self.closeButton, SCALEWIDTH(5))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(SCALEWIDTH(300));

    
    [UleRedPacketRainLocalManager sharedManager].isShowingActivityView=YES;
    
    //活动开始
    if (self.showType==UleRedPacketRainViewType_ActivityStart){
        [self setupActivityStartView];
    }
    //活动未开始
    else {
        [self setupCountDownView];
    }
}

- (void)startCountDownWithSecondTime:(NSTimeInterval)secondTime{
    if (self.showType!=UleRedPacketRainViewType_ActivityStart) {
        timeInterval=secondTime;
        [self startTime];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTimer)
                                                     name:@"CloseTimeNotification"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshTimer) name:@"updataCountDownTime"
                                                   object:nil];
    }
}

- (void)stopTimer{
    //记录当前时间
    NSDate *  localDate=[NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:localDate forKey:@"countDownStopTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self closeTime];
}

- (void)refreshTimer{
    NSDate *  nowTime=[NSDate date];
    NSDate *  stopTime=[[NSUserDefaults standardUserDefaults] objectForKey:@"countDownStopTime"];
    //算出时间差
    NSTimeInterval interval=[nowTime timeIntervalSinceDate:stopTime];
    timeInterval=timeInterval-interval;
    if (timeInterval>0) {
        [self startTime];
    }else{
        [self resetTimeLabel];
        [self closeTime];
        [self closeView];
    }
}

#pragma mark - 倒计时数据处理
//创建倒计时
-(void) startTime{
    [self closeTime];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _gcdCountDownTime= dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_gcdCountDownTime,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_gcdCountDownTime, ^{
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self timeFunction];
        });
        
    });
    dispatch_resume(_gcdCountDownTime);
}

-(void) closeTime{
    if (_gcdCountDownTime) {
        dispatch_source_cancel(_gcdCountDownTime);
        _gcdCountDownTime=nil;
    }
}

//倒计时处理
-(void) timeFunction{
    int hour;
    int minute;
    int second;

    int hour_s = 0;
    int hour_g = 0;;
    
    int minute_s = 0;
    int minute_g = 0;
    
    int second_s = 0;
    int second_g = 0;
    
    timeInterval--;
    if(timeInterval<0){
        timeInterval=-1;
    }
    else{
        hour=timeInterval/3600;
        minute=(timeInterval-hour*3600)/60;
        second=timeInterval-hour*3600-minute*60;

        hour_s=hour/10;
        hour_g=hour%10;
        
        minute_s=minute/10;
        minute_g=minute%10;
        
        second_s=second/10;
        second_g=second%10;
    }
    if ((int)timeInterval<0) {
        [self resetTimeLabel];
        [self closeTime];
        
        [self closeView];
    }else{
        [self.hourLabel_s setText:[NSString stringWithFormat:@"%d",hour_s]];
        [self.hourLabel_g setText:[NSString stringWithFormat:@"%d",hour_g]];
        [self.minuteLabel_s setText:[NSString stringWithFormat:@"%d",minute_s]];
        [self.minuteLabel_g setText:[NSString stringWithFormat:@"%d",minute_g]];
        [self.secondLabel_s setText:[NSString stringWithFormat:@"%d",second_s]];
        [self.secondLabel_g setText:[NSString stringWithFormat:@"%d",second_g]];
    }
}

- (void)resetTimeLabel{
    [self.hourLabel_s setText:@"0"];
    [self.hourLabel_g setText:@"0"];
    [self.minuteLabel_s setText:@"0"];
    [self.minuteLabel_g setText:@"0"];
    [self.secondLabel_s setText:@"0"];
    [self.secondLabel_g setText:@"0"];
}

//活动开始状态
- (void)setupActivityStartView{
    self.backImageView.image=[UIImage bundleImageNamed:@"redRainActivityStart_background"];
    [self.remindButton setBackgroundImage:[UIImage bundleImageNamed:@"redRain_ActivityStartButton"] forState:UIControlStateNormal];
    [self.backImageView sd_addSubviews:@[self.remindButton]];
    self.remindButton.sd_layout
    .bottomSpaceToView(self.backImageView, SCALEWIDTH(16))
    .centerXEqualToView(self.backImageView)
    .heightIs(SCALEWIDTH(110))
    .widthIs(SCALEWIDTH(120));
}

////活动倒计时状态
- (void)setupCountDownView{
    self.backImageView.image=[UIImage bundleImageNamed:@"redRainCountDownBackImg"];
    
    if (self.showType==UleRedPacketRainViewType_ActivityCountDown_Remind_ON) {
        [self.remindButton setBackgroundImage:[UIImage bundleImageNamed:@"redRainRemind_Opened"] forState:UIControlStateNormal];
    }
    else if(self.showType==UleRedPacketRainViewType_ActivityCountDown_Remind_OFF || ![USAuthorizetionHelper currentNotificationAllowed]){
        [self.remindButton setBackgroundImage:[UIImage bundleImageNamed:@"redRainRemind_ON"] forState:UIControlStateNormal];
    }
  /*
    UILabel * pointLab_L=[self createLabel];
    pointLab_L.text=@":";
    pointLab_L.font=[UIFont boldSystemFontOfSize:27.0f];
    UILabel * pointLab_R=[self createLabel];
    pointLab_R.text=@":";
    pointLab_R.font=[UIFont boldSystemFontOfSize:27.0f];
   */
    
    //游戏规则按钮
    UIButton * ruleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [ruleBtn setBackgroundColor:[UIColor clearColor]];
    [ruleBtn setImage:[UIImage bundleImageNamed:@"redRainCountDown_rule_button"] forState:UIControlStateNormal];
    [ruleBtn addTarget:self action:@selector(showRule:) forControlEvents:UIControlEventTouchUpInside];
    [self sd_addSubviews:@[ruleBtn,self.gameEnterImage]];
    self.gameEnterImage.sd_layout
    .topSpaceToView(self.backImageView, SCALEWIDTH(10))
    .leftSpaceToView(self, SCALEWIDTH(18))
    .rightSpaceToView(self, SCALEWIDTH(18))
    .heightIs(0);
    if ([UleRedPacketRainLocalManager sharedManager].enterGameImageUrl.length>0) {
        self.gameEnterImage.sd_layout.heightIs(SCALEWIDTH(70));
        [self.gameEnterImage yy_setImageWithURL:[NSURL URLWithString:[UleRedPacketRainLocalManager sharedManager].enterGameImageUrl] placeholder:nil];
        UITapGestureRecognizer * TapGesture= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(enterGameAction)];
        [self.gameEnterImage addGestureRecognizer:TapGesture];
    }
    ruleBtn.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self.gameEnterImage,0)
    .widthIs(SCALEWIDTH(155))
    .heightIs(SCALEWIDTH(40));
    
    UIView * middleLine=[[UIView alloc] init];
    middleLine.backgroundColor=[UIColor clearColor];
    [self.backImageView sd_addSubviews:@[self.remindButton,middleLine,self.hourImage_g,self.hourImage_s,self.minuteImage_s,self.minuteImage_g,self.secondImage_s,self.secondImage_g]];
    
    self.remindButton.sd_layout
    .bottomSpaceToView(self.backImageView, SCALEWIDTH(25))
    .centerXEqualToView(self.backImageView)
    .heightIs(SCALEWIDTH(50))
    .widthIs(SCALEWIDTH(194));

    //中间对齐用
    middleLine.sd_layout
    .topSpaceToView(self.backImageView, SCALEWIDTH(143))
    .centerXEqualToView(self.backImageView)
    .widthIs(0.1)
    .heightIs(KTimeLabelHeight);
    self.minuteImage_s.sd_layout
    .rightSpaceToView(middleLine, KTimeLabelMargin*0.25)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    //    pointLab_L.sd_layout
    //    .rightSpaceToView(self.minuteImage_s, 0)
    //    .topEqualToView(middleLine)
    //    .widthIs(12)
    //    .heightIs(KTimeLabelHeight-4);
    self.hourImage_g.sd_layout
    .rightSpaceToView(self.minuteImage_s, KTimeLabelMargin)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    self.hourImage_s.sd_layout
    .rightSpaceToView(self.hourImage_g, KTimeLabelMargin*0.5)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    
    self.minuteImage_g.sd_layout
    .leftSpaceToView(middleLine, KTimeLabelMargin*0.25)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    //    pointLab_R.sd_layout
    //    .leftSpaceToView(self.minuteImage_g, 0)
    //    .topEqualToView(middleLine)
    //    .widthIs(12)
    //    .heightIs(KTimeLabelHeight-4);
    
    self.secondImage_s.sd_layout
    .leftSpaceToView(self.minuteImage_g, KTimeLabelMargin)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    self.secondImage_g.sd_layout
    .leftSpaceToView(self.secondImage_s, KTimeLabelMargin*0.5)
    .bottomEqualToView(middleLine)
    .widthIs(KTimeLabelWidth)
    .heightIs(KTimeLabelHeight);
    
    [self.backImageView bringSubviewToFront:self.remindButton];
}
#pragma mark - 点击事件
- (void)showRule:(id)sender{
    [UleRedPacketRainRuleView showRuleViewAtRootView:[self superview] ruleHtmlPath:kRulePath];
}
//点击红包雨图片 进入玩游戏网页
- (void)enterGameAction{
    if([UleRedPacketRainLocalManager sharedManager].enterGameImageUrl.length>0 && [UleRedPacketRainLocalManager sharedManager].enterGameiOSURL.length>0){
        [self closeView];
        
        [UleRedPacketRainLocalManager sharedManager].redRainModel.userId=[US_UserUtility sharedLogin].m_userId;
        [UleRedPacketRainLocalManager sharedManager].redRainModel.province=[US_UserUtility sharedLogin].m_provinceCode;
        [UleRedPacketRainLocalManager sharedManager].redRainModel.channel=UleRedPacketRainChannel;
        [UleRedPacketRainLocalManager sharedManager].redRainModel.deviceId=[US_UserUtility sharedLogin].openUDID;
        // h5游戏点击日志
        [UleRedPacketRainManager startRecordLogWithEventName:@"RedPacketsH5Game" environment:[UleStoreGlobal shareInstance].config.envSer withModel:[UleRedPacketRainLocalManager sharedManager].redRainModel];
        
        [[UleRedPacketRainLocalManager sharedManager] enterGameAction];
    }
}

- (void)closeView{
    [UleRedPacketRainLocalManager sharedManager].isShowingActivityView=NO;
    [self closeTime];
    [self hiddenView];
}

- (void)remindButtonClick:(UIButton *)button{
    switch (self.showType) {
        case UleRedPacketRainViewType_ActivityStart:
            [self closeView];
            break;
        case UleRedPacketRainViewType_ActivityCountDown_Remind_ON:
        {
            self.showType=UleRedPacketRainViewType_ActivityCountDown_Remind_OFF;
            [self.remindButton setBackgroundImage:[UIImage bundleImageNamed:@"redRainRemind_ON"] forState:UIControlStateNormal];
            NSLog(@"关闭提醒");
        }
            break;
        case UleRedPacketRainViewType_ActivityCountDown_Remind_OFF:
        {
            //如果没有权限  提醒用户开启
            if (![USAuthorizetionHelper currentNotificationAllowed]){
                US_NotificationAlertView *notiAlertView=[[US_NotificationAlertView alloc]init];
                [notiAlertView show];
                return;
            }
            self.showType=UleRedPacketRainViewType_ActivityCountDown_Remind_ON;
            [self.remindButton setBackgroundImage:[UIImage bundleImageNamed:@"redRainRemind_Opened"] forState:UIControlStateNormal];
            NSLog(@"开启提醒");
        }
            break;
        default:
            break;
    }
    
    self.clickBlock(self.showType);

}

- (void)showAlrtToSetting{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"开启通知，第一时间抢亿元红包" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去开启", nil];
    alert.tag=100;
    [alert show];
}

#pragma mark - setter and getter
- (UIImageView *) backImageView{
    if (_backImageView==nil) {
        _backImageView=[[UIImageView alloc] init];
        _backImageView.userInteractionEnabled=YES;
    }
    return _backImageView;
}

- (UIButton *)closeButton{
    if (_closeButton==nil) {
        _closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage bundleImageNamed:@"CountDoenClose"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIButton *)remindButton{
    if (_remindButton==nil) {
        _remindButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_remindButton addTarget:self action:@selector(remindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _remindButton;
}

- (UILabel *)hourLabel_s{
    if (_hourLabel_s==nil) {
        _hourLabel_s=[self createLabel];
    }
    return _hourLabel_s;
}
- (UILabel *)hourLabel_g{
    if (_hourLabel_g==nil) {
        _hourLabel_g=[self createLabel];
    }
    return _hourLabel_g;
}
- (UILabel *)minuteLabel_s{
    if (_minuteLabel_s==nil) {
        _minuteLabel_s=[self createLabel];
    }
    return _minuteLabel_s;
}
- (UILabel *)minuteLabel_g{
    if (_minuteLabel_g==nil) {
        _minuteLabel_g=[self createLabel];
    }
    return _minuteLabel_g;
}
- (UILabel *)secondLabel_s{
    if (_secondLabel_s==nil) {
        _secondLabel_s=[self createLabel];
    }
    return _secondLabel_s;
}
- (UILabel *)secondLabel_g{
    if (_secondLabel_g==nil) {
        _secondLabel_g=[self createLabel];
    }
    return _secondLabel_g;
}
//小时 十位
- (UIImageView *)hourImage_s{
    if (_hourImage_s==nil) {
        _hourImage_s=[self createLabelImage];
        [_hourImage_s addSubview:self.hourLabel_s];
    }
    return _hourImage_s;
}
//小时 个位
- (UIImageView *)hourImage_g{
    if (_hourImage_g==nil) {
        _hourImage_g=[self createLabelImage];
        [_hourImage_g addSubview:self.hourLabel_g];
    }
    return _hourImage_g;
}
//分钟 十位
- (UIImageView *)minuteImage_s{
    if (_minuteImage_s==nil) {
        _minuteImage_s=[self createLabelImage];
        [_minuteImage_s addSubview:self.minuteLabel_s];
    }
    return _minuteImage_s;
}
//分钟 个位
- (UIImageView *)minuteImage_g{
    if (_minuteImage_g==nil) {
        _minuteImage_g=[self createLabelImage];
        [_minuteImage_g addSubview:self.minuteLabel_g];
    }
    return _minuteImage_g;
}
//秒 十位
- (UIImageView *)secondImage_s{
    if (_secondImage_s==nil) {
        _secondImage_s=[self createLabelImage];
        [_secondImage_s addSubview:self.secondLabel_s];
    }
    return _secondImage_s;
}
//秒 个位
- (UIImageView *)secondImage_g{
    if (_secondImage_g==nil) {
        _secondImage_g=[self createLabelImage];
        [_secondImage_g addSubview:self.secondLabel_g];
    }
    return _secondImage_g;
}
- (UIImageView *)createLabelImage{
    UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KTimeLabelWidth, KTimeLabelHeight)];
    [image setImage:[UIImage bundleImageNamed:@"countDownLabel_Background"]];
    return image;
}
- (UILabel *)createLabel{
    UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, SCALEWIDTH(8), KTimeLabelWidth, KTimeLabelHeight-SCALEWIDTH(8))];
    label.font=[UIFont boldSystemFontOfSize:SCALEWIDTH(24.0f)];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor convertHexToRGB:@"da0000"];
    return label;
}

- (UIImageView *)gameEnterImage{
    if (_gameEnterImage==nil) {
        _gameEnterImage=[[UIImageView alloc]init];
        _gameEnterImage.userInteractionEnabled=YES;
    }
    return _gameEnterImage;
}

@end
