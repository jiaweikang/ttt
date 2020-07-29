//
//  US_UpdateUserInfoView.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UpdateUserInfoView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>
#import "FSTextView.h"
#import "UIView+Shade.h"
#import "US_MystoreManangerApi.h"
#import "UleMBProgressHUD.h"
#import <UleNetworkExcute.h>

#define CancelBtnTag  1000
#define ConfirmBtnTag 2000

static NSInteger const kMaxLength = 15;

@interface US_UpdateUserInfoView () <UITextViewDelegate>
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) FSTextView *textView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, copy) ConfirmBlock confirmBlock;
@property (nonatomic, assign) AlertType alerType;

@property (nonatomic, strong) UleNetworkExcute * networkClient_API;
@end

@implementation US_UpdateUserInfoView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (US_UpdateUserInfoView *)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder alertType:(AlertType)alertType confirmBlock:(ConfirmBlock)confirmBlock
{
    return [[self alloc] initWithTitle:title placeholder:placeholder alertType:alertType confirmBlock:confirmBlock];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder alertType:(AlertType)alertType confirmBlock:(ConfirmBlock)confirmBlock
{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width - KScreenScale(152), alertType!=ChangeStoreInfoType ? KScreenScale(312) : KScreenScale(422))];
    if (self) {
        self.confirmBlock = confirmBlock;
        [self createSubviews:title placeholder:(NSString *)placeholder alertType:alertType];
        
        //监听键盘高度
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)createSubviews:(NSString *)title placeholder:(NSString *)placeholder alertType:(AlertType)alertType
{
    self.alerType = alertType;
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = KScreenScale(16);
    
    [self sd_addSubviews:@[self.titleLbl, self.textView, self.cancelBtn, self.confirmBtn]];
    
    self.titleLbl.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(110));
    
    self.textView.sd_layout.topSpaceToView(self.titleLbl, 0)
    .leftSpaceToView(self, KScreenScale(30))
    .rightSpaceToView(self, KScreenScale(30))
    .heightIs(alertType!=ChangeStoreInfoType ? KScreenScale(80) : KScreenScale(200));
    
    self.cancelBtn.sd_layout.bottomSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .widthIs(self.frame.size.width / 2)
    .heightIs(KScreenScale(90));
    
    self.confirmBtn.sd_layout.bottomSpaceToView(self, 0)
    .leftSpaceToView(self.cancelBtn, 0.5)
    .widthIs(self.frame.size.width / 2)
    .heightIs(KScreenScale(90));
    
    [UIView setDirectionBorderWithView:_cancelBtn top:YES left:NO bottom:NO right:YES borderColor:[UIColor lightGrayColor] withBorderWidth:0.5];
    [UIView setDirectionBorderWithView:_confirmBtn top:YES left:NO bottom:NO right:NO borderColor:[UIColor lightGrayColor] withBorderWidth:0.5];
    
    self.titleLbl.text = title;
    self.textView.text = placeholder;
    if (alertType != ChangeStoreInfoType) {
        self.textView.contentInset = UIEdgeInsetsMake(KScreenScale(8), 0, 0, 0);
    }
}

- (void)btnAction:(UIButton *)btn
{
    [self.textView resignFirstResponder];
    if (btn.tag == CancelBtnTag) {
        [self hiddenView];
    } else if (btn.tag == ConfirmBtnTag) {
        if ([NSString isNullToString:self.textView.text].length==0) {
            [UleMBProgressHUD showHUDWithText:@"请输入内容" afterDelay:1.5];
            return;
        }
        if (self.alerType == ChangeUserNameType) {
            [self beginUpdateUserName];
        } else {
            [self beginUpdateStoreInfo];
        }
    }
}

#pragma mark - KVO-keyboard
-(void)keyboardWillDisappear:(NSNotification *)notification
{
    // self.tooBar.frame = rect;
    [UIView animateWithDuration:0.25 animations:^{
        //恢复原样
        self.transform = CGAffineTransformIdentity;
    }];
}
-(void)keyboardWillAppear:(NSNotification *)notification
{
    //获得通知中的info字典
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect= [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];

    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -([UIScreen mainScreen].bounds.size.height-rect.origin.y-self.frame.size.height));
    }];
}
#pragma mark - <UITextView delegate>
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *tmpTxt = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSInteger Length = tmpTxt.length - range.length + text.length;
    if (self.alerType == ChangeStoreInfoType) {
        
        if ([[[UIApplication sharedApplication]textInputMode].primaryLanguage isEqualToString:@"emoji"]) {
            return NO;
        }
        if(Length > 100 && text.length > 0){
            return NO;
        }
    } else {
        if ([@"\n" isEqualToString:text])
        {
            [textView resignFirstResponder];
            return NO;
        }
        NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (Length > kMaxLength) {
//                    textView.text = [tmpTxt substringToIndex:kMaxLength];
                    return NO;
                }
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                
            }
        }
        else{
            if (tmpTxt.length > kMaxLength) {
                textView.text = [tmpTxt substringToIndex:kMaxLength];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - <http request>
- (void)beginUpdateStoreInfo{
    NSString *storeNameStr = [NSString isNullToString:self.textView.text].length > 0 ? self.textView.text : @"";
    if (self.alerType == ChangeStoreInfoType) {
        storeNameStr = [US_UserUtility sharedLogin].m_stationName;
    }
    
    UleRequest * request=[US_MystoreManangerApi buildUpdateStoreInfo:storeNameStr shareText:self.textView.text type:self.alerType==ChangeStoreInfoType ? @"1" : @"0"];
    [UleMBProgressHUD showHUDAddedTo:self withText:@"正在保存"];
    @weakify(self);
    [self.networkClient_API beginRequest:request success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self];
        @strongify(self);
        [self hiddenView];
        NSString *fieldText = [NSString isNullToString:self.textView.text].length > 0 ? self.textView.text : @"";
        if (self.confirmBlock) {
            self.confirmBlock(fieldText);
        }
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self];
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [UleMBProgressHUD showHUDWithText:errorInfo afterDelay:1.5];
    }];
}

- (void)beginUpdateUserName{
    NSString *storeNameStr = [NSString isNullToString:self.textView.text].length > 0 ? self.textView.text : @"用户大人";
    
    UleRequest * request = [US_MystoreManangerApi buildUpdateUserName:storeNameStr];
    [UleMBProgressHUD showHUDAddedTo:self withText:@"正在保存"];
    @weakify(self);
    [self.networkClient_API beginRequest:request success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self];
        @strongify(self);
        [self hiddenView];
        if (self.confirmBlock) {
            self.confirmBlock(storeNameStr);
        }
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self];
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [UleMBProgressHUD showHUDWithText:errorInfo afterDelay:1.5];
    }];
}

#pragma mark - setter and getter
- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (FSTextView *)textView{
    if (!_textView) {
        _textView = [FSTextView new];
        _textView.backgroundColor = [UIColor convertHexToRGB:@"f1f1f1"];
        _textView.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _textView.layer.cornerRadius = KScreenScale(6);
        _textView.returnKeyType = self.alerType==ChangeStoreInfoType?UIReturnKeyDefault:UIReturnKeyDone;
        _textView.delegate = self;
//        _textView.placeholderColor = [UIColor convertHexToRGB:@"B5B5B5"];
        _textView.textColor = [UIColor blackColor];
    }
    return _textView;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.tag = CancelBtnTag;
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        [_confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        _confirmBtn.tag = ConfirmBtnTag;
        [_confirmBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UleNetworkExcute *)networkClient_API{
    if (!_networkClient_API) {
        _networkClient_API=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _networkClient_API;
}

@end
