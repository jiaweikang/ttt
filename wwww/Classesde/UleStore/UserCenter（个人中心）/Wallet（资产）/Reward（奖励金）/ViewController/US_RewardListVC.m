//
//  US_RewardListVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_RewardListVC.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_UserCenterApi.h"
#import "US_RewardListViewModel.h"
#import "US_RewardHeadView.h"

@interface US_RewardListVC ()
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) US_RewardHeadView *headView;
@property (nonatomic, strong) US_RewardListViewModel * mViewModel;
@property (nonatomic, strong) NSString *transFlag; //当前列表类型 空为全部 E支出 D收入
@end

@implementation US_RewardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"奖励金明细"];
    }
    
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.headView];
    [self.mTableView addSubview:self.mNoItemsBgView];
    
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, KScreenScale(404) + 2.5);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;

    self.mNoItemsBgView.sd_layout.topSpaceToView(self.mTableView, 0)
    .widthIs(__MainScreen_Width)
    .heightIs(KScreenScale(900));
    
    @weakify(self);
    self.mViewModel.sucessBlock = ^(NSMutableArray * mdataArray) {
        @strongify(self);
        UleSectionBaseModel * sectionModel=mdataArray.firstObject;
        self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
//        self.mTableView.hidden=sectionModel.cellArray.count>0?NO:YES;
        [self.mTableView reloadData];
    };
    
    self.transFlag = @"";
    //请求奖励金列表数据
    [self requestRewardHeadData];
    [self beginRequestList];
    
}

- (void)beginRequestList
{
    self.start=1;
    [self requestRewardListDataWithStartPage:[NSString stringWithFormat:@"%@",@(self.start)] transFlag:self.transFlag];
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    [self beginRequestList];
    //    self.start=1;
    //    [self requestRewardListDataWithStartPage:[NSString stringWithFormat:@"%@",@(self.start)] transFlag:self.transFlag];
}

- (void)beginRefreshFooter{
    self.start++;
    [self requestRewardListDataWithStartPage:[NSString stringWithFormat:@"%@",@(self.start)] transFlag:self.transFlag];
}

- (void)endRefreshAnimation{
    [self.mTableView.mj_header endRefreshing];
    if (self.mViewModel.isEndRefreshFooter) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        self.mTableView.mj_footer.alpha=1.0;
        [self.mTableView.mj_footer endRefreshing];
    }
}

- (void)requestRewardHeadData{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetRewardHeadRequest] success:^(id responseObject) {
        @strongify(self);
        TotalRewardsHeadModel * incomeData=[TotalRewardsHeadModel yy_modelWithDictionary:responseObject];
        self.headView.model = incomeData.data;
    } failure:^(UleRequestError *error) {
        NSLog(@"error == %@", error);
    }];
}

//transFlag当前列表类型 空为全部 E支出 D收入
- (void)requestRewardListDataWithStartPage:(NSString *)startPage transFlag:(NSString *)transFlag {
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetRewardListRequestWithStartPage:startPage PageSize:@"10" transFlag:transFlag] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        US_WalletTotalIncomeModel * incomeData=[US_WalletTotalIncomeModel yy_modelWithDictionary:responseObject];
        incomeData = nil;
        [self.mViewModel fetchRewardListWithData:incomeData WithStartPage:self.start DetailViewName:@"奖励金明细"];
        
        [self endRefreshAnimation];
        if ([startPage intValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mTableView setContentOffset:CGPointZero animated:YES];
            });
        }
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        if (self.mViewModel.mDataArray.count == 0) {
            self.mNoItemsBgView.hidden = NO;
            self.mNoItemsBgView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_serviceError"];
            self.mNoItemsBgView.describe = @"下拉刷新试试";
            self.mNoItemsBgView.subTitleLabel.textColor = [UIColor convertHexToRGB:@"ee3b39"];
        }
    }];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (US_RewardHeadView *)headView
{
    if (!_headView) {
        _headView = [[US_RewardHeadView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.frame.size.height + self.uleCustemNavigationBar.frame.origin.y, __MainScreen_Width, KScreenScale(404) + 2.5)];
        @weakify(self);
        _headView.chooseBtnBlock = ^(NSString * _Nonnull transFlag) {
            @strongify(self);
            self.transFlag = transFlag;
            [self beginRequestList];
        };
    }
    return _headView;
}

- (US_RewardListViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_RewardListViewModel alloc] init];
        _mViewModel.rootVC=self;
    }
    return _mViewModel;
}

- (US_EmptyPlaceHoldView *)mNoItemsBgView{
    if (!_mNoItemsBgView) {
        _mNoItemsBgView=[[US_EmptyPlaceHoldView alloc] init];
        _mNoItemsBgView.hidden=YES;
        _mNoItemsBgView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noDetail"];
        _mNoItemsBgView.titleLabel.text=@"暂无收益明细";
//        _mNoItemsBgView.describe=@"请点击重试";
        @weakify(self);
        _mNoItemsBgView.clickEvent = ^{
            @strongify(self);
            [self beginRefreshHeader];
        };
    }
    return _mNoItemsBgView;
}
@end
