//
//  Ule_ResetVC.m
//  u_store
//
//  Created by wangkun on 16/6/12.
//  Copyright © 2016年 yushengyang. All rights reserved.
//

#import "Ule_ResetVC.h"
#import <CoreText/CoreText.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "US_LoginManager.h"

@interface Ule_ResetVC () <UIAlertViewDelegate>
{
    /**
     *  剩余输入机会次数
     */
    NSInteger mRetryNumber;
    // 界面文本信息
    NSString* pwdLocal;     // 本地存储的密码
    NSString* pwdOld;       // 旧密码
    NSString* pwdNew;       // 新密码
    NSString* pwdSure;      // 确认密码
}
/**
 *  顶部提示信息view
 */
@property (nonatomic, strong) Ule_LockIndicator *mIndicator;

/**
 *  文本信息
 */
@property (nonatomic, strong) UILabel *mTipsLabel;

/**
 *  手势锁view
 */
@property (nonatomic, strong) Ule_LockView *mLockView;

/**
 *  忘记密码按钮
 */
@property (nonatomic, strong) UIButton *mUserButton;
@end

@implementation Ule_ResetVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled=YES;//禁用滑动返回
    self.view.backgroundColor = [UIColor convertHexToRGB:@"E0E0E0"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"验证手势密码"];
    }
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mTipsLabel.text = @"请输入原手势密码";
    mRetryNumber = kLVCMaxNumber;
    // 手势密码信息
    pwdOld = @"";
    pwdNew = @"";
    pwdSure = @"";
    pwdLocal = [Ule_LockPasswordFile readLockPassword];
}

#pragma mark -Ule_LockViewDelegate
- (void)lockString:(NSString *)string {
    
    if (!string || string.length < 3) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"密码太短，最少三位，请重新输入" afterDelay:0.8];
        return;
    }
    [self checkPassword:string];
    [self updateIndicator];
}

- (void)updateIndicator {
    if (_mIndicator) {
        // 更新指示圆点
        if (![pwdNew isEqualToString:@""] &&
            [pwdSure isEqualToString:@""]) {
            [self.mIndicator rectPasswordString:pwdNew];
        }
        // 还原
        else {
            [self.mIndicator rectPasswordString:@""];
        }
    }
}

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString *)string {
    
    // 验证密码
    if ([[Ule_LockPasswordFile cryptoStringWithKey:string] isEqualToString:pwdLocal]) {
        // 验证成功
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(UleLockVCTypeModify),kLVTypeKey, nil];
        [self pushNewViewController:@"Ule_LockVC" isNibPage:NO withData:dic];
    }
    // 验证密码错误
    else if (string.length > 0) {
        mRetryNumber --;
        // 继续验证
        if (mRetryNumber > 0) {
            [self setErrorTip:[NSString stringWithFormat:@"密码错误,还可以再输入%@次", @(mRetryNumber)] errorPswd:string];
        }
        // 用户注销回到登录页
        else {
            [self forgerPwdPressed:nil];
        }
    }
}

#pragma mark -显示提示
- (void)setTip:(NSString *)tip {
    
    [self.mTipsLabel setText:tip];
    [self.mTipsLabel setTextColor:[UIColor convertHexToRGB:@"222222"]];
    self.mTipsLabel.alpha = 0;
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.mTipsLabel.alpha = 1;
                     }completion:^(BOOL finished){}];
}

// 错误
- (void)setErrorTip:(NSString*)tip errorPswd:(NSString*)string {
    // 手势显示错误点
    [self.mLockView showErrorInfo:string];
    // 直接_变量的坏处是
    [self.mTipsLabel setText:tip];
    [self.mTipsLabel setTextColor:[UIColor redColor]];
    [self shakeAnimationForView:self.mTipsLabel];
}

#pragma mark -手势错误 抖动动画
- (void)shakeAnimationForView:(UIView *)view {
    
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x - 10, position.y);
    CGPoint right = CGPointMake(position.x + 10, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES]; // 平滑结束
    [animation setDuration:0.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - private methods
- (void)setUI {
    CGFloat offset_y = self.uleCustemNavigationBar.bottom + 34.0f;
    // 文字提示
    CGFloat t_size = 25.0f;
    self.mTipsLabel = ({
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, offset_y + 20.0f, __MainScreen_Width, t_size)];
        tips.backgroundColor = [UIColor clearColor];
        tips.textColor = [UIColor convertHexToRGB:@"222222"];
        tips.font = [UIFont systemFontOfSize:15.0f];
        tips.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tips];
        tips;
    });
    offset_y = offset_y + t_size + 20;
    // 手势view
    CGFloat l_size = 320.0f;
    self.mLockView = ({
        Ule_LockView *lock = [[Ule_LockView alloc] initWithFrame:CGRectMake((__MainScreen_Width-l_size)/2, offset_y, l_size, l_size)];
        lock.backgroundColor = [UIColor clearColor];
        lock.delegate = self;
        [self.view addSubview:lock];
        lock;
    });
}

#pragma mark - event response
#pragma mark -底部按钮(忘记手势密码)
- (void)forgerPwdPressed:(UIButton *)sender {
    
    [Ule_LockPasswordFile removeLockPassword];

    [US_LoginManager logOutToLoginWithMessage:@"请登录"];
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
