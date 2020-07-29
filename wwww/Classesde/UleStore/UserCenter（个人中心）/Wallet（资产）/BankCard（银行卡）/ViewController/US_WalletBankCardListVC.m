//
//  US_WalletBankCardListVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_WalletBankCardListVC.h"
#import "US_UserCenterApi.h"
#import "US_BankCardListViewModel.h"
#import "US_BindingBankCardVC.h"
#import "US_UntyingBankCardResultAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_UntyingBankCardAlertView.h"
#import "US_EmptyPlaceHoldView.h"

@interface US_WalletBankCardListVC ()<UntyingBankCardResultAlertViewDelegate>
{
    BOOL    isFromAuthorize;
    BOOL    isFromWithdraw;
}
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) US_BankCardListViewModel * mViewModel;
@property (nonatomic, strong) UIButton * editButton;
@property (nonatomic, strong) US_EmptyPlaceHoldView * placeHoldView;
@property (nonatomic, strong) NSString * deleteCardNumber;
@end

@implementation US_WalletBankCardListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"银行卡"];
    }
    isFromAuthorize = [[self.m_Params objectForKey:@"isFromAuthorize"] isEqualToString:@"1"];
    isFromWithdraw = [[self.m_Params objectForKey:@"isFromWithdraw"] isEqualToString:@"1"];

    [self.view addSubview:self.placeHoldView];
    self.placeHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.editButton];
    self.editButton.hidden = YES;
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.hidden=YES;
    if (isFromAuthorize || isFromWithdraw) {
        self.mTableView.tableFooterView=nil;
        self.uleCustemNavigationBar.rightBarButtonItems=nil;
    }
    //请求银行卡列表数据
    [self requestBindingCardList];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadBankCardList:)
                                                 name:@"bindingBankCardSucessBack"
                                               object:nil];
    @weakify(self);
    self.mViewModel.sucessBlock = ^(NSArray * mdataArray) {
        @strongify(self);
        self.placeHoldView.hidden = mdataArray.count>0?YES:NO;
        self.editButton.hidden = mdataArray.count>0?NO:YES;
        [self.mTableView reloadData];
        self.mTableView.hidden=mdataArray.count>0?NO:YES;
    };
    self.mViewModel.cellSelectBlock = ^(US_WalletBindingCardInfo * _Nonnull cardInfo) {
        @strongify(self);
        if (isFromAuthorize || isFromWithdraw) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_SelectBankcardDone object:self userInfo:@{@"bankCardInfo":cardInfo}];
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    [self requestBindingCardList];
}


- (void)reloadBankCardList:(NSNotification *)notification{
    self.mTableView.contentOffset = CGPointMake(0, 0);
    [self requestBindingCardList];
}

- (void)requestBindingCardList{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetBindCardListRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel fetchBankCardListWithData:responseObject];
        [self.mTableView.mj_header endRefreshing];
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - US_BankCardListCellDelegate
//解除绑定
- (void)deleteCardWithCardNum:(NSString *)cardNum{
    if (cardNum.length == 0) {
        return;
    }
    _deleteCardNumber = cardNum;
    @weakify(self);
    US_UntyingBankCardAlertView *alertView =[US_UntyingBankCardAlertView untyingBankCardAlertViewWithTitle:@"您确定解除绑定该银行卡吗？" message:@"解除绑定后，银行服务将不可使用" confirmAction:^{
        @strongify(self);
        [self deleteCard];
    } cancelAction:^{
       
    }];
    [alertView showViewWithAnimation:AniamtionPresentBottom];
    
}

- (void)deleteCard{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildDeleteCardWithCardNumber:_deleteCardNumber] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        
        US_UntyingBankCardResultAlertView *alertView = [US_UntyingBankCardResultAlertView untyingBankCardResultAlertViewWithType:(UntyingBankCardResultAlertViewTypeSuccess) delegate:self];
        [alertView showViewWithAnimation:AniamtionAlert];
        
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD hideHUDForView:self.view];
        US_UntyingBankCardResultAlertView *alertView = [US_UntyingBankCardResultAlertView untyingBankCardResultAlertViewWithType:(UntyingBankCardResultAlertViewTypeFail) delegate:self];
        [alertView showViewWithAnimation:AniamtionAlert];
    }];
}

#pragma mark - UntyingBankCardResultAlertViewDelegate
- (void)untyingBankCardResultAlertViewSuccess {
    [self requestBindingCardList];
}

- (void)untyingBankCardResultAlertViewTryAgainAction {
    if (_deleteCardNumber.length>0) {
        [self deleteCardWithCardNum:_deleteCardNumber];
    }
}

#pragma mark - Action
- (void)addNewCardAction
{
    //统计
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"银行卡" moduledesc:@"绑定银行卡" networkdetail:@""];
    
    [self pushNewViewController:@"US_BindingBankCardVC" isNibPage:NO withData:nil];
}

- (void)editButtonClicked:(UIButton *)button{
    button.selected = !button.isSelected;
    [self.mViewModel setBankCardListEdit:button.selected];
}

- (UIButton *)bindingCardButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 5;
    [button setTitle:@"绑定新卡" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor convertHexToRGB:@"c60a1e"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setImage:[UIImage bundleImageNamed:@"card_icon_add"] forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(addNewCardAction:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
        
        UIView *bindingCardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 120)];
        UIButton * button = [self bindingCardButton];
        [bindingCardView addSubview:button];
        button.sd_layout.leftSpaceToView(bindingCardView, KScreenScale(20)).rightSpaceToView(bindingCardView, KScreenScale(20)).topSpaceToView(bindingCardView, 20).heightIs(48);
        _mTableView.tableFooterView = bindingCardView;
    }
    return _mTableView;
}
- (US_BankCardListViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[US_BankCardListViewModel alloc] init];
        _mViewModel.rootVC=self;
    }
    return _mViewModel;
}

//导航栏右侧-编辑按钮
- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(1.0, 3.0, 40, 40)];
        [_editButton setBackgroundColor:[UIColor clearColor]];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:(UIControlStateNormal)];
        [_editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

- (US_EmptyPlaceHoldView *)placeHoldView{
    if (!_placeHoldView) {
        _placeHoldView=[[US_EmptyPlaceHoldView alloc] init];
        _placeHoldView.hidden=YES;
        _placeHoldView.titleLabel.text = @"您还没有绑定邮政卡哦~";
        _placeHoldView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noBankCard"];
        _placeHoldView.clickBtnText = @"添加邮储卡";
        @weakify(self);
        _placeHoldView.btnClickBlock = ^{
            @strongify(self);
            [self addNewCardAction];
        };
    }
    return _placeHoldView;
}

@end
