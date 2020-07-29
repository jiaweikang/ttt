//
//  US_LogisticDetailVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticDetailVC.h"
#import "US_MyOrderApi.h"
#import "UleBaseViewModel.h"
#import "US_ExpressInfo.h"
#import "US_LogisticDetailCellModel.h"
#import "US_LogisticTitleCellModel.h"
#import "MyWaybillOrderInfo.h"
@interface US_LogisticDetailVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) NSString * logisticId;
@property (nonatomic, strong) NSString * logisticCode;
@property (nonatomic, strong) NSString * packageId;
@property (nonatomic, strong) WaybillOrder * billOrder;
@end

@implementation US_LogisticDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"物流详情"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.logisticId=[self.m_Params objectForKey:@"logisticsId"];
    self.logisticCode=[self.m_Params objectForKey:@"logisticsCode"];
    self.packageId=[self.m_Params objectForKey:@"package_id"];
    self.billOrder=[self.m_Params objectForKey:@"waybillOrder"];
    [self startRequestLogisticDetailInfo];
}

- (void)startRequestLogisticDetailInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyOrderApi buildSearchLogisticWithId:self.logisticId code:self.logisticCode andPackageId:self.packageId] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self frechLogisticDetailInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}


- (void)frechLogisticDetailInfo:(NSDictionary *)dic{
    US_ExpressInfo * express=[US_ExpressInfo yy_modelWithDictionary:dic];
    UleSectionBaseModel * titleSectonModel=[[UleSectionBaseModel alloc] init];
    titleSectonModel.footHeight=10;
    US_LogisticTitleCellModel * cellModel=[[US_LogisticTitleCellModel alloc] initWithCellName:@"US_LogisticDetailTitleCell"];
    if (express.data.map.expressData.myArrayList.count>0) {
        cellModel.packageId=express.data.map.packageNo;
        cellModel.name=express.data.map.expressName;
    }else{
        DeleveryInfo * dever=self.billOrder.delevery.firstObject;
        cellModel.packageId=dever.package_id;
        cellModel.name=dever.logisticsName;
    }

    
    [titleSectonModel.cellArray addObject:cellModel];
    [self.mViewModel.mDataArray addObject:titleSectonModel];
    
    
    UleSectionBaseModel * sectonModel=[[UleSectionBaseModel alloc] init];
    for (int i=0; i<express.data.map.expressData.myArrayList.count; i++) {
        US_ExpressListMap * expressList=express.data.map.expressData.myArrayList[i];
        US_LogisticDetailCellModel * cellModel=[[US_LogisticDetailCellModel alloc] initWithLogiticMapInfo:expressList];
        if (i==0) {
            cellModel.states=@"0"; //当前节点
        }else if (i==express.data.map.expressData.myArrayList.count-1){
            cellModel.states=@"-1"; //最初节点
        }else{
            cellModel.states=@"1";//中间节点
        }
        [sectonModel.cellArray addObject:cellModel];
    }
    [self.mViewModel.mDataArray addObject:sectonModel];
    [self.mTableView reloadData];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSelectionStyleNone;
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

@end
