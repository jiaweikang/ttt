//
//  US_EditStoreNameAndShareVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_EditStoreNameAndShareVC.h"
#import "US_MystoreManangerApi.h"
#import "US_EditStoreAlertView.h"
#import <UIView+ShowAnimation.h>
#import "DeviceInfoHelper.h"

static NSInteger const kMaxLength = 15;
static NSInteger const kVMargin =20;

@interface US_EditStoreNameAndShareVC ()<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIButton * saveButton;
@property (nonatomic, strong) UITextField * storeNameTF;
@property (nonatomic, strong) UIView * tfBackgroudView;
@property (nonatomic, strong) UIButton * ruleButton;
@property (nonatomic, strong) UITextView * storeShareTextView;
@property (nonatomic, strong) NSString * editType;
@property (nonatomic, strong) NSString * storeName;
@property (nonatomic, copy) NSString *storeNameStandard;
@end

@implementation US_EditStoreNameAndShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.editType  = [self.m_Params objectForKey:@"editType"];
    NSString *standardUrl=[self.m_Params objectForKey:@"storeNameStandard"];
    if (!standardUrl||standardUrl.length==0) {
        standardUrl=@"https@@www.ule.com/event/2015/1208/storeStandard.html";
    }
    self.storeNameStandard =standardUrl;
    self.storeName=[self.m_Params objectForKey:@"storeName"];
    [self setUI];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setUI{
    [self.view addSubview:self.saveButton];
    self.saveButton.sd_layout.leftSpaceToView(self.view, kVMargin)
    .rightSpaceToView(self.view, kVMargin)
    .bottomSpaceToView(self.view, 20)
    .heightIs(49);
    if ([self.editType isEqualToString:@"0"]) {
        [self.uleCustemNavigationBar customTitleLabel:@"店铺名"];
        [self setupEditStroeNameUI];
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"StoreNameEdit"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"店铺名"];
    }else if([self.editType isEqualToString:@"1"]){
        [self.uleCustemNavigationBar customTitleLabel:@"店铺分享介绍"];
        [self setupEditStoreShareUI];
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"StoreDesEdit"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"店铺分享介绍"];
    }
}

- (void)setupEditStroeNameUI{

    [self.view sd_addSubviews:@[self.tfBackgroudView,self.ruleButton]];
    [self.tfBackgroudView addSubview:self.storeNameTF];
    
    self.tfBackgroudView.sd_layout.leftSpaceToView(self.view, kVMargin)
    .topSpaceToView(self.uleCustemNavigationBar, kVMargin)
    .rightSpaceToView(self.view, kVMargin)
    .heightIs(49);
    
    self.storeNameTF.sd_layout.leftSpaceToView(self.tfBackgroudView, kVMargin)
    .centerYEqualToView(self.tfBackgroudView)
    .rightSpaceToView(self.tfBackgroudView, kVMargin)
    .heightIs(40);
    
    self.ruleButton.sd_layout.leftSpaceToView(self.view, kVMargin)
    .topSpaceToView(self.tfBackgroudView, kVMargin)
    .rightSpaceToView(self.view, kVMargin)
    .heightIs(45);
    
    self.storeNameTF.text=self.storeName;
}

- (void)setupEditStoreShareUI{
    [self.view sd_addSubviews:@[self.tfBackgroudView]];
    [self.tfBackgroudView addSubview:self.storeShareTextView];
    
    self.tfBackgroudView.sd_layout.leftSpaceToView(self.view, kVMargin)
    .topSpaceToView(self.uleCustemNavigationBar, kVMargin)
    .rightSpaceToView(self.view, kVMargin)
    .heightIs(135);
    
    self.storeShareTextView.sd_layout.leftSpaceToView(self.tfBackgroudView, kVMargin/2.0)
    .topSpaceToView(self.tfBackgroudView, kVMargin/2.0)
    .rightSpaceToView(self.tfBackgroudView, kVMargin/2.0)
    .bottomSpaceToView(self.tfBackgroudView, kVMargin/2.0);
    
    UILabel * note=[UILabel new];
    note.text = @"* 文字介绍写得好，分享到社交软件上更能吸引人哟！";
    note.textColor = [UIColor convertHexToRGB:@"666666"];
    note.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:note];
    note.sd_layout.leftSpaceToView(self.view, kVMargin)
    .topSpaceToView(self.tfBackgroudView, kVMargin)
    .rightSpaceToView(self.view, kVMargin)
    .heightIs(20);
    
    self.storeShareTextView.text=self.storeNameStandard;
}

#pragma mark - <http request>
- (void)beginUpdateStoreInfo{
    NSString * storeNameStr=[self.editType isEqualToString:@"0"]?self.storeNameTF.text:self.storeName;
    UleRequest * request=[US_MystoreManangerApi buildUpdateStoreInfo:storeNameStr shareText:self.storeShareTextView.text type:self.editType];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在保存"];
    @weakify(self);
    [self.networkClient_API beginRequest:request success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        US_EditStoreAlertView * alert=[[US_EditStoreAlertView alloc] initWithTitle:@"信息保存成功" type:US_EditStoreAlertViewSucess confirmBlock:^(id obj) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showViewWithAnimation:AniamtionPresentBottom];
        if ([self.editType isEqualToString:@"0"]) {
            [US_UserUtility saveStationName:self.storeNameTF.text];
        }else if ([self.editType isEqualToString:@"1"]) {
            [US_UserUtility saveStoreDesc:self.storeShareTextView.text];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:Notify_EditStoreInfo object:nil userInfo:nil];
        
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        US_EditStoreAlertView * alert=[[US_EditStoreAlertView alloc] initWithTitle:errorInfo type:US_EditStoreAlertViewFailed confirmBlock:^(id obj) {
        }];
        [alert showViewWithAnimation:AniamtionPresentBottom];
    }];
}

#pragma mark - <UITextFieldDelegate>
- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
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
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.storeNameTF resignFirstResponder];
    self.storeName=self.storeNameTF.text;
    [self beginUpdateStoreInfo];
    return YES;
}

#pragma mark - <UITextView delegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *tmpTxt = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger Length = tmpTxt.length - range.length + text.length;
    
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    if(Length > 100 && text.length > 0){
        return NO;
    }
    return YES;
}
#pragma mark - <button event>
- (void)saveClick:(id)sender{
    [self beginUpdateStoreInfo];
}

- (void)ruleButtonClick:(id)sender{
    NSMutableDictionary *params = @{@"title":@"小店命名规则",@"key":self.storeNameStandard}.mutableCopy;
    [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
}

#pragma mark - <setter and getter>
- (UIView *)tfBackgroudView{
    if (!_tfBackgroudView) {
        _tfBackgroudView=[[UIView alloc] init];
        _tfBackgroudView.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
        _tfBackgroudView.clipsToBounds=YES;
        _tfBackgroudView.layer.cornerRadius=5;
        _tfBackgroudView.layer.borderWidth=0.6;
        _tfBackgroudView.layer.borderColor=[UIColor convertHexToRGB:@"cccccc"].CGColor;
    }
    return _tfBackgroudView;
}

- (UITextField *)storeNameTF{
    if (!_storeNameTF) {
        _storeNameTF=[[UITextField alloc] init];
        _storeNameTF.placeholder=[DeviceInfoHelper getAppName];
        _storeNameTF.returnKeyType = UIReturnKeyDone;
        _storeNameTF.tintColor = [UIColor redColor];
        _storeNameTF.delegate=self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:_storeNameTF];
    }
    return _storeNameTF;
}
- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton=[[UIButton alloc] initWithFrame:CGRectZero];
        _saveButton.backgroundColor=kNavBarBackColor;
        _saveButton.layer.cornerRadius=5;
        [_saveButton setTitle:@"保存信息" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}
- (UIButton *)ruleButton{
    if (!_ruleButton) {
        _ruleButton=[[UIButton alloc] init];
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:@"查看《小店命名规范》"];
        _ruleButton.layer.cornerRadius = 5;
        _ruleButton.layer.borderColor = [UIColor convertHexToRGB:@"999999"].CGColor;
        _ruleButton.layer.borderWidth = 1;
        _ruleButton.layer.masksToBounds = YES;
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(0,2)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"36a4f1"] range:NSMakeRange(2,@"查看《小店命名规范》".length - 2)];
        [_ruleButton setAttributedTitle:attriString forState:UIControlStateNormal];
        [_ruleButton addTarget:self action:@selector(ruleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ruleButton;
}

- (UITextView *)storeShareTextView{
    if (!_storeShareTextView) {
        _storeShareTextView=[[UITextView alloc] init];
        _storeShareTextView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _storeShareTextView.font = [UIFont systemFontOfSize:15];
        _storeShareTextView.delegate = self;
        _storeShareTextView.tintColor = [UIColor redColor];
        _storeShareTextView.text=@"有一家不错的店铺！分享给你们";
    }
    return _storeShareTextView;
}
@end
