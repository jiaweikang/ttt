//
//  UpdateUserPickCollectionViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserPickCollectionViewModel.h"
#import "AttributionPickCellModel.h"
#import "UpdateUserPickCollectionCellModel.h"

@interface UpdateUserPickCollectionViewModel ()
@property (nonatomic, strong)AttributionPickCellModel           *lastSelectedCellModel;

@end
@implementation UpdateUserPickCollectionViewModel

- (void)fetchTableCellModel:(UpdateUserPickCollectionCellModel *)itemModel{
    [self.sideBarDataArray removeAllObjects];
    for (int i=0; i<itemModel.tableviewDataArray.count; i++) {
        UleSectionBaseModel *sectionModel=[itemModel.tableviewDataArray objectAt:i];
        if (sectionModel.sectionData) {
            [self.sideBarDataArray addObject:sectionModel.sectionData];
        }
        for (AttributionPickCellModel *cellModel in sectionModel.cellArray) {
            @weakify(cellModel);
            cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                @strongify(cellModel);
                if (self.lastSelectedCellModel==cellModel) {
                    return;
                }
                if (self.lastSelectedCellModel) {
                    self.lastSelectedCellModel.isContentSelected=NO;
                }
                cellModel.isContentSelected=YES;
                self.lastSelectedCellModel=cellModel;
                if (self.sucessBlock) {
                    self.sucessBlock(nil);
                }
                if (self.didSelectCellBlock) {
                    self.didSelectCellBlock(cellModel);
                }
            };
        }
    }
    [self.mDataArray removeAllObjects];
    [self.mDataArray addObjectsFromArray:itemModel.tableviewDataArray];
    if (self.sucessBlock) {
        self.sucessBlock(nil);
    }
}

- (NSMutableArray *)sideBarDataArray{
    if (!_sideBarDataArray) {
        _sideBarDataArray=[NSMutableArray array];
    }
    return _sideBarDataArray;
}

@end
