//
//  US_IncomeListInfoVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_IncomeListInfoVC.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_RewardListViewModel.h"
#import "US_UserCenterApi.h"
#import "UleBasePageViewController.h"
#import "US_SelectDateTitleView.h"

@interface US_IncomeListInfoVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_RewardListViewModel * mViewModel;
@property (nonatomic, strong) NSString * selectIndex;//选择下标 0收入 1支出 2全部
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) US_SelectDateTitleView * dateView;
@property (nonatomic, strong) NSString * beginDateStr;
@property (nonatomic, strong) NSString * endDateStr;
@end

@implementation US_IncomeListInfoVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
    self.selectIndex = [self.m_Params objectForKey:@"selectIndex"];
    [self setUI];
}

- (void)setUI{
    self.dateView=[[US_SelectDateTitleView alloc] init];
    UIView * line=[[UIView alloc] init];
    line.backgroundColor=[UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
    [self.view sd_addSubviews:@[self.dateView,line,self.mTableView]];
    
    self.dateView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(46);
    line.sd_layout
    .topSpaceToView(self.dateView, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(0.4);
    self.mTableView.sd_layout
    .topSpaceToView(line, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0);

    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    self.mTableView.hidden=YES;
    
    [self.view addSubview:self.mNoItemsBgView];
    self.mNoItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mNoItemsBgView.sd_layout.topSpaceToView(line, 0);
    
    @weakify(self);
    self.mViewModel.sucessBlock = ^(NSArray * mdataArray) {
        @strongify(self);
        UleSectionBaseModel *sectionModel=[mdataArray firstObject];
        self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
        self.mTableView.hidden=sectionModel.cellArray.count>0?NO:YES;
        [self.mTableView reloadData];
    };

    self.beginDateStr=self.dateView.beginDateTF.text;
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.endDateStr = [dateFormatter stringFromDate:currentDate];
    
    self.dateView.selectDateBlock = ^(NSString * _Nonnull beginDateStr, NSString * _Nonnull endDateStr) {
        @strongify(self);
        self.beginDateStr=beginDateStr;
        self.endDateStr=endDateStr;
        [self beginRefreshHeader];
    };
}

- (void)didStartLoadData:(NSNotification *)notify{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel && sectionModel.cellArray.count>0) {
        //第一次加载时请求
        return;
    }
//    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
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

- (void)beginRequestIncomeListFromStartPage:(NSString *)startPage{
    NSString * pageFlag = @"";
    switch (self.selectIndex.integerValue) {
        case 0:
            pageFlag = @"D";
            break;
        case 1:
            pageFlag = @"E";
            break;
        case 2:
            pageFlag = @"";
            break;
        default:
            break;
    }
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetIncomeListRequestWithStartPage:startPage PageSize:@"10" PageFlag:pageFlag accTypeId:@"" BeginDate:self.beginDateStr EndDate:self.endDateStr] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        US_WalletTotalIncomeModel * incomeData=[US_WalletTotalIncomeModel yy_modelWithDictionary:responseObject];
        [self.mViewModel fetchRewardListWithData:incomeData WithStartPage:self.start DetailViewName:@"收入明细"];
        [self endRefreshAnimation];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self endRefreshAnimation];
    }];
}

- (void)endRefreshAnimation{
    [self.mTableView.mj_header endRefreshing];
    if (self.mViewModel.isEndRefreshFooter) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
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
        NSString * tipsString = @"";
        switch (self.selectIndex.integerValue) {
            case 0:
                tipsString = @"暂无收入明细";
                break;
            case 1:
                tipsString = @"暂无支出明细";
                break;
            case 2:
                tipsString = @"暂无收支明细";
                break;
            default:
                break;
        }
        _mNoItemsBgView.titleLabel.text=tipsString;
        _mNoItemsBgView.describe=@"请点击重试";
        @weakify(self);
        _mNoItemsBgView.clickEvent = ^{
            @strongify(self);
            [self beginRefreshHeader];
        };
    }
    return _mNoItemsBgView;
}

@end
