//
//  MyWalletViewModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyWalletViewModel.h"
#import "MyWalletCellModel.h"
#import "US_WalletInfo.h"
#import "US_IncomeManageVC.h"
#import "US_WalletBankCardListVC.h"
#import "US_RewardListVC.h"
#import "FeaturedModel_UserCenter.h"
#import "UleModulesDataToAction.h"
#import "FileController.h"
#import "MyWalletBannerCell.h"
#import "MyWalletTitleCell.h"

@interface MyWalletViewModel ()
@property (nonatomic, strong) UIView * sectionHeaderView;
@property (nonatomic, strong) NSMutableArray *sectionArr;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, strong) MyWalletCellModel * redCellModel;//红包余额的cell数据
@end

@implementation MyWalletViewModel
- (instancetype) init{
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)fetchWalletListWithData:(NSDictionary *)dic{
    FeaturedModel_UserCenter *info = [FeaturedModel_UserCenter mj_objectWithKeyValues:dic];
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    if (info.indexInfo.count > 0) {
        for (int i = 0;i < [info.indexInfo count];i++) {
            FeaturedModel_UserCenterIndex *indexInfo = info.indexInfo[i];
            
            BOOL iscaninput = [UleModulesDataToAction canInputDataMin:indexInfo.minversion withMax:indexInfo.maxversion withDevice:indexInfo.devicetype withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
            if (iscaninput) {
                [saveArray addObject:info.indexInfo[i]];
            }
        }
    }
    [self loadLocalData:saveArray];
    [self prepareLayoutDataArray];
}

//读取加载本地数据
- (void)loadLocalData:(NSMutableArray *)dataArray{
    NSMutableArray *userCenterList=dataArray;
    //缓存没有取本地plist数据
    if (!userCenterList || userCenterList.count == 0) {
        userCenterList = [FeaturedModel_UserCenterIndex mj_objectArrayWithKeyValuesArray:[FileController loadArrayListProduct:kCacheFile_WalletList]];
    }
    if (userCenterList.count > 0) {
        [self.sectionArr removeAllObjects];
        //根据groupsort进行排序
        [userCenterList sortUsingComparator:^NSComparisonResult(FeaturedModel_UserCenterIndex *obj1, FeaturedModel_UserCenterIndex *obj2) {
            NSInteger num1 = [obj1.groupsort integerValue];
            NSInteger num2 = [obj2.groupsort integerValue];
            if (num1 <= num2) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        
        FeaturedModel_UserCenterIndex *info1 = [[FeaturedModel_UserCenterIndex alloc] init];
        FeaturedModel_UserCenterIndex *info2 = [[FeaturedModel_UserCenterIndex alloc] init];
        
        for (int i = 0; i < userCenterList.count; i++) {
            info1 = userCenterList[i];
            BOOL isLast = (i==userCenterList.count-1) ? YES : NO;
            if (i < userCenterList.count - 1) {
                info2 = userCenterList[i + 1];
            }
       
            [self filterData:info1 userCenterIndex:info2 isLast:isLast];
        }
    }
}
- (void)filterData:(FeaturedModel_UserCenterIndex *)info1 userCenterIndex:(FeaturedModel_UserCenterIndex *)info2 isLast:(BOOL)isLast{
    [self.cellArr addObject:info1];
    if (info1.groupsort != info2.groupsort || isLast) {
        [self.sectionArr addObject:self.cellArr];
        self.cellArr = nil;
    }
}

- (void)prepareLayoutDataArray{
   if (self.sectionArr.count > 0) {
        if (self.mDataArray.count > 0) {
            [self.mDataArray removeAllObjects];
        }
        for (int i=0; i<self.sectionArr.count; i++) {
            UleSectionBaseModel * seconModel=[[UleSectionBaseModel alloc] init];
            seconModel.headHeight=10;
            NSMutableArray * section=self.sectionArr[i];
            for (int j=0; j<section.count; j++) {
                
                FeaturedModel_UserCenterIndex * info=section[j];
                //资产余额 不添加 在tableViewHeader显示
                if ([info.groupid isEqualToString:@"1"]) {
                    self.headerTitleStr=info.title;
                    continue;
                }
                //奖励金(帅康用户不显示)
                if ([info.functionId isEqualToString:kWallet_AwardAmount] && [[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"]) {
                    continue;
                }
                //自有商品货款(开通自有商品才显示)
                if ([info.functionId isEqualToString:kWallet_SelfGoodsAmount] && ![[US_UserUtility sharedLogin].qualificationFlag isEqualToString:@"1"]) {
                    continue;
                }
                
                MyWalletCellModel * cellModel=[[MyWalletCellModel alloc] init];
                cellModel.titleStr=info.title;
                cellModel.sub_titleStr=info.sub_title;
                cellModel.iconUrlStr=info.imgUrl;
                cellModel.functionId=info.functionId;
                cellModel.statistics_flag=info.statistics_flag;
                cellModel.log_title=info.log_title;
                if ([cellModel.functionId isEqualToString:kWallet_Authorize] && [US_UserUtility isUserRealNameAuthorized]) {
                    cellModel.rightTitle = [[NSMutableAttributedString alloc] initWithString:@"已实名"];
                }

                if (info.ios_action.length>0) {
                    cellModel.ios_action=info.ios_action;
                }
                cellModel.img_wh_rate=info.wh_rate;
                if ([info.groupid isEqualToString:@"2"]) {
                    cellModel.cellName=@"MyWalletTitleCell";
                }
                else if([info.groupid isEqualToString:@"3"]){
                    cellModel.cellName=@"MyWalletCell";
                }
                else if([info.groupid isEqualToString:@"4"]){
                    cellModel.cellName=@"MyWalletBannerCell";
                }
                @weakify(self);
                @weakify(cellModel);
                cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                    @strongify(self);
                    @strongify(cellModel);
                    [self tableCellClickAt:cellModel];
                };
                //红包余额 金额大于0显示 先不添加进数组
                if ([info.functionId isEqualToString:kWallet_RedAmount]) {
                    self.redCellModel=cellModel;
                }
                else{
                    [seconModel.cellArray addObject:cellModel];
                }
            }
            if ([seconModel.cellArray count] > 0) {
                [self.mDataArray addObject:seconModel];
            }
            else{
                seconModel=nil;
            }
        }
        [self.rootTableView reloadData];
    }
}

- (void) tableCellClickAt:(MyWalletCellModel *)cellModel{
    if ([NSString isNullToString:cellModel.ios_action].length > 0) {
        
        if ([cellModel.functionId isEqualToString:kWallet_Authorize]) {
            //统计
            [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的钱包" moduledesc:@"实名认证" networkdetail:@""];
            if ([US_UserUtility isUserRealNameAuthorized]) {
                [self.rootVC pushNewViewController:@"US_AuthorizeRealNameSuccessVC" isNibPage:NO withData:nil];
            }else {
                NSMutableDictionary *params = @{@"isFromWithdraw":@"0",@"bankCardCount":[NSString isNullToString:[US_UserUtility sharedLogin].bankCardCount]}.mutableCopy;
                [self.rootVC pushNewViewController:@"US_AuthorizeRealNameVC" isNibPage:NO withData:params];
            }
            return;
        }
        
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:cellModel.ios_action];
        [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        [UleMbLogOperate addMbLogClick:@"" moduleid:@"我的钱包" moduledesc:cellModel.log_title networkdetail:@""];
    }
}

//解析钱包数据
- (NSDecimalNumber *)fetchWalletInfoValueWithData:(NSDictionary *) dic{
    US_WalletInfo * walletInfo = [US_WalletInfo yy_modelWithDictionary:dic];
    [US_UserUtility sharedLogin].bankCardCount = walletInfo.data.bindingCardCount;
    NSDecimalNumber *cardB=[NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *redPacketB=[NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *commissionB=[NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *redPacketB_919=[NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *redPacketB_myList=[NSDecimalNumber decimalNumberWithString:@"0"];
    
    for (UleSectionBaseModel * sectionModel in self.mDataArray) {
        for (MyWalletCellModel * cellModel in sectionModel.cellArray) {
            //分享赚取
            if ([cellModel.functionId isEqualToString:kWallet_ShareAmount]) {
                NSString *commissionBStr=[NSString isNullToString:walletInfo.data.commissionBalance];
                NSString * string = [NSString stringWithFormat:@"¥ %.2lf",commissionBStr.length>0?[commissionBStr doubleValue]:0.00];
                cellModel.rightTitle=[self attributedStringTransformFontWithString:string];
                
                if ([cellModel.statistics_flag boolValue]) {
                commissionB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",walletInfo.data.commissionBalance.length>0?walletInfo.data.commissionBalance:@"0.00"]];
                }
            }
            //奖励金
            if ([cellModel.functionId isEqualToString:kWallet_AwardAmount]) {
                NSString *redPacket919B=[NSString isNullToString:walletInfo.data.redPackageBalance919];
                NSString * string = [NSString stringWithFormat:@"¥ %.2lf",redPacket919B.length>0?[redPacket919B doubleValue]:0.00];
                cellModel.rightTitle=[self attributedStringTransformFontWithString:string];
                
                if ([cellModel.statistics_flag boolValue]) {
                    redPacketB_919 = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", walletInfo.data.redPackageBalance919.length>0?walletInfo.data.redPackageBalance919:@"0.00"]];
                }
            }
            //自有商品货款
            if ([cellModel.functionId isEqualToString:kWallet_SelfGoodsAmount]) {
                NSString *myListingB=[NSString isNullToString:walletInfo.data.myListingBalance];
                NSString * string = [NSString stringWithFormat:@"¥ %.2lf",myListingB.length>0?[myListingB doubleValue]:0.00];
                cellModel.rightTitle=[self attributedStringTransformFontWithString:string];
                if ([cellModel.statistics_flag boolValue]) {
                redPacketB_myList = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", walletInfo.data.myListingBalance.length>0?walletInfo.data.myListingBalance:@"0.00"]];
                }
            }
            if ([cellModel.functionId isEqualToString:kWallet_BankCardCount]) {
                NSString *bindCardB=[NSString isNullToString:walletInfo.data.bindingCardCount];
                NSString * string = [NSString stringWithFormat:@"%@ 张",bindCardB.length>0?bindCardB:@"0"];
                cellModel.rightTitle=[self attributedStringTransformColorWithString:string subString:@" 张"];
            }
            //邮乐卡
            if ([cellModel.functionId isEqualToString:kWallet_UleCardAmount]) {
                NSString *uleCardB=[NSString isNullToString:walletInfo.data.uleCardBalance];
                NSString * string = [NSString stringWithFormat:@"¥ %.2lf",uleCardB.length>0?[uleCardB doubleValue]:0.00];
                cellModel.rightTitle=[self attributedStringTransformFontWithString:string];
                
                if ([cellModel.statistics_flag boolValue]) {
                    cardB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@", walletInfo.data.uleCardBalance.length>0?walletInfo.data.uleCardBalance:@"0.00"]];
                }
            }
            if ([cellModel.functionId isEqualToString:kWallet_CouponCount]) {
                NSString *couponB=[NSString isNullToString:walletInfo.data.useableCouponCount];
                NSString * string = [NSString stringWithFormat:@"%@ 张",couponB.length>0?couponB:@"0"];
                cellModel.rightTitle=[self attributedStringTransformColorWithString:string subString:@" 张"];
            }
        }
    }
    //红包余额大于0才显示
    if (walletInfo.data.redPackageBalance.length > 0 && [walletInfo.data.redPackageBalance floatValue] > 0) {
        NSString * string = [NSString stringWithFormat:@"¥ %@",walletInfo.data.redPackageBalance];
               self.redCellModel.rightTitle=[self attributedStringTransformFontWithString:string];
        //红包余额
        if ([self.redCellModel.statistics_flag boolValue]) {
            redPacketB = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",walletInfo.data.redPackageBalance.length>0?walletInfo.data.redPackageBalance:@"0.00"]];
        }
        if ([self.mDataArray count]>0) {
            UleSectionBaseModel * sectionModel=[self.mDataArray objectAtIndex:0];
            if (![sectionModel.cellArray containsObject:self.redCellModel]) {
                [sectionModel.cellArray addObject:self.redCellModel];
            }
        }
    }

    //计算 decimalNumberWithString不能转空字符串@"" 会崩溃
    NSDecimalNumber *fullB = [[[cardB decimalNumberByAdding:redPacketB] decimalNumberByAdding:commissionB] decimalNumberByAdding:redPacketB_919];
    if ([[US_UserUtility sharedLogin].qualificationFlag isEqualToString:@"1"]) {
        fullB=[fullB decimalNumberByAdding:redPacketB_myList];
    }
     
    return fullB;
}

- (void)refeashUserRealNameAuthorization{
    for (UleSectionBaseModel * sectionModel in self.mDataArray) {
        for (MyWalletCellModel * cellModel in sectionModel.cellArray) {
            if ([cellModel.functionId  isEqualToString:kWallet_Authorize]) {
                NSString * string = [US_UserUtility isUserRealNameAuthorized]?@"已实名":@"未实名";
                cellModel.rightTitle = [[NSMutableAttributedString alloc] initWithString:string];
            }
        }
    }
}

- (NSMutableAttributedString *)attributedStringTransformFontWithString:(NSString *)string{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange([string rangeOfString:@"¥ "].location, [string rangeOfString:@"¥ "].length);
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:redRange];
    return attStr;
}

- (NSMutableAttributedString *)attributedStringTransformColorWithString:(NSString *)string subString:(NSString *)subString{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange([string rangeOfString:subString].location, [string rangeOfString:subString].length);
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"b6b6b6"] range:redRange];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:redRange];
    return attStr;
}

#pragma mark - <setter and getter>
- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [UIView new];
        _sectionHeaderView.frame = CGRectMake(0, 0, __MainScreen_Width, 50);
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 10)];
        label.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
        [_sectionHeaderView addSubview:label];
        
        UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, __MainScreen_Width - 15, 40)];
        tLabel.text = @"我的资产";
        tLabel.backgroundColor = [UIColor whiteColor];
        tLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        tLabel.font = [UIFont systemFontOfSize:16];
        [_sectionHeaderView addSubview:tLabel];

    }
    return _sectionHeaderView;
}

- (NSMutableArray *)sectionArr
{
    if (!_sectionArr) {
        _sectionArr = [NSMutableArray array];
    }
    return _sectionArr;
}

- (NSMutableArray *)cellArr
{
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}
@end
