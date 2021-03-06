//
//  US_MessageListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MessageListVC.h"
#import "US_MystoreManangerApi.h"
#import "US_MessageModel.h"
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"
#import "UleBaseViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "UIImage+USAddition.h"
#import "UlePushHelper.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_OrderMessageListVC.h"
#import "US_OrderMessageVC.h"
#import "US_MessageDetailVC.h"

@interface US_MessageListVC ()

@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyPlaceholdView;
@end

@implementation US_MessageListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
          [self.uleCustemNavigationBar customTitleLabel:title];
    }else [self.uleCustemNavigationBar customTitleLabel:@"消息"];
    self.category = [self.m_Params objectForKey:@"category"];
    if ([self.category isEqualToString:@"1089"]) {
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"ActivityMessage"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"活动消息"];
    }else if ([self.category isEqualToString:@"1081"]){
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"WalletMessage"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"钱包消息"];
    }else if ([self.category isEqualToString:@"1029"]){
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"ExpressMessage"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"物流消息"];
    }else if ([self.category isEqualToString:@"1011"]){
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"OrderMessage"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"订单消息"];
    } else{
        self.logModel.cur=[NSString LS_safeUrlBase64Encode:@"NormalMsgList"];
        self.logModel.cti=[NSString LS_safeUrlBase64Encode:@"系统消息"];
    }
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.emptyPlaceholdView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    self.emptyPlaceholdView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.emptyPlaceholdView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self beginRefreshHeader];
}
#pragma mark - <上拉、下拉刷新>
- (void)beginRefreshHeader{
    self.startIndex=1;
    if (self.category.length>0) {
        [self getMessageListForCategory:self.category andAtIndex:self.startIndex];
    }else{
        [self getPushMessageListInfoAtIndex:self.startIndex];
    }
}

- (void)beginRefreshFooter{

    self.mTableView.mj_footer.alpha=1.0;
    if (self.category.length>0) {
        [self getMessageListForCategory:self.category andAtIndex:self.startIndex];
    }else{
        [self getPushMessageListInfoAtIndex:self.startIndex];
    };
}

#pragma mark - <http>
- (void)getPushMessageListInfoAtIndex:(NSInteger) index{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MystoreManangerApi buildGetMessageListFromIndex:index] success:^(id responseObject) {
        @strongify(self);
        [self handleMessageInfo:responseObject];
        self.startIndex++;
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
        self.emptyPlaceholdView.hidden=sectionModel.cellArray.count>0?YES:NO;
    }];
}

- (void)getMessageListForCategory:(NSString *)category andAtIndex:(NSInteger)index{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MystoreManangerApi buildGetCategroyMessageFromIndex:index category:category] success:^(id responseObject) {
        [self handelCategoryMessageListInfor:responseObject];
        self.startIndex++;
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
        self.emptyPlaceholdView.hidden=sectionModel.cellArray.count>0?YES:NO;
    }];
}

- (void)handleMessageInfo:(NSDictionary *)dic{
     US_MessageModel * messageModel=[US_MessageModel yy_modelWithDictionary:dic];
    NSInteger total=[messageModel.data.total integerValue];
    [self fetchCellDataArray:messageModel.data.data andTotoalNum:total];
}

- (void)handelCategoryMessageListInfor:(NSDictionary *)dic{
    MessageData2 * messageModel=[MessageData2 yy_modelWithDictionary:dic];
    NSInteger total=[messageModel.total integerValue];
    [self fetchCellDataArray:messageModel.data andTotoalNum:total];
}

- (void)fetchCellDataArray:(NSArray *)dataArray andTotoalNum:(NSInteger)total{
    if (self.startIndex==1) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<dataArray.count; i++) {
        US_MessageDetail * messageInfo=dataArray[i];
        UleCellBaseModel * cellBaseModel=[[UleCellBaseModel alloc] initWithCellName:@"US_MessageListCell"];
        @weakify(self);
        cellBaseModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            [self cellClickWithMessageDetail:messageInfo];
        };
        cellBaseModel.data=messageInfo;
        [sectionModel.cellArray addObject:cellBaseModel];
    }
    self.emptyPlaceholdView.hidden=sectionModel.cellArray.count>0?YES:NO;
    [self.mTableView reloadData];
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count>=total) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mTableView.mj_footer endRefreshing];
    }
}

#pragma mark - <Cell Click>
- (void)cellClickWithMessageDetail:(US_MessageDetail *)messageDetail{
    NSString * parem=messageDetail.msgparam;
    if (!messageDetail.msgparam || messageDetail.msgparam.length <= 0) {
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:[NSString stringWithFormat:@"%@",messageDetail.sendTime] forKey:@"sendTime"];
        [infoDic setObject:[NSString stringWithFormat:@"%@",messageDetail.content] forKey:@"content"];
        [infoDic setObject:[NSString stringWithFormat:@"%@",messageDetail.title] forKey:@"title"];
        [self pushNewViewController:@"US_MessageDetailVC" isNibPage:NO withData:infoDic];
        return;
    }
    [[UlePushHelper shared] handlePushParams:parem alertStr:@""];
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
- (US_EmptyPlaceHoldView *)emptyPlaceholdView{
    if (!_emptyPlaceholdView) {
        _emptyPlaceholdView=[[US_EmptyPlaceHoldView alloc] init];
        _emptyPlaceholdView.hidden=YES;
        _emptyPlaceholdView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noMessage"];
        _emptyPlaceholdView.titleLabel.text=@"暂无消息内容";
    }
    return _emptyPlaceholdView;
}
@end
