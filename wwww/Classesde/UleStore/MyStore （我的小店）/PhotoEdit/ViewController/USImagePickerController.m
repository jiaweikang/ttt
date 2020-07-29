//
//  WKImagePickerController.m
//  裁剪照片上传头像
//
//  Created by wangkun on 16/7/20.
//  Copyright © 2016年 ule. All rights reserved.
//

#import "USImagePickerController.h"

@interface USImagePickerController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation USImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
