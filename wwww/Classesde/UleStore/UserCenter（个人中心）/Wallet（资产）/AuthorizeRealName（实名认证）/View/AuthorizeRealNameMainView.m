//
//  AuthorizeRealNameMainView.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "AuthorizeRealNameMainView.h"
#import <UIView+SDAutoLayout.h>
#import "US_SMSCodeButton.h"

static NSInteger const Tag_userNameTF = 100000;
static NSInteger const Tag_idCardTF = 100001;
static NSInteger const Tag_bankCardTF = 100002;
static NSInteger const Tag_mobileTF = 100003;
static NSInteger const Tag_smsCodeTF = 100004;

static NSInteger const kUserNameMaxLength = 15;


@interface  AuthorizeRealNameMainView ()<UITextFieldDelegate>

@end

@implementation AuthorizeRealNameMainView

- (UIView *)getLineView{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor convertHexToRGB:kGrayLineColor];
    return view;
}

+ (UIView *)getPromoteViewWithStr:(NSString *)textStr{
    //注意：#&#·填写本人真实信息资料；##·仅支持邮储银行借记卡，不支持信用卡；##·认证时会自动开通快捷支付功能，以便提现；##·收益必须满20元或以上时才可进行提现","key":"poststore_proceeds_info","attribute2":"注意：#&#收益满20元可发起提现；
    NSString *titleStr = @"";
    NSString *contentStr = @"";
    CGFloat hintH = 0.0;
    NSArray *array = [textStr componentsSeparatedByString:@"#&#"];
    titleStr = [array firstObject];
    if (array.count>1) {
        NSArray *array1 = [array[1] componentsSeparatedByString:@"##"];
        contentStr = [NSString isNullToString:[array[1] stringByReplacingOccurrencesOfString:@"##" withString:@"\n"]];
        hintH = [contentStr heightForFont:[UIFont systemFontOfSize:14] width:__MainScreen_Width-20]+5 + array1.count * 10;
    }
    
    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 30+hintH)];
    mView.backgroundColor = kViewCtrBackColor;
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 15)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textColor = [UIColor redColor];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.text = titleStr;
    [mView addSubview:tipLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(tipLabel.frame), __MainScreen_Width - 30, hintH)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.text = contentStr;
    [mView addSubview:contentLabel];
    
    return mView;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    [self setAllowAuthorize:NO];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tmpTxt = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger Length = tmpTxt.length - range.length + string.length;
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    if (textField.tag == Tag_userNameTF)
    {
        //去除特殊符号，二次验证通过正则表达式
        NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"^_^0123456789＼｜＝％＊＠＃／＿;＆－＾￡＄￥><>」「」’‘’］［］£€:/：；（）¥@“”。，、？！.【】｛｝—～《》…,^_^?!'[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic =[string isEqualToString:filtered];
        return basic;
    }else if (textField.tag == Tag_idCardTF) {
        if (Length == 7 && string.length > 0){
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if (Length == 15 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if(Length >= 19 && string.length > 0)
        {
            return NO;
        }
    }else if (textField.tag == Tag_mobileTF) {
        if ([string isEqualToString:@" "]) return NO;
        NSInteger length = textField.text.length - range.length + string.length;
        return length<=11;
    }else if (textField.tag == Tag_bankCardTF) {
        if (Length == 5 && string.length > 0){
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if (Length == 9 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if (Length == 13 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if (Length == 17 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@"  " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if(Length >= 20 && string.length > 0)
        {
            return NO;
        }
    }
    return YES;
}


@end


@interface AuthorizeRealNameTopView ()
@property (nonatomic, strong)UITextField        *userNameTF;
@property (nonatomic, strong)UITextField        *idCardTF;

@end

@implementation AuthorizeRealNameTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *icon_userName = [[UIImageView alloc]init];
    icon_userName.image = [UIImage bundleImageNamed:@"authorize_img_icon_name"];
    [self addSubview:icon_userName];
    [self addSubview:self.userNameTF];
    UIView *lineView = [self getLineView];
    [self addSubview:lineView];
    icon_userName.sd_layout.topSpaceToView(self, 15)
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs(20)
    .heightIs(20);
    self.userNameTF.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(icon_userName, KScreenScale(20))
    .rightSpaceToView(self, 0)
    .heightIs(50);
    lineView.sd_layout.topSpaceToView(self.userNameTF, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.8);
    UIImageView *icon_idCard = [[UIImageView alloc]init];
    icon_idCard.image = [UIImage bundleImageNamed:@"authorize_img_icon_id"];
    [self addSubview:icon_idCard];
    [self addSubview:self.idCardTF];
    UIView *lineView1 = [self getLineView];
    [self addSubview:lineView1];
    icon_idCard.sd_layout.topSpaceToView(lineView, 15)
    .leftEqualToView(icon_userName)
    .widthRatioToView(icon_userName, 1.0)
    .heightRatioToView(icon_userName, 1.0);
    self.idCardTF.sd_layout.topSpaceToView(lineView, 0)
    .leftEqualToView(self.userNameTF)
    .rightEqualToView(self.userNameTF)
    .heightRatioToView(self.userNameTF, 1.0);
    lineView1.sd_layout.topSpaceToView(self.idCardTF, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.8);
}

#pragma mark - <actions>
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
            if (toBeString.length > kUserNameMaxLength) {
                textField.text = [toBeString substringToIndex:kUserNameMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kUserNameMaxLength) {
            textField.text = [toBeString substringToIndex:kUserNameMaxLength];
        }
    }
}

#pragma mark - <getters>
- (UITextField *)userNameTF
{
    if (!_userNameTF) {
        _userNameTF = [[UITextField alloc]init];
        _userNameTF.placeholder = @"请输入您的真实姓名";
        _userNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTF.font = [UIFont systemFontOfSize:15];
        _userNameTF.textColor = [UIColor convertHexToRGB:@"333333"];
        _userNameTF.returnKeyType = UIReturnKeyDone;
        _userNameTF.delegate = self;
        _userNameTF.tag = Tag_userNameTF;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_userNameTF];
    }
    return _userNameTF;
}

- (UITextField *)idCardTF
{
    if (!_idCardTF) {
        _idCardTF = [[UITextField alloc]init];
        _idCardTF.placeholder = @"请输入真实身份证号";
        _idCardTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _idCardTF.font = [UIFont systemFontOfSize:15];
        _idCardTF.textColor = [UIColor convertHexToRGB:kBlackTextColor];
        _idCardTF.keyboardType = UIKeyboardTypeDefault;
        _idCardTF.returnKeyType = UIReturnKeyDone;
        _idCardTF.delegate = self;
        _idCardTF.tag = Tag_idCardTF;
    }
    return _idCardTF;
}

@end

@interface AuthorizeRealNameCenterView ()
@property (nonatomic, strong)UITextField        *bankCardTF;
@property (nonatomic, strong)UIButton       *chooseBtn;

@end

@implementation AuthorizeRealNameCenterView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.chooseBtn];
    self.chooseBtn.sd_layout.topSpaceToView(self, KScreenScale(60))
    .rightSpaceToView(self, KScreenScale(20))
    .widthIs(KScreenScale(180))
    .heightIs(KScreenScale(140));
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"authorize_img_icon_bank"]];
    [self addSubview:iconView];
    iconView.sd_layout.topSpaceToView(self, KScreenScale(20))
    .leftSpaceToView(self, KScreenScale(30))
    .widthIs(KScreenScale(90))
    .heightIs(KScreenScale(90));
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"中国邮政储蓄银行";
    titleLab.textColor = [UIColor convertHexToRGB:kDarkTextColor];
    titleLab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    [self addSubview:titleLab];
    titleLab.sd_layout.centerYEqualToView(iconView)
    .leftSpaceToView(iconView, KScreenScale(30))
    .rightSpaceToView(self.chooseBtn, 0)
    .heightIs(KScreenScale(40));
    UIView *textFieldBackView = [[UIView alloc]init];
    textFieldBackView.backgroundColor = kViewCtrBackColor;
    textFieldBackView.layer.cornerRadius = 5.0;
    textFieldBackView.layer.masksToBounds = YES;
    [self addSubview:textFieldBackView];
    textFieldBackView.sd_layout.leftSpaceToView(self, KScreenScale(30))
    .topSpaceToView(iconView, KScreenScale(30))
    .rightSpaceToView(self.chooseBtn, KScreenScale(20))
    .heightIs(KScreenScale(100));
    [textFieldBackView addSubview:self.bankCardTF];
    self.bankCardTF.sd_layout.topSpaceToView(textFieldBackView, 0)
    .leftSpaceToView(textFieldBackView, KScreenScale(20))
    .bottomSpaceToView(textFieldBackView, 0)
    .rightSpaceToView(textFieldBackView, KScreenScale(20));
}

#pragma mark - <actions>
- (void)setBankCardNum:(NSString *)cardNum
{
    self.bankCardTF.text = cardNum;
}

- (void)setBankCardChoosenBtnHidden:(BOOL)isHidden{
    if (isHidden) {
        self.chooseBtn.sd_layout.widthIs(0);
    }else {
        self.chooseBtn.sd_layout.widthIs(KScreenScale(180));
    }
}

- (void)chooseBtnAction:(UIButton *)sender{
    if (self.choosenBtnBlock) {
        self.choosenBtnBlock();
    }
}

#pragma mark - <getters>
- (UITextField *)bankCardTF
{
    if (!_bankCardTF) {
        _bankCardTF = [[UITextField alloc]init];
        _bankCardTF.backgroundColor = [UIColor clearColor];
        _bankCardTF.placeholder = @"您可输入新的银行卡账号";
        _bankCardTF.font = [UIFont systemFontOfSize:15];
        _bankCardTF.keyboardType = UIKeyboardTypeNumberPad;
        _bankCardTF.returnKeyType = UIReturnKeyDone;
        _bankCardTF.delegate = self;
        _bankCardTF.tag = Tag_bankCardTF;
    }
    return _bankCardTF;
}

- (UIButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"authorize_img_icon_cardselect"]];
        [_chooseBtn addSubview:imgView];
        imgView.sd_layout.topSpaceToView(_chooseBtn, KScreenScale(10))
        .leftSpaceToView(_chooseBtn, KScreenScale(65))
        .widthIs(KScreenScale(50))
        .heightIs(KScreenScale(50));
        UILabel *lab = [[UILabel alloc]init];
        lab.text = @"选择已绑卡";
        lab.textColor = [UIColor convertHexToRGB:kDarkTextColor];
        lab.font = [UIFont systemFontOfSize:KScreenScale(26)];
        lab.textAlignment = NSTextAlignmentCenter;
        [_chooseBtn addSubview:lab];
        lab.sd_layout.topSpaceToView(imgView, KScreenScale(KScreenScale(30)))
        .leftSpaceToView(_chooseBtn, 0)
        .rightSpaceToView(_chooseBtn, 0)
        .heightIs(KScreenScale(40));
        [_chooseBtn addTarget:self action:@selector(chooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}

@end



@interface AuthorizeRealNameBootomView ()
@property (nonatomic, strong)UITextField        *mobileTF;
@property (nonatomic, strong)UITextField        *smsCodeTF;

@end

@implementation AuthorizeRealNameBootomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *icon_mobile = [[UIImageView alloc]init];
    icon_mobile.image = [UIImage bundleImageNamed:@"authorize_img_icon_phone"];
    [self addSubview:icon_mobile];
    [self addSubview:self.mobileTF];
    UIView *lineView = [self getLineView];
    [self addSubview:lineView];
    icon_mobile.sd_layout.topSpaceToView(self, 15)
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs(20)
    .heightIs(20);
    [self addSubview:self.smsCodeBtn];
    self.smsCodeBtn.sd_layout.topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .widthIs(KScreenScale(220))
    .heightIs(50);
    UIView *verticalLine = [self getLineView];
    [self addSubview:verticalLine];
    verticalLine.sd_layout.centerYEqualToView(self.smsCodeBtn)
    .rightSpaceToView(self.smsCodeBtn, 0)
    .widthIs(1.0)
    .heightIs(25);
    self.mobileTF.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(icon_mobile, KScreenScale(20))
    .rightSpaceToView(verticalLine, 0)
    .heightIs(50);
    lineView.sd_layout.topSpaceToView(self.mobileTF, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.8);
    UIImageView *icon_smsCode = [[UIImageView alloc]init];
    icon_smsCode.image = [UIImage bundleImageNamed:@"authorize_img_icon_smscode"];
    [self addSubview:icon_smsCode];
    [self addSubview:self.smsCodeTF];
    UIView *lineView1 = [self getLineView];
    [self addSubview:lineView1];
    icon_smsCode.sd_layout.topSpaceToView(lineView, 15)
    .leftEqualToView(icon_mobile)
    .widthRatioToView(icon_mobile, 1.0)
    .heightRatioToView(icon_mobile, 1.0);
    self.smsCodeTF.sd_layout.topSpaceToView(lineView, 0)
    .leftEqualToView(self.mobileTF)
    .rightEqualToView(self.mobileTF)
    .heightRatioToView(self.mobileTF, 1.0);
    lineView1.sd_layout.topSpaceToView(self.smsCodeTF, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(0.8);
    @weakify(self);
    [self.smsCodeBtn addClickBlock:^(US_SMSCodeButton *sender) {
        @strongify(self);
        if (self.smsCodeBtnBlock) {
            self.smsCodeBtnBlock();
        }
    } finishedBlock:^NSString *(US_SMSCodeButton *sender, int second) {
        
        return @"获取验证码";
    }];
}

- (void)setMobileNum:(NSString *)mobileNum
{
    self.mobileTF.text = mobileNum;
}

- (UITextField *)mobileTF{
    if (!_mobileTF) {
        _mobileTF = [[UITextField alloc]init];
        _mobileTF.font = [UIFont systemFontOfSize:15];
        _mobileTF.textColor = [UIColor convertHexToRGB:@"333333"];
        _mobileTF.keyboardType = UIKeyboardTypeNumberPad;
        _mobileTF.placeholder=@"请输入您的手机号码";
        _mobileTF.delegate = self;
        _mobileTF.tag = Tag_mobileTF;
    }
    return _mobileTF;
}

-(UITextField *)smsCodeTF{
    if (!_smsCodeTF) {
        _smsCodeTF = [[UITextField alloc]init];
        _smsCodeTF.placeholder = @"请填写收到的验证码";
        _smsCodeTF.font = [UIFont systemFontOfSize:15];
        _smsCodeTF.textColor = [UIColor convertHexToRGB:@"333333"];
        _smsCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _smsCodeTF.returnKeyType = UIReturnKeyDone;
        _smsCodeTF.delegate = self;
        _smsCodeTF.tag = Tag_smsCodeTF;
    }
    return _smsCodeTF;
}

- (US_SMSCodeButton *)smsCodeBtn{
    if (!_smsCodeBtn) {
        _smsCodeBtn = [[US_SMSCodeButton alloc]init];
        [_smsCodeBtn setBackgroundColor:[UIColor clearColor]];
        [_smsCodeBtn setTitleColor:[UIColor convertHexToRGB:kBlackTextColor] forState:UIControlStateNormal];
        [_smsCodeBtn setTitle:@"验证码" forState:UIControlStateNormal];
        _smsCodeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_smsCodeBtn setNormalColor:[UIColor convertHexToRGB:kBlackTextColor]];
        [_smsCodeBtn setCountDownColor:[UIColor convertHexToRGB:kLightTextColor]];
        _smsCodeBtn.preTitle = @"已发送";
    }
    return _smsCodeBtn;
}

@end
