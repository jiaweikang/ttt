//
//  Ule_SetLockFirst.m
//  u_store
//
//  Created by yushengyang on 15/6/10.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import "Ule_SetLockFirst.h"
//#import "Ule_LockVC.h"
#import "Ule_LockConst.h"
#import "DeviceInfoHelper.h"

@interface Ule_SetLockFirst ()

@end

@implementation Ule_SetLockFirst

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"手势密码设置"];
    [self setUI];
}

- (void)setUI {
    
    CGFloat offset_y = self.uleCustemNavigationBar.bottom + 46.0f;
    
    // image
    ({
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((__MainScreen_Width-96.0)/2, offset_y, 96.0, 182.0)];
        img.image = [UIImage bundleImageNamed:@"lock_phone"];
        img.backgroundColor = [UIColor clearColor];
        [self.view addSubview:img];
    });
    offset_y += 182.0;
    
    // text
    ({
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((__MainScreen_Width-287.0)/2, offset_y, 287.0, 104.0)];
        lab.backgroundColor = [UIColor clearColor];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.textColor = [UIColor convertHexToRGB:@"222222"];
        lab.numberOfLines = 3;
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = [NSString stringWithFormat:@"您可以创建一个需要用手势画出的%@安全保护图案,这样他人在使用您的手机的时,将无法打开%@",[DeviceInfoHelper getAppName],[DeviceInfoHelper getAppName]];
        [self.view addSubview:lab];
    });
    
    // button
    ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor convertHexToRGB:@"c60a1e"];
        [btn setFrame:CGRectMake((__MainScreen_Width-287.0)/2, (kIphoneX?(__MainScreen_Height-34):__MainScreen_Height)-44.0-50.0, 287.0, 44.0)];
        [btn addTarget:self action:@selector(createButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"我要创建手势密码" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.layer.cornerRadius = 5;
        [self.view addSubview:btn];
    });
}

- (void)createButtonClick:(UIButton *)sender {

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@(UleLockVCTypeCreate),kLVTypeKey, nil];
    [self pushNewViewController:@"Ule_LockVC" isNibPage:NO withData:dic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
