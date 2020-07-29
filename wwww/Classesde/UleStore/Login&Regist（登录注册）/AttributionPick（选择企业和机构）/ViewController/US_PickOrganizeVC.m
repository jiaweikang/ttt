//
//  US_PickOrganizeVC.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/19.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_PickOrganizeVC.h"
#import "AttributionPickViewModel.h"
#import "OrganizeCollectionViewCell.h"
#import "OrganizePickAlertView.h"
#import "PostOrgModel.h"
#import "OrganizeConfirmAlertView.h"
#import <UIView+ShowAnimation.h>

@interface US_PickOrganizeVC ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, OrganizePickAlertViewDelegate>
{
    NSString    *orgType;
    CGFloat collectionItemHeight;
    
    NSString * provinceName;//省
    NSString * cityName;//市
    NSString * areaName;//县
    NSString * townName;//支局
    
    /*****省市县支局ID*****/
    NSString * provinceID;
    NSString * cityID;
    NSString * areaID;
    NSString * townID;
    
    //最终选择机构
    NSString * finalSelectName;
    NSString * finalSelectID;
}
@property (nonatomic, strong)UICollectionView               *mCollectionView;
@property (nonatomic, strong)OrganizePickAlertView          *mBottomAlertView;
@property (nonatomic, strong)OrganizeConfirmAlertView       *mConfirmAlertView;
@property (nonatomic, strong)AttributionPickViewModel       *mViewModel;
@property (nonatomic, strong)NSMutableDictionary            *cellDic;
@property (nonatomic, strong)NSMutableArray                 *collectionViewDataArr;

@end

@implementation US_PickOrganizeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mCollectionView];
    self.mCollectionView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    collectionItemHeight=__MainScreen_Height-CGRectGetHeight(self.uleCustemNavigationBar.frame);
    orgType = [self.m_Params objectForKey:@"pickOrgType"];
    [self.uleCustemNavigationBar customTitleLabel:[orgType isEqualToString:@"1000"] ? @"所在地区" : @"所在邮政局"];
    [self startRequestOrganizeInfoWithParentID:orgType andLevelName:@"省"];
}

- (void)startRequestOrganizeInfoWithParentID:(NSString *)parentId andLevelName:(NSString *)levelName
{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"加载中..."];
    [self.mViewModel loadDataWithSucessBlock:^(NSMutableArray *returnValue) {
        [UleMBProgressHUD hideHUDForView:self.view];
        NSMutableArray *firstSectionArr=[returnValue firstObject];
        if (self.collectionViewDataArr.count>0&&firstSectionArr&&firstSectionArr.count==0) {
            [self showConfirmAlertViewWithContent:self->finalSelectName];
        }else {
            [self.collectionViewDataArr addObject:returnValue];
            [self.mCollectionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.collectionViewDataArr.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            });
        }
    } faildBlock:^(id errorCode) {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self showErrorHUDWithError:errorCode];
    }];
    
    [self.mViewModel loadOrganizeInfoWithParentId:parentId andLevelName:levelName andPostOrgType:[self getCurrentChinaPostOrgType]];
}


#pragma mark - <action>
- (void)setCurrentAttributionWithIndexPath:(NSIndexPath *)pIndexPath andName:(NSString *)attributeName andId:(NSString *)attributeID
{
    //点击了新的机构后,删除下级的所有元数据
    if (self.collectionViewDataArr.count>(pIndexPath.row+1)) {
        [self.collectionViewDataArr removeObjectsInRange:NSMakeRange(pIndexPath.row+1, self.collectionViewDataArr.count-pIndexPath.row-1)];
        [self.mCollectionView reloadData];
    }
    switch (pIndexPath.row) {
        case 0:
            //省
        {
            provinceName=attributeName;
            provinceID=attributeID;
            
            cityName=@"";
            areaName=@"";
            townName=@"";
            cityID=@"";
            areaID=@"";
            townID=@"";
        }
            break;
        case 1:
            //市
        {
            cityName=attributeName;
            cityID=attributeID;
            
            areaName=@"";
            townName=@"";
            areaID=@"";
            townID=@"";
        }
            break;
        case 2:
            //县
        {
            areaName=attributeName;
            areaID=attributeID;
            
            townName=@"";
            townID=@"";
        }
            break;
        case 3:
            //支局
        {
            townName=attributeName;
            townID=attributeID;
            //展示确认弹窗
            [self showConfirmAlertViewWithContent:townName];
        }
            break;
        default:
            break;
    }
    
    [self changeBottomAlertViewStatusWithCollectionIndexRow:pIndexPath.row];
}

- (void)changeBottomAlertViewStatusWithCollectionIndexRow:(NSInteger)cellRow
{
    if (cellRow==0) {
        [self.mBottomAlertView showBackupBtn:NO];
    }else [self.mBottomAlertView showBackupBtn:YES];
    
    @weakify(self);
    [self getCurrentAttributionByCellRow:cellRow withResult:^(NSString *lowestAttribeName, NSString *secondLowestAttributeName, NSString *lowestAttribeID, NSString *secondLowestAttributeID) {
        @strongify(self);
        [self.mBottomAlertView setPresentStr:lowestAttribeName andLastStr:secondLowestAttributeName];
        self->finalSelectID=lowestAttribeID;
        self->finalSelectName=lowestAttribeName;
    }];
}

//- (void)getCurrentLowestAttributionResult:(void(^)(NSString *lowestAttribution, NSString *secondLowestAttribution))result{
//    NSString *lowestAtt=@"";
//    NSString *secondLowestAtt=@"";
//    if (townName.length>0) {
//        lowestAtt=townName;
//        secondLowestAtt=areaName;
//    }else if (areaName.length>0) {
//        lowestAtt=areaName;
//        secondLowestAtt=cityName;
//    }else if (cityName.length>0) {
//        lowestAtt=cityName;
//        secondLowestAtt=provinceName;
//    }else if (provinceName.length>0) {
//        lowestAtt=provinceName;
//    }
//
//    result(lowestAtt, secondLowestAtt);
//}

- (void)getCurrentAttributionByCellRow:(NSInteger)cellRow withResult:(void(^)(NSString *lowestAttribeName, NSString *secondLowestAttributeName, NSString *lowestAttribeID, NSString *secondLowestAttributeID))result
{
    NSString *lowestName=@"";
    NSString *secondLowestName=@"";
    NSString *lowestID=@"";
    NSString *secondLowestID=@"";
    switch (cellRow) {
        case 0:
        {
            lowestName=provinceName;
            lowestID=provinceID;
        }
            break;
        case 1:
        {
            if (cityName.length>0) {
                lowestName=cityName;
                lowestID=cityID;
                secondLowestName=provinceName;
                secondLowestID=provinceID;
            }else {
                lowestName=provinceName;
                lowestID=provinceID;
            }
        }
            break;
        case 2:
        {
            if (areaName.length>0) {
                lowestName=areaName;
                lowestID=areaID;
                secondLowestName=cityName;
                secondLowestID=cityID;
            }else {
                lowestName=cityName;
                lowestID=cityID;
                secondLowestName=provinceName;
                secondLowestID=provinceID;
            }
        }
            break;
        case 3:
        {
            if (townName.length>0) {
                lowestName=townName;
                lowestID=townID;
                secondLowestName=areaName;
                secondLowestID=areaID;
            }else {
                lowestName=areaName;
                lowestID=areaID;
                secondLowestName=cityName;
                secondLowestID=cityID;
            }
        }
            break;
        default:
            break;
    }
    if (result) {
        result(lowestName, secondLowestName, lowestID, secondLowestID);
    }
}

- (void)showConfirmAlertViewWithContent:(NSString *)contentStr
{
    [self.mConfirmAlertView setConfirmedStr:contentStr];
    [self.mConfirmAlertView showViewWithAnimation:AniamtionPresentBottom];
}


#pragma mark - <OrganizePickAlertViewDelegate>
//返回上级
- (void)backupBtnAction
{
    NSInteger currentPage = self.mCollectionView.contentOffset.x/__MainScreen_Width;
    if (currentPage>0) {
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}

//去下一级
- (void)leftBtnAction
{
    NSInteger currentPage = self.mCollectionView.contentOffset.x/__MainScreen_Width;
    if (self.collectionViewDataArr.count>currentPage+1) {
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        return;
    }
    
    NSString *currentParentID=@"";
    NSString *currentLevelName=@"";
    switch (currentPage) {
        case 0:
        {
            currentParentID=provinceID;
            currentLevelName=@"市";
        }
            break;
        case 1:
        {
            if (cityID.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            currentParentID=cityID;
            currentLevelName=@"县";
        }
            break;
        case 2:
        {
            if (areaID.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            currentParentID=areaID;
            currentLevelName=@"支局";
        }
            break;
        case 3:
        {
            if (townID.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"没有下一级机构" afterDelay:1.5];
            return;
        }
            break;
            
        default:
            break;
    }
    
    [self startRequestOrganizeInfoWithParentID:currentParentID andLevelName:currentLevelName];
}

//确认
- (void)rightBtnAction
{
    [self showConfirmAlertViewWithContent:finalSelectName];
}
#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(__MainScreen_Width, collectionItemHeight);
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectionViewDataArr.count;
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //滚动结束
    NSInteger currentPage = scrollView.contentOffset.x/__MainScreen_Width;
    [self changeBottomAlertViewStatusWithCollectionIndexRow:currentPage];
    
}

#pragma mark - <UICollectionViewDelegate>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //取消UICollectionView的强制复用
    NSString *identify = [self.cellDic objectForKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]];
    if (identify==nil) {
        identify = [NSString stringWithFormat:@"%@%@",@"OrganizeCollectionViewCell",[NSString stringWithFormat:@"%@",indexPath]];
        [self.cellDic setObject:identify forKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]];
        [self.mCollectionView registerClass:[OrganizeCollectionViewCell class] forCellWithReuseIdentifier:identify];
    }
    
    OrganizeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    @weakify(self);
    cell.tableCellDidSelectBlock = ^(NSString * _Nonnull organizeName, NSString * _Nonnull organizeId, NSIndexPath * _Nonnull tableIndexPath, NSIndexPath * _Nonnull lastTableIndexPath) {
        @strongify(self);
        //修改元数据
        NSMutableArray *cellDataArr = self.collectionViewDataArr[indexPath.row];
        //选中的
        NSMutableArray *sectionDataArr = cellDataArr[tableIndexPath.section];
        PostOrgData *cellData = sectionDataArr[tableIndexPath.row];
        cellData.isSelected=YES;
        //上次选中的
        if (lastTableIndexPath!=nil) {
            NSMutableArray *sectionDataArr = cellDataArr[lastTableIndexPath.section];
            PostOrgData *cellData = sectionDataArr[lastTableIndexPath.row];
            cellData.isSelected=NO;
        }
        
        
        if (self->_mBottomAlertView==nil) {
            //底部弹框
            [self.view addSubview:self.mBottomAlertView];
            [self.mBottomAlertView show];
            CGFloat bottomViewHeight = CGRectGetHeight(self.mBottomAlertView.frame);
            self->collectionItemHeight-=bottomViewHeight;
            self.mCollectionView.sd_resetLayout.topSpaceToView(self.uleCustemNavigationBar, 0)
            .leftSpaceToView(self.view, 0)
            .bottomSpaceToView(self.view, bottomViewHeight)
            .rightSpaceToView(self.view, 0);
            [self.mCollectionView reloadData];
        }
        //修改底部弹框显示
        [self setCurrentAttributionWithIndexPath:indexPath andName:organizeName andId:organizeId];
    };
    [cell setTableviewData:self.collectionViewDataArr[indexPath.row]];
    
    return cell;
}


#pragma mark - <getter>
- (UICollectionView *)mCollectionView
{
    if (!_mCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0.0;
        flowLayout.minimumLineSpacing = 0.0;
        _mCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _mCollectionView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mCollectionView.pagingEnabled = YES;
        _mCollectionView.scrollEnabled = NO;
        _mCollectionView.showsHorizontalScrollIndicator = NO;
        _mCollectionView.dataSource = self;
        _mCollectionView.delegate = self;
    }
    return _mCollectionView;
}

- (OrganizePickAlertView *)mBottomAlertView
{
    if (!_mBottomAlertView) {
        _mBottomAlertView = [[OrganizePickAlertView alloc] init];
        _mBottomAlertView.mDelegate=self;
    }
    return _mBottomAlertView;
}

- (OrganizeConfirmAlertView *)mConfirmAlertView
{
    if (!_mConfirmAlertView) {
        _mConfirmAlertView = [[OrganizeConfirmAlertView alloc]init];
        @weakify(self);
        _mConfirmAlertView.confirmBlock = ^{
            @strongify(self);
            NSMutableDictionary *confirmNotiDic = [NSMutableDictionary dictionary];
            NSArray *allAttributeNameArr=@[self->provinceName, self->cityName, self->areaName, self->townName];
            NSArray *allAttributeIDArr=@[self->provinceID, self->cityID, self->areaID, self->townID];
            NSArray *allKeys_id=@[@"provinceID", @"cityID", @"areaID", @"townID"];
            NSArray *allKeys_name=@[@"provinceName", @"cityName", @"areaName", @"townName"];
            for (int i=0; i<allAttributeNameArr.count; i++) {
                if ([self->finalSelectName isEqualToString:allAttributeNameArr[i]]) {
                    [confirmNotiDic setObject:allAttributeIDArr[i] forKey:allKeys_id[i]];
                    [confirmNotiDic setObject:allAttributeNameArr[i] forKey:allKeys_name[i]];
                    [confirmNotiDic setObject:self->finalSelectName forKey:@"finalSelectName"];
                    break;
                }else {
                    [confirmNotiDic setObject:allAttributeIDArr[i] forKey:allKeys_id[i]];
                    [confirmNotiDic setObject:allAttributeNameArr[i] forKey:allKeys_name[i]];
                }
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_OrganizePickConfirm object:nil userInfo:confirmNotiDic];
            [self.mConfirmAlertView hiddenView];
            self.mConfirmAlertView=nil;
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _mConfirmAlertView;
}

- (AttributionPickViewModel *)mViewModel
{
    if (!_mViewModel) {
        _mViewModel=[[AttributionPickViewModel alloc]init];
    }
    return _mViewModel;
}

- (NSMutableDictionary *)cellDic
{
    if (!_cellDic) {
        _cellDic=[NSMutableDictionary dictionary];
    }
    return _cellDic;
}

- (NSMutableArray *)collectionViewDataArr
{
    if (!_collectionViewDataArr) {
        _collectionViewDataArr=[NSMutableArray array];
    }
    return _collectionViewDataArr;
}


- (NSString *)getCurrentChinaPostOrgType
{
    NSString *chinaPostOrgType=@"";
    if ([orgType isEqualToString:@"100"]) {
        chinaPostOrgType=@"0";
    }else {
        chinaPostOrgType=@"2";
    }
    return chinaPostOrgType;
}
@end
