//
//  OrganizeCollectionCellViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/26.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "OrganizeCollectionCellViewModel.h"
#import "AttributionPickHeaderModel.h"
#import "AttributionPickCellModel.h"
#import "PostOrgModel.h"

@interface OrganizeCollectionCellViewModel ()
@property (nonatomic, strong)AttributionPickCellModel              *lastSelectedCellModel;
@property (nonatomic, strong)NSIndexPath                           *lastSelectedCellIndexPath;

@end

@implementation OrganizeCollectionCellViewModel

- (NSMutableArray *)setCollectionCellViewTableviewData:(NSMutableArray *)mTableViewData
{
    NSMutableArray *sectionDataArr=[NSMutableArray arrayWithArray:mTableViewData];
    //导航边栏的数据源
    NSMutableArray *sideBarDataArr=[NSMutableArray array];
    //设置数据模型
    NSMutableArray *finalDataArr = [NSMutableArray array];
    for (int i=0; i<sectionDataArr.count; i++) {
        NSMutableArray *cellDataArr=sectionDataArr[i];
        //只有一种分组，取消头
        UleSectionBaseModel *sectionModel = [[UleSectionBaseModel alloc]init];
        if (sectionDataArr.count>1) {
            PostOrgData *cellItem = [cellDataArr firstObject];
            [sideBarDataArr addObject:cellItem.firstLetter];
            AttributionPickHeaderModel *newSectionModel = [[AttributionPickHeaderModel alloc]init];
            newSectionModel.headViewName=@"AttributionPickTableHeaderView";
            newSectionModel.headHeight=KScreenScale(60)+1;
            newSectionModel.headTitle = cellItem.firstLetter;
            sectionModel = newSectionModel;
        }
        for (int j=0; j<cellDataArr.count; j++) {
            PostOrgData *cellItemData = cellDataArr[j];
            AttributionPickCellModel *cellModel=[[AttributionPickCellModel alloc]initWithCellName:@"AttributionPickTableViewCell"];
            cellModel.contentStr = [NSString stringWithFormat:@"%@", cellItemData.name];
            cellModel._id = [NSString stringWithFormat:@"%ld", (long)cellItemData._id];
            cellModel.isContentSelected = cellItemData.isSelected;
            if (cellModel.isContentSelected) self.lastSelectedCellModel=cellModel;
            @weakify(self)
            @weakify(cellModel);
            cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                @strongify(self);
                @strongify(cellModel);
                if (self.lastSelectedCellModel) {
                    if (self.lastSelectedCellModel==cellModel) {
                        //重复点击
                        return;
                    }
                    self.lastSelectedCellModel.isContentSelected=NO;
                }
                cellModel.isContentSelected=YES;
                self.lastSelectedCellModel=cellModel;
                if (self.mViewModelCellDidSelectBlock) {
                    self.mViewModelCellDidSelectBlock(cellModel.contentStr, cellModel._id, indexPath, self.lastSelectedCellIndexPath);
                }
                self.lastSelectedCellIndexPath=indexPath;
            };
            [sectionModel.cellArray addObject:cellModel];
        }
        [finalDataArr addObject:sectionModel];
    }
    self.mDataArray=finalDataArr;
    if (self.sucessBlock) {
        self.sucessBlock(nil);
    }
    
    return sideBarDataArr;
}

@end
