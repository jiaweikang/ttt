//
//  US_MyGoodsCatergoryCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsCatergoryCell.h"
#import <UIView+SDAutoLayout.h>

#define kMaxLength 12

@interface US_MyGoodsCatergoryCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * mCellTextField;
@property (nonatomic, strong) UILabel * mTotalLabel;
@property (nonatomic, strong) UIImageView *mArrowView;
@property (nonatomic, strong) UIButton * mDeleteBtn;
@property (nonatomic, strong) UIImageView * mSortImageView;
@property (nonatomic, strong) UIView * mSplitLine;

@end


@implementation US_MyGoodsCatergoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.mCellTextField,self.mTotalLabel,self.mArrowView,self.mDeleteBtn,self.mSortImageView,self.mSplitLine]];
    self.mCellTextField.sd_layout.leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .widthIs(__MainScreen_Width-120);
    
    self.mArrowView.sd_layout.centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(8)
    .heightIs(14);
    
    self.mTotalLabel.sd_layout.topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.mArrowView, 5)
    .bottomSpaceToView(self.contentView, 0)
    .autoWidthRatio(0);
    
    self.mSortImageView.sd_layout.centerYEqualToView(self.contentView)
    .rightSpaceToView(self.contentView, 20)
    .widthIs(14).heightIs(14);
    
    self.mDeleteBtn.sd_layout.centerYEqualToView(self.contentView)
    .rightSpaceToView(self.mSortImageView, 40)
    .widthIs(40).heightIs(40);
    
    self.mSplitLine.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(0.6);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(CategroyItem *)model{
    _model=model;
    self.mCellTextField.text=model.categoryName;
    self.mTotalLabel.text=[NSString stringWithFormat:@"%@件商品",model.totalRecords];
    [self.mTotalLabel setSingleLineAutoResizeWithMaxWidth:200];
}

- (void)setIsEditType:(BOOL)isEditType{
    _isEditType=isEditType;
    self.mCellTextField.enabled=isEditType?YES:NO;
    self.mTotalLabel.hidden=isEditType?YES:NO;
    self.mArrowView.hidden=isEditType?YES:NO;;
    self.mSortImageView.hidden=isEditType?NO:YES;
    self.mDeleteBtn.hidden=isEditType?NO:YES;
}
#pragma mark - <click >
- (void)deleteClick:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidDeletecatergoryId:)]) {
        [self.delegate cellDidDeletecatergoryId:self.model.idForCate];
    }
}

#pragma mark - UiTextField Delegate
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
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"TEXTCHANGED" object:self userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"isChanged" ,nil]];
    }
    
    if (![self isInputRuleAndBlank:toBeString]) {
        textField.text = [self disable_emoji:toBeString];
        return;
    }
    
    NSString *lang = [[textField textInputMode] primaryLanguage]; // 获取当前键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入,第三方输入法（搜狗）所有模式下都会显示“zh-Hans”
        UITextRange *selectedRange = [textField markedTextRange];
        if (!selectedRange) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }else{
            
        }
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
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.model.categoryName = textField.text;
    if ([self isInputRuleNotBlank:string] || [string isEqualToString:@""]) {//当输入符合规则和退格键时允许改变输入框
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_CategroyNameChanged object:self userInfo:[[NSDictionary alloc]initWithObjectsAndKeys:@"1",@"isChanged" ,nil]];
        return YES;
    } else {
        [UleMBProgressHUD showHUDWithText:@"内容不合法(仅限中文、数字、字母)"  afterDelay:2];
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.model.categoryName = textField.text;
}

#pragma mark - <setter and getter>
- (UITextField *)mCellTextField{
    if (!_mCellTextField) {
        _mCellTextField=[[UITextField alloc] init];
        _mCellTextField.backgroundColor = [UIColor clearColor];
        _mCellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _mCellTextField.delegate = self;
        _mCellTextField.font = [UIFont systemFontOfSize:15];
        [_mCellTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _mCellTextField;
}
- (UILabel *)mTotalLabel{
    if (!_mTotalLabel) {
        _mTotalLabel=[UILabel new];
        _mTotalLabel.textAlignment=NSTextAlignmentRight;
        _mTotalLabel.backgroundColor = [UIColor clearColor];
        _mTotalLabel.textColor = [UIColor convertHexToRGB:@"b3b3b3"];
        _mTotalLabel.font = [UIFont systemFontOfSize:13];
    }
    return _mTotalLabel;
}
- (UIImageView *)mArrowView{
    if (!_mArrowView) {
        _mArrowView=[UIImageView new];
        _mArrowView.image=[UIImage bundleImageNamed:@"myGoods_img_arrow"];
    }
    return _mArrowView;
}
- (UIButton *)mDeleteBtn{
    if (!_mDeleteBtn) {
        _mDeleteBtn=[[UIButton alloc] init];
        [_mDeleteBtn setImage:[UIImage bundleImageNamed:@"myGoods_btn_catergroy_delete"] forState:UIControlStateNormal];
        [_mDeleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mDeleteBtn;
}
- (UIImageView * )mSortImageView{
    if (!_mSortImageView) {
        _mSortImageView=[[UIImageView alloc] init];
        _mSortImageView.image=[UIImage bundleImageNamed:@"myGoods_btn_sort"];
    }
    return _mSortImageView;
}
- (UIView *)mSplitLine{
    if (!_mSplitLine) {
        _mSplitLine=[UIView new];
        _mSplitLine.backgroundColor=kViewCtrBackColor;
    }
    return _mSplitLine;
}
@end
