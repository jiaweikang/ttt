//
//  US_OrderPreListViewModel.m
//  u_store
//
//  Created by xulei on 2019/6/28.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "US_OrderPreListViewModel.h"
#import <MJExtension/MJExtension.h>
#import "FeaturedModel_OrderPre.h"
#import "US_OrderPreListCellModel.h"
#import "UleModulesDataToAction.h"
#import "UleMbLogOperate.h"

@implementation US_OrderPreListViewModel

- (void)fetchOrderPreList:(NSDictionary *)dic{
    [self.mDataArray removeAllObjects];
    FeaturedModel_OrderPre *model = [FeaturedModel_OrderPre mj_objectWithKeyValues:dic];
    //过滤
    NSMutableArray *filterdArray=[NSMutableArray array];
    for (FeaturedModel_OrderPreIndex *indexItem in model.indexInfo) {
        if ([UleModulesDataToAction canInputDataMin:indexItem.min_version withMax:indexItem.max_version withDevice:indexItem.device_type withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]]&&[UleModulesDataToAction canInputWithProvinceList:indexItem.showProvince isConsiderCompany:NO]) {
            if ([indexItem.log_title isEqualToString:@"ziyou_orderlist"]&&![[US_UserUtility sharedLogin].qualificationFlag isEqualToString:@"1"]) {
                continue;
            }
            if ([indexItem.log_title isEqualToString:@"yzg_orderlist"]&&![[US_UserUtility sharedLogin].m_yzgFlag isEqualToString:@"1"]) {
                continue;
            }
            [filterdArray addObject:indexItem];
        }
    }
    
    UleSectionBaseModel *sectionModel=[[UleSectionBaseModel alloc]init];
    for (FeaturedModel_OrderPreIndex *filterIndexItem in filterdArray) {
        US_OrderPreListCellModel  *cellModel=[[US_OrderPreListCellModel alloc]initWithCellName:@"OrderPreListViewCell"];
        cellModel.imgUrl=filterIndexItem.imgUrl;
        cellModel.titleName=filterIndexItem.title;
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            UleUCiOSAction *commonAction = [UleModulesDataToAction resolveModulesActionStr:filterIndexItem.ios_action];
            [[UIViewController currentViewController] pushNewViewController:commonAction.mViewControllerName isNibPage:commonAction.mIsXib withData:commonAction.mParams];
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的订单" moduledesc:filterIndexItem.log_title networkdetail:@""];
        };
        
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mDataArray addObject:sectionModel];
}

@end
