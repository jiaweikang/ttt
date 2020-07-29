//
//  UpdateUserPickViewModel.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserPickViewModel.h"
#import "AttributionModel.h"
#import "US_NetworkExcuteManager.h"
#import "US_LoginApi.h"
#import "PostOrgModel.h"
#import "UpdateUserPickCollectionCellModel.h"
#import "UleTableViewCellProtocol.h"

@interface UpdateUserPickViewModel ()
@property (nonatomic, strong)UleNetworkExcute           *networkClient_VPS;
@property (nonatomic, strong)UleSectionBaseModel        *mSectionModel;
@property (nonatomic, strong)NSMutableDictionary        *cellDic;
@end

@implementation UpdateUserPickViewModel

- (void)fetchEnterpriseData:(NSDictionary *)dic{
    AttributionModel *responseModel=[AttributionModel yy_modelWithDictionary:dic];
    UleSectionBaseModel *sectionModel = [[UleSectionBaseModel alloc]init];
    for (int i=0; i<responseModel.data.count; i++) {
        AttributionData *item=[responseModel.data objectAtIndex:i];
        AttributionPickCellModel *cellModel=[[AttributionPickCellModel alloc]initWithCellName:@"UpdateUserPickListCell"];
        cellModel.contentStr=[NSString stringWithFormat:@"%@", item.name];
        cellModel._id=[NSString stringWithFormat:@"%ld", (long)item._id];
        cellModel.isContentSelected=NO;
        @weakify(cellModel);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(cellModel);
            if (self.enter_lastSelectedCellModel) {
                self.enter_lastSelectedCellModel.isContentSelected=NO;
            }
            cellModel.isContentSelected=YES;
            self.enter_lastSelectedCellModel=cellModel;
            if (self.sucessBlock) {
                self.sucessBlock(nil);
            }
        };
        [sectionModel.cellArray addObject:cellModel];
    }
    [self.mDataArray removeAllObjects];
    [self.mDataArray addObject:sectionModel];
    if (self.sucessBlock) {
        self.sucessBlock(nil);
    }
}

- (void)addUserAuthDefaultData{
    self.org_provinceId=[US_UserUtility sharedLogin].m_provinceCode;
    self.org_provinceName=[US_UserUtility sharedLogin].m_provinceName;
    UpdateUserPickCollectionCellModel *collectionCellModel=[[UpdateUserPickCollectionCellModel alloc]initWithCellName:@"UpdateUserPickCollectionCell"];
    collectionCellModel.mCellType=UpdateUserPickCollectionCellTypeProvince;
    UleSectionBaseModel *tableSectionModel=[[UleSectionBaseModel alloc]init];
    AttributionPickCellModel *cellModel=[[AttributionPickCellModel alloc]initWithCellName:@"UpdateUserPickListCell"];
    cellModel.contentStr=self.org_provinceName;
    cellModel._id=self.org_provinceId;
    cellModel.isContentSelected=YES;
    [tableSectionModel.cellArray addObject:cellModel];
    collectionCellModel.tableviewDataArray=[NSMutableArray arrayWithObject:tableSectionModel];
    [self.mSectionModel.cellArray addObject:collectionCellModel];
    if (self.sucessBlock) {
        self.sucessBlock(self.mDataArray);
    }
}

- (void)loadOrganizeInfoWithParentId:(NSString *)parentId andLevelName:(NSString *)levelName
{
    [UleMBProgressHUD showHUDAddedTo:self.rootVC.view withText:@""];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostOrganizationWithParentId:parentId andLevelName:levelName andOrgType:self.postOrgType] success:^(id responseObject) {
        @strongify(self);
        USLog(@"%@", [responseObject yy_modelToJSONString]);
        PostOrgModel *respModel = [PostOrgModel yy_modelWithDictionary:responseObject];
        if (!respModel.data||respModel.data.count==0) {
            if (self.sucessBlock) {
                self.sucessBlock(nil);
            }
            [UleMBProgressHUD hideHUDForView:self.rootVC.view];
            return;
        }
        NSMutableArray *responseArr = [NSMutableArray arrayWithObject:respModel.data];
        if ([levelName isEqualToString:@"省"]) {
            responseArr = [self sortSourceData:respModel.data];
        }
        NSMutableArray *tableDataArray=[NSMutableArray array];
        for (NSArray *sectionArray in responseArr) {
            UleSectionBaseModel *tableSectionModel=[[UleSectionBaseModel alloc]init];
            for (PostOrgData *item in sectionArray) {
                AttributionPickCellModel *cellModel=[[AttributionPickCellModel alloc]initWithCellName:@"UpdateUserPickListCell"];
                cellModel.contentStr=[NSString stringWithFormat:@"%@", item.name];
                cellModel._id=[NSString stringWithFormat:@"%ld", (long)item._id];
                cellModel.isContentSelected=NO;
                [tableSectionModel.cellArray addObject:cellModel];
                tableSectionModel.sectionData=[NSString isNullToString:item.firstLetter];
            }
            [tableDataArray addObject:tableSectionModel];
        }
        
        UpdateUserPickCollectionCellModel *cellModel=[[UpdateUserPickCollectionCellModel alloc]initWithCellName:@"UpdateUserPickCollectionCell"];
        NSInteger currentCellType=[self getCurrentCellTypeByLevelName:levelName];
        cellModel.mCellType=currentCellType;
        cellModel.tableviewDataArray=tableDataArray;
        @weakify(self);
        cellModel.collectionCellSelectBlock = ^(AttributionPickCellModel * _Nonnull selectCellModel) {
            @strongify(self);
            [self tableViewInCollectionCellDidSelectWith:currentCellType andSelectCellModel:selectCellModel];
        };
        NSInteger cellCount=self.mSectionModel.cellArray.count;
        if (self.mSectionModel.cellArray.count>=cellModel.mCellType) {
            [self.mSectionModel.cellArray removeObjectsInRange:NSMakeRange(cellModel.mCellType-1, cellCount-(cellModel.mCellType-1))];
        }
        [self.mSectionModel.cellArray addObject:cellModel];
        
        if (self.sucessBlock) {
            self.sucessBlock(self.mDataArray);
        }
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.rootVC.view];
        if (self.failedBlock) {
            self.failedBlock(error);
        }
    }];
}

- (void)tableViewInCollectionCellDidSelectWith:(UpdateUserPickCollectionCellType)itemType andSelectCellModel:(AttributionPickCellModel*)selectCellModel{
    NSString *selectID=[NSString isNullToString:selectCellModel._id];
    NSString *selectName=[NSString isNullToString:selectCellModel.contentStr];
    UleSectionBaseModel *collectionSectionModel=[self.mDataArray firstObject];
    NSUInteger collectionCellCount=collectionSectionModel.cellArray.count;
    if (collectionCellCount>itemType) {
        [collectionSectionModel.cellArray removeObjectsInRange:NSMakeRange(itemType, collectionCellCount-itemType)];
    }
    switch (itemType) {
        case UpdateUserPickCollectionCellTypeProvince:
        {
            self.org_provinceId=selectID;
            self.org_provinceName=selectName;
            self.org_cityId=@"";
            self.org_countryId=@"";
            self.org_subStationId=@"";
            self.org_cityName=@"";
            self.org_countryName=@"";
            self.org_subStationName=@"";
        }
            break;
        case UpdateUserPickCollectionCellTypeCity:
            self.org_cityId=selectID;
            self.org_cityName=selectName;
            self.org_countryId=@"";
            self.org_subStationId=@"";
            self.org_countryName=@"";
            self.org_subStationName=@"";
            break;
        case UpdateUserPickCollectionCellTypeCountry:
            self.org_countryId=selectID;
            self.org_countryName=selectName;
            self.org_subStationId=@"";
            self.org_subStationName=@"";
            break;
        case UpdateUserPickCollectionCellTypeSubStation:
            self.org_subStationId=selectID;
            self.org_subStationName=selectName;
            break;
        default:
            break;
    }
    if (self.didSelectNew) {
        self.didSelectNew();
    }
}

#pragma mark - <重写cellForItemAtIndexPath>
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionModel=self.mDataArray[indexPath.section];
    UleCellBaseModel * cellModel=sectionModel.cellArray[indexPath.row];
    NSString *identify = [self.cellDic objectForKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]];
    if (identify==nil) {
        identify = [NSString stringWithFormat:@"%@%@",@"PickTemplateCell",[NSString stringWithFormat:@"%@",indexPath]];
        [self.cellDic setObject:identify forKey:[NSString stringWithFormat:@"%@%@",@(indexPath.section),@(indexPath.row)]];
        [collectionView registerClass:NSClassFromString(cellModel.cellName) forCellWithReuseIdentifier:identify];
    }
    
    UICollectionViewCell<UleTableViewCellProtocol> * cell= [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:cellModel];
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [cell setDelegate:self];
    }
    return cell;
}

#pragma mark - <scrollDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX=scrollView.contentOffset.x;
    if (self.didEndScrollBlock) {
        self.didEndScrollBlock(offsetX);
    }
}

- (UpdateUserPickCollectionCellType)getCurrentCellTypeByLevelName:(NSString *)levelName{
    UpdateUserPickCollectionCellType cellType=UpdateUserPickCollectionCellTypeNone;
    if ([levelName isEqualToString:@"省"]) {
        cellType=UpdateUserPickCollectionCellTypeProvince;
    }else if ([levelName isEqualToString:@"市"]) {
        cellType=UpdateUserPickCollectionCellTypeCity;
    }else if ([levelName isEqualToString:@"县"]) {
        cellType=UpdateUserPickCollectionCellTypeCountry;
    }else if ([levelName isEqualToString:@"支局"]) {
        cellType=UpdateUserPickCollectionCellTypeSubStation;
    }
    return cellType;
}

- (NSString *)getCurrentOrganizationNameLowest{
    NSString *lowestOrganName=@"";
    if ([NSString isNullToString:self.org_subStationName].length>0) {
        lowestOrganName=[NSString isNullToString:self.org_subStationName];
    }else if ([NSString isNullToString:self.org_countryName].length>0) {
        lowestOrganName=[NSString isNullToString:self.org_countryName];
    }else if ([NSString isNullToString:self.org_cityName].length>0) {
        lowestOrganName=[NSString isNullToString:self.org_cityName];
    }else if ([NSString isNullToString:self.org_provinceName].length>0) {
        lowestOrganName=[NSString isNullToString:self.org_provinceName];
    }
    return lowestOrganName;
}

- (NSString *)getLastOrganizeName:(NSUInteger)pageIndex{
    switch (pageIndex) {
        case 0:
            return self.org_provinceName;
            break;
        case 1:
            return self.org_cityName;
            break;
        case 2:
            return self.org_countryName;
            break;
        case 3:
            return self.org_subStationName;
            break;
        default:
            return @"";
            break;
    }
}

#pragma mark - <actions>
- (NSMutableArray *)sortSourceData:(NSMutableArray *)sourceData
{
    //firstLetter为空的加到最后
    NSMutableArray *emptyLetterArr = [NSMutableArray array];
    for (PostOrgData *item in sourceData) {
        if ([NSString isNullToString:item.firstLetter].length==0) {
            [emptyLetterArr addObject:item];
        }
    }
    //排序
    NSMutableArray *sourceArr = [NSMutableArray arrayWithArray:sourceData];
    NSMutableArray *sortedDataArr = [NSMutableArray array];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstLetter" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [sourceArr sortUsingDescriptors:sortDescriptors];
    for (char flag='A'; flag<='Z'; flag++) {
        NSMutableArray *flagArr = [NSMutableArray array];
        for (PostOrgData *item in sourceArr) {
            if ([item.firstLetter isEqualToString:[NSString stringWithFormat:@"%c",flag]]) {
                [flagArr addObject:item];
            }
        }
        if (flagArr.count>0) {
            [sortedDataArr addObject:flagArr];
        }
    }
    if (emptyLetterArr.count>0) {
        [sortedDataArr addObject:emptyLetterArr];
    }
    return sortedDataArr;
}

#pragma mark - <getters>
- (UleNetworkExcute *)networkClient_VPS{
    if (!_networkClient_VPS) {
        _networkClient_VPS=[US_NetworkExcuteManager uleVPSRequestClient];
    }
    return _networkClient_VPS;
}
- (UleSectionBaseModel *)mSectionModel{
    if (!_mSectionModel) {
        _mSectionModel=[[UleSectionBaseModel alloc]init];
        [self.mDataArray addObject:_mSectionModel];
    }
    return _mSectionModel;
}
-(NSMutableDictionary *)cellDic{
    if (!_cellDic) {
        _cellDic=[NSMutableDictionary dictionary];
    }
    return _cellDic;
}
@end
