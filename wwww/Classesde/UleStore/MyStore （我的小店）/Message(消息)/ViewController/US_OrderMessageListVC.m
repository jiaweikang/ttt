//
//  US_OrderMessageListVC.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/10.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderMessageListVC.h"
#import "US_OrderMessageVC.h"

@interface US_OrderMessageListVC ()

@end

@implementation US_OrderMessageListVC

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasNaviBar=YES;
        self.hasTabBar=YES;
        self.titleLayoutType=PageVCTitleFixedWidth;
        self.titleMarin=15;
//        [self layoutSubViews];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.uleCustemNavigationBar customTitleLabel:@"订单消息"];
    [self setTitleNormalColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] andFont:[UIFont systemFontOfSize:14]];
    [self setUnLineColor:[UIColor whiteColor]];
    self.titleView.backgroundColor=kNavBarBackColor;
    self.titleScrollView.backgroundColor=[UIColor clearColor];
    [self initPageScrollViewWithTabArray:nil];
    self.ignorePageLog=YES;
    
}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        //            [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    NSArray * titleArray=@[@"成单消息", @"退单消息"];
    for (int i=0; i<titleArray.count; i++) {
        Class class=[UIViewController getClassMapViewController:@"US_OrderMessageVC"];
        UleBaseViewController *orderList=[[class alloc] init];
        [orderList hideCustomNavigationBar];
        NSString *category = @"";
        if (i == 0) {
            category = @"1011";
        } else if (i == 1) {
            category = @"1096,1097";
        }
        [orderList setM_Params:@{@"category":category}.mutableCopy];
        orderList.title=titleArray[i];
        orderList.ignorePageLog=YES;
        [self addChildViewController:orderList];
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
