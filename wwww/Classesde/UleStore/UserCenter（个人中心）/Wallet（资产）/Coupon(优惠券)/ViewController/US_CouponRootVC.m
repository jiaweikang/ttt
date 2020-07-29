//
//  US_CouponRootVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CouponRootVC.h"
#import "US_CouponListVC.h"
@interface US_CouponRootVC ()

@end

@implementation US_CouponRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"优惠券"];
    [self initPageScrollViewWithTabArray:@[@"可用",@"已用"]];
}
- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        //            [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    NSArray * titleArray=tabArray;
    for (int i=0; i<titleArray.count; i++) {
        Class class=[UIViewController getClassMapViewController:@"US_CouponListVC"];
        UleBaseViewController *couponList=[[class alloc] init];
//        orderList.m_Params=@{@"orderFlag":self.orderFlag}.mutableCopy;
        [couponList hideCustomNavigationBar];
        NSString * couponType=[titleArray[i] isEqualToString:@"可用"]?@"1":@"2";
        couponList.m_Params=@{@"couponStatus":couponType}.mutableCopy;
        couponList.title=titleArray[i];
        [self addChildViewController:couponList];
        couponList.ignorePageLog=YES;
    }
    [self resetTabListVCAtCurrentPageIndex:0];;
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
