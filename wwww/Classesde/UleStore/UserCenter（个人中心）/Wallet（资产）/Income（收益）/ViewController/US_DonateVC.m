//
//  US_DonateVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_DonateVC.h"
#import "US_AlertView.h"
#import "US_DonateAreaPickVC.h"
#import "US_UserCenterApi.h"

@interface US_DonateVC ()<UITextFieldDelegate,US_DonateAreaPickVCDelegate>
@property (nonatomic, strong) NSString      *donateBalance;
@property (nonatomic, strong) UILabel       *ableDonateBalanceLab;
@property (nonatomic, strong) UITextField   *donateAmountTF;//捐赠金额输入框
@property (nonatomic, strong) UITextField   *organization_TF;//捐赠地区
@property (nonatomic, strong) UIButton      *donateSumbitBtn;//确认捐赠
@property (nonatomic, strong) US_postOrigData * selectData;
@end

@implementation US_DonateVC

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"捐赠"];
    self.donateBalance=[self.m_Params objectForKey:@"balance"];
    [self setUI];
}

- (void)setUI{
    //选择捐赠地区
    UILabel *locationTitle=[[UILabel alloc]init];
    locationTitle.text=@"选择捐赠地区：";
    locationTitle.textColor=[UIColor convertHexToRGB:@"999999"];
    locationTitle.font=[UIFont systemFontOfSize:KScreenScale(35)];
    
    UIView *lineView1=[[UIView alloc]init];
    lineView1.backgroundColor=[UIColor convertHexToRGB:@"cccccc"];
    UIView *lineView2=[[UIView alloc]init];
    lineView2.backgroundColor=[UIColor convertHexToRGB:@"cccccc"];
    
    [self.view sd_addSubviews:@[self.ableDonateBalanceLab,self.donateAmountTF,self.organization_TF,locationTitle,lineView1,lineView2,self.donateSumbitBtn]];
    
    self.ableDonateBalanceLab.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, KScreenScale(40))
    .leftSpaceToView(self.view, KScreenScale(40))
    .rightSpaceToView(self.view, KScreenScale(40))
    .heightIs(KScreenScale(60));
    
    self.donateAmountTF.sd_layout
    .topSpaceToView(self.ableDonateBalanceLab, KScreenScale(50))
    .leftSpaceToView(self.view, KScreenScale(80))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(KScreenScale(70));
    lineView1.sd_layout
    .topSpaceToView(self.donateAmountTF, 3)
    .leftSpaceToView(self.view, KScreenScale(40))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(1);
    
    locationTitle.sd_layout
    .topSpaceToView(lineView1, KScreenScale(80))
    .leftSpaceToView(self.view, KScreenScale(20))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(KScreenScale(30));
    self.organization_TF.sd_layout
    .topSpaceToView(locationTitle, KScreenScale(50))
    .leftSpaceToView(self.view, KScreenScale(80))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(KScreenScale(70));
    lineView2.sd_layout
    .topSpaceToView(self.organization_TF, 3)
    .leftSpaceToView(self.view, KScreenScale(40))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(1);
    
    self.donateSumbitBtn.sd_layout
    .bottomSpaceToView(self.view, kIphoneX? 34+KScreenScale(40) : KScreenScale(40))
    .leftSpaceToView(self.view, KScreenScale(20))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(50);
}

#pragma mark - TextField相关
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.organization_TF) {
        [self pushToPick];
        return NO;
    }
    return YES;
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
    
    NSString *commission=[NSString stringWithFormat:@"%.2lf",self.donateBalance?[self.donateBalance doubleValue]:0.00];
    
    if (toBestring.doubleValue>0&&toBestring.length>0&&toBestring.doubleValue<=commission.doubleValue) {
        self.donateSumbitBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        self.donateSumbitBtn.userInteractionEnabled=YES;
    }else{
        self.donateSumbitBtn.backgroundColor=[UIColor convertHexToRGB:@"999999"];
        self.donateSumbitBtn.userInteractionEnabled=NO;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (range.location==0&&[string isEqualToString:@"."]) {
        textField.text=@"0.";
        return NO;
    }
    
    NSInteger length=textField.text.length-range.length+string.length;
    if ([textField.text rangeOfString:@"."].location!=NSNotFound) {
        if ([string isEqualToString:@"."]) {
            return NO;
        }
        return YES;
    }else{
        return length<=8;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text hasSuffix:@"."]) {
        textField.text=[NSString stringWithFormat:@"%@00",textField.text];
    }
}

#pragma mark - US_DonateAreaPickVCDelegate
- (void)organizationSelect:(US_postOrigData *)listData{
    self.organization_TF.text = listData.name;
    _selectData = listData;
}

#pragma mark - Action

//选择机构
-(void)pushToPick{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
    [dic setObject:self forKey:@"delegate"];
    [self pushNewViewController:@"US_DonateAreaPickVC" isNibPage:NO withData:dic];
}

- (void)donateSubmitBtnAction:(UIButton *)button{
    if (self.organization_TF.text.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择捐赠地区" afterDelay:showDelayTime];
        return;
    }
    US_AlertView * alert=[US_AlertView alertViewWithTitle:@"您确认将收益捐赠至该地区吗？" message:@"（确认后，您所输入的收益金额将直接扣除并捐出）" cancelButtonTitle:@"取消" confirmButtonTitle:@"确定"];
    @weakify(self);
    alert.clickBlock = ^(NSInteger buttonIndex, NSString * _Nonnull title) {
        @strongify(self);
        [self donationRequest];
    };
    [alert showViewWithAnimation:AniamtionAlert];
}

- (void)donationRequest{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildDonationRequestWithOrgProvince:_selectData._id OrgProvinceName:_selectData.name TransMoney:self.donateAmountTF.text] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"捐赠成功" afterDelay:2.0 withTarget:self dothing:@selector(viewBack)];

    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

- (void)viewBack{
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_RefreshIncomeData object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITextField *)createTextFieldWithPlaceholderText:(NSString *)placeholderText KeyboardType:(UIKeyboardType )KeyboardType{
    UITextField * textField = [[UITextField alloc]init];
    textField.font = [UIFont systemFontOfSize:15];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = KeyboardType;
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    
    return textField;
}

#pragma mark - setter and getter
- (UILabel *)ableDonateBalanceLab{
    if (!_ableDonateBalanceLab) {
        _ableDonateBalanceLab=[[UILabel alloc]init];
        _ableDonateBalanceLab.textColor=[UIColor convertHexToRGB:@"999999"];
        _ableDonateBalanceLab.font=[UIFont systemFontOfSize:KScreenScale(36)];
        _ableDonateBalanceLab.textAlignment=NSTextAlignmentRight;
        _ableDonateBalanceLab.text=[NSString stringWithFormat:@"最多可捐赠收益：￥%.2lf",[self.donateBalance doubleValue]];
    }
    return _ableDonateBalanceLab;
}

- (UITextField *)donateAmountTF{
    if (!_donateAmountTF) {
        _donateAmountTF=[self createTextFieldWithPlaceholderText:@"请输入捐赠的金额" KeyboardType:UIKeyboardTypeDecimalPad];
        _donateAmountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _donateAmountTF.font = [UIFont systemFontOfSize:KScreenScale(36)];
        UILabel *tfLeftView=[[UILabel alloc]initWithFrame:CGRectMake(0, KScreenScale(10), KScreenScale(50), KScreenScale(40))];
        tfLeftView.textColor=[UIColor convertHexToRGB:@"333333"];
        tfLeftView.text=@"￥ ";
        tfLeftView.font=[UIFont systemFontOfSize:KScreenScale(50)];
        _donateAmountTF.leftView=tfLeftView;
        _donateAmountTF.leftViewMode = UITextFieldViewModeAlways;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_donateAmountTF];
    }
    return _donateAmountTF;
}

- (UITextField *)organization_TF{
    if (!_organization_TF) {
        _organization_TF=[self createTextFieldWithPlaceholderText:@"请选择捐赠地区" KeyboardType:UIKeyboardTypeDefault];
        _organization_TF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _donateAmountTF.font = [UIFont systemFontOfSize:KScreenScale(33)];
        UIImageView * rightImageView=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"enter_icon"]];
        [rightImageView setFrame:CGRectMake(0, 0, 9, 17)];
        _organization_TF.rightView=rightImageView;
        _organization_TF.rightViewMode = UITextFieldViewModeAlways;
    }
    return _organization_TF;
}

- (UIButton *)donateSumbitBtn{
    if (!_donateSumbitBtn) {
        _donateSumbitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_donateSumbitBtn setTitle:@"我要捐赠" forState:UIControlStateNormal];
        _donateSumbitBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(40)];
        _donateSumbitBtn.backgroundColor=[UIColor convertHexToRGB:@"999999"];
        _donateSumbitBtn.userInteractionEnabled=NO;
        [_donateSumbitBtn addTarget:self action:@selector(donateSubmitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _donateSumbitBtn;
}
@end
