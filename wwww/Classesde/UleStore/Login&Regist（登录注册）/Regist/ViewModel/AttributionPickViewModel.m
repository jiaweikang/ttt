//
//  AttributionPickViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "AttributionPickViewModel.h"
#import "US_NetworkExcuteManager.h"
#import "US_LoginApi.h"
#import "AttributionModel.h"
#import "AttributionPickHeaderModel.h"
#import "AttributionPickCellModel.h"
#import "PostOrgModel.h"

@interface AttributionPickViewModel ()
@property (nonatomic, strong)UleNetworkExcute           *networkClient_VPS;
@property (nonatomic, strong)AttributionPickCellModel   *lastSelectedCellModel;

@end

@implementation AttributionPickViewModel

- (void)loadEnterpriseInfo
{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostEnterpriseInfo] success:^(id responseObject) {
        @strongify(self);
        AttributionModel *responseModel=[AttributionModel yy_modelWithDictionary:responseObject];
        UleSectionBaseModel *sectionModel = [[UleSectionBaseModel alloc]init];
        for (int i=0; i<responseModel.data.count; i++) {
            AttributionData *item=[responseModel.data objectAtIndex:i];
            AttributionPickCellModel *cellModel=[[AttributionPickCellModel alloc]initWithCellName:@"AttributionPickTableViewCell"];
            cellModel.contentStr=[NSString stringWithFormat:@"%@", item.name];
            cellModel._id=[NSString stringWithFormat:@"%ld", item._id];
            cellModel.isContentSelected=NO;
            @weakify(cellModel);
            cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                @strongify(cellModel);
                if (self.lastSelectedCellModel) {
                    self.lastSelectedCellModel.isContentSelected=NO;
                }
                cellModel.isContentSelected=YES;
                self.lastSelectedCellModel=cellModel;
                if (self.didSelectCellBlock) {
                    self.didSelectCellBlock(cellModel.contentStr, cellModel._id);
                }
            };
            [sectionModel.cellArray addObject:cellModel];
        }
        self.mDataArray = @[sectionModel].mutableCopy;
        if (self.sucessBlock) {
            self.sucessBlock(nil);
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        if (self.failedBlock) {
            self.failedBlock(error);
        }
    }];
}

- (void)loadOrganizeInfoWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName andPostOrgType:(NSString *)postOrgType
{
    
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostOrganizationWithParentId:parentId andLevelName:levelName andOrgType:postOrgType] success:^(id responseObject) {
        USLog(@"%@", [responseObject yy_modelToJSONString]);
        PostOrgModel *respModel = [PostOrgModel yy_modelWithDictionary:responseObject];
        
        NSMutableArray *responseArr = [NSMutableArray arrayWithObject:respModel.data];
        if ([levelName isEqualToString:@"省"]) {
           responseArr = [self sortSourceData:respModel.data];
        }
        
        if (self.sucessBlock) {
            self.sucessBlock(responseArr);
        }
    } failure:^(UleRequestError *error) {
        if (self.failedBlock) {
            self.failedBlock(error);
        }
    }];
}

#pragma mark - <action>
- (NSMutableArray *)sortSourceData:(NSMutableArray *)sourceData
{
    //firstLetter为空的加到最后
    NSMutableArray *emptyLetterArr = [NSMutableArray array];
    for (PostOrgData *item in sourceData) {
        item.firstLetter=@"";
        if ([NSString isNullToString:item.firstLetter].length==0) {
            [emptyLetterArr addObject:item];
        }
    }
    //排序
    NSMutableArray *sourceArr = [NSMutableArray arrayWithArray:sourceData];
    NSMutableArray *sortedDataArr = [NSMutableArray array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstLetter" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [sourceArr sortUsingDescriptors:sortDescriptors];
    for (char flag='A'; flag<='Z'; flag++) {
        NSMutableArray *flagArr = [NSMutableArray array];
        for (PostOrgData *item in sourceArr) {
            if ([item.firstLetter isEqualToString:[NSString stringWithFormat:@"%c",flag]]) {
                [flagArr addObject:item];
            }
        }
        if (flagArr.count>0) {
            [sortedDataArr addObject:flagArr];
        }
    }
    if (emptyLetterArr.count>0) {
        [sortedDataArr addObject:emptyLetterArr];
    }
    return sortedDataArr;
}

#pragma mark - <getters>
- (UleNetworkExcute *)networkClient_VPS{
    if (!_networkClient_VPS) {
        _networkClient_VPS=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _networkClient_VPS;
}
@end
