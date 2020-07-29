//
//  UleBaseNaviViewController.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/11/28.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseNaviViewController.h"

@interface UleBaseNaviViewController ()

@end

@implementation UleBaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        //        [viewController showBackButton];
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark --<UIStatusBarStyle>

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

#pragma mark - <StatusBarHidden>
- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIViewController*)childViewControllerForStatusBarHidden{
    return self.topViewController;
}

#pragma mark --<屏幕方向>
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


@end
