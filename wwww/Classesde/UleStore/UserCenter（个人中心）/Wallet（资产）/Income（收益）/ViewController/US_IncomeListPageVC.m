//
//  US_IncomeListVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_IncomeListPageVC.h"
#import "US_IncomeListInfoVC.h"

@interface US_IncomeListPageVC ()
@property (nonatomic, strong) NSString * selectIndex;//选择下标 0收入 1支出 2全部
@end

@implementation US_IncomeListPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"收支明细"];
    self.selectIndex = @"0";
    self.selectIndex=[self.m_Params objectForKey:@"selectIndex"];
    [self setTitleNormalColor:[UIColor blackColor] selectedColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:14]];
    self.hiddenUnderLine=NO;
    [self initPageScrollViewWithTabArray:@[@"收入",@"支出",@"全部"]];
}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    for (int i=0; i<tabArray.count; i++) {
        Class class=[UIViewController getClassMapViewController:@"US_IncomeListInfoVC"];
        UleBaseViewController * orderList=[[class alloc] init];
        orderList.m_Params=@{@"selectIndex":[NSString stringWithFormat:@"%d",i]}.mutableCopy;
        [orderList hideCustomNavigationBar];
        orderList.title=tabArray[i];
        orderList.ignorePageLog=YES;
        [self addChildViewController:orderList];
    }
    [self resetTabListVCAtCurrentPageIndex:self.selectIndex.integerValue];;
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
