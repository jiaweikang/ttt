//
//  OwnGoodsDetailListVC.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "OwnGoodsDetailListVC.h"
#import <UIView+SDAutoLayout.h>
#import "OwnGoodsDetailHeadView.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_RewardListViewModel.h"
#import "US_UserCenterApi.h"
#import "OwnGoodsDetailManager.h"
#import "FeatureModel_OwnGoodsTips.h"
#import "US_WalletTotalIncomeModel.h"

@interface OwnGoodsDetailListVC ()
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) OwnGoodsDetailHeadView *headView;
@property (nonatomic, strong) US_RewardListViewModel * mViewModel;
@property (nonatomic, strong) NSString *transFlag; //当前列表类型 空为全部 E支出 D收入

@property (nonatomic, assign) BOOL isHeadRefresh;
@end

@implementation OwnGoodsDetailListVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![US_UserUtility sharedLogin].isPushOwnListDetail) {
        [self beginRefreshHeader];
    }
    [US_UserUtility sharedLogin].isPushOwnListDetail = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"自有商品货款"];
    }
    
    [self.view addSubview:self.mNoItemsBgView];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.headView];
    
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, KScreenScale(258) + 2.5);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    self.mTableView.hidden=YES;
    
    self.mNoItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mNoItemsBgView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, KScreenScale(258) + 2.5);
    
    @weakify(self);
    self.mViewModel.sucessBlock = ^(NSMutableArray * mdataArray) {
        @strongify(self);
        UleSectionBaseModel * sectionModel=mdataArray.firstObject;
        self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
        self.mTableView.hidden=sectionModel.cellArray.count>0?NO:YES;
        [self.mTableView reloadData];
    };
    [self beginRequestOwnGoodsTips];
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.start=1;
    [self beginRequestIncomeListFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRefreshFooter{
    self.start++;
    [self beginRequestIncomeListFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)endRefreshAnimation{
    [self.mTableView.mj_header endRefreshing];
    if (self.mViewModel.isEndRefreshFooter) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}

#pragma mark - 网络请求
- (void)beginRequestIncomeListFromStartPage:(NSString *)startPage{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetIncomeListRequestWithStartPage:startPage PageSize:@"10" PageFlag:self.transFlag accTypeId:@"A010" BeginDate:@"" EndDate:@""] success:^(id responseObject) {
        @strongify(self);
        US_WalletTotalIncomeModel * incomeData=[US_WalletTotalIncomeModel yy_modelWithDictionary:responseObject];
        [self.headView layoutHeadView:incomeData.data.balance];
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel fetchRewardListWithData:incomeData WithStartPage:self.start DetailViewName:@"自有商品货款"];
        [self endRefreshAnimation];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self endRefreshAnimation];
    }];
}

- (void)beginRequestOwnGoodsTips
{
    @weakify(self);
    [self.networkClient_Ule beginRequest:[US_UserCenterApi buildOwnGoodsTips] success:^(id responseObject) {
        @strongify(self);
        FeatureModel_OwnGoodsTips *ownGoodsTips=[FeatureModel_OwnGoodsTips yy_modelWithDictionary:responseObject];
        FeatureModel_OwnGoodsTipsInfo *indexInfo= [ownGoodsTips.indexInfo firstObject];
        if ([NSString isNullToString:indexInfo.title].length > 0) {
            self.headView.explainBtn.hidden = NO;
            self.headView.tipsStr = indexInfo.title;
        }
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
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

- (OwnGoodsDetailHeadView *)headView
{
    if (!_headView) {
        _headView = [[OwnGoodsDetailHeadView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.frame.size.height + self.uleCustemNavigationBar.frame.origin.y, __MainScreen_Width, KScreenScale(258) + 2.5)];
        @weakify(self);
        _headView.chooseBtnBlock = ^(NSString * _Nonnull transFlag) {
            @strongify(self);
            self.transFlag = transFlag;
            self.isHeadRefresh = NO;
            [self beginRefreshHeader];
        };
        _headView.withdrawBtnBlock = ^{
            @strongify(self);
            [OwnGoodsDetailManager shareManager].rootVC = self;
            [[OwnGoodsDetailManager shareManager] withDrawAction];
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
        _mNoItemsBgView.titleLabel.text=@"暂无货款";
        _mNoItemsBgView.describe=@"请点击重试";
        _mNoItemsBgView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_bgNew"];
        @weakify(self);
        _mNoItemsBgView.clickEvent = ^{
            @strongify(self);
            [self beginRefreshHeader];
        };
    }
    return _mNoItemsBgView;
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
