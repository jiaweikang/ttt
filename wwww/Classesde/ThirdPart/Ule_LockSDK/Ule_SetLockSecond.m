//
//  Ule_SetLockSecond.m
//  u_store
//
//  Created by yushengyang on 15/6/10.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "Ule_SetLockSecond.h"
#import "US_SettingCenterVC.h"
#import "Ule_SetLockFirst.h"
#import "Ule_LockPasswordFile.h"
#import "Ule_LockConst.h"

@interface Ule_SetLockSecond ()

/**
 *  重置手势按钮
 */
@property (nonatomic, strong) UIButton *changeBtn;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *m_switch;

@end

@implementation Ule_SetLockSecond

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"手势密码设置"];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"F7F7F7"];
    [self setUI];
}

- (void)setUI {

    CGFloat offset_x = 12.0f;
    CGFloat offset_y = self.uleCustemNavigationBar.bottom + 15.0f;
    // view手势开关
    self.m_switch = ({
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, offset_y, __MainScreen_Width, 44.0)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:bgView];
        // 文字
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, 0, 150.0, 44.0)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:16.0];
        lab.textColor = [UIColor convertHexToRGB:@"222222"];
        lab.text = @"手势密码开关";
        [bgView addSubview:lab];
        // 开关
        UISwitch *m_switch = [[UISwitch alloc] init];
        CGFloat rect_w = CGRectGetWidth(m_switch.bounds);
        CGFloat rect_h = CGRectGetHeight(m_switch.bounds);
        m_switch.frame = CGRectMake(__MainScreen_Width-rect_w-offset_x, (44.0-rect_h)/2, rect_w, rect_h);
        [m_switch addTarget:self action:@selector(m_switchMethod:) forControlEvents:UIControlEventValueChanged];
        [bgView addSubview:m_switch];
        NSString *string = [Ule_LockPasswordFile readLockStatus];
        if (string && [string isEqualToString:@"1"]) {
            [m_switch setOn:YES];
        }else {
            [m_switch setOn:NO];
        }
        m_switch;
    });
    offset_y += 44.0f;
    offset_y += 170.0f;
    // button
    self.changeBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor convertHexToRGB:@"c60a1e"]];
        [btn setFrame:CGRectMake(offset_x, offset_y, (__MainScreen_Width-2*offset_x), 44.0)];
        [btn setTitle:@"修改手势密码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
        // 关闭时 隐藏按钮
        if (!self.m_switch.isOn) {
            [btn setHidden:YES];
        }
        [self.view addSubview:btn];
        btn;
    });
}

- (void)m_switchMethod:(UISwitch *)sender {
    // 开启
    if (sender.isOn) {
        [Ule_LockPasswordFile saveLockStatus:@"1"];
        [self.changeBtn setHidden:NO];
    }
    // 关闭
    else {
        [Ule_LockPasswordFile removeLockStatus];
        [self.changeBtn setHidden:YES];
    }
}

- (void)changeButton:(UIButton *)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(UleLockVCTypeModify),kLVTypeKey, nil];
    [self pushNewViewController:@"Ule_ResetVC" isNibPage:NO withData:dic];
}

#pragma mark -重载返回按钮
- (void)ule_toLastViewController {
    // 返回到 最底部VC
    BOOL isSetGesture = NO;
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[Ule_SetLockFirst class]]) {
            isSetGesture = YES;
            break;
        }
    }
    //如果从设置进入手势，返回上一级，如果是开启设置完手势返回设置
    if (!isSetGesture) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[US_SettingCenterVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
