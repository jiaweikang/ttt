//
//  US_HomeSecureVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_HomeSecureVC.h"
#import "US_GoodsSourceApi.h"
#import "UleBaseViewModel.h"
#import "US_InsuranceCellModel.h"
#import "UleBasePageViewController.h"
#import "UleModulesDataToAction.h"
@interface US_HomeSecureVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) UIImageView * mHeadView;
@property (nonatomic, copy) NSString * logName;
@end

@implementation US_HomeSecureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
    NSString *titleStr = self.m_Params[@"title"];
    if (titleStr && titleStr.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:titleStr];
    } else {
        [self.uleCustemNavigationBar customTitleLabel:@"保险专区"];
    }
    self.logName=[[self.m_Params objectForKey:@"hasTab"] isEqualToString:@"1"]?@"首页保险":@"保险专区";
    [self.view addSubview:self.mHeadView];
    [self.view addSubview:self.mTableView];
    UIView * maskheadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(190))];
    maskheadView.backgroundColor=[UIColor clearColor];
    [self.mTableView setTableHeaderView:maskheadView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self.mTableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self startRequestInsuranceList];
}

- (void)dealloc{
    [_mTableView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <http>
- (void)didStartLoadData:(NSNotification *)notify{
    if (self.mViewModel.mDataArray.count<=0) {
        [self startRequestInsuranceList];
    }
}

- (void)startRequestInsuranceList{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    NSString * sectionkey = NonEmpty([UleStoreGlobal shareInstance].config.sectionKey_insurance);
    [self.networkClient_UstaticCDN beginRequest:[US_GoodsSourceApi buildCdnFeaturedGetRequestWithKey:sectionkey] success:^(id responseObject) {
        @strongify(self);
        [self fetchInsuranceListDicInfo:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)fetchInsuranceListDicInfo:(NSDictionary *)dic{
    FeatureModel_Insurance * insuranceData=[FeatureModel_Insurance yy_modelWithDictionary:dic];
    if (insuranceData.indexInfo.count>0) {
        if (self.mViewModel.mDataArray) {
            [self.mViewModel.mDataArray removeAllObjects];
        }
        InsuranceIndexInfo * indexInfo=insuranceData.indexInfo.firstObject;
        [self.mHeadView yy_setImageWithURL:[NSURL URLWithString:indexInfo.imgUrl] placeholder:nil];
        UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
        for (int i=1; i<insuranceData.indexInfo.count; i++) {
            InsuranceIndexInfo * indexInfo=insuranceData.indexInfo[i];
            BOOL iscaninput=[UleModulesDataToAction canInputDataMin:indexInfo.min_version withMax:indexInfo.max_version withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
            if (iscaninput &&[self filterProvince:indexInfo]) {
                US_InsuranceCellModel * cellModel=[[US_InsuranceCellModel alloc] initWithInsuranceItem:indexInfo];
                cellModel.logShareFrom=self.logName;
                cellModel.logPageName=self.logName;
                [sectionModel.cellArray addObject:cellModel];
            }
        }
        
        [self.mViewModel.mDataArray addObject:sectionModel];
        [self.mTableView reloadData];
    }
}

//筛选省份,没配默认不限制省份
- (BOOL)filterProvince:(InsuranceIndexInfo *)info {
    if ([NSString isNullToString:info.showProvince].length > 0) {
        if ([US_UserUtility sharedLogin].m_provinceCode.length>0 && [info.showProvince containsString:[US_UserUtility sharedLogin].m_provinceCode]) {
            return YES;
        }
    } else {
        return YES;
    }
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat newoffsety = newvalue.UIOffsetValue.vertical;
        self.mHeadView.top_sd=self.uleCustemNavigationBar.bottom_sd-newoffsety;
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

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

- (UIImageView *)mHeadView{
    if (!_mHeadView) {
        _mHeadView=[[UIImageView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.bottom_sd, __MainScreen_Width, KScreenScale(240))];
    }
    return _mHeadView;
}
@end
