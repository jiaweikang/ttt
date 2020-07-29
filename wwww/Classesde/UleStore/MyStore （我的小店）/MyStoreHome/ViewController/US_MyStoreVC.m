//
//  US_MyStoreVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/4.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_MyStoreVC.h"
#import "MyStoreViewModel.h"
#import "MyStoreTableHeaderView.h"
#import "UleSectionBaseModel.h"
#import <MJRefresh/MJRefresh.h>
#import "UIImage+USAddition.h"
#import "USInviteShareManager.h"
#import "UleControlView.h"
@interface US_MyStoreVC ()
@property (nonatomic, strong) UleControlView * leftButton;
@property (nonatomic, strong) UleControlView * rightButton;
@property (nonatomic, strong) UIScrollView  *mScrollView;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) MyStoreViewModel * viewModel;
@property (nonatomic, strong) MyStoreTableHeaderView * mHeadView;
@property (nonatomic, strong) UILabel * iconBadgeLabel;

@end

@implementation US_MyStoreVC

- (void)dealloc{
    NSLog(@"--%s--",__FUNCTION__);
    if (_mScrollView) {
        [_mScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    if (_mTableView) {
        [_mTableView removeObserver:self forKeyPath:@"contentSize"];
    }
    if (_mHeadView) {
        [_mHeadView removeObserver:self forKeyPath:@"isShowPromoteBar"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar ule_setBackgroundAlpha:0.0];
    self.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeLeft | UIRectEdgeRight;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:self.mScrollView];
    [self.mScrollView addSubview:self.mHeadView];
    [self.mScrollView addSubview:self.mTableView];
    self.mScrollView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.frame=CGRectMake(0, CGRectGetMaxY(self.mHeadView.frame)-KScreenScale(40), __MainScreen_Width, 0);
    self.mScrollView.mj_header=self.mRefreshHeader;
 
    [self.mScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.mTableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self.mHeadView addObserver:self forKeyPath:@"isShowPromoteBar" options:NSKeyValueObservingOptionNew context:nil];
    @weakify(self);
    [self.viewModel loadDataWithSucessBlock:^( MyStoreViewModel * model) {
        @strongify(self);
        [self.mTableView reloadData];
        [self.mHeadView setModel:model];
        [self.mScrollView.mj_header endRefreshing];
    } faildBlock:^(id errorCode) {
        @strongify(self);
        [self.mScrollView.mj_header endRefreshing];
        [self showErrorHUDWithError:errorCode];
    }];
    [self loadAndRequestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoRequestSuccess) name:NOTI_UserInfoRequest_Success object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBar];
}

- (void)setupNavigationBar{
    NSString *stationName = @"";
    if ([US_UserUtility sharedLogin].m_stationName && ![[US_UserUtility sharedLogin].m_stationName isEqualToString:@""]) {
        stationName = [US_UserUtility sharedLogin].m_stationName;
    } else if ([US_UserUtility sharedLogin].m_userName.length>0){
        stationName = [NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
    }
    [self.uleCustemNavigationBar customTitleLabel:stationName];
    self.uleCustemNavigationBar.leftBarButtonItems=@[self.leftButton];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
}

- (void)userInfoRequestSuccess{
    [self.viewModel getMiddleButtonsIsRequestNewData:NO];
}

#pragma mark - <下拉刷新>
- (void)beginRefreshHeader{
    [self loadAndRequestData];
}
#pragma mark - <网络请求>
- (void)loadAndRequestData{

    if ([US_UserUtility sharedLogin].mIsLogin) {
        [self.viewModel getCommisionInfo];
        [self.viewModel getShareInfo];
        [self.viewModel getWithdrawCommision];
    }
    @weakify(self);
    [self.viewModel getNewPushMessageCountSuccess:^(id  _Nonnull obj) {
        @strongify(self);
        self.iconBadgeLabel.hidden=NO;
    }];
    //获取中间各模块数据，并显示
    [self.viewModel getMiddleButtonsIsRequestNewData:YES];
}

#pragma mark - <button Action>
- (void)leftButtonAction{
    //TODO:
    [[USInviteShareManager sharedManager] inviteShareMyStore];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"头部分享" networkdetail:@""];
    [LogStatisticsManager onClickLog:Store_share andTev:@""];
}
- (void)rightButtonAction{
    //TODO:
    [self pushNewViewController:@"MyMessageCenterVC" isNibPage:NO withData:nil];
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"首页" moduledesc:@"消息中心" networkdetail:@""];
}

#pragma mark - <ScrollerView delegate>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY=self.mScrollView.contentOffset.y;
        CGFloat alpha;
        if (offsetY>0) {
        alpha=offsetY/self.uleCustemNavigationBar.height_sd>1.0?1.0:offsetY/self.uleCustemNavigationBar.height_sd;
        }else {
            alpha=0.0;
        }
        [self.uleCustemNavigationBar ule_setBackgroundAlpha:alpha];
    }else if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat contentSizeHeight=self.mTableView.contentSize.height;
        self.mTableView.height_sd=contentSizeHeight;
        self.mScrollView.contentSize=CGSizeMake(__MainScreen_Width, self.mTableView.bottom_sd);
    }else if ([keyPath isEqualToString:@"isShowPromoteBar"]) {
        if (self.mHeadView.isShowPromoteBar) {
            CGFloat targetOriginY=self.mHeadView.bottom_sd+KScreenScale(20);
            if (self.mTableView.origin_sd.y!=targetOriginY) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.mTableView.origin_sd=CGPointMake(self.mTableView.origin_sd.x, targetOriginY);
                    self.mScrollView.contentSize=CGSizeMake(__MainScreen_Width, self.mTableView.bottom_sd);
                }];
            }
        }else {
            CGFloat targetOriginY=self.mHeadView.bottom_sd-KScreenScale(40);
            if (self.mTableView.origin_sd.y!=targetOriginY) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.mTableView.origin_sd=CGPointMake(self.mTableView.origin_sd.x, targetOriginY);
                    self.mScrollView.contentSize=CGSizeMake(__MainScreen_Width, self.mTableView.bottom_sd);
                }];
            }
        }
    }
}


#pragma mark - <setter and getter>
- (UIScrollView *)mScrollView{
    if (!_mScrollView) {
        _mScrollView=[[UIScrollView alloc]init];
        _mScrollView.backgroundColor=[UIColor clearColor];
        _mScrollView.contentSize=CGSizeMake(__MainScreen_Width, __MainScreen_Height-kStatusBarHeight-kTabBarHeight);
        if (@available(iOS 11.0, *)) {
            _mScrollView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mScrollView;
}
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.scrollEnabled=NO;
        _mTableView.dataSource=self.viewModel;
        _mTableView.delegate=self.viewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}
- (UleControlView *)leftButton{
    if (!_leftButton) {
        _leftButton=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [_leftButton.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_myStore_share"]];
        _leftButton.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _leftButton.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _leftButton.mTitleLabel.textColor=[UIColor whiteColor];
        _leftButton.mTitleLabel.text=@"店铺分享";
        [_leftButton addTouchTarget:self action:@selector(leftButtonAction)];
        _leftButton.mImageView.sd_layout.centerXEqualToView(_leftButton)
        .topSpaceToView(_leftButton, 5)
        .widthIs(20)
        .heightEqualToWidth();
        _leftButton.mTitleLabel.sd_layout.topSpaceToView(_leftButton.mImageView, 0)
        .bottomEqualToView(_leftButton)
        .leftEqualToView(_leftButton)
        .rightEqualToView(_leftButton);
    }
    return _leftButton;
}

- (UleControlView *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UleControlView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_rightButton.mImageView setImage:[UIImage bundleImageNamed:@"nav_btn_myStore_msg"]];
        _rightButton.mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _rightButton.mTitleLabel.font=[UIFont systemFontOfSize:10];
        _rightButton.mTitleLabel.textColor=[UIColor whiteColor];
        _rightButton.mTitleLabel.text=@"消息";
        [_rightButton addTouchTarget:self action:@selector(rightButtonAction)];
        _rightButton.mImageView.sd_layout.centerXEqualToView(_rightButton)
        .topSpaceToView(_rightButton, 5)
        .widthIs(20)
        .heightEqualToWidth();
        _rightButton.mTitleLabel.sd_layout.topSpaceToView(_rightButton.mImageView, 0)
        .bottomEqualToView(_rightButton)
        .leftEqualToView(_rightButton)
        .rightEqualToView(_rightButton);
    }
    return _rightButton;
}

- (MyStoreViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel=[[MyStoreViewModel alloc] init];
    }
    return _viewModel;
}


- (MyStoreTableHeaderView *)mHeadView{
    if (!_mHeadView) {

        _mHeadView=[[MyStoreTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(360)+kStatusBarHeight+44)];
        _mHeadView.tableView=self.mTableView;
    }
    return _mHeadView;
}

-(UILabel *)iconBadgeLabel{
    if (!_iconBadgeLabel) {
        _iconBadgeLabel = [[UILabel alloc]init];
        _iconBadgeLabel.hidden=YES;
        _iconBadgeLabel.layer.cornerRadius = 4;
        _iconBadgeLabel.layer.masksToBounds = YES;
        _iconBadgeLabel.backgroundColor = [UIColor whiteColor];
        _iconBadgeLabel.layer.borderWidth=0.5;
        _iconBadgeLabel.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    return _iconBadgeLabel;
}


@end
