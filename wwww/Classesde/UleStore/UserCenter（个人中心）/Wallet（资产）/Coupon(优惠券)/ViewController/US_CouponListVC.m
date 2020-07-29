//
//  US_CouponListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CouponListVC.h"
#import "UleBaseViewModel.h"
#import "US_UserCenterApi.h"
#import "US_MyCoupons.h"
#import "US_CouponListCellModel.h"
#import "UleBasePageViewController.h"
#import "UleTabBarViewController.h"
#import "USGoodsPreviewManager.h"
#import "US_EmptyPlaceHoldView.h"
@interface US_CouponListVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSString * couponStatus;
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyHoldeView;
@end

@implementation US_CouponListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.startIndex=1;
    self.couponStatus=self.m_Params[@"couponStatus"];
    
    [self.view sd_addSubviews:@[self.mTableView,self.emptyHoldeView]];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer.alpha=0.0;
    self.emptyHoldeView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didStartLoadData:(NSNotification *)notify{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel && sectionModel.cellArray.count>0) {
        //第一次加载时请求
        return;
    }
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
}

#pragma mark - <上拉 下拉>
- (void)beginRefreshHeader{
    self.startIndex=1;
    [self startRequestCouponst];
}

- (void)beginRefreshFooter{
    [self startRequestCouponst];
}

#pragma mark - <http>

- (void)startRequestCouponst{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_UserCenterApi buildCouponListInfoWithStatus:NonEmpty(self.couponStatus) pageIndex:[NSString stringWithFormat:@"%@",@(self.startIndex)] andPageSize:@"10"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchCouponlistDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)fetchCouponlistDicInfo:(NSDictionary * )dic{
    US_MyCoupons * coupondata=[US_MyCoupons yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    if (self.startIndex==1) {
        [sectionModel.cellArray removeAllObjects];
    }
    for (int i=0; i<coupondata.data.couponInfo.count; i++) {
        MyCouponModel * coupon=coupondata.data.couponInfo[i];
        US_CouponListCellModel * cellModel=[[US_CouponListCellModel alloc] initWithCouponData:coupon];
        cellModel.status=self.couponStatus;
        @weakify(self)
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self cellDidClickAt:tableView indexPath:indexPath];
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    self.startIndex++;
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count>=[coupondata.data.couponTotal
                                  integerValue] ) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
    [self.mTableView reloadData];
    self.mTableView.mj_footer.alpha=1.0;
    self.emptyHoldeView.hidden=sectionModel.cellArray.count>0?YES:NO;
}

- (void)cellDidClickAt:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    US_CouponListCellModel * cellModel  = sectionModel.cellArray[indexPath.row];
    MyCouponModel *myCouponModel=cellModel.data;
    /*
     规定 根据couponType判断跳转的页面
     1 店铺券 根据batchId ->US_CouponUseVC
     2 商品券 a.多商品(listId拼接多个字符串 用,号隔开) 则根据batchId ->US_CouponUseVC
     b.单商品 则直接跳VI
     3 运费券 直接跳首页(帅康用户没有首页 其实都默认跳tabbar[0])
     4 充值券 隐藏立即使用button
     5 通用券 直接跳首页(帅康用户没有首页 其实都默认跳tabbar[0])
     6 品类券 根据batchId ->US_CouponUseVC
     */
    if([self.couponStatus isEqualToString:@"2"]){//已使用的优惠券点击不跳转
        return;
    }
    NSString *couponType = myCouponModel.couponType;
    [LogStatisticsManager onSearchLog:Coupon_use tel:couponType];
    if ([couponType isEqualToString:@"3"] || [couponType isEqualToString:@"5"]) {
        UleTabBarViewController *tabViewController = (UleTabBarViewController *)self.tabBarController;
        [tabViewController selectTabBarItemAtIndex:0 animated:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else if ([couponType isEqualToString:@"1"] || [couponType isEqualToString:@"2"] || [couponType isEqualToString:@"6"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:myCouponModel.batchId, @"batchId", nil];
        [LogStatisticsManager shareInstance].srcid=Srcid_Coupon;
        if ([couponType isEqualToString:@"2"]) {
            NSArray *listIds = [myCouponModel.listId componentsSeparatedByString:@","];
            if (listIds.count>1) { //多商品
                //US_CouponUseVC
                [self pushNewViewController:@"US_CouponUseListVC" isNibPage:NO withData:dic];
            } else { //单商品
                //VI
                [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString stringWithFormat:@"%@",myCouponModel.listId] andSearchKeyword:@"" andPreviewType:@"7" andHudVC:self];
            }
        } else {
            //US_CouponUseVC
            [self pushNewViewController:@"US_CouponUseListVC" isNibPage:NO withData:dic];;
        }
        
    } else if ([couponType isEqualToString:@"4"]) {
        //应该不会出现这个问题 如果出现了 则不跳转...
    }
    [UleMbLogOperate addMbLogClick:myCouponModel.batchId moduleid:@"可用优惠券" moduledesc:@"使用优惠券" networkdetail:@""];
}

#pragma mark - <setter and getter>
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
        
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

- (US_EmptyPlaceHoldView *)emptyHoldeView{
    if (!_emptyHoldeView) {
        _emptyHoldeView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
//        _emptyHoldeView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_noClient"];
        _emptyHoldeView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_noCoupon"];
        _emptyHoldeView.titleLabel.text=[self.couponStatus isEqualToString:@"1"] ? @"没有可领的优惠券哦~" : @"还没有使用过优惠券哦~";
        _emptyHoldeView.hidden=YES;
    }
    return _emptyHoldeView;
}
@end
