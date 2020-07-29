//
//  US_DonateAreaPickVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/8.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_DonateAreaPickVC.h"
#import "UleBaseViewModel.h"
#import "US_LoginApi.h"
#import "DonatePickListCell.h"

@interface US_DonateAreaPickVC ()
@property (nonatomic, strong) UITableView    *mTableView;
@property (nonatomic, strong) UIButton       *confirmBtn;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_postOrigData * selectData;
@end

@implementation US_DonateAreaPickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = [self.m_Params objectForKey:@"delegate"];
    [self.uleCustemNavigationBar customTitleLabel:@"选择捐赠地区"];
    [self setUI];
    [self requestPostUnit];
}

-(void)setUI {
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.confirmBtn];
    self.confirmBtn.sd_layout
    .bottomSpaceToView(self.view, kIphoneX? 34+KScreenScale(40) : KScreenScale(40))
    .leftSpaceToView(self.view, KScreenScale(20))
    .rightSpaceToView(self.view, KScreenScale(20))
    .heightIs(50);
    
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.confirmBtn, 20);
    self.mTableView.mj_header=self.mRefreshHeader;
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    [self requestPostUnit];
}

-(void)requestPostUnit{//beta 109
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    //六安市
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostOrganizationWithParentId:[US_UserUtility sharedLogin].m_cityCode andLevelName:@"县" andOrgType:@"0"] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchPostUnitDicInfo:responseObject];
        [self.mTableView.mj_header endRefreshing];
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
    }];
}

- (void)fetchPostUnitDicInfo:(NSDictionary *)dic{
    [self.mViewModel.mDataArray removeAllObjects];
    US_PostOrigModel * postOrigData=[US_PostOrigModel yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<postOrigData.data.count; i++) {
        US_postOrigData * detail=postOrigData.data[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"DonatePickListCell"];
        cellModel.data=detail;
        [sectionModel.cellArray addObject:cellModel];
         @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self reloadListDataWithIndex:indexPath.row];
        };
    }
    
    [self.mTableView reloadData];
}

- (void)reloadListDataWithIndex:(NSInteger)index{
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    for (int i=0; i<sectionModel.cellArray.count; i++) {
        UleCellBaseModel * cellModel=sectionModel.cellArray[i];
        US_postOrigData * detail=(US_postOrigData *)cellModel.data;
        if (index == i) {
            detail.selected=YES;
            _selectData=detail;
        }
        else{
            detail.selected=NO;
        }
    }
    [self.mTableView reloadData];
}

#pragma mark - Actions
-(void)donateSubmitBtnAction:(UIButton *)sender
{
    if (_selectData==nil) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择地区" afterDelay:showDelayTime];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(organizationSelect:)]) {
        [self.delegate organizationSelect:_selectData];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(40)];
        _confirmBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        [_confirmBtn addTarget:self action:@selector(donateSubmitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}
@end
