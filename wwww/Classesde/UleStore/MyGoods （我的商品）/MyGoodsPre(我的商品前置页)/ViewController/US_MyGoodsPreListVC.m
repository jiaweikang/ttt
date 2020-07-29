//
//  US_MyGoodsPreVC.m
//  UleStoreApp
//
//  Created by lei xu on 2020/3/19.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsPreListVC.h"
#import "UleBaseViewModel.h"
#import "US_MyGoodsApi.h"
#import "FeaturedModel_OrderPre.h"
#import "UleModulesDataToAction.h"

#define imagesArray @[@"myGoodsPre_img_retail", @"myGoodsPre_img_distribute"]
#define titlesArray @[@"零售商品", @"分销商品"]
@interface US_MyGoodsPreListVC ()
@property (nonatomic, strong) UITableView       *mTableView;
@property (nonatomic, strong) UleBaseViewModel  *mViewModel;

@end

@implementation US_MyGoodsPreListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        [self.uleCustemNavigationBar customTitleLabel:[self.m_Params objectForKey:@"title"]];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"我的商品"];
    }
    [self.view sd_addSubviews:@[self.mTableView]];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self startRequestlistData];
}

- (void)startRequestlistData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    [self.networkClient_UstaticCDN beginRequest:[US_MyGoodsApi buildGoodsFavPreListRequest] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mTableView.mj_header endRefreshing];
        [self handleGoodsFavPreList:responseObject];
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:error];
    }];
}

- (void)beginRefreshHeader{
    [self startRequestlistData];
}
#pragma mark - <actions>
- (void)handleGoodsFavPreList:(NSDictionary *)responseObj{
    [self.mViewModel.mDataArray removeAllObjects];
    FeaturedModel_OrderPre *model = [FeaturedModel_OrderPre mj_objectWithKeyValues:responseObj];
    //过滤
    NSMutableArray *filterdArray=[NSMutableArray array];
    for (FeaturedModel_OrderPreIndex *indexItem in model.indexInfo) {
        if ([UleModulesDataToAction canInputDataMin:indexItem.min_version withMax:indexItem.max_version withDevice:indexItem.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]]&&[UleModulesDataToAction canInputWithProvinceList:indexItem.showProvince isConsiderCompany:NO]) {
            [filterdArray addObject:indexItem];
        }
    }
    
    UleSectionBaseModel *sectionModel=[[UleSectionBaseModel alloc]init];
    for (FeaturedModel_OrderPreIndex *filterIndexItem in filterdArray) {
        UleCellBaseModel  *cellModel=[[UleCellBaseModel alloc]initWithCellName:@"MyGoodsPreListCell"];
        NSDictionary *dic=@{@"imageUrl":[NSString isNullToString:[NSString stringWithFormat:@"%@", filterIndexItem.imgUrl]],
        @"titleName":[NSString isNullToString:[NSString stringWithFormat:@"%@", filterIndexItem.title]]};
        cellModel.data=dic;
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:filterIndexItem.ios_action];
            [self pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的订单" moduledesc:filterIndexItem.log_title networkdetail:@""];
        };
        
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mViewModel.mDataArray addObject:sectionModel];
}

#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        _mTableView.mj_header=self.mRefreshHeader;
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc]init];
    }
    return _mViewModel;
}

@end
