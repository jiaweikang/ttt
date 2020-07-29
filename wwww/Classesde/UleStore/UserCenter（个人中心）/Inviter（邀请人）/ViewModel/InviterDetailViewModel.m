//
//  InviterDetailViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterDetailViewModel.h"
#import "UleSectionBaseModel.h"
#import "US_NetworkExcuteManager.h"
#import "InviterDetailHeadView.h"
#import "InviterDetailCellModel.h"
#import <UIView+SDAutoLayout.h>
#import "InviterDetailCell.h"
#import "USGoodsPreviewManager.h"

@interface InviterDetailViewModel ()
@property (nonatomic, strong) UleSectionBaseModel * sectionModel;
@property (nonatomic, strong) InviterDetailHeadView * headerView;

@end
@implementation InviterDetailViewModel

- (void)fetchInviterDetailValueWithData:(InviterDetailData *) inviterData{
   
    for (int i=0; i<[inviterData.data.storeDetail count]; i++) {
        InviterGoodsInfo * inviterGoodsInfo=[inviterData.data.storeDetail objectAtIndex:i];
        
        InviterDetailCellModel * cellModel=[[InviterDetailCellModel alloc]init];
        cellModel.cellName=@"InviterDetailCell";
        cellModel.listingId=inviterGoodsInfo.listingId;
        cellModel.productPic=inviterGoodsInfo.productPic;
        cellModel.listingName=inviterGoodsInfo.listingName;
        cellModel.salePrice=inviterGoodsInfo.salePrice;
        cellModel.prdCommission=inviterGoodsInfo.prdCommission;
        cellModel.orderCount=inviterGoodsInfo.orderCount;
       
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self tableCellClickAt:indexPath];
        };
        [self.sectionModel.cellArray addObject:cellModel];
    }
    if (self.mDataArray.count == 0) {
        [self.mDataArray addObject:self.sectionModel];
    }
    [self.headerView setModel:inviterData.data];
    self.rootTableView.tableHeaderView=self.headerView;
}

- (void) tableCellClickAt:(NSIndexPath *)indexPath{
    if (indexPath.row < self.sectionModel.cellArray.count) {
        InviterDetailCellModel * inviterDetail = [self.sectionModel.cellArray objectAtIndex:indexPath.row];
        [self getPreViewUrl:inviterDetail.listingId];
    }
    
}

/**
 *  获取预览url
 */
- (void)getPreViewUrl:(NSString *)listId {
    [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString stringWithFormat:@"%@",listId] andSearchKeyword:@"" andPreviewType:@"5" andHudVC:self.rootVC];
}

#pragma mark - <setter and getter>
- (UleSectionBaseModel *)sectionModel{
    if (!_sectionModel) {
        _sectionModel=[[UleSectionBaseModel alloc] init];
    }
    return _sectionModel;
}

- (InviterDetailHeadView *)headerView{
    if (!_headerView) {
        _headerView = [[InviterDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(470)+1)];
    }
    return _headerView;
}
@end
