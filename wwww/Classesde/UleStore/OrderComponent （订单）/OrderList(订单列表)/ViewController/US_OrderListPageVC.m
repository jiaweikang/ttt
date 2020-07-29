//
//  US_OrderListPageVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListPageVC.h"
#import "US_OrderListInfoVC.h"
@interface US_OrderListPageVC ()
//@property (nonatomic, strong) NSString * orderFlag;//"2":我的订单   “3”:客户订单
@end

@implementation US_OrderListPageVC
- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasNaviBar=NO;
        self.titleLayoutType=PageVCTitleFixedWidth;
        self.titleMarin=15;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.orderFlag=[self.m_Params objectForKey:@"orderFlag"];
    [self setTitleNormalColor:[UIColor blackColor] selectedColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.hiddenUnderLine=YES;
    [self initPageScrollViewWithTabArray:nil];
    self.ignorePageLog=YES;
}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        //            [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    NSArray * titleArray=@[@"全部订单",@"待付款",@"待发货",@"待签收"];
    for (int i=0; i<titleArray.count; i++) {
        Class class=[UIViewController getClassMapViewController:@"US_OrderListInfoVC"];
        UleBaseViewController *orderList=[[class alloc] init];
        [orderList setM_Params:[NSMutableDictionary dictionaryWithDictionary:self.m_Params]];
        [orderList hideCustomNavigationBar];
        orderList.title=titleArray[i];
        orderList.ignorePageLog=YES;
        [self addChildViewController:orderList];
    }
    NSInteger defaultIndex=0;
    NSString *settedIndex=[NSString isNullToString:[self.m_Params objectForKey:@"index"]];
    if (settedIndex.length>0&&titleArray.count>[settedIndex integerValue]) {
        defaultIndex=[settedIndex integerValue];
    }
    [self resetTabListVCAtCurrentPageIndex:defaultIndex];
}


@end
