//
//  US_BindingBankCardVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_BindingBankCardVC.h"
#import "US_BindingBankCardSureVC.h"

@interface US_BindingBankCardVC ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel * topPromptView;      //顶部提示View
@property (nonatomic, strong) UITextField *cardNumberTF;    //卡号
@property (nonatomic, strong) UITextField *cardUserNameTF;  //持卡人
@property (nonatomic, strong) UIButton *nextStepButton;     //下一步
@end

@implementation US_BindingBankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"添加银行卡"];
    }
    
    [self setUI];
}

- (void)setUI{
    UIView * backView  = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    UIView * lineView = [UIView new];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"f1f1f1"];
    UILabel * cardNumberLab = [UILabel new];
    cardNumberLab.text = @"卡号";
    cardNumberLab.font = [UIFont systemFontOfSize:16];
    UILabel * cardUserNameLab = [UILabel new];
    cardUserNameLab.text = @"姓名";
    cardUserNameLab.font = [UIFont systemFontOfSize:16];
    [self.view sd_addSubviews:@[backView,self.topPromptView,cardNumberLab,self.cardNumberTF,lineView,cardUserNameLab,self.cardUserNameTF,self.nextStepButton]];
    self.topPromptView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(47);
    backView.sd_layout
    .topSpaceToView(self.topPromptView, 10)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(91);
    cardNumberLab.sd_layout
    .topSpaceToView(self.topPromptView, 10)
    .leftSpaceToView(self.view, 10)
    .widthIs(45)
    .heightIs(45);
    self.cardNumberTF.sd_layout
    .topEqualToView(cardNumberLab)
    .leftSpaceToView(cardNumberLab, 5)
    .rightSpaceToView(self.view, 10)
    .heightIs(45);
    lineView.sd_layout
    .topSpaceToView(self.cardNumberTF, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(1);
    cardUserNameLab.sd_layout
    .topSpaceToView(lineView, 0)
    .leftEqualToView(cardNumberLab)
    .widthIs(45)
    .heightIs(45);
    self.cardUserNameTF.sd_layout
    .topEqualToView(cardUserNameLab)
    .leftEqualToView(self.cardNumberTF)
    .rightEqualToView(self.cardNumberTF)
    .heightRatioToView(self.cardNumberTF, 1);
    self.nextStepButton.sd_layout
    .topSpaceToView(self.cardUserNameTF, 30)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .heightIs(45);
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    [self nextStepButtonCanClick:NO];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *tmpTxt = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger Length = tmpTxt.length - range.length + string.length;
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    if (textField == self.cardNumberTF)
    {
        if (Length == 1 && self.cardUserNameTF.text.length > 0) {
            [self nextStepButtonCanClick:YES];
        }
        else if (Length == 0 && _cardUserNameTF.text.length > 0)
        {
           [self nextStepButtonCanClick:NO];
        }
        
    }
    else if (textField == _cardUserNameTF)
    {
        //去除特殊符号，二次验证通过正则表达式
        NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"^_^0123456789＼｜＝％＊＠＃／＿;＆－＾￡＄￥><>」「」’‘’］［］£€:/：；（）¥@“”。，、？！.【】｛｝—～《》…,^_^?!'[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic =[string isEqualToString:filtered];
        if (basic) {
            if (Length == 1 && _cardNumberTF.text.length > 0) {
                [self nextStepButtonCanClick:YES];
            }
            else if (Length == 0 && _cardNumberTF.text.length > 0)
            {
                [self nextStepButtonCanClick:NO];
            }
        }
        return basic;
    }
    
    if (textField == _cardNumberTF) {
        
        if (Length == 5 && string.length > 0){
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ ",textField.text];
        }
        else if (Length == 9 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ %@ ",
                              [textField.text substringWithRange:NSMakeRange(0, 4)],
                              [textField.text substringWithRange:NSMakeRange(4, 4)]];
        }
        else if (Length == 13 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ %@ %@ ",
                              [textField.text substringWithRange:NSMakeRange(0, 4)],
                              [textField.text substringWithRange:NSMakeRange(4, 4)],
                              [textField.text substringWithRange:NSMakeRange(8, 4)]];
        }
        else if (Length == 17 && string.length > 0)
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            textField.text = [NSString stringWithFormat:@"%@ %@ %@ %@ ",
                              [textField.text substringWithRange:NSMakeRange(0, 4)],
                              [textField.text substringWithRange:NSMakeRange(4, 4)],
                              [textField.text substringWithRange:NSMakeRange(8, 4)],
                              [textField.text substringWithRange:NSMakeRange(12, 4)]];
        }
        else if(Length >= 20 && string.length > 0)
        {
            return NO;
        }
    }
    return YES;
}

/**
 *  校验输入的内容
 */
- (void)checkOutInputText:(UITextField *)textField {
    
    if (textField.text.length >= 1 && self.cardNumberTF.text.length > 0)
    {
        [self nextStepButtonCanClick:YES];
    }
    else if (textField.text.length == 0 && self.cardNumberTF.text.length > 0)
    {
        [self nextStepButtonCanClick:NO];
    }
}

- (void)nextStepButtonCanClick:(BOOL)canClick{
    if (canClick) {
        self.nextStepButton.backgroundColor = [UIColor convertHexToRGB:@"c60a1e"];
        [self.nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.nextStepButton.userInteractionEnabled = YES;
    }
    else{
        self.nextStepButton.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
        [self.nextStepButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        self.nextStepButton.userInteractionEnabled = NO;
    }
}

#pragma mark - Action
- (void)nextStepButtonClick:(UIButton *)button{
    [self.view endEditing:YES];
    NSString * cardNumberString= [self.cardNumberTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (cardNumberString.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入银行卡号" afterDelay:2.0f];
        return;
    }
    
    if (self.cardUserNameTF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入持卡人姓名" afterDelay:2.0f];
        return;
    }
    NSMutableDictionary *params = @{@"accountNumber":cardNumberString,
                                    @"accountName":self.cardUserNameTF.text}.mutableCopy;
    [self pushNewViewController:@"US_BindingBankCardSureVC" isNibPage:NO withData:params];
}

#pragma mark - <setter and getter>
- (UILabel *)topPromptView{
    if (!_topPromptView) {
        _topPromptView = [UILabel new];
        _topPromptView.text = @"首次使用邮储银行卡支付功能绑定卡号，以便能下次快速支付";
        _topPromptView.textColor = [UIColor whiteColor];
        _topPromptView.font = [UIFont systemFontOfSize:14];
        _topPromptView.backgroundColor = [UIColor convertHexToRGB:@"444444"];
        _topPromptView.numberOfLines = 0;
    }
    return _topPromptView;
}
- (UITextField *)cardNumberTF{
    if (!_cardNumberTF) {
        _cardNumberTF = [[UITextField alloc]init];
        _cardNumberTF.font = [UIFont systemFontOfSize:15];
        _cardNumberTF.placeholder = @"请输入卡号";
        _cardNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardNumberTF.keyboardType = UIKeyboardTypeNumberPad;
        _cardNumberTF.backgroundColor = [UIColor whiteColor];
        _cardNumberTF.delegate = self;
    }
    return _cardNumberTF;
}
- (UITextField *)cardUserNameTF{
    if (!_cardUserNameTF) {
        _cardUserNameTF = [[UITextField alloc]init];
        _cardUserNameTF.font = [UIFont systemFontOfSize:15];
        _cardUserNameTF.placeholder = @"持卡人姓名";
        _cardUserNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _cardUserNameTF.keyboardType = UIKeyboardTypeDefault;
        _cardUserNameTF.backgroundColor = [UIColor whiteColor];
        _cardUserNameTF.delegate = self;
        [_cardUserNameTF addTarget:self
                            action:@selector(checkOutInputText:)
                  forControlEvents:UIControlEventAllEditingEvents];
    }
    return _cardUserNameTF;
}
- (UIButton *)nextStepButton{
    if (!_nextStepButton) {
        _nextStepButton = [UIButton new];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        _nextStepButton.layer.cornerRadius = 5;
        _nextStepButton.userInteractionEnabled = NO;
        _nextStepButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextStepButton setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        _nextStepButton.backgroundColor = [UIColor convertHexToRGB:@"cccccc"];
        [_nextStepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStepButton;
}

@end
