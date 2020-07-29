//
//  InviterViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterViewModel.h"
#import "InviterMemberData.h"
#import "InviterMemberCell.h"
#import "InviterMemberCellModel.h"
#import <MJRefresh.h>
#import "US_InviterDetailVC.h"

@interface InviterViewModel ()
@property (nonatomic, strong) UleSectionBaseModel * sectionModel;
@property (nonatomic, strong) UILabel * totalLabel;
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation InviterViewModel

- (instancetype) init{
    self = [super init];
    if (self) {
        self.startPage = 1;
    }
    return self;
}

- (void)fetchInviterValueWithModel:(NSDictionary *) dic{
    InviterMemberData *inviteMemberData = [InviterMemberData yy_modelWithDictionary:dic];
    _totalCount = inviteMemberData.data.totalRecords.integerValue;
    if (self.startPage==1) {
        [self.sectionModel.cellArray removeAllObjects];
    }
    self.startPage ++;

    for (int i=0; i<[inviteMemberData.data.result count]; i++) {
        InviterInfo * inviterInfo=[inviteMemberData.data.result objectAtIndex:i];
        
        InviterMemberCellModel * cellModel=[[InviterMemberCellModel alloc]init];
        cellModel.cellName=@"InviterMemberCell";
        cellModel.imageUrl = inviterInfo.storeLogo;
        cellModel.storeName = inviterInfo.storeName;
        cellModel.inviterId = inviterInfo.ownerId;
        cellModel.mobile = inviterInfo.mobile;
        cellModel.provinceName = inviterInfo.provinceName;
        if (inviterInfo.organizationName.length > 0) {
            cellModel.userName = [NSString stringWithFormat:@"%@ | %@", inviterInfo.usrTrueName, inviterInfo.organizationName];
        } else {
            cellModel.userName = inviterInfo.usrTrueName;
        }
        if (inviterInfo.orderCount.length>0 && ![inviterInfo.orderCount isEqualToString:@"0"]) {
            cellModel.saleCount = [NSString stringWithFormat:@"%@单", inviterInfo.orderCount];
        }
        else{
            cellModel.saleCount = @"";
        }
        cellModel.lastShareTime = inviterInfo.lastShareTime;
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
    [self.rootTableView.mj_header endRefreshing];
    [self.rootTableView.mj_footer endRefreshing];
    if (self.sectionModel.cellArray.count == 0||self.sectionModel.cellArray.count == inviteMemberData.data.totalRecords.floatValue) {
        self.rootTableView.mj_footer.hidden=YES;
    }else{
        self.rootTableView.mj_footer.hidden=NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 25)];
    [headerView addSubview:self.totalLabel];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (void) tableCellClickAt:(NSIndexPath *)indexPath{
    if (indexPath.row < self.sectionModel.cellArray.count) {
        InviterMemberCellModel * inviterInfo = [self.sectionModel.cellArray objectAtIndex:indexPath.row];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:inviterInfo.inviterId,@"inviterId",nil];
        [self.rootVC pushNewViewController:@"US_InviterDetailVC" isNibPage:NO withData:dic];
    }
    
}

#pragma mark - <setter and getter>
- (UleSectionBaseModel *)sectionModel{
    if (!_sectionModel) {
        _sectionModel=[[UleSectionBaseModel alloc] init];
    }
    return _sectionModel;
}

- (UILabel *)totalLabel{
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenScale(30), 0, __MainScreen_Width - KScreenScale(30), 25)];
        _totalLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _totalLabel.textAlignment = NSTextAlignmentLeft;
        _totalLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _totalLabel.backgroundColor = [UIColor clearColor];
    }
    _totalLabel.text = [NSString stringWithFormat:@"您共邀请了：%@位好友",@(_totalCount)];
    return _totalLabel;
}
@end
