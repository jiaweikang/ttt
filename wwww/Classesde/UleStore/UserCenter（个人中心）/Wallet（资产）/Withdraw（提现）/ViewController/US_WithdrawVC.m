//
//  US_WithdrawVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_WithdrawVC.h"
#import "US_UserCenterApi.h"
#import "AuthorizeRealNameMainView.h"
#import "WithdrawViewModel.h"
#import "US_WalletBindingCardModel.h"
#import "WithdrawRecordModel.h"
#import "WithdrawCommissionCellModel.h"
#import "WithdrawSummaryCellModel.h"
#import "WithdrawResultModel.h"
#import "WithdrawCashPromoteView.h"
#import <UIView+ShowAnimation.h>
#import "WithdrawFailAlertView.h"

@interface US_WithdrawVC ()
{
    dispatch_group_t    downloadGroup;
    NSString            *bankCode;//上传的银行卡加密串
    NSString            *transMoney;//上传的提现金额
}
@property (nonatomic, strong) UITableView           *mTableView;
@property (nonatomic, strong) WithdrawViewModel     *mViewModel;

@end

@implementation US_WithdrawVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    WithdrawCommissionCellModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:1];
    if (cellModel) {
        [cellModel removeObserver:self forKeyPath:@"transMoneyStr"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"提现"];
    }
    downloadGroup=dispatch_group_create();
    [self setUI];
    [self requestDataWithNum:3];
    [self startRequestProceedInfo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectBankCardDone:) name:NOTI_SelectBankcardDone object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotiAction:) name:NOTI_RefreshWithdrawView object:nil];
}

- (void)setUI{
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self buildDefaultSourceData];
    [self.mTableView reloadData];
}

#pragma mark - <kvo>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"transMoneyStr"]) {
        self->transMoney = [change objectForKey:NSKeyValueChangeNewKey];
    }
}

#pragma mark - <网络请求>
- (void)requestDataWithNum:(NSInteger)num{
    @weakify(self);
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    dispatch_apply(num, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(size_t i) {
        @strongify(self);
        switch (i) {
            case 0:
                [self requestIncomeInfo];
                break;
            case 1:
                [self requestWithdrawSummary];
                break;
            case 2:
                [self startRequestBindingCardInfo];
                break;
            default:
                break;
        }
        dispatch_group_enter(self->downloadGroup);
    });
    dispatch_group_notify(downloadGroup, dispatch_get_main_queue(), ^{
        [self.mTableView.mj_header endRefreshing];
        [UleMBProgressHUD hideHUDForView:self.view];
    });
}

//查询可提现收益
- (void)requestIncomeInfo{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetIncomeRequestWithAccTypeId:self.m_Params[@"accTypeId"]] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self->downloadGroup);
        NSDictionary * dic = [responseObject objectForKey:@"data"];
        NSString * withdrawcommison = [dic objectForKey:@"balance"];
        UleCellBaseModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:1];
        cellModel.data=withdrawcommison;
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        dispatch_group_leave(self->downloadGroup);
        [self showErrorHUDWithError:error];
    }];
}

//查询提现记录
- (void)requestWithdrawSummary{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetWithdrawRecordRequestWithStartPage:@"1" accTypeId:self.m_Params[@"accTypeId"]] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self->downloadGroup);
        WithdrawRecordModel *recordModel = [WithdrawRecordModel yy_modelWithDictionary:responseObject];
        WithdrawRecordList *listModel = [recordModel.data.list firstObject];
        if (listModel) {
            UleCellBaseModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:3];
            cellModel.data = listModel;
            [self.mTableView reloadData];
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self->downloadGroup);
        [self showErrorHUDWithError:error];
    }];
}

//银行卡列表
- (void)startRequestBindingCardInfo{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetBindCardListRequest] success:^(id responseObject) {
        @strongify(self);
        dispatch_group_leave(self->downloadGroup);
        US_WalletBindingCardModel *model=[US_WalletBindingCardModel yy_modelWithDictionary:responseObject];
        US_WalletBindingCardInfo *firstObj = [model.data.cardList firstObject];
        if (firstObj) {
            self->bankCode = firstObj.cardNoCipher;
            UleCellBaseModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:0];
            cellModel.data = firstObj.cardNo;
            [self.mTableView reloadData];
        }
    } failure:^(UleRequestError *error) {
        @strongify(self);
        dispatch_group_leave(self->downloadGroup);
        [self showErrorHUDWithError:error];
    }];
}

//提示文案
- (void)startRequestProceedInfo{
    [self.networkClient_Ule beginRequest:[US_UserCenterApi buildWithdrawProcessInfo] success:^(id responseObject) {
        NSDictionary *responseDic = responseObject;
        NSArray *array = [responseDic objectForKey:@"indexInfo"];
        NSDictionary *dataDic = [array firstObject];
        NSString *key_info=@"attribute1";
        if ([NSString isNullToString:[self.m_Params objectForKey:@"accTypeId"]].length>0) {
            key_info=@"attribute3";
        }
        NSString *instructionText = [NSString isNullToString:[dataDic objectForKey:key_info]];
        UleCellBaseModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:2];
        cellModel.data = instructionText;
        [self.mTableView reloadData];
    } failure:^(UleRequestError *error) {
        
    }];
}

- (void)startRequestWithdrawApply{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildWithdrawApplyWithPhoneNum:[US_UserUtility sharedLogin].m_mobileNumber bankCodeNum:[NSString isNullToString:bankCode] transMoneyNum:[NSString isNullToString:transMoney] accTypeId:self.m_Params[@"accTypeId"]] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        WithdrawResultModel *resultModel = [WithdrawResultModel yy_modelWithDictionary:responseObject];
        NSString *accTypeId = self.m_Params[@"accTypeId"];
        NSMutableDictionary *params = @{@"resultType":@"1",
                                        @"withdrawNum":[NSString isNullToString:self->transMoney],
                                        @"resultSubs":[NSString isNullToString:resultModel.data.presentRecordHint],
                                        @"accTypeId":[NSString isNullToString:accTypeId].length > 0 ? accTypeId : @""
                                        }.mutableCopy;
        [self pushNewViewController:@"US_WithdrawResultVC" isNibPage:NO withData:params];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        NSDictionary *dic = error.responesObject;
        WithdrawResultModel *resultModel = [WithdrawResultModel yy_modelWithDictionary:dic];
        if ([resultModel.returnCode isEqualToString:@"A3006"]) {
            WithdrawFailAlertView *alertView = [WithdrawFailAlertView withdrawFailViewWithMsg:[NSString isNullToString:resultModel.returnMessage] confirmBlock:^{
                //身份与银行卡不符
                [self pushNewViewController:@"US_WalletBankCardListVC" isNibPage:NO withData:@{@"isFromWithdraw":@"1"}.mutableCopy];
            }];
            [alertView showViewWithAnimation:AniamtionPresentBottom];
        }else {
            //提现失败
            NSString *accTypeId = self.m_Params[@"accTypeId"];
            NSMutableDictionary *params = @{@"resultType":@"0",@"withdrawNum":self->transMoney,
                                         @"resultMessage":[NSString isNullToString:resultModel.returnMessage],
                                         @"resultSubs":[NSString isNullToString:resultModel.data.presentRecordHint],
                                            @"accTypeId":[NSString isNullToString:accTypeId].length > 0 ? accTypeId : @""
                                            }.mutableCopy;
            [self pushNewViewController:@"US_WithdrawResultVC" isNibPage:NO withData:params];
        }
    }];
}

#pragma mark - <notification>
- (void)selectBankCardDone:(NSNotification *)noti{
    US_WalletBindingCardInfo *bankcardInfo = [noti.userInfo objectForKey:@"bankCardInfo"];
    bankCode = bankcardInfo.cardNoCipher;
    UleCellBaseModel *cellModel = [[self.mViewModel.mDataArray firstObject].cellArray objectAt:0];
    cellModel.data = bankcardInfo.cardNo;
    [self.mTableView reloadData];
}

- (void)refreshNotiAction:(NSNotification *)noti{
    [self requestDataWithNum:3];
}

#pragma mark - <actions>
- (void)buildDefaultSourceData{
    //创建cell
    UleSectionBaseModel *sectionModel = [[UleSectionBaseModel alloc]init];
    for (int i=0; i<4; i++) {
        switch (i) {
            case 0:{
                UleCellBaseModel *cellModel = [[UleCellBaseModel alloc]init];
                cellModel.cellName = @"WithdrawCell_bankCard";
                cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                    [self pushNewViewController:@"US_WalletBankCardListVC" isNibPage:NO withData:@{@"isFromWithdraw":@"1"}.mutableCopy];
                };
                [sectionModel.cellArray addObject:cellModel];
            }
                break;
            case 1:{
                WithdrawCommissionCellModel *cellModel = [[WithdrawCommissionCellModel alloc]initWithCellName:@"WithdrawCell_commission"];
                @weakify(self);
                cellModel.withdrawCommissionConfirmBlock = ^{
                    @strongify(self);
                    [self.view endEditing:YES];
                    WithdrawCashPromoteView *alertView = [WithdrawCashPromoteView withdrawCashPromoteViewWithType:WithdrawCashPromoteTypeWithdraw andNum:[NSString isNullToString:self->transMoney] confirmBlock:^(WithdrawCashPromoteType type) {
                        [self startRequestWithdrawApply];
                    }];
                    [alertView showViewWithAnimation:AniamtionAlert];
                };
                [cellModel addObserver:self forKeyPath:@"transMoneyStr" options:NSKeyValueObservingOptionNew context:nil];
                [sectionModel.cellArray addObject:cellModel];
            }
                break;
            case 2:{
                UleCellBaseModel *cellModel = [[UleCellBaseModel alloc]init];
                cellModel.cellName = @"WithdrawCell_proceed";
                [sectionModel.cellArray addObject:cellModel];
            }
                break;
            case 3:{
                WithdrawSummaryCellModel *cellModel = [[WithdrawSummaryCellModel alloc]initWithCellName:@"WithdrawCell_summary"];
                @weakify(self);
                cellModel.withdrawSummaryRecordBlock = ^{
                    @strongify(self);
                    [self.view endEditing:YES];
                    NSString *accTypeId = self.m_Params[@"accTypeId"];
                    NSMutableDictionary *params = @{@"accTypeId":[NSString isNullToString:accTypeId].length > 0 ? accTypeId : @""}.mutableCopy;
                    [self pushNewViewController:@"US_WithdrawRecordVC" isNibPage:NO withData:params];
                };
                [sectionModel.cellArray addObject:cellModel];
            }
                break;
        }
    }
    [self.mViewModel.mDataArray addObject:sectionModel];
}

#pragma mark - <US_RefreshProtocol>
- (void)beginRefreshHeader{
    if ([NSString isNullToString:bankCode].length>0) {
        [self requestDataWithNum:2];
    }else [self requestDataWithNum:3];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _mTableView.backgroundColor = kViewCtrBackColor;
        _mTableView.mj_header = self.mRefreshHeader;
    }
    return _mTableView;
}

- (WithdrawViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel = [[WithdrawViewModel alloc]init];
    }
    return _mViewModel;
}


@end
