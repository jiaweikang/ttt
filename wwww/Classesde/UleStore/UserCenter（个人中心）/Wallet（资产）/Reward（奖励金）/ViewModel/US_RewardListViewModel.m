//
//  US_RewardListViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_RewardListViewModel.h"
#import "US_RewardCellModel.h"
#import "US_RewardListCell.h"
#import "UleDateFormatter.h"
#import "US_RewardDetailVC.h"
@interface US_RewardListViewModel ()

@property (nonatomic, strong) NSString * detailViewName;

@end

@implementation US_RewardListViewModel
//组装成sectionModel 数组用于显示
- (void)fetchRewardListWithData:(US_WalletTotalIncomeModel *)incomeData WithStartPage:(NSInteger)startPage DetailViewName:(NSString *)detailViewName{
    self.detailViewName = detailViewName;
    
    UleSectionBaseModel * sectionModel=self.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mDataArray addObject:sectionModel];
    }
    //加载第一页先清空数据
    if (startPage==1) {
        [sectionModel.cellArray removeAllObjects];
    }
        
    if (incomeData.data.AccountTransList.count == 0) {
        if (self.sucessBlock) {
            self.sucessBlock(self.mDataArray);
        }
        return;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (int i=0; i<incomeData.data.AccountTransList.count; i++) {
        TotalIncomeListInfo * listInfo=incomeData.data.AccountTransList[i];
        US_RewardCellModel * cellModel = [[US_RewardCellModel alloc] init];
        cellModel = [self fetchImgNameWithTransTypeId:listInfo.transFlag IncomeCellModel:cellModel];
        cellModel.incomeDesc=listInfo.statusText;
        cellModel.amount=listInfo.transMoney;
        cellModel.orderID=listInfo.transId;
        cellModel.detailTime=listInfo.transTime;
        cellModel.detailDesc=listInfo.remark;
        if (listInfo.transTime.length>0) {
            cellModel.creatOrderTime=[UleDateFormatter GetCustomDate:[formatter dateFromString:listInfo.transTime] dataFormat:@"MM-dd HH:mm"];
        }
        cellModel.timeTitle=listInfo.timeType;
        cellModel.iconUrl=listInfo.iconUrl;
        cellModel.effectiveTime=listInfo.effectiveTime;
        cellModel.cellName=@"US_RewardListCell";
        @weakify(self);
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            @strongify(cellModel);
            [self cellDidClickWithListInfo:cellModel];
            [US_UserUtility sharedLogin].isPushOwnListDetail = YES;
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    if (sectionModel.cellArray.count == [incomeData.data.count integerValue]) {
        self.isEndRefreshFooter=YES;
    }else{
        self.isEndRefreshFooter=NO;
    }
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)cellDidClickWithListInfo:(US_RewardCellModel *)cellModel{
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setObject:cellModel forKey:@"RewardDetail"];
    if (self.detailViewName.length>0) {
        [dic setObject:self.detailViewName forKey:@"title"];
    }
    [self.rootVC pushNewViewController:@"US_RewardDetailVC" isNibPage:NO withData:dic];
}

- (US_RewardCellModel *)fetchImgNameWithTransTypeId:(NSString *)transTypeId IncomeCellModel:(US_RewardCellModel *)model{
//    NSString *imgName = @"";
    NSString *symbol = @"";
    NSString *colorValue = @"";
    
    if ([transTypeId isEqualToString:@"D"]) { //已获收益
//        imgName = @"totalincome_5";
        symbol = @"＋";
        colorValue = @"ef3b39";
    } else if ([transTypeId isEqualToString:@"E"]) { //提现失败  购物退款
//        imgName = @"totalincome_2";
        symbol = @"-";
        colorValue = @"36a4f1";
    }
//    model.imageName=imgName;
    model.symbol=symbol;
    model.colorValue=colorValue;
    return model;
}

@end
