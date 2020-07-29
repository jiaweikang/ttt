//
//  US_AddNewCategoryAlert.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/31.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_AddNewCategoryAlert.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

static NSInteger const kMaxLength = 12;

@interface US_AddNewCategoryAlert ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * mTitelLabel;
@property (nonatomic, strong) UITextField * mNameTextField;
@property (nonatomic, strong) UIButton * mCancelButton;
@property (nonatomic, strong) UIButton * mSureButton;
@property (nonatomic, strong) US_AddNewCategoryAlertBlock comfrimClickBlock;
@end

@implementation US_AddNewCategoryAlert

+ (instancetype)creatAlertWithConfirmBlock:(US_AddNewCategoryAlertBlock) comfirmBlock{
    US_AddNewCategoryAlert * alertView=[[US_AddNewCategoryAlert alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width-80, KScreenScale(390))];
    alertView.comfrimClickBlock = [comfirmBlock copy];
    return alertView;
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self addKeybordNotify];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    self.clipsToBounds=YES;
    self.layer.cornerRadius=KScreenScale(10);
    [self sd_addSubviews:@[self.mTitelLabel,self.mNameTextField,self.mCancelButton,self.mSureButton]];
    
    self.mTitelLabel.sd_layout.leftSpaceToView(self, 10)
    .topSpaceToView(self, KScreenScale(35))
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(40));
    
    self.mNameTextField.sd_layout.leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .centerYEqualToView(self)
    .heightIs(KScreenScale(95));
    
    self.mCancelButton.sd_layout.leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 10)
    .widthIs((self.width_sd-10*3)/2.0)
    .heightIs(KScreenScale(78));
    
    self.mSureButton.sd_layout.bottomSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .leftSpaceToView(self.mCancelButton, 10)
    .heightRatioToView(self.mCancelButton, 1);
}

- (void)addKeybordNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - keyBoard Notify
- (void)keyboardDidShow:(NSNotification *)notify{
    [self updateViewWithNotify:notify];
}

- (void)keyboardWillHidden:(NSNotification *)notify{
    CGFloat keyboardDuration =[[notify userInfo] [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:keyboardDuration animations:^{
        self.center=CGPointMake(__MainScreen_Width/2.0, __MainScreen_Height/2.0);
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notify{
    [self updateViewWithNotify:notify];
}

- (void)updateViewWithNotify:(NSNotification *)notify{
    CGRect _keyboardRect=[[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat bgBottom= CGRectGetMaxY(self.frame);
    CGFloat keyboardY=_keyboardRect.origin.y;
    CGFloat keyboardDuration =[[notify userInfo] [UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    if (bgBottom>keyboardY) {
        CGRect rect=self.frame;
        [UIView animateWithDuration:keyboardDuration animations:^{
            self.frame=CGRectMake(rect.origin.x, rect.origin.y-(bgBottom-keyboardY), rect.size.width, rect.size.height);
        }];
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        return YES;
    } else {
        [UleMBProgressHUD showHUDWithText:@"内容不合法(仅限中文、数字、字母)" afterDelay:2];
        return NO;
    }

}

- (void)textFieldChanged:(UITextField *)textField {
    
    NSString *toBeString = textField.text;
    
    //去除特殊符号，二次验证通过正则表达式
    NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"^_^＼｜＝％＊＠＃／＿;＆－＾￡＄￥><>」「」’‘’］［］£€:/：；（）¥@“”。，、？！.【】｛｝—～《》…,^_^?!'[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSString *filtered =[[toBeString componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic =[toBeString isEqualToString:filtered];
    if (!basic) {
        [UleMBProgressHUD showHUDWithText:@"内容不合法(仅限中文、数字、字母)" afterDelay:2];
        textField.text = filtered;
        return;
    }
    
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            NSString *getStr = [self getSubString:toBeString];
            if(getStr && getStr.length > 0) {
                textField.text = getStr;
            }
        }
    } else{
        NSString *getStr = [self getSubString:toBeString];
        if(getStr && getStr.length > 0) {
            textField.text= getStr;
        }
    }
}

- (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d➋➌➍➎➏➐➑➒]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 * 字母、数字、中文正则判断（包括空格）（在系统输入法中文输入时会出现拼音之间有空格，需要忽略，当按return键时会自动用字母替换，按空格输入响应汉字）
 */
- (BOOL)isInputRuleAndBlank:(NSString *)str {
    
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d\\s]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}
/**
 *  获得 kMaxLength长度的字符
 */
-(NSString *)getSubString:(NSString*)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSInteger length = [data length];
    if (length > kMaxLength) {
        [UleMBProgressHUD showHUDWithText:@"内容超出长度(仅限6个字)" afterDelay:2];
        NSData *data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength)];
        NSString *content = [[NSString alloc] initWithData:data1 encoding:encoding];//注意：当截取kMaxLength长度字符时把中文字符截断返回的content会是nil
        if (!content || content.length == 0) {
            data1 = [data subdataWithRange:NSMakeRange(0, kMaxLength - 1)];
            content =  [[NSString alloc] initWithData:data1 encoding:encoding];
        }
        return content;
    }
    return nil;
}
- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

#pragma mark - <Button click>
- (void)dismiss:(UIButton *)btn{
    [self hiddenView];
}

- (void)confirmAction:(UIButton *)btn{
    
    if (self.mNameTextField.text.length>0) {
        if (self.comfrimClickBlock) {
            self.comfrimClickBlock(self.mNameTextField.text);
        }
        [self hiddenView];
    }else{
        [UleMBProgressHUD showHUDWithText:@"请输入分类名称" afterDelay:2];
    }

}

#pragma mark - <setter and getter>

- (UILabel *)mTitelLabel{
    if (!_mTitelLabel) {
        _mTitelLabel=[UILabel new];
        _mTitelLabel.textAlignment=NSTextAlignmentCenter;
        _mTitelLabel.font=[UIFont systemFontOfSize:KScreenScale(38)];
        _mTitelLabel.text=@"新建分类";
        _mTitelLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _mTitelLabel;
}
- (UITextField *)mNameTextField{
    if (!_mNameTextField) {
        _mNameTextField=[[UITextField alloc] init];
        _mNameTextField.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _mNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mNameTextField.layer.cornerRadius = 5;
        _mNameTextField.layer.masksToBounds = YES;
        _mNameTextField.placeholder = @"分类名称（限6个字）";
        [_mNameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        _mNameTextField.delegate = self ;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        leftView.backgroundColor = [UIColor whiteColor];
        _mNameTextField.leftView = leftView;
        _mNameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _mNameTextField;
}
- (UIButton *)mCancelButton{
    if (!_mCancelButton) {
        _mCancelButton=[[UIButton alloc] init];
        _mCancelButton.backgroundColor=[UIColor whiteColor];
        _mCancelButton.layer.borderWidth=0.5;
        _mCancelButton.layer.borderColor=[[UIColor convertHexToRGB:@"666666"]colorWithAlphaComponent:.5].CGColor;
        _mCancelButton.layer.cornerRadius=5.0;
        [_mCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_mCancelButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        _mCancelButton.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];
        [_mCancelButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mCancelButton;
}
- (UIButton *)mSureButton{
    if (!_mSureButton) {
        _mSureButton=[[UIButton alloc] init];
        _mSureButton.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        _mSureButton.layer.cornerRadius=5.0;
        [_mSureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_mSureButton setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
        _mSureButton.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(32)];;
        [_mSureButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mSureButton;
}
@end
