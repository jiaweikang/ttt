//
//  US_EnterpriseRootVC.m
//  UleStoreApp
//
//  Created by xulei on 2020/3/17.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_EnterpriseRootVC.h"
#import "US_EnterpriseList.h"
#import "US_EnterpeiseWholeSaleVC.h"
#import "US_EnterpriseApi.h"
#import "UleControlView.h"

@interface US_EnterpriseRootVC ()
@property (nonatomic, strong) UleControlView * enterpriseChangeBtn;

@end

@implementation US_EnterpriseRootVC
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasNaviBar=YES;
        self.titleLayoutType=PageVCTitleFixedWidth;
        self.titleMarin=15;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    [self.uleCustemNavigationBar customTitleLabel:[US_UserUtility getLowestOrganizationName]];
    [self setTitleNormalColor:[UIColor convertHexToRGB:kBlackTextColor] selectedColor:[UIColor convertHexToRGB:@"ee3b39"] andFont:[UIFont systemFontOfSize:14]];
    [self initPageScrollViewWithTabArray:nil];
    self.ignorePageLog=YES;
    //切换掌柜
    if ([US_UserUtility sharedLogin].hasCSzg && [[US_UserUtility sharedLogin].m_yzgFlag isEqualToString:@"1"] && self.navigationController.childViewControllers.count<=1) {
        [US_UserUtility sharedLogin].enterpriseMark = @"2";
        [self.enterpriseChangeBtn.mImageView setImage:[UIImage bundleImageNamed:@"enterpriseChangeIcon"]];
        self.uleCustemNavigationBar.rightBarButtonItems=@[self.enterpriseChangeBtn];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notiAction:) name:NOTI_ReloadEnterpriseRoot object:nil];
}

- (void)initPageScrollViewWithTabArray:(NSArray *)tabArray{
    for (UIViewController * vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    NSArray * titleArray=@[@"零售商品", @"分销商品"];
    Class enterpriseClass=[UIViewController getClassMapViewController:@"US_EnterpriseList"];
    UleBaseViewController *enterpriseList=[[enterpriseClass alloc] init];
    [enterpriseList setM_Params:[NSMutableDictionary dictionaryWithDictionary:self.m_Params]];
    [enterpriseList hideCustomNavigationBar];
    enterpriseList.title=titleArray[0];
    enterpriseList.ignorePageLog=YES;
    [self addChildViewController:enterpriseList];
    Class wholeSaleClass=[UIViewController getClassMapViewController:@"US_EnterpeiseWholeSaleVC"];
    UleBaseViewController *wholeSaleList=[[wholeSaleClass alloc]init];
    [wholeSaleList setM_Params:[NSMutableDictionary dictionaryWithDictionary:self.m_Params]];
    [wholeSaleList hideCustomNavigationBar];
    wholeSaleList.title=titleArray[1];
    wholeSaleList.ignorePageLog=YES;
    [self addChildViewController:wholeSaleList];
    
    NSInteger defaultIndex=0;
    NSString *settedIndex=[NSString isNullToString:[self.m_Params objectForKey:@"index"]];
    if (settedIndex.length>0&&titleArray.count>[settedIndex integerValue]) {
        defaultIndex=[settedIndex integerValue];
    }
    [self resetTabListVCAtCurrentPageIndex:defaultIndex];
}

- (void)notiAction:(NSNotification *)noti{
    [self initPageScrollViewWithTabArray:nil];
}

#pragma mark - <getters>
- (void)buttonAction_changeEnterprise
{
    [US_UserUtility sharedLogin].enterpriseMark = @"1";
    NSMutableDictionary * userInfo=[[NSMutableDictionary alloc] init];
    [userInfo setObject:@YES forKey:@"hadEnterprice"];
    [userInfo setObject:@"1" forKey:@"isEnterpriseChange"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateTabBarVC object:nil userInfo:userInfo];
}

#pragma mark - <getters>
- (UleControlView *)enterpriseChangeBtn{
    if (!_enterpriseChangeBtn) {
        _enterpriseChangeBtn=[[UleControlView alloc] initWithFrame:CGRectMake(10, 10, KScreenScale(66), KScreenScale(106))];
        _enterpriseChangeBtn.mTitleLabel.text = @"切换";
        _enterpriseChangeBtn.mTitleLabel.font = [UIFont systemFontOfSize:KScreenScale(20)];
        _enterpriseChangeBtn.mTitleLabel.textColor = [UIColor whiteColor];
        [_enterpriseChangeBtn addTouchTarget:self action:@selector(buttonAction_changeEnterprise)];

        _enterpriseChangeBtn.mImageView.sd_layout.centerXEqualToView(_enterpriseChangeBtn)
        .topSpaceToView(_enterpriseChangeBtn, 2)
        .widthIs(23)
        .heightEqualToWidth();
        _enterpriseChangeBtn.mTitleLabel.sd_layout.topSpaceToView(_enterpriseChangeBtn.mImageView, 0)
        .bottomEqualToView(_enterpriseChangeBtn)
        .leftEqualToView(_enterpriseChangeBtn)
        .rightEqualToView(_enterpriseChangeBtn);
    }
    return _enterpriseChangeBtn;
}
@end
