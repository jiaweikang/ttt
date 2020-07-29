//
//  MineViewModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "MineViewModel.h"
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"
#import "MineCellModel.h"
#import <UIViewController+UleExtension.h>
#import "US_UserUtility.h"
#import "InviterMemberData.h"
#import "USInviteShareManager.h"
#import "FeaturedModel_UserCenter.h"
#import "UleModulesDataToAction.h"
#import <FileController.h>
#import "MyWalletCellModel.h"
#import "WalletButtonCell.h"
#import "MineBannerCell.h"
#import "US_WalletInfo.h"

#define MineCellTitle_GWC   @"Cart"
#define MineCellTitle_YQR   @"InvitedPerson"
#define MineCellTitle_YQHY  @"InviteOpenStore"

@interface MineViewModel()
@property (nonatomic, assign) NSInteger inviterMemberCount;
@property (nonatomic, strong) NSMutableArray *groupsortList;
@property (nonatomic, strong) NSMutableArray *allListArr;

@end

@implementation MineViewModel

- (instancetype) init{
    self = [super init];
    if (self) {
        [self prepareLayoutDataArray:NO];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 圆角弧度半径
    CGFloat cornerRadius = 5.f;
   
    
    // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
    cell.backgroundColor = UIColor.clearColor;
    
    // 创建一个shapeLayer
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
    // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
    CGMutablePathRef pathRef = CGPathCreateMutable();
    // 获取cell的size
    // 第一个参数,是整个 cell 的 bounds, 第二个参数是距左右两端的距离,第三个参数是距上下两端的距离
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
   
    // CGRectGetMinY：返回对象顶点坐标
    // CGRectGetMaxY：返回对象底点坐标
    // CGRectGetMinX：返回对象左边缘坐标
    // CGRectGetMaxX：返回对象右边缘坐标
    // CGRectGetMidX: 返回对象中心点的X坐标
    // CGRectGetMidY: 返回对象中心点的Y坐标
    
    // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
    
    // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
    
    if ([tableView numberOfRowsInSection:indexPath.section]-1 == 0) {
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMinX(bounds), CGRectGetMidY(bounds), cornerRadius);
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        
        
    }
    else if (indexPath.row == 0) {
        // 初始起点为cell的左下角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
        // 起始坐标为左下角，设为p，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
        
    } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
        
        // 初始起点为cell的左上角坐标
        CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
        CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
        // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
        CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
    } else {
        
        // 添加cell的rectangle信息到path中（不包括圆角）
        CGPathAddRect(pathRef, nil, bounds);
    }
    // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
    layer.path = pathRef;
    backgroundLayer.path = pathRef;
    // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
    CFRelease(pathRef);
    // 按照shape layer的path填充颜色，类似于渲染render
    // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
    layer.fillColor = [UIColor whiteColor].CGColor;
    
    
    // view大小与cell一致
    UIView *roundView = [[UIView alloc] initWithFrame:bounds];
    // 添加自定义圆角后的图层到roundView中
    [roundView.layer insertSublayer:layer atIndex:0];
    roundView.backgroundColor = UIColor.clearColor;
    // cell的背景view
    cell.backgroundView = roundView;
            
    //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
    backgroundLayer.fillColor = tableView.separatorColor.CGColor;
    [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
    selectedBackgroundView.backgroundColor = UIColor.clearColor;
    cell.selectedBackgroundView = selectedBackgroundView;
}

- (void)fetchUserCenterListDicInfo:(NSDictionary *)dic{
    FeaturedModel_UserCenter *info = [FeaturedModel_UserCenter mj_objectWithKeyValues:dic];
    NSMutableArray *infoArray = info.indexInfo;
    NSMutableArray *saveArray = [[NSMutableArray alloc] init];
    
    if (info.indexInfo.count > 0) {
        for (int i = 0;i < [infoArray count];i++) {
            FeaturedModel_UserCenterIndex *indexInfo = infoArray[i];
            
            BOOL iscaninput = [UleModulesDataToAction canInputDataMin:indexInfo.minversion withMax:indexInfo.maxversion withDevice:@"0" withAppVersion:[NonEmpty([UleStoreGlobal shareInstance].config.versionNum) integerValue]];
            if (iscaninput) {
                [saveArray addObject:infoArray[i]];
            }
        }
        //缓存本地
        [NSKeyedArchiver archiveRootObject:saveArray toFile:[FileController fullpathOfFilename:kCacheFile_UserCenterList]];
        [self prepareLayoutDataArray:YES];
    }
}

- (void)fetchWalletValueWithModel:(NSDictionary *) dic{
    US_WalletInfo * walletInfo = [US_WalletInfo yy_modelWithDictionary:dic];
    [US_UserUtility sharedLogin].bankCardCount = walletInfo.data.bindingCardCount;

    for (int i=0; i<self.mDataArray.count; i++) {
        UleSectionBaseModel * seconModel=self.mDataArray[i];
        for (int j=0; j<seconModel.cellArray.count; j++) {
            MineCellModel * cellModel=[seconModel.cellArray objectAtIndex:j];
            if (cellModel.walletButtonArr.count>0) {
                for (int a=0; a<cellModel.walletButtonArr.count; a++) {
                     MineCellModel * buttonModel=[cellModel.walletButtonArr objectAtIndex:a];
                    //收益
                    if ([buttonModel.functionId isEqualToString:kWallet_ShareAmount]) {
                        buttonModel.rightTitleStr=[NSString stringWithFormat:@"%.2lf",[walletInfo.data.commissionBalance doubleValue]];
                    }
                    //奖励金
                    if ([buttonModel.functionId isEqualToString:kWallet_AwardAmount]) {
                        buttonModel.rightTitleStr=[NSString stringWithFormat:@"%.2lf",[walletInfo.data.redPackageBalance919 doubleValue]];
                    }
                    if ([buttonModel.functionId isEqualToString:kWallet_CouponCount]) {
                        buttonModel.rightTitleStr=NonEmpty(walletInfo.data.useableCouponCount);
                    }
                }
            }
        }
    }
    [self.rootTableView reloadData];
}

- (void)fetchInviterValueWithModel:(NSDictionary *) dic{
    InviterMemberData *inviteMemberData = [InviterMemberData yy_modelWithDictionary:dic];
    _inviterMemberCount = inviteMemberData.data.totalRecords.integerValue;
    for (int i=0; i<self.mDataArray.count; i++) {
        UleSectionBaseModel * seconModel=self.mDataArray[i];
        for (int j=0; j<seconModel.cellArray.count; j++) {
            MineCellModel * cellModel=[seconModel.cellArray objectAtIndex:j];
            if ([cellModel.functionId isEqualToString:MineCellTitle_YQR]) {
                cellModel.rightTitleStr=inviteMemberData.data.totalRecords;
            }
        }
    }
    [self.rootTableView reloadData];
}

- (void)fetchShopCartValueWithModel:(NSDictionary *) dic{
    NSString * countStr = dic[@"data"];
    if (countStr.integerValue > 99) {
        countStr=@"99+";
    }
    for (int i=0; i<self.mDataArray.count; i++) {
        UleSectionBaseModel * seconModel=self.mDataArray[i];
        for (int j=0; j<seconModel.cellArray.count; j++) {
            MineCellModel * cellModel=[seconModel.cellArray objectAtIndex:j];
            if ([cellModel.functionId isEqualToString:MineCellTitle_GWC]) {
                cellModel.rightTitleStr=countStr;
            }
        }
    }
    [self.rootTableView reloadData];
}
#pragma mark - <>
- (void)prepareLayoutDataArray:(BOOL)needReload{
    self.haveWalletCell=NO;
    self.haveCartCell=NO;
    self.haveInvitedPersonCell=NO;
    [self fetchUserCenterListDicInfo];
    
    if (self.allListArr.count > 0) {
        if (self.mDataArray.count > 0) {
            [self.mDataArray removeAllObjects];
        }
        for (int i=0; i<self.allListArr.count; i++) {
            UleSectionBaseModel * seconModel=[[UleSectionBaseModel alloc] init];
            seconModel.footHeight=10;
            NSMutableArray * indexArr=self.allListArr[i];
            BOOL isWalletCell=NO;
            NSMutableArray * walletBtnArray=[NSMutableArray new];
            for (int j=0; j<indexArr.count; j++) {
                FeaturedModel_UserCenterIndex * info=indexArr[j];
                if ([info.groupid isEqualToString:@"1"]) {
                    isWalletCell=YES;
                    self.haveWalletCell=YES;
                }
                if ([info.functionId isEqualToString:MineCellTitle_GWC]) {
                    self.haveCartCell=YES;
                }
                if ([info.functionId isEqualToString:MineCellTitle_YQR]) {
                    self.haveInvitedPersonCell=YES;
                }
                MineCellModel * cellModel=[[MineCellModel alloc] init];
                cellModel.titleStr=info.title;
                cellModel.iconUrlStr=info.imgUrl;
                cellModel.ios_action=info.ios_action;
                cellModel.functionId=info.functionId;
                cellModel.groupId=info.groupid;
                cellModel.wh_rate=info.wh_rate;
                
                if ([info.groupid isEqualToString:@"4"]) {
                    cellModel.cellName=@"MineBannerCell";
                }else{
                    cellModel.cellName=@"MineTableViewCell";
                }
                
                
                if (isWalletCell) {
                    //奖励金(帅康用户不显示) 不往里添加
                  if ([info.functionId isEqualToString:kWallet_AwardAmount] && [[US_UserUtility sharedLogin].m_orgType isEqualToString:@"1000"]) {
                      continue;
                  }
                    [walletBtnArray addObject:cellModel];
                }
                else{
                    @weakify(self);
                    @weakify(cellModel);
                    cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
                        @strongify(self);
                        @strongify(cellModel);
                        [self tableCellClicAt:cellModel];
                    };
                    [seconModel.cellArray addObject:cellModel];
                }
            }
            if (isWalletCell && walletBtnArray.count>0) {
                MineCellModel * cellModel=[[MineCellModel alloc] init];
                cellModel.walletButtonArr=walletBtnArray;
                cellModel.cellName=@"WalletButtonCell";
                [seconModel.cellArray addObject:cellModel];
            }
            else{
                walletBtnArray=nil;
            }
            [self.mDataArray addObject:seconModel];
        }
        if (needReload) {
            [self.rootTableView reloadData];
        }
    }
}

- (void)fetchUserCenterListDicInfo{
    //取出缓存
    NSMutableArray *userCenterList = [NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_UserCenterList]];
    //缓存没有取本地plist数据
    if (!userCenterList || userCenterList.count == 0) {
        userCenterList = [FeaturedModel_UserCenterIndex mj_objectArrayWithKeyValuesArray:[FileController loadArrayListProduct:@"UleStoreApp.bundle/USUserCenterListNew.plist"]];
    }
    if (userCenterList.count > 0) {
        [self.allListArr removeAllObjects];
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
            if ([NSString isNullToString:info1.showProvince].length > 0) {
                if ([NSString isNullToString:[US_UserUtility sharedLogin].m_provinceCode].length > 0) {
                    if ([info1.showProvince containsString:[US_UserUtility sharedLogin].m_provinceCode]) {
                        [self filtereData:info1 userCenterIndex:info2 isLast:isLast];
                    }
                } else {
                    [self filtereData:info1 userCenterIndex:info2 isLast:isLast];
                }
            } else {
                [self filtereData:info1 userCenterIndex:info2 isLast:isLast];
            }
        }
    }
}

- (void)filtereData:(FeaturedModel_UserCenterIndex *)info1 userCenterIndex:(FeaturedModel_UserCenterIndex *)info2 isLast:(BOOL)isLast{
    [self.groupsortList addObject:info1];
    if (info1.groupsort != info2.groupsort || isLast) {
        [self.allListArr addObject:self.groupsortList];
        self.groupsortList = nil;
    }
}

- (void) tableCellClicAt:(MineCellModel *)cellModel{
    if ([NSString isNullToString:cellModel.ios_action].length > 0) {
        self.functionId = cellModel.functionId;
        [self iosAction:cellModel.ios_action];
    } else if ([cellModel.functionId isEqualToString:MineCellTitle_YQHY]){
        [[USInviteShareManager sharedManager] inviteShareToOpenStore];
    }
    
    [UleMbLogOperate addMbLogClick:@"" moduleid:@"个人中心" moduledesc:cellModel.titleStr networkdetail:@""];
}

/**
 *  iosAction跳转
 */
- (void)iosAction:(NSString *)iosActionStr {
    UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:iosActionStr];
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}


#pragma mark --getter
- (NSMutableArray *)groupsortList
{
    if (!_groupsortList) {
        _groupsortList = [NSMutableArray array];
    }
    return _groupsortList;
}

- (NSMutableArray *)allListArr
{
    if (!_allListArr) {
        _allListArr = [NSMutableArray array];
    }
    return _allListArr;
}
@end
