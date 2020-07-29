//
//  Ule_LockVC.m
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "Ule_LockVC.h"
#import <YYWebImage.h>
#import <CoreText/CoreText.h>
#import "US_UserUtility.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "US_LoginManager.h"


@interface Ule_LockVC ()<UIAlertViewDelegate>
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
    NSString* tip_1;        // 提示语1
    NSString* tip_2;        // 提示语2
}

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImageView *mUserImage;

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

@implementation Ule_LockVC

- (instancetype)initWithType:(UleLockVCType)ntype {
    self = [super init];
    if (self) {
        _nLockViewType = ntype;
    }
    return self;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled=YES;//禁用滑动返回
    
    self.view.frame=[UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor convertHexToRGB:@"E0E0E0"];
    if (self.m_Params[kLVTypeKey]) {
        self.nLockViewType = (UleLockVCType)[self.m_Params[kLVTypeKey] integerValue];
    }
    if (self.nLockViewType == UleLockVCTypeCheck) {
        [self.uleCustemNavigationBar removeFromSuperview];
    }else{
        NSString *title=[self.m_Params objectForKey:@"title"];
        if (title&&title.length>0) {
            [self.uleCustemNavigationBar customTitleLabel:title];
        }else {
            [self.uleCustemNavigationBar customTitleLabel:@"手势密码"];
        }
    }
   
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.nLockViewType == UleLockVCTypeCheck) {
        self.mTipsLabel.text = @"请输入手势密码";
    }
    // 其他情况
    else {
        self.mTipsLabel.text = @"绘制解锁图案";
    }
    // 尝试机会
    mRetryNumber = kLVCMaxNumber;
    // 手势密码信息
    pwdOld = @"";
    pwdNew = @"";
    pwdSure = @"";
    pwdLocal = [Ule_LockPasswordFile readLockPassword];
}

#pragma mark -重载返回按钮
- (void)ule_toLastViewController {
    if (self.nLockViewType == UleLockVCTypeModify) {
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:NSClassFromString(@"Ule_SetLockSecond")]) {
                [self.navigationController popToViewController:viewC animated:YES];
            }
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUI {
    
    CGFloat offset_y = self.uleCustemNavigationBar.bottom + 34.0f;
    // 验证手势密码UI 为用户头像
    if (self.nLockViewType == UleLockVCTypeCheck) {
        offset_y = 52.0f;
        // iphone4、phone4s屏幕短
        if (__MainScreen_Height <= 480.0f) {
            offset_y -= 40.0f;
        }
        CGFloat u_size = 80.0f;
        self.mUserImage = ({
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((__MainScreen_Width-u_size)/2, offset_y, u_size, u_size)];
            
            NSString *imgString = [US_UserUtility sharedLogin].m_userHeadImgUrl;
            if (imgString) {
                [img yy_setImageWithURL:[NSURL URLWithString:imgString] placeholder:[UIImage bundleImageNamed:@"lock_head"]];
            }else {
                [img yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"lock_head"]];
            }
            
            [img setBackgroundColor:[UIColor clearColor]];
            img.layer.cornerRadius = u_size/2;
            img.clipsToBounds = YES;
            img.layer.borderWidth = 1.5f;
            img.layer.borderColor = [UIColor whiteColor].CGColor;
            [self.view addSubview:img];
            img;
        });
        offset_y += u_size;
    }
    // 其他情况为显示手势输入记录
    else {
        CGFloat i_size = 36.0f;
        self.mIndicator = ({
            Ule_LockIndicator *indicator = [[Ule_LockIndicator alloc] initWithFrame:CGRectMake((__MainScreen_Width-i_size)/2, offset_y, i_size, i_size)];
            indicator.backgroundColor = [UIColor clearColor];
            [self.view addSubview:indicator];
            indicator;
        });
        offset_y += i_size;
    }
    // 文字提示
    CGFloat t_size = 25.0f;
    self.mTipsLabel = ({
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(0, offset_y+20.0f, __MainScreen_Width, t_size)];
        tips.backgroundColor = [UIColor clearColor];
        tips.textColor = [UIColor convertHexToRGB:@"222222"];
        tips.font = [UIFont systemFontOfSize:15.0f];
        tips.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:tips];
        tips;
    });
    offset_y += t_size;
    // 手势view
    CGFloat l_size = 320.0f;
    self.mLockView = ({
        Ule_LockView *lock = [[Ule_LockView alloc] initWithFrame:CGRectMake((__MainScreen_Width-l_size)/2, offset_y, l_size, l_size)];
        lock.backgroundColor = [UIColor clearColor];
        lock.delegate = self;
        [self.view addSubview:lock];
        lock;
    });
    offset_y += l_size;
    // 忘记密码按钮
    if (self.nLockViewType == UleLockVCTypeCheck) {
        CGFloat b_size = 40.0f;
        self.mUserButton = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setFrame:CGRectMake(0, __MainScreen_Height-b_size-20.0f, __MainScreen_Width, b_size)];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(forgerPwdPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            // title
            ({
                UILabel *lab = [[UILabel alloc] initWithFrame:btn.bounds];
                lab.backgroundColor = [UIColor clearColor];
                lab.textAlignment = NSTextAlignmentCenter;
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"忘记手势密码?"];
                [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0,attString.length)];
                [attString addAttribute:NSForegroundColorAttributeName value:(id)[UIColor convertHexToRGB:@"ed6e41"] range:NSMakeRange(0,attString.length)];
                [attString addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:kCTUnderlineStyleSingle] range:(NSRange){0,[attString length]}];
                [lab setAttributedText:attString];
                [btn addSubview:lab];
            });
            btn;
        });
    }
    
}


#pragma mark -Ule_LockViewDelegate
- (void)lockString:(NSString *)string {
    if (self.nLockViewType == UleLockVCTypeCheck) {
        tip_1 = @"请输入手势密码";
        [self checkPassword:string];
    }
    else {
        if (!string || string.length < 3) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"密码太短，最少三位，请重新输入" afterDelay:0.8];
            return;
        }
        tip_1 = @"绘制解锁图案";
        tip_2 = @"请再次绘制解锁图案";
        [self createPassword:string];
    }
    [self updateIndicator];
}

#pragma mark -指示器状态更新
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

#pragma mark -dissmiss
- (void)viewDismiss {
    // 验证
    if (self.nLockViewType == UleLockVCTypeCheck) {
        self.lockIsShow = NO;
        // 有block时 处于登录页面 先登录 再移除
        if (_didRemovedBlock) {
            self.didRemovedBlock();
        }
        [UIView animateWithDuration:0.25f*2 animations:^{
            [self.view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view removeFromSuperview];
            }
        }];
    }
    // 维护(新建) 跳转到维护vc
    else if(self.nLockViewType == UleLockVCTypeCreate) {
        [self pushNewViewController:@"Ule_SetLockSecond" isNibPage:NO withData:nil];
    }
    // 维护(修改) 维护成功 直接返回
    else {
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:NSClassFromString(@"Ule_SetLockSecond")]) {
                [self.navigationController popToViewController:viewC animated:YES];
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        [self viewDismiss];
    }
}


#pragma mark -底部按钮(忘记手势密码)
- (void)forgerPwdPressed:(UIButton *)sender {
    
    [Ule_LockPasswordFile removeLockPassword];
    
    if ([US_UserUtility sharedLogin].mIsLogin) {
        [US_LoginManager logOutToLoginWithMessage:@"请登录"];
        if (_didRemovedBlock) {
            self.didRemovedBlock();
        }
        [self viewDismiss];
    }
    else{
        if (_didRemovedBlock) {
            self.didRemovedBlock();
        }
    }
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

#pragma mark - 检查/更新密码
- (void)checkPassword:(NSString *)string {
    
    // 验证密码
    if ([[Ule_LockPasswordFile cryptoStringWithKey:string] isEqualToString:pwdLocal]) {
        // 验证成功
        [self setTip:@"验证成功,请稍后。"];
        self.view.userInteractionEnabled = NO;
        [self viewDismiss];
    }
    // 验证密码错误
    else if (string.length > 0) {
        mRetryNumber--;
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

#pragma mark -创建密码
- (void)createPassword:(NSString *)string {
    // 输入密码
    if ([pwdNew isEqualToString:@""] &&
        [pwdSure isEqualToString:@""]) {
        
        pwdNew = [NSString stringWithFormat:@"%@",string];
        [self setTip:tip_2];
    }
    // 确认输入密码
    else if (![pwdNew isEqualToString:@""] &&
             [pwdSure isEqualToString:@""]) {
        
        pwdSure = [NSString stringWithFormat:@"%@",string];
        if ([pwdNew isEqualToString:pwdSure]) {
            // 设置成功
            [Ule_LockPasswordFile saveLockPassword:string];
            // 设置自动开启
            [Ule_LockPasswordFile saveLockStatus:@"1"];
            // 提示信息
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"恭喜您"
                                                            message:@"手势密码设置成功"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            alert.tag = 1001;
            [alert show];
        } else {
            [self setErrorTip:@"与上一次输入不一致,请重新设置" errorPswd:string];
            // 手势密码延用android的逻辑 不清楚第一次
            //pwdNew = @"";
            pwdSure = @"";
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

- (void)hiddenLockViewUI {
    [self.mIndicator setAlpha:0.0f];
    [self.mTipsLabel setAlpha:0.0f];
    [self.mLockView setAlpha:0.0f];
    [self.mUserButton setAlpha:0.0f];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
