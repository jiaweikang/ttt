//
//  WithdrawCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "WithdrawCell.h"
#import <UIView+SDAutoLayout.h>
#import "UleCellBaseModel.h"
#import "MyUILabel.h"
#import "WithdrawRecordModel.h"
#import "WithdrawCommissionCellModel.h"
#import "WithdrawSummaryCellModel.h"

@implementation WithdrawCell

@end

@interface WithdrawCell_bankCard ()
@property (nonatomic, strong) UIImageView        *imgView;
@property (nonatomic, strong) UIImageView        *arrowImgView;
@property (nonatomic, strong) UILabel            *titleLab;
@property (nonatomic, strong) UILabel            *bankCardLab;
@end

@implementation WithdrawCell_bankCard

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.imgView, self.arrowImgView, self.titleLab, self.bankCardLab]];
    self.imgView.sd_layout.topSpaceToView(self.contentView, KScreenScale(40))
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .widthIs(KScreenScale(100))
    .heightIs(KScreenScale(100));
    self.arrowImgView.sd_layout.centerYEqualToView(self.imgView)
    .rightSpaceToView(self.contentView, KScreenScale(30))
    .widthIs(KScreenScale(20))
    .heightIs(KScreenScale(20)*1.75);
    self.titleLab.sd_layout.topEqualToView(self.imgView)
    .leftSpaceToView(self.imgView, KScreenScale(20))
    .rightSpaceToView(self.arrowImgView, 0)
    .heightIs(KScreenScale(40));
    self.bankCardLab.sd_layout.topSpaceToView(self.titleLab, KScreenScale(20))
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightRatioToView(self.titleLab, 1.0);
    UIView *paddingView = [[UIView alloc]init];
    paddingView.backgroundColor = kViewCtrBackColor;
    [self.contentView addSubview:paddingView];
    paddingView.sd_layout.topSpaceToView(self.imgView, KScreenScale(40))
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(10);
    
    [self setupAutoHeightWithBottomView:paddingView bottomMargin:0];
}

- (void)setModel:(UleCellBaseModel *)model{
    NSString *bankcardNum = [NSString isNullToString:model.data];
    self.bankCardLab.text = bankcardNum;
}

#pragma mark - <getters>
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"authorize_img_icon_bank"]];
    }
    return _imgView;
}

- (UIImageView *)arrowImgView
{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"withdraw_img_bankcard_arrow"]];
    }
    return _arrowImgView;
}

- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        _titleLab.text=@"中国邮政储蓄银行";
        _titleLab.font=[UIFont boldSystemFontOfSize:KScreenScale(40)];
    }
    return _titleLab;
}

- (UILabel *)bankCardLab{
    if (!_bankCardLab) {
        _bankCardLab = [[UILabel alloc]init];
        _bankCardLab.textColor=[UIColor convertHexToRGB:kDarkTextColor];
        _bankCardLab.font=[UIFont systemFontOfSize:KScreenScale(40)];
    }
    return _bankCardLab;
}

@end


@interface WithdrawCell_commission ()
@property (nonatomic, strong) UILabel       *incomeLab;
@property (nonatomic, strong) UITextField   *withdrawTF;
@property (nonatomic, strong) UIButton      *withdrawSubmitBtn;

@property (nonatomic, strong) NSString      *commissionStr;
@property (nonatomic, strong) WithdrawCommissionCellModel  *mDataModel;
@end

@implementation WithdrawCell_commission

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.incomeLab];
    self.incomeLab.sd_layout.topSpaceToView(self.contentView, KScreenScale(30))
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .rightSpaceToView(self.contentView, 0)
    .heightIs(KScreenScale(40));
    MyUILabel *leftLab = [[MyUILabel alloc]init];
    leftLab.verticalAlignment = VerticalAlignmentMiddle;
    leftLab.text = @"￥";
    leftLab.textColor = [UIColor convertHexToRGB:kBlackTextColor];
    leftLab.font = [UIFont systemFontOfSize:23];
    [self.contentView addSubview:leftLab];
    leftLab.sd_layout.topSpaceToView(self.incomeLab, KScreenScale(70))
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .widthIs(KScreenScale(55))
    .heightIs(30);
    [self.contentView addSubview:self.withdrawTF];
    self.withdrawTF.sd_layout.topEqualToView(leftLab)
    .leftSpaceToView(leftLab, 5)
    .rightSpaceToView(self.contentView, KScreenScale(30))
    .heightIs(30);
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:kLightTextColor];
    [self.contentView addSubview:lineView];
    lineView.sd_layout.topSpaceToView(self.withdrawTF, KScreenScale(38))
    .leftEqualToView(leftLab)
    .rightEqualToView(self.withdrawTF)
    .heightIs(0.5);
    [self.contentView addSubview:self.withdrawSubmitBtn];
    self.withdrawSubmitBtn.userInteractionEnabled = NO;
    self.withdrawSubmitBtn.sd_layout.topSpaceToView(lineView, KScreenScale(40))
    .leftEqualToView(lineView)
    .rightEqualToView(lineView)
    .heightIs(KScreenScale(88));
    
    [self setupAutoHeightWithBottomView:self.withdrawSubmitBtn bottomMargin:KScreenScale(20)];
}

- (void)setModel:(WithdrawCommissionCellModel *)model{
    self.mDataModel = model;
    NSString *commission = [NSString isNullToString:model.data];
    self.commissionStr = commission;
    self.incomeLab.text = [NSString stringWithFormat:@"可提现收益 ￥%.2lf",[commission doubleValue]>0?[commission doubleValue]:0.00];
    [self setAttributedWithdrawIncome:self.incomeLab];
    self.withdrawTF.text = @"";
    self.mDataModel.transMoneyStr = @"";
}

- (void)withdrawSubmitBtnAction:(UIButton *)sender{
    if (self.mDataModel.withdrawCommissionConfirmBlock) {
        self.mDataModel.withdrawCommissionConfirmBlock();
    }
}

-(void)textFiledEditChanged:(NSNotification *)not
{
    UITextField *textField=not.object;
    NSString *toBestring=textField.text;
    if ([toBestring rangeOfString:@"."].location!=NSNotFound) {
        //是小数
        if (toBestring.length>=([toBestring rangeOfString:@"."].location+3)) {
            toBestring=[toBestring substringToIndex:[toBestring rangeOfString:@"."].location+3];
        }
        if ([toBestring hasPrefix:@"0"]&&![toBestring hasPrefix:@"0."]) {//
            toBestring=[NSString stringWithFormat:@"%.2lf", [toBestring doubleValue]];
        }else if ([toBestring hasPrefix:@"."]) {
            toBestring=[NSString stringWithFormat:@"0%@", toBestring];
        }
        textField.text=toBestring;
    }else{
        //是整数
        if ([toBestring hasPrefix:@"0"]) {
            toBestring=[NSString stringWithFormat:@"%@", @([toBestring intValue])];
            textField.text=toBestring;
        }
    }
    
    NSString *commission=[NSString stringWithFormat:@"%.2lf",self
                          .commissionStr?[self.commissionStr doubleValue]:0.00];
    if (toBestring.doubleValue>0&&toBestring.doubleValue<=commission.doubleValue&&toBestring.length>0) {
        self.withdrawSubmitBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        self.withdrawSubmitBtn.userInteractionEnabled=YES;
    }else{
        self.withdrawSubmitBtn.backgroundColor=[UIColor convertHexToRGB:@"999999"];
        self.withdrawSubmitBtn.userInteractionEnabled=NO;
        if (toBestring.doubleValue>commission.doubleValue) {
            [UleMBProgressHUD showHUDWithText:@"申请提现金额已超限" afterDelay:1.5];
        }
    }
    //触发kvo
    self.mDataModel.transMoneyStr = toBestring;
}

-(void)setAttributedWithdrawIncome:(UILabel *)lab
{
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"36a4f1"] range:NSMakeRange(6, attributedStr.length-6)];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(6, 1)];
    lab.attributedText=attributedStr;
}

#pragma mark - <getters>
- (UILabel *)incomeLab{
    if (!_incomeLab) {
        _incomeLab=[[UILabel alloc]init];
        _incomeLab.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        _incomeLab.font=[UIFont systemFontOfSize:KScreenScale(35)];
    }
    return _incomeLab;
}

- (UITextField *)withdrawTF{
    if (!_withdrawTF) {
        _withdrawTF = [[UITextField alloc]init];
        _withdrawTF.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        _withdrawTF.font=[UIFont boldSystemFontOfSize:20];
        _withdrawTF.placeholder=@" 请输入小于50000元的提现金额";
        _withdrawTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_withdrawTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"cccccc"],NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        _withdrawTF.keyboardType=UIKeyboardTypeDecimalPad;
        _withdrawTF.returnKeyType=UIReturnKeyDone;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_withdrawTF];
    }
    return _withdrawTF;
}

- (UIButton *)withdrawSubmitBtn
{
    if (!_withdrawSubmitBtn) {
        _withdrawSubmitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_withdrawSubmitBtn setTitle:@"确认提交申请" forState:UIControlStateNormal];
        _withdrawSubmitBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(40)];
        _withdrawSubmitBtn.backgroundColor=[UIColor convertHexToRGB:kLightTextColor];
        _withdrawSubmitBtn.layer.cornerRadius=5.0;
        [_withdrawSubmitBtn addTarget:self action:@selector(withdrawSubmitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _withdrawSubmitBtn;
}

@end

@interface WithdrawCell_proceed ()
@property (nonatomic, strong) UILabel       *titleLab;
@property (nonatomic, strong) UILabel       *contentLab;

@end

@implementation WithdrawCell_proceed

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = kViewCtrBackColor;
    [self.contentView sd_addSubviews:@[self.titleLab, self.contentLab]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .rightSpaceToView(self.contentView, KScreenScale(30))
    .heightIs(0);
    self.contentLab.sd_layout.topSpaceToView(self.titleLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(0);
    
    [self setupAutoHeightWithBottomView:self.contentLab bottomMargin:0];
}

- (void)setModel:(UleCellBaseModel *)model{
    NSString *textStr = [NSString isNullToString:model.data];
    NSString *titleStr = @"";
    NSString *contentStr = @"";
    CGFloat hintH = 0.0;
    NSArray *array = [textStr componentsSeparatedByString:@"#&#"];
    titleStr = [array firstObject];
    if ([NSString isNullToString:titleStr].length>0) {
        self.titleLab.text = titleStr;
        self.titleLab.sd_layout.heightIs(15);
    }
    if (array.count>1) {
        contentStr = [NSString isNullToString:[array[1] stringByReplacingOccurrencesOfString:@"##" withString:@"\n"]];
        hintH = [contentStr heightForFont:self.contentLab.font width:__MainScreen_Width-KScreenScale(60)]+20;
        self.contentLab.text = contentStr;
        self.contentLab.sd_layout.heightIs(hintH);
    }
}

#pragma mark - <getters>
- (UILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor redColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.font = [UIFont systemFontOfSize:15];
    }
    return _titleLab;
}

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc]init];
        _contentLab.adjustsFontSizeToFitWidth = YES;
        _contentLab.textColor = [UIColor convertHexToRGB:kBlackTextColor];
        _contentLab.textAlignment = NSTextAlignmentLeft;
        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

@end



@interface WithdrawCell_summary ()
@property (nonatomic, strong) UILabel       *titleLab;
@property (nonatomic, strong) UIView        *summaryBgView;
@property (nonatomic, strong) UILabel       *summaryDescLab;
@property (nonatomic, strong) UILabel       *summaryNumLab;
@property (nonatomic, strong) UILabel       *summaryTimeLab;
@property (nonatomic, strong) UILabel       *summaryStateLab;
@property (nonatomic, strong) UIView        *lineView;
@property (nonatomic, strong) UIButton      *recordBtn;
@property (nonatomic, strong) WithdrawSummaryCellModel  *mDataModel;

@end

@implementation WithdrawCell_summary

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.contentView.backgroundColor = kViewCtrBackColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab, self.summaryBgView]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .rightSpaceToView(self.contentView, KScreenScale(30))
    .heightIs(0);
    self.summaryBgView.sd_layout.topSpaceToView(self.titleLab, KScreenScale(20))
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(0);
    [self.summaryBgView sd_addSubviews:@[self.summaryNumLab, self.summaryDescLab, self.summaryTimeLab, self.summaryStateLab, self.recordBtn]];
    self.summaryNumLab.sd_layout.topSpaceToView(self.summaryBgView, KScreenScale(20))
    .rightSpaceToView(self.summaryBgView, KScreenScale(30))
    .heightIs(0)
    .widthIs(__MainScreen_Width*0.33);
    self.summaryDescLab.sd_layout.topEqualToView(self.summaryNumLab)
    .leftSpaceToView(self.summaryBgView, KScreenScale(30))
    .rightSpaceToView(self.summaryNumLab, 0)
    .heightRatioToView(self.summaryNumLab, 1.0);
    self.summaryTimeLab.sd_layout.topSpaceToView(self.summaryDescLab, KScreenScale(20))
    .leftEqualToView(self.summaryDescLab)
    .rightEqualToView(self.summaryDescLab)
    .heightRatioToView(self.summaryDescLab, 1.0);
    self.summaryStateLab.sd_layout.topEqualToView(self.summaryTimeLab)
    .leftEqualToView(self.summaryNumLab)
    .rightEqualToView(self.summaryNumLab)
    .heightRatioToView(self.summaryTimeLab, 1.0);
    
    [self.summaryBgView addSubview:self.lineView];
    self.lineView.sd_layout.topSpaceToView(self.summaryTimeLab, KScreenScale(10))
    .leftSpaceToView(self.summaryBgView, 0)
    .rightSpaceToView(self.summaryBgView, 0)
    .heightIs(0);
    self.recordBtn.sd_layout.topSpaceToView(self.lineView, 0)
    .leftSpaceToView(self.summaryBgView, 0)
    .rightSpaceToView(self.summaryBgView, 0)
    .heightIs(KScreenScale(66));
    self.recordBtn.hidden=YES;
    
    [self setupAutoHeightWithBottomView:self.summaryBgView bottomMargin:0];
}

- (void)setModel:(WithdrawSummaryCellModel *)model{
    self.mDataModel = model;
    if (model.data) {
        WithdrawRecordList *itemModel = model.data;
        if (itemModel) {
            self.titleLab.text = @"最近一次提现";
            self.titleLab.sd_layout.heightIs(KScreenScale(40));
            self.summaryNumLab.sd_layout.heightIs(KScreenScale(40));
            self.lineView.sd_layout.heightIs(0.5);
            self.summaryBgView.sd_layout.heightIs(KScreenScale(196)+0.5);
            self.recordBtn.hidden=NO;
            self.summaryDescLab.text = [NSString stringWithFormat:@"%@(尾号%@)",[NSString isNullToString:itemModel.bankOrgan],[NSString isNullToString:itemModel.bankCode]];
            [self setAttributedBankInfo:self.summaryDescLab];
            self.summaryNumLab.text = [NSString stringWithFormat:@"￥%.2lf",itemModel.orderMoney.doubleValue?itemModel.orderMoney.doubleValue:0.00];
            [self setAttributedOrderMoney:self.summaryNumLab];
            
            self.summaryStateLab.textColor = [UIColor convertHexToRGB:[NSString isNullToString:itemModel.colorText]];
            self.summaryStateLab.text = [NSString isNullToString:itemModel.statusText];
            self.summaryTimeLab.text = [NSString isNullToString:itemModel.timeText];
        }
    }
}

- (void)recordBtnAction:(UIButton *)sender{
    if (self.mDataModel.withdrawSummaryRecordBlock) {
        self.mDataModel.withdrawSummaryRecordBlock();
    }
}


-(void)setAttributedOrderMoney:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 1)];
    label.attributedText = attributedStr;
}

-(void)setAttributedBankInfo:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"36a4f1"] range:NSMakeRange(attributedStr.length-8, 8)];
    label.attributedText = attributedStr;
}
#pragma mark - <getters>
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
        _titleLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
    }
    return _titleLab;
}

- (UIView *)summaryBgView
{
    if (!_summaryBgView) {
        _summaryBgView = [[UIView alloc]init];
        _summaryBgView.backgroundColor = [UIColor whiteColor];
    }
    return _summaryBgView;
}

- (UILabel *)summaryDescLab{
    if (!_summaryDescLab) {
        _summaryDescLab = [[UILabel alloc]init];
        _summaryDescLab.adjustsFontSizeToFitWidth = YES;
        _summaryDescLab.textColor = [UIColor convertHexToRGB:kDarkTextColor];
        _summaryDescLab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    }
    return _summaryDescLab;
}

- (UILabel *)summaryNumLab{
    if (!_summaryNumLab) {
        _summaryNumLab = [[UILabel alloc]init];
        _summaryNumLab.adjustsFontSizeToFitWidth = YES;
        _summaryNumLab.textColor = [UIColor convertHexToRGB:kDarkTextColor];
        _summaryNumLab.font = [UIFont systemFontOfSize:KScreenScale(34)];
        _summaryNumLab.textAlignment = NSTextAlignmentRight;
    }
    return _summaryNumLab;
}

- (UILabel *)summaryTimeLab{
    if (!_summaryTimeLab) {
        _summaryTimeLab = [[UILabel alloc]init];
        _summaryTimeLab.adjustsFontSizeToFitWidth = YES;
        _summaryTimeLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
        _summaryTimeLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
    }
    return _summaryTimeLab;
}

- (UILabel *)summaryStateLab{
    if (!_summaryStateLab) {
        _summaryStateLab = [[UILabel alloc]init];
        _summaryStateLab.adjustsFontSizeToFitWidth = YES;
        _summaryStateLab.textColor = [UIColor convertHexToRGB:kGreenColor];
        _summaryStateLab.textAlignment = NSTextAlignmentRight;
    }
    return _summaryStateLab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor convertHexToRGB:kLightTextColor];
    }
    return _lineView;
}

- (UIButton *)recordBtn{
    if (!_recordBtn) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordBtn setTitleColor:[UIColor convertHexToRGB:kLightTextColor] forState:UIControlStateNormal];
        [_recordBtn setTitle:@"查看提现记录" forState:UIControlStateNormal];
        _recordBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        [_recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordBtn;
}

@end
