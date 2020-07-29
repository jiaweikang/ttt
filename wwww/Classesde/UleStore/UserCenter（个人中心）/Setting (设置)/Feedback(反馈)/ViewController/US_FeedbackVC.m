//
//  US_FeedbackVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_FeedbackVC.h"
#import <UIView+SDAutoLayout.h>
#import <UleKeyBoardScrollView.h>
#import "FSTextView.h"
#import "US_UserCenterApi.h"
#import "UserDefaultManager.h"
#import "DeviceInfoHelper.h"

#define key_lastSubmitTime @"LastSubmitTime"

static NSString *stringDefault = @"亲，请写下您遇到的系统问题，或提出您宝贵的意见和建议，谢谢！";


@interface US_FeedbackVC ()<UITextViewDelegate>
@property (nonatomic, strong) UleKeyBoardScrollView * mBackScrollView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) FSTextView * suggestTextView;
@property (nonatomic, strong) UILabel * versionLab;
@property (nonatomic, strong) UIButton * submitButton;
@end

@implementation US_FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"问题反馈"];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (void)setUI{
    [self.view addSubview:self.mBackScrollView];
    self.mBackScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mBackScrollView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self.mBackScrollView sd_addSubviews:@[self.titleLab,self.suggestTextView,self.versionLab,self.submitButton]];
    self.titleLab.sd_layout
    .topSpaceToView(self.mBackScrollView, 0)
    .leftSpaceToView(self.mBackScrollView, 20)
    .rightSpaceToView(self.mBackScrollView, 20)
    .heightIs(40);
    self.suggestTextView.sd_layout
    .topSpaceToView(self.titleLab, 10)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(self.view.frame.size.height/3);
    self.versionLab.sd_layout
    .topSpaceToView(self.suggestTextView, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(40);
    self.submitButton.sd_layout
    .topSpaceToView(self.versionLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.titleLab)
    .heightIs(38);

    __weak __typeof(self) weakSelf = self;
    // 添加输入改变Block回调.
    [self.suggestTextView addTextDidChangeHandler:^(FSTextView *textView) {
        [weakSelf textViewTextDidChangeHandle:textView.text];
    }];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.suggestTextView becomeFirstResponder];
}

- (void)textViewTextDidChangeHandle:(NSString *)textStr{
    textStr = [textStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textStr.length > 0) {
        self.submitButton.backgroundColor = [UIColor convertHexToRGB:@"c60a1e"];
    } else {
        self.submitButton.backgroundColor = [UIColor colorWithWhite:0.824 alpha:1.000];
    }
}

#pragma mark - Action
- (void)submitButtonPress:(UIButton *)sender {
    [self.suggestTextView resignFirstResponder];
  NSString * textStr = [self.suggestTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textStr.length == 0) {
        [UserDefaultManager setLocalDataObject:[NSDate date] key:key_lastSubmitTime];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入您的建议或意见" afterDelay:showDelayTime];
        return;
    }
    if([self timeComponent]) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"限15分钟提交一次" afterDelay:showDelayTime];
    }
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildSuggestSubmitRequest:textStr] success:^(id responseObject) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:[[DeviceInfoHelper getAppName] stringByAppendingString:@"非常感谢你的参与！"] afterDelay:showDelayTime withTarget:self dothing:@selector(popViewController)];

    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUD];
        NSString * errorInfo = [error.responesObject objectForKey:@"returnMessage"];
        if (errorInfo.length >0) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:errorInfo afterDelay:showDelayTime];
        }
        NSLog(@"问题反馈error:%@",[error.responesObject objectForKey:@"returnMessage"]);
    }];
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)timeComponent {
    NSDate *lastTime = [UserDefaultManager getLocalDataObject:key_lastSubmitTime];
    return [[NSDate date] timeIntervalSinceDate:lastTime] < 15*60;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
    
}

#pragma mark - setter and getter
- (UleKeyBoardScrollView *)mBackScrollView{
    if (!_mBackScrollView) {
        _mBackScrollView = [[UleKeyBoardScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        _mBackScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        _mBackScrollView.backgroundColor = [self.view backgroundColor];
        if (@available(iOS 11.0, *)) {
            _mBackScrollView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mBackScrollView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc] init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"999999"];
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.text = @"● 问题反馈";
    }
    return _titleLab;
}
- (FSTextView *)suggestTextView{
    if (!_suggestTextView) {
        _suggestTextView = [FSTextView new];
        _suggestTextView.backgroundColor = [UIColor convertHexToRGB:@"EAEAEA"];
        _suggestTextView.font = [UIFont systemFontOfSize:14];
        _suggestTextView.layer.cornerRadius = 4;
        _suggestTextView.placeholder = stringDefault;
        _suggestTextView.returnKeyType = UIReturnKeyDone;
        _suggestTextView.delegate = self;
        _suggestTextView.placeholderColor = [UIColor convertHexToRGB:@"B5B5B5"];
        _suggestTextView.maxLength = 300;
        _suggestTextView.textColor = [UIColor blackColor];
    }
    return _suggestTextView;
}
- (UILabel *)versionLab{
    if (!_versionLab) {
        _versionLab=[[UILabel alloc] init];
        _versionLab.textColor=[UIColor convertHexToRGB:@"999999"];
        _versionLab.font = [UIFont systemFontOfSize:15];
        _versionLab.textAlignment = NSTextAlignmentRight;
        _versionLab.text = [NSString stringWithFormat:@"当前版本:%@",NonEmpty([UleStoreGlobal shareInstance].config.appVersion)];
    }
    return _versionLab;
}
- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = [UIColor colorWithWhite:0.824 alpha:1.000];
        _submitButton.layer.cornerRadius = 3;
        [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        _submitButton.titleLabel.textColor = [UIColor whiteColor];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitButtonPress:) forControlEvents:UIControlEventTouchDown];
    }
    return _submitButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
