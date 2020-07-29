//
//  US_MemberRootVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MemberRootVC.h"
#import "US_SearchTextFieldBar.h"
#import "US_MemberManageVC.h"

@interface US_MemberRootVC ()
@property (nonatomic, strong) US_SearchTextFieldBar *searchView;

@end

@implementation US_MemberRootVC

- (void)dealloc{
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasNaviBar=YES;
        self.hasTabBar=YES;
        self.titleLayoutType=PageVCTitleFixedWidth;
        self.titleMarin=0;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.uleCustemNavigationBar.titleView = self.searchView;
    self.uleCustemNavigationBar.titleLayoutType=WidthFixedLayout;
    [self initPageScrollViewWithTabArray:@[@"全部客户",@"扫码购客户"]];
    self.ignorePageLog=NO;
}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        //            [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    NSArray * titleArray=tabArray;
    for (int i=0; i<titleArray.count; i++) {
        Class class=[UIViewController getClassMapViewController:@"US_MemberManageVC"];
        UleBaseViewController * memmberList=[[class alloc] init];
        [memmberList hideCustomNavigationBar];
        NSString * memberType=[titleArray[i] isEqualToString:@"全部客户"]?@"1":@"2";
        @weakify(self);
        MemberManageDidScrollEndBlock endScrollB = ^{
            @strongify(self);
            self.searchView.searchField.text=@"";
        };;
        memmberList.m_Params=@{@"memberType":memberType,
                               @"didScrollEndBlock":endScrollB}.mutableCopy;
        memmberList.title=titleArray[i];
        [self addChildViewController:memmberList];
        memmberList.ignorePageLog=YES;
    }
    [self resetTabListVCAtCurrentPageIndex:0];
}

#pragma mark - <getters>
- (US_SearchTextFieldBar *)searchView {
    if (!_searchView) {
        @weakify(self);
        _searchView = [[US_SearchTextFieldBar alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width - 100, 30) placeholdText:@"姓名/手机号码" clickReturnBlock:^(UITextField * _Nonnull textField) {
            @strongify(self);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MemberDidSearch object:self userInfo:@{@"currentPage":[NSString stringWithFormat:@"%@",@(self.currentPageIndex+1)],@"keyWord":[NSString isNullToString:textField.text]}];
        }];
    }
    return _searchView;
}

@end
