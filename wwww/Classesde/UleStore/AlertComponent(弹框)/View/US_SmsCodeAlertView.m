//
//  US_SmsCodeAlertView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_SmsCodeAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_SmsCodeAlertView ()

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) ConfirmActionBlock confirmBlock;

@property (nonatomic, strong) UILabel *phoneLab;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *cancelBtn;

@end
@implementation US_SmsCodeAlertView

+(US_SmsCodeAlertView *)smsCodeAlertViewWithPhoneNum:(NSString *)phoneNum confirmAction:(ConfirmActionBlock)confirmBlock{
    return [[self alloc] initWithPhoneNum:phoneNum confirmAction:confirmBlock];
}
-(instancetype)initWithPhoneNum:(NSString *)phoneNum confirmAction:(ConfirmActionBlock)confirmBlock
{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]){
        _phoneNum = phoneNum;
        _confirmBlock = confirmBlock;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=5.0;
    
    UILabel *titleLab0=[[UILabel alloc]init];
    titleLab0.textAlignment=NSTextAlignmentCenter;
    titleLab0.font=[UIFont systemFontOfSize:KScreenScale(33)];
    titleLab0.text=@"我们将发送短信验证码至手机号";
    titleLab0.textColor=[UIColor convertHexToRGB:@"333333"];
    
    _phoneLab=[[UILabel alloc]init];
    _phoneLab.textAlignment=NSTextAlignmentCenter;
    _phoneLab.font=titleLab0.font;
    _phoneLab.text=_phoneNum;
    _phoneLab.textColor=titleLab0.textColor;
    _phoneLab.numberOfLines = 0;
    
    UILabel *titleLab1=[[UILabel alloc]init];
    titleLab1.textAlignment=NSTextAlignmentCenter;
    titleLab1.font=titleLab0.font;
    titleLab1.text=@"请注意查收";
    titleLab1.textColor=titleLab0.textColor;
    
    _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.backgroundColor=[UIColor whiteColor];
    _cancelBtn.layer.borderWidth=1.0;
    _cancelBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    _cancelBtn.layer.cornerRadius=5.0;
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(36)];
    [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
    _confirmBtn.layer.cornerRadius=5.0;
    [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
    _confirmBtn.titleLabel.font=_cancelBtn.titleLabel.font;
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self sd_addSubviews:@[titleLab0,_phoneLab,titleLab1,_cancelBtn,_confirmBtn]];
    titleLab0.sd_layout
    .topSpaceToView(self, KScreenScale(74))
    .leftSpaceToView(self, 10).rightSpaceToView(self, 10)
    .heightIs(KScreenScale(40));
    _phoneLab.sd_layout
    .topSpaceToView(titleLab0, KScreenScale(18))
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(40));
    titleLab1.sd_layout
    .topSpaceToView(_phoneLab, KScreenScale(18))
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(40));
    
    _cancelBtn.sd_layout
    .bottomSpaceToView(self, KScreenScale(30))
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs(__MainScreen_Width/2-KScreenScale(15)-KScreenScale(20))
    .heightIs(KScreenScale(90));
    _confirmBtn.sd_layout
    .bottomEqualToView(_cancelBtn)
    .rightSpaceToView(self, KScreenScale(20))
    .widthRatioToView(_cancelBtn, 1)
    .heightRatioToView(_cancelBtn, 1);
}

-(void)dismiss
{
    [self hiddenView];
}

-(void)confirmAction:(id)sender
{
    [self hiddenView];
    if (_confirmBlock) {
        _confirmBlock();
    }
}
@end
