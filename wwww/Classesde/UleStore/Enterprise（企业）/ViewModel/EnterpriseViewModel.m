//
//  EnterpriseViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "EnterpriseViewModel.h"
#import "US_EnterpriseDataModel.h"
#import "US_EnterpriseSectionModel.h"
#import "US_MyGoodsListCellModel.h"
#import "UleModulesDataToAction.h"
#import "US_EnterpriseWholeSaleModel.h"

@implementation EnterpriseViewModel

- (void)handleEnterpriseRecommendData:(US_EnterpriseRecommendData *)recomModel isFirstPage:(BOOL)isFirst
{
    if (!recomModel.recommendDaily||recomModel.recommendDaily.count==0) {
        return;
    }
    if (isFirst) {
        [self.mDataArray removeAllObjects];
    }
    
    US_EnterpriseSectionModel *sectionModel = (US_EnterpriseSectionModel *)[self.mDataArray firstObject];
    if (!sectionModel) {
        sectionModel = [[US_EnterpriseSectionModel alloc]init];
        [self.mDataArray addObject:sectionModel];
    }
    
    for (int i=0; i<recomModel.recommendDaily.count; i++) {
        US_MyGoodsListCellModel *cellModel = [[US_MyGoodsListCellModel alloc]initWithEnterprise:recomModel.recommendDaily[i] andCellName:@"US_MyGoodsListCell"];
        cellModel.logPageName=@"企业推荐";
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareChannel=@"1";
        cellModel.shareFrom=@"1";
        cellModel.srcid=Srcid_Enterprise_Prd;
        @weakify(self);
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(cellModel);
            if (self.recommendCellClickBlock) {
                self.recommendCellClickBlock(cellModel.listId, cellModel.zoneId);
            }
        };
        [sectionModel.cellArray addObject:cellModel];
    }
}

- (void)handleEnterpriseWholeSaleData:(US_EnterpriseWholeSaleData *)wholeSaleData isFirstPage:(BOOL)isFirst{
    if (isFirst) {
        [self.mDataArray removeAllObjects];
    }
    if (!wholeSaleData.list||wholeSaleData.list.count==0) {
        return;
    }
    UleSectionBaseModel *sectionModel=[self.mDataArray firstObject];
    if (!sectionModel) {
        sectionModel = [[US_EnterpriseSectionModel alloc]init];
        [self.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<wholeSaleData.list.count; i++) {
        US_MyGoodsListCellModel *cellModel = [[US_MyGoodsListCellModel alloc]initWithEnterpriseWholeSale:wholeSaleData.list[i]];
        cellModel.logPageName=@"企业分销";
        cellModel.logShareFrom=@"商品列表";
        cellModel.shareChannel=@"3";
        cellModel.shareFrom=@"1";
        cellModel.srcid=Srcid_Enterprise_fxPrd;
        @weakify(self);
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(cellModel);
            if (self.recommendCellClickBlock) {
                self.recommendCellClickBlock(cellModel.listId, cellModel.zoneId);
            }
        };
        [sectionModel.cellArray addObject:cellModel];
    }
}


@end
