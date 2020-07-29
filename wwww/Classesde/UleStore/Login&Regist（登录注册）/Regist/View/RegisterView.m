//
//  RegisterView.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/12.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "RegisterView.h"
#import <UIView+SDAutoLayout.h>
#import "WBPopOverView.h"
#import "DeviceInfoHelper.h"

static NSInteger const kMaxLength = 15;

@interface RegisterTopView () <UITextFieldDelegate>
@property (nonatomic, strong)UITextField    *storeName_TF;
@property (nonatomic, strong)UILabel        *switchStateLab;
@property (nonatomic, strong)UILabel        *desLab;
@property (nonatomic, strong)UIView         *exitTeamView;

@property (nonatomic, assign)BOOL   isTextFieldInputed;//被操作过

@end

@implementation RegisterTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    //店铺名
    UILabel *storeNameTitle=[[UILabel alloc]init];
    storeNameTitle.text=@"店铺名称";
    storeNameTitle.textAlignment = NSTextAlignmentRight;
    storeNameTitle.textColor=[UIColor convertHexToRGB:@"666666"];
    storeNameTitle.font=[UIFont systemFontOfSize:KScreenScale(33)];
    [self addSubview:storeNameTitle];
    CGFloat storeNameTitleW = [storeNameTitle.text widthForFont:storeNameTitle.font]+3;
    storeNameTitle.sd_layout.topSpaceToView(self, KScreenScale(60))
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs(storeNameTitleW)
    .heightIs(25);
    UIView *storeNameBg=[[UIView alloc]init];
    storeNameBg.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
    storeNameBg.layer.cornerRadius=5.0;
    [self addSubview:storeNameBg];
    [storeNameBg addSubview:self.storeName_TF];
    storeNameBg.sd_layout.centerYEqualToView(storeNameTitle)
    .leftSpaceToView(storeNameTitle, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(KScreenScale(80));
    self.storeName_TF.sd_layout.centerYEqualToView(storeNameBg)
    .leftSpaceToView(storeNameBg, KScreenScale(30))
    .rightSpaceToView(storeNameBg, 0)
    .heightIs(KScreenScale(50));
    //手机号
    UILabel *phoneTitle=[[UILabel alloc]init];
    phoneTitle.text=@"手机号";
    phoneTitle.textAlignment = NSTextAlignmentRight;
    phoneTitle.textColor=[UIColor convertHexToRGB:@"666666"];
    phoneTitle.font=[UIFont systemFontOfSize:KScreenScale(33)];
    [self addSubview:phoneTitle];
    phoneTitle.sd_layout.topSpaceToView(storeNameTitle, KScreenScale(50))
    .leftEqualToView(storeNameTitle)
    .rightEqualToView(storeNameTitle)
    .heightRatioToView(storeNameTitle, 1.0);
    [self addSubview:self.phoneNum_TF];
    self.phoneNum_TF.sd_layout.leftSpaceToView(phoneTitle, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(30))
    .centerYEqualToView(phoneTitle)
    .heightRatioToView(phoneTitle, 1.0);
    
    //线
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
    [self addSubview:lineView];
    lineView.sd_layout.topSpaceToView(phoneTitle, KScreenScale(50))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(16));
    //我是企业用户
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.font=[UIFont systemFontOfSize:KScreenScale(34)];
    titleLab.text=@"我是企业用户";
    titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    [self addSubview:titleLab];
    CGFloat titleLabW = [titleLab.text widthForFont:titleLab.font]+3;
    titleLab.sd_layout.topSpaceToView(lineView, KScreenScale(50))
    .leftSpaceToView(self, KScreenScale(30))
    .widthIs(titleLabW)
    .heightIs(40);
    UIButton *quesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [quesBtn setImage:[UIImage bundleImageNamed:@"regist_btn_question"] forState:UIControlStateNormal];
    [quesBtn addTarget:self action:@selector(quesBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quesBtn];
    quesBtn.sd_layout.centerYEqualToView(titleLab)
    .leftSpaceToView(titleLab, 0)
    .widthIs(30)
    .heightIs(30);
    self.desLab=[[UILabel alloc]init];
    self.desLab.text=@"开启完善我的员工信息";
    self.desLab.textColor=[UIColor convertHexToRGB:@"666666"];
    self.desLab.font=[UIFont systemFontOfSize:KScreenScale(31)];
    [self addSubview:self.desLab];
    CGFloat desLabW = [self.desLab.text widthForFont:self.desLab.font]+5;
    self.desLab.sd_layout.topSpaceToView(titleLab, 0)
    .leftSpaceToView(self, KScreenScale(30))
    .widthIs(desLabW)
    .heightIs(30);
    [self addSubview:self.switchControl];
    self.switchControl.sd_layout.centerYEqualToView(titleLab)
    .rightSpaceToView(self, KScreenScale(30))
    .widthIs(CGRectGetWidth(self.switchStateLab.bounds))
    .heightIs(CGRectGetHeight(self.switchStateLab.bounds));
    [self addSubview:self.switchStateLab];
    CGFloat swStatusLabW=[self.switchStateLab.text widthForFont:self.switchStateLab.font]+5;
    self.switchStateLab.sd_layout.centerXEqualToView(self.switchControl)
    .topEqualToView(self.desLab)
    .widthIs(swStatusLabW)
    .heightRatioToView(self.desLab, 1.0);
    
    //退出战队提示
    [self addSubview:self.exitTeamView];
    self.exitTeamView.sd_layout.topSpaceToView(titleLab, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(70));
    self.exitTeamView.hidden = YES;
}

#pragma mark - <UITextFieldDelegate>
-(void)textFiledEditChanged:(NSNotification *)obj
{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
                [self hudShow:@"店铺名称不能超过15个字哦" delay:2.0];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
            [self hudShow:@"店铺名称不能超过15个字哦" delay:2.0];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    self.isTextFieldInputed=YES;
    NSInteger length = textField.text.length - range.length + string.length;
    if (textField==self.phoneNum_TF) {
        return length<=11;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.storeName_TF) {
        self.storeName = textField.text;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.storeName_TF) {
        self.storeName = textField.text;
    }
}


#pragma mark - <action>
- (void)quesBtnAction:(UIButton *)sender {
    NSString *str=@"请正确选择您的所属机构，以确保业绩的准确统计";
    CGPoint point=CGPointMake(sender.frame.origin.x+sender.frame.size.width/2, sender.frame.origin.y);//箭头点的位置
    CGPoint a = [self convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
    
    CGFloat maxWidth=__MainScreen_Width-CGRectGetMaxX(sender.frame)+KScreenScale(200);
    CGFloat labW=[str widthForFont:[UIFont systemFontOfSize:KScreenScale(26)]]+10;
    CGFloat adjustW=(labW>maxWidth?maxWidth:labW)+10;
    
    WBPopOverView *view=[[WBPopOverView alloc]initWithOrigin:a Width:adjustW Height:60 Direction:WBArrowDirectionDown1];//初始化弹出视图的箭头顶点位置point，展示视图的宽度Width，高度Height，Direction以及展示的方向
    view.backView.layer.cornerRadius=5.0;
    view.backView.backgroundColor=[UIColor convertHexToRGB:@"36a4f1"];
    UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, adjustW-10, 50)];
    lable.numberOfLines=2;
    lable.text=@"温馨提示：\n请正确选择您的所属机构，以确保业绩的准确统计";
    lable.textColor=[UIColor whiteColor];
    lable.textAlignment=NSTextAlignmentLeft;
    lable.font=[UIFont systemFontOfSize:KScreenScale(26)];
    if (labW>maxWidth) {
        lable.adjustsFontSizeToFitWidth=YES;
    }
    [view.backView addSubview:lable];
    [view popViewAtSuperView:nil];
}

- (void)setMobileNum:(NSString *)phoneNum isUserInteractionEnabled:(BOOL)isEnabled
{
    self.phoneNum_TF.text = [NSString isNullToString:phoneNum];
    self.phoneNum_TF.userInteractionEnabled = isEnabled;
}

- (void)setRegistTopStoreName:(NSString *)storeName
{
    self.storeName_TF.text = [NSString isNullToString:[NSString stringWithFormat:@"%@", storeName]];
    self.storeName = self.storeName_TF.text;
}

- (void)lockRegistTopView
{
    self.desLab.hidden=YES;
    self.switchControl.hidden=YES;
    self.switchStateLab.hidden=YES;
}

- (void)showTeamExitView:(BOOL)isShow{
    self.desLab.hidden=isShow;
    self.switchControl.hidden=isShow;
    self.switchStateLab.hidden=isShow;
    self.exitTeamView.hidden=!isShow;
}

-(void)shiftUserStatus:(UISwitch *)sw {
    self.switchStateLab.text=sw.isOn?@"开启":@"关闭";
    if (self.registTopviewDelegate&&[self.registTopviewDelegate respondsToSelector:@selector(registViewShiftSwitchStatusIsOn:)]) {
        [self.registTopviewDelegate registViewShiftSwitchStatusIsOn:sw.isOn];
    }
}

- (void)hudShow:(NSString *)text delay:(NSTimeInterval)interval
{
    if (self.registTopviewDelegate&&[self.registTopviewDelegate respondsToSelector:@selector(registViewShowHudWithText:delay:)]) {
        [self.registTopviewDelegate registViewShowHudWithText:text delay:interval];
    }
}

- (void)exitTeamAction{
    NSString *action = [NSString stringWithFormat:@"WebDetailViewController::0&&key::%@/event/2018/0816/dist/index.html#/##hasnavi::0",[UleStoreGlobal shareInstance].config.ulecomDomain];
    UleUCiOSAction *moduleAction = [UleModulesDataToAction resolveModulesActionStr:action];
    if (self.registTopviewDelegate&&[self.registTopviewDelegate respondsToSelector:@selector(registPushNewViewController:)]) {
        [self.registTopviewDelegate registPushNewViewController:moduleAction];
    }
}
#pragma mark - <getter>
- (UITextField *)phoneNum_TF
{
    if (!_phoneNum_TF) {
        _phoneNum_TF = [[UITextField alloc] init];
        _phoneNum_TF.delegate = self;
        _phoneNum_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNum_TF.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNum_TF.textColor=[UIColor convertHexToRGB:@"333333"];
        _phoneNum_TF.placeholder = @"输入您的手机号";
        _phoneNum_TF.font = [UIFont systemFontOfSize:KScreenScale(32)];
    }
    return _phoneNum_TF;
}

- (UITextField *)storeName_TF
{
    if (!_storeName_TF) {
        _storeName_TF = [[UITextField alloc]init];
        _storeName_TF.delegate = self;
        _storeName_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _storeName_TF.placeholder = [DeviceInfoHelper getAppName];
        _storeName_TF.font = [UIFont systemFontOfSize:KScreenScale(32)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_storeName_TF];
    }
    return _storeName_TF;
}

- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc]init];
        [_switchControl setOn:NO];
        [_switchControl addTarget:self action:@selector(shiftUserStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

- (UILabel *)switchStateLab
{
    if (!_switchStateLab) {
        _switchStateLab=[[UILabel alloc]init];
        _switchStateLab.textAlignment=NSTextAlignmentCenter;
        _switchStateLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _switchStateLab.font=[UIFont systemFontOfSize:KScreenScale(31)];
        _switchStateLab.text=@"关闭";
    }
    return _switchStateLab;
}

- (UIView *)exitTeamView{
    if (!_exitTeamView) {
        _exitTeamView = [[UIView alloc]init];
        _exitTeamView.backgroundColor = [UIColor convertHexToRGB:@"FFF1DC"];
     
        UIButton *teamButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [teamButton setTitle:@"立即前往" forState:(UIControlStateNormal)];
        [teamButton setTitleColor:[UIColor convertHexToRGB:@"ED4B4C"] forState:(UIControlStateNormal)];
        teamButton.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        teamButton.layer.borderColor = [UIColor convertHexToRGB:@"ED4B4C"].CGColor;
        teamButton.layer.borderWidth = KScreenScale(1);
        teamButton.layer.cornerRadius = KScreenScale(24);
        [teamButton addTarget:self action:@selector(exitTeamAction) forControlEvents:(UIControlEventTouchUpInside)];
        [_exitTeamView addSubview:teamButton];
        teamButton.sd_layout.rightSpaceToView(_exitTeamView, KScreenScale(20))
        .centerYEqualToView(_exitTeamView)
        .widthIs(KScreenScale(154))
        .heightRatioToView(_exitTeamView, 0.6);
        
        UILabel *teamLabel = [[UILabel alloc] init];
        teamLabel.text = @"请先退出战队再修改机构信息";
        teamLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        teamLabel.textColor = [UIColor convertHexToRGB:@"ED4B4C"];
        [_exitTeamView addSubview:teamLabel];
        teamLabel.sd_layout.leftSpaceToView(_exitTeamView, KScreenScale(22))
        .rightSpaceToView(teamButton, KScreenScale(10))
        .centerYEqualToView(_exitTeamView)
        .heightRatioToView(_exitTeamView, 1.0);
    }
    return _exitTeamView;
}

@end

static NSInteger const tag_enterpriseBGView = 1002;
static NSInteger const tag_organizeBGView = 1003;
static NSInteger const tag_enterpriseRightImg = 1004;
static NSInteger const tag_organizeRightImg = 1005;
@interface RegisterCenterView ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField    *realName_TF;
@property (nonatomic, assign)BOOL   isTextFieldInputed;//被操作过

@end

@implementation RegisterCenterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
    UILabel *redHint = [[UILabel alloc] init];
    redHint.textColor = kCommonRedColor;
    redHint.text = @"（标注*为必填选项）";
    redHint.font = [UIFont systemFontOfSize:KScreenScale(24)];
    [self addSubview:lineView];
    [self addSubview:redHint];
    lineView.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(0);
    redHint.sd_layout.topSpaceToView(lineView, 5)
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(KScreenScale(40));
    
    /***********真实姓名************/
    UILabel *symbol = [[UILabel alloc] init];
    symbol.textAlignment = NSTextAlignmentCenter;
    symbol.text = @"*";
    symbol.textColor = kCommonRedColor;
    symbol.font = [UIFont systemFontOfSize:KScreenScale(24)];
    
    UILabel *lab=[[UILabel alloc]init];
    lab.textColor=[UIColor convertHexToRGB:@"666666"];
    lab.font=[UIFont systemFontOfSize:KScreenScale(28)];
    lab.text=@"真实姓名";
    
    //选择所在机构
    UIView *selBgView = [[UIView alloc]init];
    selBgView.backgroundColor = [UIColor whiteColor];
    selBgView.layer.cornerRadius = 5;
    selBgView.layer.borderColor=[UIColor convertHexToRGB:@"cccccc"].CGColor;
    selBgView.layer.borderWidth=0.7;
    
    [self addSubview:symbol];
    [self addSubview:lab];
    [selBgView addSubview:self.realName_TF];
    [self addSubview:selBgView];
    symbol.sd_layout.topSpaceToView(lineView, KScreenScale(50) + 7.5)
    .leftEqualToView(lineView)
    .widthIs(10)
    .heightIs(15);
    
    CGFloat labW=[lab.text widthForFont:lab.font] + 5;
    lab.sd_layout.centerYEqualToView(symbol)
    .leftSpaceToView(symbol, 10)
    .widthIs(labW)
    .heightIs(25);
    selBgView.sd_layout.leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .topSpaceToView(lab, KScreenScale(20))
    .heightIs(KScreenScale(100));
    self.realName_TF.sd_layout.topSpaceToView(selBgView, KScreenScale(30))
    .leftSpaceToView(selBgView, KScreenScale(30))
    .bottomSpaceToView(selBgView, KScreenScale(30))
    .rightSpaceToView(selBgView, KScreenScale(30));
 
    /***********所属企业************/
    UILabel *symbol2 = [[UILabel alloc] init];
    symbol2.textAlignment = NSTextAlignmentCenter;
    symbol2.text = @"*";
    symbol2.textColor = kCommonRedColor;
    symbol2.font = [UIFont systemFontOfSize:KScreenScale(24)];
    [self addSubview:symbol2];
    UILabel *lab2=[[UILabel alloc]init];
    lab2.textColor=[UIColor convertHexToRGB:@"666666"];
    lab2.font=[UIFont systemFontOfSize:KScreenScale(28)];
    lab2.text=@"所属企业";
    [self addSubview:lab2];
    //选择所在企业
    UIView *selBgView2 = [[UIView alloc]init];
    selBgView2.backgroundColor = [UIColor whiteColor];
    selBgView2.layer.cornerRadius = 5;
    selBgView2.layer.borderColor=[UIColor convertHexToRGB:@"cccccc"].CGColor;
    selBgView2.layer.borderWidth=0.7;
    selBgView2.tag = tag_enterpriseBGView;
    selBgView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPickEnterprise:)];
    [selBgView2 addGestureRecognizer:tapGes2];
    [self addSubview:selBgView2];
    [selBgView2 addSubview:self.enterprise_TF];
    UIImageView *enterpriseRightImgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"regist_img_arrow_right"]];
    enterpriseRightImgView.tag = tag_enterpriseRightImg;
    [selBgView2 addSubview:enterpriseRightImgView];
    
    symbol2.sd_layout.topSpaceToView(selBgView, KScreenScale(40) + 7.5)
    .leftEqualToView(lineView)
    .widthIs(10)
    .heightIs(15);
    CGFloat labW2=[lab2.text widthForFont:lab.font]+5;
    lab2.sd_layout.topSpaceToView(selBgView, KScreenScale(40))
    .leftSpaceToView(symbol2, 10)
    .widthIs(labW2)
    .heightIs(25);
    selBgView2.sd_layout.topSpaceToView(lab2, KScreenScale(20))
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(KScreenScale(100));
    enterpriseRightImgView.sd_layout.topSpaceToView(selBgView2, KScreenScale(30))
    .rightSpaceToView(selBgView2, 10)
    .widthIs(KScreenScale(40))
    .heightIs(KScreenScale(40));
    self.enterprise_TF.sd_layout.centerYEqualToView(enterpriseRightImgView)
    .leftSpaceToView(selBgView2, KScreenScale(30))
    .rightSpaceToView(enterpriseRightImgView, 5)
    .heightRatioToView(enterpriseRightImgView, 1.0);
    
    /***********所属机构************/
    UILabel *symbol3 = [[UILabel alloc] init];
    symbol3.textAlignment = 1;
    symbol3.text = @"*";
    symbol3.textColor = kCommonRedColor;
    symbol3.font = [UIFont systemFontOfSize:KScreenScale(24)];
    [self addSubview:symbol3];
    
    UILabel *lab3=[[UILabel alloc]init];
    lab3.textColor=[UIColor convertHexToRGB:@"666666"];
    lab3.font=[UIFont systemFontOfSize:KScreenScale(28)];
    lab3.text=@"所属机构";
    [self addSubview:lab3];
    
    //选择所在机构
    UIView *selBgView3 = [[UIView alloc]init];
    selBgView3.backgroundColor = [UIColor whiteColor];
    selBgView3.layer.cornerRadius = 5;
    selBgView3.layer.borderColor=[UIColor convertHexToRGB:@"cccccc"].CGColor;
    selBgView3.layer.borderWidth=0.7;
    selBgView3.tag = tag_organizeBGView;
    selBgView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToPickOrganization:)];
    [selBgView3 addGestureRecognizer:tapGes3];
    [self addSubview:selBgView3];
    [selBgView3 addSubview:self.organization_TF];
    UIImageView *organizeRightImgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"regist_img_arrow_right"]];
    organizeRightImgView.tag = tag_organizeRightImg;
    [selBgView3 addSubview:organizeRightImgView];
    
    symbol3.sd_layout.topSpaceToView(selBgView2, KScreenScale(40) + 7.5)
    .leftEqualToView(lineView)
    .widthIs(10)
    .heightIs(15);
    CGFloat labW3=[lab3.text widthForFont:lab.font]+5;
    lab3.sd_layout.topSpaceToView(selBgView2, KScreenScale(40))
    .leftSpaceToView(symbol3, 10)
    .widthIs(labW3)
    .heightIs(25);
    selBgView3.sd_layout.topSpaceToView(lab3, KScreenScale(20))
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(KScreenScale(100));
    organizeRightImgView.sd_layout.topSpaceToView(selBgView3, KScreenScale(30))
    .rightSpaceToView(selBgView3, 10)
    .widthIs(KScreenScale(40))
    .heightIs(KScreenScale(40));
    
    self.organization_TF.sd_layout.centerYEqualToView(organizeRightImgView)
    .leftSpaceToView(selBgView3, KScreenScale(30))
    .rightSpaceToView(organizeRightImgView, 5)
    .heightRatioToView(organizeRightImgView, 1.0);
}

#pragma mark - <ACTION>
- (void)setRegistCenterRealName:(NSString *)realName
{
    self.realName_TF.text = [NSString isNullToString:realName];
    self.realName = self.realName_TF.text;
}

- (void)setRegistCenterEnterpriseName:(NSString *)enterPriseName
{
    self.enterprise_TF.text = [NSString isNullToString:enterPriseName];
}

- (void)setRegistCenterOrganizationName:(NSString *)organizationName
{
    self.organization_TF.text = [NSString isNullToString:organizationName];
}

- (void)lockRegistCenterView:(BOOL)isLock
{
//    self.realName_TF.userInteractionEnabled = NO;
//    UIView *enterBGView = [self viewWithTag:tag_enterpriseBGView];
//    UIView *organBGView = [self viewWithTag:tag_organizeBGView];
//    enterBGView.userInteractionEnabled=NO;
//    organBGView.userInteractionEnabled=NO;
//    self.realName_TF.textColor = [UIColor convertHexToRGB:@"C7C7CD"];
//    self.enterprise_TF.textColor = [UIColor convertHexToRGB:@"C7C7CD"];
//    self.organization_TF.textColor = [UIColor convertHexToRGB:@"C7C7CD"];
    UIView *enterBGView = [self viewWithTag:tag_enterpriseBGView];
    UIView *organBGView = [self viewWithTag:tag_organizeBGView];
    UIImageView *enterRightImg = [self viewWithTag:tag_enterpriseRightImg];
    UIImageView *organRightImg = [self viewWithTag:tag_organizeRightImg];
    enterBGView.userInteractionEnabled=!isLock;
    organBGView.userInteractionEnabled=!isLock;
    enterBGView.layer.borderWidth = isLock ? 0 : 0.7;
    organBGView.layer.borderWidth = isLock ? 0 : 0.7;
    enterRightImg.hidden = isLock;
    organRightImg.hidden = isLock;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    self.isTextFieldInputed=YES;
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.realName_TF) {
        self.realName = textField.text;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.realName_TF) {
        self.realName = textField.text;
    }
}
#pragma mark - <action>
- (void)pushToPickEnterprise:(UIGestureRecognizer *)ges
{
    if (self.registCenterviewDelegate&&[self.registCenterviewDelegate respondsToSelector:@selector(registViewPushToPick:)]) {
        [self.registCenterviewDelegate registViewPushToPick:1];
    }
}

- (void)pushToPickOrganization:(UIGestureRecognizer *)ges
{
    if (self.enterprise_TF.text.length==0) {
        [self hudShow:@"请选择所属企业" delay:1.5];
        return;
    }
    if (self.registCenterviewDelegate&&[self.registCenterviewDelegate respondsToSelector:@selector(registViewPushToPick:)]) {
        [self.registCenterviewDelegate registViewPushToPick:2];
    }
}

- (void)hudShow:(NSString *)text delay:(NSTimeInterval)interval
{
    if (self.registCenterviewDelegate&&[self.registCenterviewDelegate respondsToSelector:@selector(registViewShowHudWithText:delay:)]) {
        [self.registCenterviewDelegate registViewShowHudWithText:text delay:interval];
    }
}
#pragma mark - <getter>
- (UITextField *)realName_TF
{
    if (!_realName_TF) {
        _realName_TF = [[UITextField alloc]init];
        _realName_TF.delegate = self;
        _realName_TF.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _realName_TF.placeholder = @"请企业员工用户填写真实的用户姓名";
        _realName_TF.userInteractionEnabled = YES;
    }
    return _realName_TF;
}

- (UITextField *)enterprise_TF
{
    if (!_enterprise_TF) {
        _enterprise_TF = [[UITextField alloc]init];
        _enterprise_TF.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _enterprise_TF.placeholder = @"请选择所属企业";
        _enterprise_TF.userInteractionEnabled=NO;
    }
    return _enterprise_TF;
}

- (UITextField *)organization_TF
{
    if (!_organization_TF) {
        _organization_TF = [[UITextField alloc]init];
        _organization_TF.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _organization_TF.placeholder = @"请选择所属机构";
        _organization_TF.userInteractionEnabled=NO;
    }
    return _organization_TF;
}
@end


@interface RegisterBottomView ()
@property (nonatomic, strong)UILabel        *protocolLab;
@property (nonatomic, strong)UIButton       *detailBtn;

@end

@implementation RegisterBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    //确认开店按钮
    [self addSubview:self.registBtn];
    self.registBtn.sd_layout.bottomSpaceToView(self, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(75))
    .rightSpaceToView(self, KScreenScale(75))
    .heightIs(KScreenScale(80));
    
//    if ([[US_UserUtility sharedLogin].m_isUserProtocol isEqualToString:@"1"] || [US_UserUtility sharedLogin].m_protocolUrl.length==0) return;
//    _protocolSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_protocolSelBtn setImage:[UIImage bundleImageNamed:@"regist_btn_protocol_normal"] forState:UIControlStateNormal];
//    [_protocolSelBtn setImage:[UIImage bundleImageNamed:@"regist_btn_protocol_selected"] forState:UIControlStateSelected];
//    [_protocolSelBtn addTarget:self action:@selector(protocolSelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_protocolSelBtn];
//    _protocolLab = [[UILabel alloc]init];
//    _protocolLab.text = @"我已阅读并同意";
//    _protocolLab.textColor = [UIColor convertHexToRGB:@"666666"];
//    _protocolLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
//    [self addSubview:_protocolLab];
//
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"《服务协议与隐私政策》"];
//    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributedStr.length)];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(30)] range:NSMakeRange(0, attributedStr.length)];
//    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_detailBtn setAttributedTitle:attributedStr forState:UIControlStateNormal];
//    [_detailBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
//    [_detailBtn addTarget:self action:@selector(protocolDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_detailBtn];
//    //约束
//    CGFloat selBtnW = 30;
//    CGFloat proLabW = [_protocolLab.text widthForFont:_protocolLab.font]+2;
//    CGFloat detailBtnW = [_detailBtn.titleLabel.text widthForFont:_detailBtn.titleLabel.font]+5;
//    CGFloat selBtnLeftPaddig = (__MainScreen_Width-selBtnW-proLabW-detailBtnW-4)*0.5;
//    self.protocolSelBtn.sd_layout.bottomSpaceToView(self.registBtn, KScreenScale(20))
//    .leftSpaceToView(self, selBtnLeftPaddig)
//    .widthIs(selBtnW)
//    .heightIs(selBtnW);
//    _protocolLab.sd_layout.centerYEqualToView(self.protocolSelBtn)
//    .leftSpaceToView(self.protocolSelBtn, 2.0)
//    .widthIs(proLabW)
//    .heightIs(20);
//    _detailBtn.sd_layout.centerYEqualToView(_protocolLab)
//    .leftSpaceToView(_protocolLab, 2.0)
//    .heightRatioToView(_protocolLab, 1.0)
//    .widthIs(detailBtnW);
}

#pragma mark - <action>
- (void)registButtonAction:(UIButton *)sender
{
//    if (_protocolSelBtn&&!_protocolSelBtn.isSelected) {
//        [self hudShow:@"请阅读并同意《服务协议与隐私政策》" delay:1.5];
//        return;
//    }
    if (self.registBottomViewDelegate&&[self.registBottomViewDelegate respondsToSelector:@selector(registViewConfirmToRegistAction)]) {
        [self.registBottomViewDelegate registViewConfirmToRegistAction];
    }
}

//- (void)protocolSelBtnAction:(UIButton *)sender
//{
//    self.protocolSelBtn.selected=!self.protocolSelBtn.isSelected;
//
//}

//- (void)protocolDetailBtnAction:(UIButton *)sender
//{
//    if (self.registBottomViewDelegate&&[self.registBottomViewDelegate respondsToSelector:@selector(registViewProtocolDetailAction)]) {
//        [self.registBottomViewDelegate registViewProtocolDetailAction];
//    }
//}

//- (void)hudShow:(NSString *)text delay:(NSTimeInterval)interval
//{
//    if (self.registBottomViewDelegate&&[self.registBottomViewDelegate respondsToSelector:@selector(registViewShowHudWithText:delay:)]) {
//        [self.registBottomViewDelegate registViewShowHudWithText:text delay:interval];
//    }
//}

- (void)removeSignAgreementView
{
//    [_protocolSelBtn removeFromSuperview];
    [_protocolLab removeFromSuperview];
    [_detailBtn removeFromSuperview];
//    _protocolSelBtn=nil;
    _protocolLab=nil;
    _detailBtn=nil;
}

#pragma mark - <getters>
- (UIButton *)registBtn
{
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setBackgroundColor:kCommonRedColor];
        [_registBtn setTitle:@"确认开店" forState:UIControlStateNormal];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _registBtn.layer.cornerRadius = KScreenScale(40);
        [_registBtn addTarget:self action:@selector(registButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

@end
