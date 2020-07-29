//
//  US_OrderListRootVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderListRootVC.h"
#import "US_SegmentBarView.h"
#import "US_OrderListPageVC.h"

@interface US_OrderListRootVC ()
@property (nonatomic, strong) US_SegmentBarView * titleBarView;
@property (nonatomic, strong) UIScrollView * containerView;
@property (nonatomic, strong) NSString * selectedTab;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, assign) US_OrderListType  orderListType;//订单类型
@end

@implementation US_OrderListRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.orderListType=[self getCurrentOrderListType];
    [self.view addSubview:self.containerView];
    self.selectedTab=[self.m_Params objectForKey:@"TAB"]?[self.m_Params objectForKey:@"TAB"]:@"0";
    /*此处兼容旧工程(自己购买完后跳转到我的订单)*/
    if ([[self.m_Params objectForKey:@"isLeft"] intValue]==1) {
        self.selectedTab=@"1";
    }
    /*此处兼容旧工程(自己购买完后跳转到我的订单)*/
    
    self.containerView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.containerView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.containerView.contentSize=CGSizeMake(__MainScreen_Width*2, __MainScreen_Height-self.uleCustemNavigationBar.height_sd);
    [self.uleCustemNavigationBar setTitleView:self.titleBarView];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    [self loadSubOrderListVC];
    [self.titleBarView segmentSelectAtIndex:[self.selectedTab integerValue]];
}

- (void)loadSubOrderListVC{
    Class class=[UIViewController getClassMapViewController:@"US_OrderListPageVC"];
    UleBaseViewController * pageOne=[[class alloc] init];
    pageOne.m_Params=[NSMutableDictionary dictionaryWithDictionary:self.m_Params];
    [pageOne.m_Params setObject:@"3" forKey:@"orderFlag"];
    [pageOne.m_Params setObject:[NSNumber numberWithUnsignedInteger:self.orderListType] forKey:@"orderListType"];
    [pageOne hideCustomNavigationBar];
    pageOne.uleCustemNavigationBar.hidden=YES;
    [self addChildViewController:pageOne];
    [self.containerView addSubview:pageOne.view];
    pageOne.view.sd_layout.topSpaceToView(self.containerView, 0)
    .leftSpaceToView(self.containerView, 0)
    .bottomSpaceToView(self.containerView, 0)
    .widthIs(__MainScreen_Width);
    
    UleBaseViewController * pageTwo=[[class alloc] init];
    pageTwo.m_Params=[NSMutableDictionary dictionaryWithDictionary:self.m_Params];
    [pageTwo.m_Params setObject:@"2" forKey:@"orderFlag"];
    [pageTwo.m_Params setObject:[NSNumber numberWithUnsignedInteger:self.orderListType] forKey:@"orderListType"];
    [pageTwo hideCustomNavigationBar];
    pageTwo.uleCustemNavigationBar.hidden=YES;
    [self addChildViewController:pageTwo];
    [self.containerView addSubview:pageTwo.view];
    pageTwo.view.sd_layout.topSpaceToView(self.containerView, 0)
    .leftSpaceToView(pageOne.view, 0)
    .bottomSpaceToView(self.containerView, 0)
    .widthIs(__MainScreen_Width);
    [self.containerView layoutSubviews];
}

#pragma mark - <click event>
- (void)searchOrderClick:(id)sender{
    //TODO:
    NSInteger currentPage=self.containerView.contentOffset.x/__MainScreen_Width;
    NSString * orderFlag = currentPage==0?@"3":@"2";
    [self pushNewViewController:@"US_SearchCategoryVC" isNibPage:NO withData:@{@"orderType":orderFlag,@"orderListType":[NSNumber numberWithUnsignedInteger:self.orderListType]}.mutableCopy];
}

#pragma mark - <setter and getter>
- (US_SegmentBarView *)titleBarView{
    if (!_titleBarView) {
        _titleBarView=[[US_SegmentBarView alloc] initWithItmes:@[@"客户订单",@"我的订单"] obserScrollView:self.containerView];
    }
    return _titleBarView;
}

- (UIScrollView *)containerView{
    if (!_containerView) {
        _containerView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.height_sd, __MainScreen_Width, __MainScreen_Height-self.uleCustemNavigationBar.height_sd)];
        _containerView.pagingEnabled=YES;
        _containerView.bounces=NO;
    }
    return _containerView;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [_rightButton setImage:[UIImage bundleImageNamed:@"myOrder_btn_search"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(searchOrderClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (US_OrderListType)getCurrentOrderListType{
    US_OrderListType listType=OrderListTypeNone;
    NSString *privateType=[self.m_Params objectForKey:@"viewType"];
    if (privateType&&privateType.length>0) {
        if ([privateType isEqualToString:@"0"]) {
            listType=OrderListTypeUle;
        }else if ([privateType isEqualToString:@"1"]) {
            listType=OrderListTypeOwn;
        }
    }else {
        listType=OrderListTypeAll;
    }
    return listType;
}
@end
