//
//  US_NotificationAlertView.m
//  u_store
//
//  Created by xulei on 2018/5/23.
//

#import "US_NotificationAlertView.h"
#import "UIView+ShowAnimation.h"
#import <UIView+SDAutoLayout.h>

@interface US_NotificationAlertView ()
@property (nonatomic, strong) UIButton  *cancelBtn;

@end

@implementation US_NotificationAlertView

-(instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, KScreenScale(600), KScreenScale(600))];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        [self setUI];
    }
    return self;
}

-(void)setUI {
   UIView*bgView = [[UIView alloc]init];
    bgView.layer.cornerRadius=5.0;
    bgView.backgroundColor = [UIColor whiteColor];
    [self sd_addSubviews:@[bgView]];
    bgView.sd_layout.topSpaceToView(self, KScreenScale(50))
    .leftSpaceToView(self, KScreenScale(50))
    .rightSpaceToView(self, KScreenScale(50))
    .bottomSpaceToView(self, KScreenScale(50));
    
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.text=@"开启消息通知";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    
    
    UILabel *subTitleLab=[[UILabel alloc]init];
    subTitleLab.text=@"接收服务提醒";
    subTitleLab.textAlignment=NSTextAlignmentCenter;
    subTitleLab.font=[UIFont systemFontOfSize:KScreenScale(30)];
    subTitleLab.textColor=[UIColor convertHexToRGB:@"999999"];
    subTitleLab.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *lab1=[[UILabel alloc]init];
    lab1.text=@"1、及时了解客户下单情况；";
    lab1.adjustsFontSizeToFitWidth=YES;
    lab1.textColor=[UIColor convertHexToRGB:@"999999"];
    lab1.font=[UIFont systemFontOfSize:KScreenScale(28)];
    
    
    UILabel *lab2=[[UILabel alloc]init];
    lab2.text=@"2、收益到账及时提醒；";
    lab2.adjustsFontSizeToFitWidth=YES;
    lab2.textColor=[UIColor convertHexToRGB:@"999999"];
    lab2.font=[UIFont systemFontOfSize:KScreenScale(28)];
    
    
    UILabel *lab3=[[UILabel alloc]init];
    lab3.text=@"3、时时高佣、低价活动不再错过；";
    lab3.adjustsFontSizeToFitWidth=YES;
    lab3.textColor=[UIColor convertHexToRGB:@"999999"];
    lab3.font=[UIFont systemFontOfSize:KScreenScale(28)];
    
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:[UIImage bundleImageNamed:@"notify_permission_icon_close"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    cancelBtn.sd_layout
    .leftSpaceToView(bgView, -KScreenScale(30))
    .bottomSpaceToView(bgView, -KScreenScale(30))
    .widthIs(KScreenScale(60))
    .heightIs(KScreenScale(60));
    
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
    confirmBtn.layer.cornerRadius=5.0;
    [confirmBtn setTitle:@"允许开启" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=cancelBtn.titleLabel.font;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView sd_addSubviews:@[titleLab,subTitleLab,lab1,lab2,lab3,confirmBtn]];
    
    titleLab.sd_layout.topSpaceToView(bgView, KScreenScale(30))
    .leftSpaceToView(bgView, 0)
    .rightSpaceToView(bgView, 0)
    .heightIs(KScreenScale(50));
    
    subTitleLab.sd_layout.topSpaceToView(titleLab, KScreenScale(20))
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .heightIs(KScreenScale(40));
    
    lab1.sd_layout.topSpaceToView(subTitleLab, KScreenScale(30))
    .leftSpaceToView(bgView, KScreenScale(30))
    .rightSpaceToView(bgView, KScreenScale(30))
    .heightIs(KScreenScale(40));
    
    lab2.sd_layout.topSpaceToView(lab1, KScreenScale(30))
    .leftSpaceToView(bgView, KScreenScale(30))
    .rightSpaceToView(bgView, KScreenScale(30))
    .heightIs(KScreenScale(40));
    
    lab3.sd_layout.topSpaceToView(lab2, KScreenScale(30))
    .leftSpaceToView(bgView, KScreenScale(30))
    .rightSpaceToView(bgView, KScreenScale(30))
    .heightIs(KScreenScale(40));
    
    confirmBtn.sd_layout.topSpaceToView(lab3, KScreenScale(30))
    .leftEqualToView(lab3)
    .rightEqualToView(lab3)
    .heightIs(KScreenScale(90));
}

-(void)show{
    [self showViewWithAnimation:AniamtionAlert];
    [US_UserUtility sharedLogin].notificationAlertShowedDate = [NSDate date];
}

-(void)dismiss
{
    [self hiddenView];
}

-(void)confirmAction:(id)sender
{
    [self dismiss];
    NSURL *settingUrl=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication]canOpenURL:settingUrl]) {
        [[UIApplication sharedApplication] openURL:settingUrl];
    }
}

@end
