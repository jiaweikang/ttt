//
//  US_SettingCenterVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_SettingCenterVC.h"
#import "MineViewModel.h"
#import "US_UserCenterApi.h"
#import "USApplicationLaunchManager.h"
#import "UleControlView.h"
#import "US_UserHeadView.h"
@interface US_SettingCenterVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) MineViewModel * mViewModel;
@property (nonatomic, strong) UleControlView * settingButton;
@property (nonatomic, strong) US_UserHeadView * mHeadView;
@end

@implementation US_SettingCenterVC

- (void)dealloc{
    if (_mTableView) {
        [_mTableView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _mTableView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[US_UserUtility poststore_my_update] isEqualToString:[USApplicationLaunchManager sharedManager].poststore_my_update]) {
        [self getUserCenterList];
    }else{
        [self requestIndexInfo];
    }
    
    [self.uleCustemNavigationBar customTitleLabel:[US_UserUtility sharedLogin].m_stationName];
    [self.mHeadView setContentData];
}

- (void)requestIndexInfo{
    if ([US_UserUtility sharedLogin].mIsLogin) {
        if (self.mViewModel.haveWalletCell) {
            [self getWalletInfo];
        }
        if (self.mViewModel.haveCartCell) {
            [self getShopCartCount];
        }
        if (self.mViewModel.haveInvitedPersonCell) {
            [self getInviterCount];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop|UIRectEdgeLeft|UIRectEdgeRight;
    [self.uleCustemNavigationBar ule_setBackgroundAlpha:0.0];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.settingButton];
    [self.view addSubview:self.mHeadView];
    [self.uleCustemNavigationBar customTitleLabel:[US_UserUtility sharedLogin].m_stationName];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.mTableView];
    self.mViewModel.rootTableView=self.mTableView;
    self.mViewModel.rootVC=self;
    self.mTableView.sd_layout.topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 0);
    
    [self.mTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    //修改用户信息后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserCenterList) name:NOTI_UpdateUserCenter object:nil];
}

- (void)refreshUserCenterList{
    [self.mViewModel prepareLayoutDataArray:YES];
}
//
- (void)getUserCenterList{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildUserCenterRequest] success:^(id responseObject) {
        @strongify(self);
        [US_UserUtility setPoststore_my_update:[USApplicationLaunchManager sharedManager].poststore_my_update];
        [self.mViewModel fetchUserCenterListDicInfo:responseObject];
        [self requestIndexInfo];
    } failure:^(UleRequestError *error) {
        NSLog(@"error");
    }];
}

//请求资产数据
- (void)getWalletInfo{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildWalletInfoRequest] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchWalletValueWithModel:responseObject];
        
    } failure:^(UleRequestError *error) {
            NSLog(@"error");
    }];
}

//获取邀请人数量
- (void)getInviterCount{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetInviterListRequestWithStartPage:@"1" PageSize:@"20"] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchInviterValueWithModel:responseObject];
    } failure:^(UleRequestError *error) {
    }];
}

//获取购物车数量
- (void)getShopCartCount{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetShopCartCount] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchShopCartValueWithModel:responseObject];
    } failure:^(UleRequestError *error) {
    }];
}

#pragma mark - Action
- (void)settingButtonClick:(id)sender{
    [self pushNewViewController:@"US_SettingVC" isNibPage:NO withData:nil];
}

- (void)userHeadViewClickAction:(UITapGestureRecognizer *)tap{
    [self pushNewViewController:@"US_UpdateUserInfoVC" isNibPage:NO withData:nil];
}

#pragma mark - <ScrollerView delegate>
#define NAVBAR_CHANGE_POINT 50
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY=self.mTableView.contentOffset.y;
        //NSLog(@"offsetY:%f",offsetY);
        if (offsetY<0) {
            self.mHeadView.top_sd=0;
            //self.mTableView.scrollEnabled = NO;
        }else {
            self.mHeadView.top_sd=-offsetY;
            //self.mTableView.scrollEnabled = YES;
        }

        // 设置自定义导航栏透明度
        CGFloat alpha = 0.0;
        if (offsetY > NAVBAR_CHANGE_POINT) {
            alpha = MIN(1.0, 1.0-((NAVBAR_CHANGE_POINT+64-offsetY) / 64));
        }
        [self.uleCustemNavigationBar ule_setBackgroundAlpha:alpha];
        if (alpha>=0.8) {
            [self.uleCustemNavigationBar.titleView setHidden:NO];
        }
        else{
            [self.uleCustemNavigationBar.titleView setHidden:YES];
        }
    }
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = NO;
        UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 150+kStatusBarHeight)];
        view.backgroundColor=[UIColor clearColor];
        view.userInteractionEnabled=YES;
        // 点击手势
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadViewClickAction:)];
        [view addGestureRecognizer:mTap];
        _mTableView.tableHeaderView=view;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (MineViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[MineViewModel alloc] init];
    }
    return _mViewModel;
}

- (UleControlView *)settingButton{
    if (!_settingButton) {
        _settingButton=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_settingButton.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_setting"]];
        _settingButton.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _settingButton.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _settingButton.mTitleLabel.textColor=[UIColor whiteColor];
        _settingButton.mTitleLabel.text=@"设置";
        [_settingButton addTouchTarget:self action:@selector(settingButtonClick:)];
        _settingButton.mImageView.sd_layout.centerXEqualToView(_settingButton)
        .topSpaceToView(_settingButton, 5)
        .widthIs(22)
        .heightEqualToWidth();
        _settingButton.mTitleLabel.sd_layout.topSpaceToView(_settingButton.mImageView, 0)
        .bottomEqualToView(_settingButton)
        .leftEqualToView(_settingButton)
        .rightEqualToView(_settingButton);
    }
    return _settingButton;
}

- (US_UserHeadView *)mHeadView {
    if (!_mHeadView) {
        _mHeadView = [[US_UserHeadView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width,  185+kStatusBarHeight)];
        _mHeadView.backgroundColor = [UIColor convertHexToRGB:@"FF7462"];
    }
    return _mHeadView;
}

@end
