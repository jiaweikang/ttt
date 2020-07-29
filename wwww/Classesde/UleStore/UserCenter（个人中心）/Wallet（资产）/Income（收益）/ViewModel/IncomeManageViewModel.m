//
//  IncomeViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/2/19.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "IncomeManageViewModel.h"
#import <UICountingLabel.h>
#import <UIView+SDAutoLayout.h>
#import <UleNetworkExcute.h>
#import "US_NetworkExcuteManager.h"
#import "US_UserCenterApi.h"
#import "US_QueryAuthInfo.h"
#import "US_WalletBindingCardModel.h"
#import "WithdrawCashPromoteView.h"
#import <UIView+ShowAnimation.h>
#import "US_WithdrawVC.h"
#import "US_DonateVC.h"
#import "US_WalletBankCardListVC.h"
#import "US_IncomeTradingVC.h"
#import "US_WithdrawRecordVC.h"
#import "US_IncomeListPageVC.h"

#define Tag_Image        1000
#define Tag_LeftTitle    2000
#define Tag_RightTitle   3000

@interface IncomeManageViewModel ()
@property (nonatomic, strong) UIView * sectionHeaderView;
@property (nonatomic, strong) UICountingLabel *amountLabel;
@property (nonatomic, strong) UIButton * donateBtn;
@property (nonatomic, strong) UIButton * sectionFooterView;
@property (nonatomic, strong) NSArray * leftTitles;
@property (nonatomic, strong) NSArray * imgNames;
@property (nonatomic, strong) NSString * canWithdrawAmount;//可提现收益
@property (nonatomic, strong) NSString * tradingIncomeAmount;//交易中的收益
@property (nonatomic, strong) UleNetworkExcute * networkClient_VPS;
@end

@implementation IncomeManageViewModel

- (void)dealloc{
//    if (_networkClient_VPS) {
//        [_networkClient_VPS cancel];
//    }
}

- (instancetype) init{
    self = [super init];
    if (self) {
        [self initData];
        
    }
    return self;
}

- (void) initData{
    _leftTitles = @[@"待结算金额", @"提现记录", @"收支明细"];
    _imgNames = @[@"income_icon_trading",@"income_icon_withdrawRecord",@"income_icon_details"];
}

- (void)fetchValueWithData:(NSDictionary *)data{
    NSDictionary * dic = [data objectForKey:@"data"];
    self.tradingIncomeAmount = [dic objectForKey:@"unIssueCms"];
    self.canWithdrawAmount = [dic objectForKey:@"balance"];
    self.canWithdrawAmount = [self.canWithdrawAmount doubleValue]>0?self.canWithdrawAmount:@"0.00";
    [self.rootTableView reloadData];
    if (self.canWithdrawAmount.length > 0) {
        @weakify(self);
        self.amountLabel.completionBlock = ^{
            @strongify(self);
            if (self) {
                self.amountLabel.text=self.canWithdrawAmount;
            }
        };
        [_amountLabel countFrom:0.00 to:[self.canWithdrawAmount doubleValue] withDuration:1.0];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 100;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return self.sectionFooterView;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 70;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_leftTitles count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"incomeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (48 - 28)/2, 28, 28)];
        iconView.tag = Tag_Image;
        [cell.contentView addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 11, 0, 150, 48)];
        titleLabel.tag = Tag_LeftTitle;
        titleLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(__MainScreen_Width - 230, 0, 200, 48)];
        contentLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        contentLabel.tag = Tag_RightTitle;
        contentLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:contentLabel];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, __MainScreen_Width, 1)];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
        [cell.contentView addSubview:lineView];
        
    }
    
    UIImageView *iconview = (UIImageView*)[cell.contentView viewWithTag:Tag_Image];
    UILabel *titlelabel = (UILabel*)[cell.contentView viewWithTag:Tag_LeftTitle];
    UILabel *contentLabel = (UILabel*)[cell.contentView viewWithTag:Tag_RightTitle];
    iconview.image = [UIImage bundleImageNamed:[_imgNames objectAtIndex:indexPath.row]];
    titlelabel.text = [_leftTitles objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) {
        NSString *str = [NSString stringWithFormat:@"￥%.2lf",self.tradingIncomeAmount.length > 0?[self.tradingIncomeAmount doubleValue]:0.00];
        NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:19] range:NSMakeRange(1, attributeStr.length - 3)];
        [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange( attributeStr.length - 2,2)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(0, attributeStr.length)];
        contentLabel.attributedText = attributeStr;
        contentLabel.hidden = NO;
    }else {
        contentLabel.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row==0) {
        //统计
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"关于收益" moduledesc:@"交易中的收益" networkdetail:@""];
        [self.rootVC pushNewViewController:@"US_IncomeTradingVC" isNibPage:NO withData:nil];
    }else if (indexPath.row==1) {
        //统计
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"关于收益" moduledesc:@"提现记录" networkdetail:@""];
        [self.rootVC pushNewViewController:@"US_WithdrawRecordVC" isNibPage:NO withData:nil];
    }else if (indexPath.row==2) {
        //统计
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"关于收益" moduledesc:@"收支明细" networkdetail:@""];
        [self.rootVC pushNewViewController:@"US_IncomeListPageVC" isNibPage:NO withData:nil];
    }
}

#pragma mark - Action
//提现
- (void)withdrawCashAction:(UIButton *)button{
    //是否签署协议
    if (![[US_UserUtility sharedLogin].m_isUserProtocol isEqualToString:@"1"]&&[US_UserUtility sharedLogin].m_protocolUrl.length>0){
        NSMutableDictionary *dic = @{@"isNeedSign":@"1",
                                     @"protocol":[US_UserUtility sharedLogin].m_protocolUrl}.mutableCopy;
        [self.rootVC pushNewViewController:@"US_AgreementVC" isNibPage:NO withData:dic];
        return;
    }
    [self getCertificationInfo];
}
//捐赠
- (void)donateAction:(UIButton *)button{
    if ([self.canWithdrawAmount doubleValue] > 0) {
        NSMutableDictionary *params=@{@"balance":self.canWithdrawAmount}.mutableCopy;
        [self.rootVC pushNewViewController:@"US_DonateVC" isNibPage:NO withData:params];
    }
    else{
        [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"当前金额不支持捐赠" afterDelay:1.5];
    }
}
//收益问题说明
- (void)incomeRemindAction:(UIButton *)button{
    //统计
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"关于收益" moduledesc:@"问题说明" networkdetail:@""];

    NSMutableDictionary *params = @{KNeedShowNav:@"0",@"key":@"https://www.ule.com/app/yxd/2016/1129/qa.html"/*,@"title":@"说明"*/}.mutableCopy;
    [self.rootVC pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
}

#pragma mark - 请求
//查询实名认证信息
- (void)getCertificationInfo{
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildQueryCertificationInfoRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        US_QueryAuthInfo * authInfo = [US_QueryAuthInfo yy_modelWithDictionary:responseObject];
        if ([authInfo.returnCode isEqualToString:@"0000"]) {
            if (authInfo.data) {
                if (authInfo.data.certificationInfo) {
                    [US_UserUtility setUserRealNameAuthorization:YES];
                    //请求接口看是否有银行卡
                    [self requestBindingCardInfo];
                } else {
                    //弹框提示实名认证 并跳往实名认证页
                    [US_UserUtility setUserRealNameAuthorization:NO];
                    [self gotoAuthorizeVC];
                }
            }
            else{
                [self gotoAuthorizeVC];
            }
        }
        else{
            [self gotoAuthorizeVC];
        }
       
    } failure:^(UleRequestError *error) {
        [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"提现通道被挤爆～正在抢修中，请稍后再试" afterDelay:1.5];
    }];
}

//请求接口看是否有银行卡
- (void)requestBindingCardInfo{
    
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetBindCardListRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        US_WalletBindingCardModel   *model=[US_WalletBindingCardModel yy_modelWithDictionary:responseObject];
        if (model.data.cardList.count > 0) {
            //存在银行卡 去提现页
            [self.rootVC pushNewViewController:@"US_WithdrawVC" isNibPage:NO withData:nil];
        }
        else{
            //无银行卡 需要绑定银行卡
            WithdrawCashPromoteView * promoteView = [WithdrawCashPromoteView withdrawCashPromoteViewWithType:WithdrawCashPromoteTypeBindcard andNum:@"" confirmBlock:^(WithdrawCashPromoteType type) {
                //                [Ule_Global shared].isJumpToWithdraw=YES;
                [self.rootVC pushNewViewController:@"US_WalletBankCardListVC" isNibPage:NO withData:nil];
            }];
            [promoteView showViewWithAnimation:AniamtionAlert];
        }
    } failure:^(UleRequestError *error) {
        NSString *errorInfo=[error.error.userInfo objectForKey:NSLocalizedDescriptionKey];
        if ([NSString isNullToString:errorInfo].length>0) {
            [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:errorInfo afterDelay:1.5];
        }
    }];
}

//弹框提示实名认证 并跳往实名认证页
- (void)gotoAuthorizeVC{
    WithdrawCashPromoteView * promoteView = [WithdrawCashPromoteView withdrawCashPromoteViewWithType:WithdrawCashPromoteTypeRealname andNum:@"" confirmBlock:^(WithdrawCashPromoteType type) {
        NSMutableDictionary *params = @{@"isFromWithdraw":@"1",@"bankCardCount":[NSString isNullToString:[US_UserUtility sharedLogin].bankCardCount]}.mutableCopy;
        [self.rootVC pushNewViewController:@"US_AuthorizeRealNameVC" isNibPage:NO withData:params];
    }];
    [promoteView showViewWithAnimation:AniamtionAlert];
}

#pragma mark - <setter and getter>
- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [UIView new];
        _sectionHeaderView.frame = CGRectMake(0, 0, __MainScreen_Width, 100);
        _sectionHeaderView.backgroundColor = kNavBarBackColor;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 150, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [[UIColor convertHexToRGB:@"f7afaf"] colorWithAlphaComponent:.9];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"可提现余额";

        _amountLabel = [[UICountingLabel alloc]init];
        _amountLabel.backgroundColor = [UIColor clearColor];
        _amountLabel.textColor = [UIColor whiteColor];
        _amountLabel.font = [UIFont systemFontOfSize:KScreenScale(50)];
        _amountLabel.adjustsFontSizeToFitWidth=YES;
        _amountLabel.format=@"%.2f";
        
        UIButton *cashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cashBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        cashBtn.tintColor = [UIColor convertHexToRGB:@"ff8080"];
        cashBtn.layer.borderColor = [UIColor convertHexToRGB:@"f7afaf"].CGColor;
        cashBtn.layer.borderWidth = 1.;
        cashBtn.layer.cornerRadius = 8.;
        cashBtn.layer.masksToBounds = YES;
        [cashBtn setTitle:@"提现" forState:UIControlStateNormal];
        [cashBtn addTarget:self action:@selector(withdrawCashAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _donateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _donateBtn.frame = CGRectMake(0, 0, 70, 40);
        _donateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _donateBtn.tintColor = cashBtn.tintColor;
        _donateBtn.layer.borderColor = [UIColor convertHexToRGB:@"f7afaf"].CGColor;
        _donateBtn.layer.borderWidth = 1.;
        _donateBtn.layer.cornerRadius = 8.;
        _donateBtn.layer.masksToBounds = YES;
        [_donateBtn setTitle:@"捐赠" forState:UIControlStateNormal];
        [_donateBtn addTarget:self action:@selector(donateAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sectionHeaderView sd_addSubviews:@[titleLabel,_amountLabel,cashBtn,_donateBtn]];
        cashBtn.sd_layout
        .rightSpaceToView(_sectionHeaderView, 10)
        .centerYEqualToView(_sectionHeaderView)
        .widthIs(70)
        .heightIs(40);
        _donateBtn.sd_layout
        .rightSpaceToView(cashBtn, 10)
        .centerYEqualToView(_sectionHeaderView)
        .widthIs(70)
        .heightIs(40);
        _amountLabel.sd_layout
        .leftSpaceToView(_sectionHeaderView, 10)
        .rightSpaceToView(_donateBtn, 10)
        .bottomEqualToView(cashBtn)
        .heightIs(30);
        //六安用户同时显示捐赠和提现 ---20180514
        if ([[US_UserUtility sharedLogin].m_donateFlag isEqualToString:@"2"]) {
            _donateBtn.hidden = NO;
        }
        else{
            _donateBtn.hidden = YES;
        }
    }
    return _sectionHeaderView;
}

- (UIButton *)sectionFooterView{
    if (!_sectionFooterView) {
        _sectionFooterView = [UIButton new];
        _sectionFooterView.backgroundColor = [UIColor whiteColor];
        _sectionFooterView.frame = CGRectMake(0, 0, __MainScreen_Width, 70);
        [_sectionFooterView addTarget:self action:@selector(incomeRemindAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 10)];
        grayView.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
        [_sectionFooterView addSubview:grayView];
        
        UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 21, 37, 37)];
        iconView.image = [UIImage bundleImageNamed:@"remainIcon"];
        [_sectionFooterView addSubview:iconView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 11, 10, 300, 60)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"小店余额、结算、提现常见问题说明";
        titleLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [_sectionFooterView addSubview:titleLabel];
        
        UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(__MainScreen_Width - 22, 32, 8, 14)];
        arrowView.image = [UIImage bundleImageNamed:@"rightArrow"];
        [_sectionFooterView addSubview:arrowView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, __MainScreen_Width, 1)];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
        [_sectionFooterView addSubview:lineView];
    }
    return _sectionFooterView;
}

- (UleNetworkExcute *)networkClient_VPS{
    if (!_networkClient_VPS) {
        _networkClient_VPS=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _networkClient_VPS;
}
@end
