//
//  US_MemberEditVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MemberEditVC.h"
#import "US_MemberListCellModel.h"
#import <UIView+SDAutoLayout.h>
#import <NSString+Utility.h>
#import "USImagePicker.h"
#include "sys/stat.h"
#import <NSData+Base64.h>
#import "US_UserCenterApi.h"
#import "UserHeadImg.h"
#import <NSString+Utility.h>
#import "DeviceInfoHelper.h"

static NSString * const KTempNum = @"0123456789";

@interface US_MemberEditVC ()<UITextFieldDelegate>
@property (nonatomic, strong) US_MemberListCellModel * memberInfo;
@property (nonatomic, strong) UIImageView   * headImgView;           //头像图片
@property (nonatomic, strong) UILabel       * headImgTipsLabel;      //头像提示label
@property (nonatomic, strong) UITextField   * nameTextField;
@property (nonatomic, strong) UITextField   * phoneNumTextField;
@property (nonatomic, strong) UITextField   * addressTextField;
@property (nonatomic, strong) UIButton      * cancelEditButton;     //放弃修改按钮
@property (nonatomic, strong) UIButton      * confirmEditButton;    //确认修改按钮

@end

@implementation US_MemberEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"客户信息编辑"];
    }
    self.view.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
    self.memberInfo = [self.m_Params objectForKey:@"memberInfo"];
    [self setUI];
    [self setData];
}

- (void)setData{
    if (self.memberInfo) {
        if (self.memberInfo.imageUrl.length > 0) {
            [self.headImgView yy_setImageWithURL:[NSURL URLWithString:self.memberInfo.imageUrl] placeholder:[UIImage bundleImageNamed:@"member_img_add"]];
            self.headImgTipsLabel.text=@"编辑";
        }
        else{
             [self.headImgView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"member_img_add"]];
            self.headImgTipsLabel.text=@"求靓照";
        }
        
        [self.nameTextField setText:self.memberInfo.name];
        [self.phoneNumTextField setText:self.memberInfo.mobileNum];
        [self.addressTextField setText:self.memberInfo.addr];
    }
}

- (void)setUI{
    
    UIView * topBackView = [UIView new];
    topBackView.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImg)];
    topBackView.userInteractionEnabled = YES;
    [topBackView addGestureRecognizer:tap];
    
    [self.headImgView sd_addSubviews:@[self.headImgTipsLabel]];
    self.headImgTipsLabel.sd_layout
    .bottomSpaceToView(self.headImgView, 0)
    .leftSpaceToView(self.headImgView, 0)
    .rightSpaceToView(self.headImgView, 0)
    .heightIs(18);
    
    UILabel * selectImgTipsLab=[UILabel new];
    selectImgTipsLab.text=@"换照片";
    selectImgTipsLab.textColor=[UIColor convertHexToRGB:@"aaaaaa"];
    selectImgTipsLab.font = [UIFont systemFontOfSize:15];
    selectImgTipsLab.textAlignment=NSTextAlignmentRight;
    
    UIImageView * arrowImgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"enter_icon"]];
    
    UILabel * nameTitleLab = [UILabel new];
    nameTitleLab.textColor=[UIColor convertHexToRGB:@"aaaaaa"];
    nameTitleLab.attributedText=[@"     姓   名*" setSubStrings:@[@"*"] showWithColor:kNavBarBackColor];
    nameTitleLab.backgroundColor=[UIColor convertHexToRGB:@"ffffff"];
    nameTitleLab.font = [UIFont systemFontOfSize:15];
    
    UILabel * phoneNumTitleLab = [UILabel new];
    phoneNumTitleLab.textColor=[UIColor convertHexToRGB:@"aaaaaa"];
    phoneNumTitleLab.attributedText=[@"     手机号*" setSubStrings:@[@"*"] showWithColor:kNavBarBackColor];
    phoneNumTitleLab.backgroundColor=[UIColor convertHexToRGB:@"ffffff"];
    phoneNumTitleLab.font = [UIFont systemFontOfSize:15];
    
    UILabel * addressTitleLab = [UILabel new];
    addressTitleLab.text=@"     地址";
    addressTitleLab.textColor=[UIColor convertHexToRGB:@"aaaaaa"];
    addressTitleLab.backgroundColor=[UIColor convertHexToRGB:@"ffffff"];
    addressTitleLab.font = [UIFont systemFontOfSize:15];
    UILabel * starTipsLab = [UILabel new];
    starTipsLab.text=@"     *为必填项";
    starTipsLab.textColor=[UIColor convertHexToRGB:@"a1a1a1"];
    starTipsLab.font = [UIFont systemFontOfSize:13];
    
    [self.view sd_addSubviews:@[topBackView,self.headImgView,selectImgTipsLab,arrowImgView,nameTitleLab,self.nameTextField,phoneNumTitleLab,self.phoneNumTextField,addressTitleLab,self.addressTextField,starTipsLab,self.cancelEditButton,self.confirmEditButton]];
    
    topBackView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(85);
    self.headImgView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 10)
    .leftSpaceToView(self.view, 15)
    .widthIs(65)
    .heightIs(65);
    arrowImgView.sd_layout
    .centerYEqualToView(self.headImgView)
    .rightSpaceToView(self.view, 15)
    .widthIs(9)
    .heightIs(17);
    selectImgTipsLab.sd_layout
    .centerYEqualToView(self.headImgView)
    .rightSpaceToView(arrowImgView, 5)
    .widthIs(80)
    .heightIs(20);
    
    nameTitleLab.sd_layout
    .topSpaceToView(topBackView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(55);
    self.nameTextField.sd_layout
    .topEqualToView(nameTitleLab)
    .leftSpaceToView(self.view, 90)
    .rightSpaceToView(self.view, 15)
    .heightRatioToView(nameTitleLab, 1);
    
    phoneNumTitleLab.sd_layout
    .topSpaceToView(nameTitleLab, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightRatioToView(nameTitleLab, 1);
    self.phoneNumTextField.sd_layout
    .topEqualToView(phoneNumTitleLab)
    .leftSpaceToView(self.view, 90)
    .rightSpaceToView(self.view, 15)
    .heightRatioToView(phoneNumTitleLab, 1);
    
    addressTitleLab.sd_layout
    .topSpaceToView(phoneNumTitleLab, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightRatioToView(nameTitleLab, 1);
    self.addressTextField.sd_layout
    .topEqualToView(addressTitleLab)
    .leftSpaceToView(self.view, 90)
    .rightSpaceToView(self.view, 15)
    .heightRatioToView(addressTitleLab, 1);
    
    starTipsLab.sd_layout
    .topSpaceToView(addressTitleLab, 10)
    .leftEqualToView(addressTitleLab)
    .rightSpaceToView(self.view, 15)
    .heightIs(20);
    
    [self.view sendSubviewToBack:topBackView];
    [self.view bringSubviewToFront:self.nameTextField];
    [self.view bringSubviewToFront:self.phoneNumTextField];
    [self.view bringSubviewToFront:self.addressTextField];
    
    for (int i = 0; i < 4; i++) {
        UIView * lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor convertHexToRGB:@"cecece"]];
        [lineView setFrame:CGRectMake(0, self.uleCustemNavigationBar.bottom+85+(i*55), __MainScreen_Width, 1)];
        [self.view addSubview:lineView];
    }
    
    self.cancelEditButton.sd_layout
    .bottomSpaceToView(self.view, KTabbarSafeBottomMargin+30)
    .leftSpaceToView(self.view, 15)
    .widthIs((__MainScreen_Width-60)*0.5)
    .heightIs(44);
    self.confirmEditButton.sd_layout
    .bottomSpaceToView(self.view, KTabbarSafeBottomMargin+30)
    .rightSpaceToView(self.view, 15)
    .widthIs((__MainScreen_Width-60)*0.5)
    .heightIs(44);
    
    UIView * cancelEditButtonBackView = [[UIView alloc] init];
    [cancelEditButtonBackView setBackgroundColor:[UIColor convertHexToRGB:@"c60a1e"]];
    cancelEditButtonBackView.layer.cornerRadius = 5.2;
    [self.view sd_addSubviews:@[cancelEditButtonBackView]];
    cancelEditButtonBackView.sd_layout
    .bottomSpaceToView(self.view, KTabbarSafeBottomMargin+29)
    .leftSpaceToView(self.view, 14)
    .widthIs(self.cancelEditButton.width+2)
    .heightIs(46);
    [self.view sendSubviewToBack:cancelEditButtonBackView];
}
#pragma mark - 点击事件
- (void)selectImg{
    if (self.memberInfo.imageUrl.length > 0) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"更换照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickVC];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除照片" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.memberInfo.imageUrl=@"";
            [self setData];
        }];
        UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    else{
        [self showImagePickVC];
    }
}

- (void)cancelEditButtonClick{
    [self popViewController];
}

- (void)confirmEditButtonClick{
    if ([self VerificationAllInformation]) {
        NSLog(@"上传");
        NSString * cardNumStr = [[NSString stringWithFormat:@"%@",self.memberInfo.cardNum] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                    cardNumStr,@"cardNum",
                                    [NSString stringWithFormat:@"%@",@(self.memberInfo.seqId)],@"seqId",
                                    [NSString stringWithFormat:@"%@",self.nameTextField.text],@"customerName",
                                    [NSString stringWithFormat:@"%@",self.phoneNumTextField.text],@"mobile",
                                    [NSString stringWithFormat:@"%@",self.memberInfo.imageUrl],@"imageUrl",
                                    [NSString stringWithFormat:@"%@",self.addressTextField.text],@"addr",
                                    @"",@"idcard",
                                    nil];
            [dic setValue:[NSString stringWithFormat:@"%@",@(self.memberInfo.integral)] forKey:@"integral"];
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
            [self.networkClient_API beginRequest:[US_UserCenterApi buildUpdateMemberInfoRequestWithDateDic:dic] success:^(id responseObject) {
                self.memberInfo.name=self.nameTextField.text;
                self.memberInfo.mobileNum=self.phoneNumTextField.text;
                self.memberInfo.addr=self.addressTextField.text;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RefreshMemberPage object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.memberInfo,@"memberInfo",nil]];
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"修改成功" afterDelay:2 withTarget:self dothing:@selector(goBack)];
                
            } failure:^(UleRequestError *error) {
                [self showErrorHUDWithError:error];
            }];
    }
}

- (void)goBack{
    [self popViewController];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
        return NO;
    }
    
    if (textField == self.phoneNumTextField)
    {
        NSUInteger length =textField.text.length;
        if (length>=11&&string.length>0)
        {
            return NO;
        }
        NSCharacterSet *cs;
        cs =[[NSCharacterSet characterSetWithCharactersInString:KTempNum]invertedSet];
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic =[string isEqualToString:filtered];
        return basic;
    }
    else if (textField == self.nameTextField)
    {
        //去除特殊符号，二次验证通过正则表达式
        NSCharacterSet *cs = [NSCharacterSet characterSetWithCharactersInString:@"^_^0123456789＼｜＝％＊＠＃／＿;＆－＾￡＄￥><>」「」’‘’］［］£€:/：；（）¥@“”。，、？！.【】｛｝—～《》…,^_^?!'[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
        NSString *filtered =[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic =[string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

- (void)showImagePickVC{
    @weakify(self);
    [USImagePicker startWKImagePicker:self cameraFailCallBack:^(NSInteger code){
        @strongify(self);
        switch (code) {
            case 1:
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"该设备不支持拍照" afterDelay:1.5];
                break;
            case 2:
                //相机权限不通过
                [self showAlertNormal:[NSString stringWithFormat:@"相机开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"相机\">\"%@\"",[DeviceInfoHelper getAppName]]];
                break;
            default:
                break;
        }
    } photoAlbumFailCallBack:^{
        //相册权限不通过
        [self showAlertNormal:[NSString stringWithFormat:@"相册开启失败，请通过以下步骤开启权限,\"设置\">\"隐私\">\"照片\">\"%@\"",[DeviceInfoHelper getAppName]]];
    } chooseCallBack:^(NSDictionary<NSString *,id> *info) {
        if(![[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]){
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"只能上传图片" afterDelay:1.5];
            return;
        }
        UIImage *original = [info objectForKey:UIImagePickerControllerEditedImage];
        [self uploadPhotoImage:original];
    } cancelCallBack:^{
    }];
}

- (void)uploadPhotoImage:(UIImage *)image{
    //将截好的图片存到本地
    NSError *err;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"temp.jpg"];
    if([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:&err];
    }
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:filePath atomically:YES];
    NSData *imageData;
    if([self fileSizeAtPath:filePath] > 512*512)
    {
        imageData = UIImageJPEGRepresentation(image, 512*512/[self fileSizeAtPath:filePath]);
    }
    else
    {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
    }
    
    NSString *hash = [imageData base64EncodedString];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在上传头像"];
    
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildUploadMemberImageWithStreamData:hash] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"上传成功" afterDelay:2];
        UserHeadImg *headImg = [UserHeadImg yy_modelWithDictionary:responseObject];
        self.memberInfo.imageUrl=headImg.data.imageUrl;
        [self setData];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
    
}

//图片长度
- (long long) fileSizeAtPath:(NSString*) filePath
{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}

//判断字符串是否为空
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//校验全部信息
- (BOOL)VerificationAllInformation{
    if ([self isBlankString:self.nameTextField.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入客户姓名" afterDelay:showDelayTime];
        return NO ;
    }
    if (![self checkUserName:self.nameTextField.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"输入客户姓名格式不正确" afterDelay:showDelayTime];
        return NO;
    }
    if ([self isBlankString:self.phoneNumTextField.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入客户手机号" afterDelay:showDelayTime];
        return NO ;
    }
    if (![NSString isMobileNum:self.phoneNumTextField.text]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入正确手机号" afterDelay:showDelayTime];
        return NO ;
    }
    return YES;
}

//校验用户名
- (BOOL)checkUserName:(NSString *)userName {
    @try {
        NSString *pattern = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
        BOOL isMatch = [userName isValidateByRegex:pattern];
        return isMatch;
    } @catch (NSException *exception) {
        return NO;
    }
}

#pragma mark - <setter and getter>

- (UIImageView *) headImgView{
    if (!_headImgView) {
        _headImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 65)];
        _headImgView.layer.cornerRadius = 65/2;
        [_headImgView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"member_img_add"]];
        _headImgView.clipsToBounds = YES;
    }
    return _headImgView;
}
- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField=[[UITextField alloc]init];
        _nameTextField.placeholder=@"请输入姓名";
        _nameTextField.font=[UIFont systemFontOfSize:15];
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.delegate=self;
    }
    return _nameTextField;
}
- (UITextField *)phoneNumTextField{
    if (!_phoneNumTextField) {
        _phoneNumTextField=[[UITextField alloc]init];
        _phoneNumTextField.placeholder=@"请输入手机号";
        _phoneNumTextField.font=[UIFont systemFontOfSize:15];
        _phoneNumTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTextField.delegate=self;
    }
    return _phoneNumTextField;
}
- (UITextField *)addressTextField{
    if (!_addressTextField) {
        _addressTextField=[[UITextField alloc]init];
        _addressTextField.placeholder=@"请输入地址";
        _addressTextField.font=[UIFont systemFontOfSize:15];
        _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTextField.keyboardType = UIKeyboardTypeDefault;
        _addressTextField.delegate=self;
    }
    return _addressTextField;
}
- (UILabel *)headImgTipsLabel{
    if (!_headImgTipsLabel) {
        _headImgTipsLabel=[[UILabel alloc] init];
        _headImgTipsLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _headImgTipsLabel.textColor = [UIColor whiteColor];
        _headImgTipsLabel.font = [UIFont systemFontOfSize:10];
        _headImgTipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headImgTipsLabel;
}

- (UIButton *)cancelEditButton{
    if (!_cancelEditButton) {
        _cancelEditButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelEditButton setTitle:@"放弃修改" forState:UIControlStateNormal];
        [_cancelEditButton setTitleColor:[UIColor convertHexToRGB:@"c60a1e"] forState:UIControlStateNormal];
        _cancelEditButton.layer.cornerRadius = 4.8;
        _cancelEditButton.backgroundColor = [UIColor whiteColor];
        [_cancelEditButton addTarget:self action:@selector(cancelEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelEditButton;
}
- (UIButton *)confirmEditButton{
    if (!_confirmEditButton) {
        _confirmEditButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmEditButton setTitle:@"确认保存" forState:UIControlStateNormal];
        [_confirmEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmEditButton.layer.cornerRadius = 5;
        _confirmEditButton.backgroundColor = [UIColor convertHexToRGB:@"ca061e"];
        [_confirmEditButton addTarget:self action:@selector(confirmEditButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmEditButton;
}
@end
