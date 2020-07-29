//
//  MemberViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/27.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "MemberViewModel.h"
#import "UleSectionBaseModel.h"
#import "US_NetworkExcuteManager.h"
#import "USMemberListData.h"
#import "US_MemberListCellModel.h"
#import "US_MemberListCell.h"
#import <MJRefresh.h>
#import "US_MemberDetailVC.h"

@interface MemberViewModel ()
@property (nonatomic, strong) UleSectionBaseModel * sectionModel;
@property (nonatomic, strong) UILabel * totalLabel;
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation MemberViewModel
- (instancetype) init{
    self = [super init];
    if (self) {
        self.startPage = 1;
    }
    return self;
}



- (void)fetchValueSuccessWithModel:(NSDictionary *) dic{
    if (self.startPage==1) {
        [self.sectionModel.cellArray removeAllObjects];
    }
    self.startPage ++;
    USMemberListData *memberListData = [USMemberListData yy_modelWithDictionary:dic];
    _totalCount = memberListData.data.totalRecord.integerValue;
    for (int i=0; i<[memberListData.data.retLst count]; i++) {
        US_MemberInfo * memberInfo=[memberListData.data.retLst objectAtIndex:i];

        US_MemberListCellModel * cellModel=[[US_MemberListCellModel alloc]init];
        cellModel.cellName=@"US_MemberListCell";
        cellModel.imageUrl = memberInfo.imageUrl;
        cellModel.name = memberInfo.customerName;
        cellModel.mobileNum = memberInfo.mobile;
        cellModel.addr = memberInfo.addr;
        cellModel.seqId = memberInfo.seqId;
        cellModel.integral = memberInfo.integral;
        cellModel.cardNum = memberInfo.cardNum;
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
    if (self.sectionModel.cellArray.count == memberListData.data.totalRecord.floatValue) {
        [self.rootTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        [self.rootTableView.mj_footer endRefreshing];
    }
    if (self.sectionModel.cellArray.count == 0) {
        self.rootTableView.mj_footer.hidden=YES;
    }
    else{
        self.rootTableView.mj_footer.hidden=NO;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.totalLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (void) tableCellClickAt:(NSIndexPath *)indexPath{
    //取消修改功能-20191030
//    NSLog(@"===%@===%@",@(indexPath.section),@(indexPath.row));
//    if (indexPath.row < self.sectionModel.cellArray.count) {
//        US_MemberListCellModel * memberInfo = [self.sectionModel.cellArray objectAtIndex:indexPath.row];
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:memberInfo,@"memberInfo",nil];
//        [self.rootVC pushNewViewController:@"US_MemberDetailVC" isNibPage:NO withData:dic];
//    }
    
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
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 25)];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.7];
    }
    _totalLabel.text = [NSString stringWithFormat:@"当前客户：%ld",(long)_totalCount];
    return _totalLabel;
}

@end
