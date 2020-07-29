//
//  UleBaseViewModel.m
//  UleApp
//
//  Created by ule-admin on 2018/4/9.
//  Copyright © 2018年 ule. All rights reserved.
//

#import "UleBaseViewModel.h"
#import <UITableView+SDAutoTableViewCellHeight.h>
#import "UleTableViewCellProtocol.h"
#import "UleSectionBaseModel.h"
@interface UleBaseViewModel ()<UIScrollViewDelegate>
{
    NSMutableSet *_reuseCellSet;
    NSMutableSet *_reuseHeaderSet;
    NSMutableSet *_reuseFooterSet;
}
@end

@implementation UleBaseViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _reuseCellSet = [NSMutableSet set];
        _reuseHeaderSet = [NSMutableSet set];
        _reuseFooterSet = [NSMutableSet set];
    }
    return self;
}


- (void)loadDataWithSucessBlock:(ReturnSucessBlock)success faildBlock:(ErrorCodeBlock)faild{
    self.sucessBlock = success;
    self.failedBlock = faild;
}

- (instancetype) initWithDataArray:(NSMutableArray<UleSectionBaseModel *> *) array{
    self = [super init];
    if (self) {
        self.mDataArray=array;
    }
    return self;
}

#pragma mark - <UITableView DataSource>

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    UleSectionBaseModel * model=self.mDataArray[section];
    return model.cellArray.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * section=self.mDataArray[indexPath.section];
    UleCellBaseModel *model= section.cellArray[indexPath.row];
    Class cellClass=NSClassFromString(model.cellName);
    UITableViewCell<UleTableViewCellProtocol> * cell=[tableView dequeueReusableCellWithIdentifier:model.cellName];
    if (cell==nil) {
        cell=[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.cellName];
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]&&self.rootVC) {
        [cell setDelegate:self.rootVC];
    }
    if ([cell respondsToSelector:@selector(setTableView:)]) {
        cell.tableView=tableView;
    }
    if ([cell respondsToSelector:@selector(setIndexPath:)]) {
        cell.indexPath=indexPath;
    }
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:model];
    }
    if ([cell respondsToSelector:@selector(setReloadTableView:)]) {
         __weak typeof(tableView) wTableView  = tableView;
        [cell setReloadTableView:^{
            __strong typeof (wTableView) tableView=wTableView;
            [tableView reloadData];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * section=self.mDataArray[indexPath.section];
    UleCellBaseModel *model= section.cellArray[indexPath.row];
    Class cellClass=NSClassFromString(model.cellName);
    if (model.layoutType == TableCellMasonryLayout) {
        return UITableViewAutomaticDimension;
    }
    return ceil([tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[cellClass class] contentViewWidth:[UIScreen mainScreen].bounds.size.width]);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UleSectionBaseModel * model=self.mDataArray[section];
    if (model.headViewName.length>0) {
        Class headViewClass=NSClassFromString(model.headViewName);
        UITableViewHeaderFooterView<UleTableViewCellProtocol> * headView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:model.headViewName];
        if (headView==nil) {
            headView=[[headViewClass alloc] initWithReuseIdentifier:model.headViewName];
        }
        if ([headView respondsToSelector:@selector(setDelegate:)]&&self.rootVC) {
            [headView setDelegate:self.rootVC];
        }
        if ([headView respondsToSelector:@selector(setModel:)]) {
            [headView setModel:model];
        }
        if ([headView respondsToSelector:@selector(setReloadTableView:)]) {
             __weak typeof(tableView) wTableView  = tableView;
            [headView setReloadTableView:^{
                __strong typeof (wTableView) tableView=wTableView;
                [tableView reloadData];
            }];
        }
        return headView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UleSectionBaseModel * model= self.mDataArray[section];
    if (model.footViewName.length>0) {
        Class footViewClass=NSClassFromString(model.footViewName);
        UITableViewHeaderFooterView<UleTableViewCellProtocol> * footView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:model.footViewName];
        if (footView==nil) {
            footView=[[footViewClass alloc] initWithReuseIdentifier:model.footViewName];
        }
        if ([footView respondsToSelector:@selector(setDelegate:)]&&self.rootVC) {
            [footView setDelegate:self.rootVC];
        }
        if ([footView respondsToSelector:@selector(setModel:)]) {
            [footView setModel:model];
        }
        if ([footView respondsToSelector:@selector(setReloadTableView:)]) {
             __weak typeof(tableView) wTableView  = tableView;
            [footView setReloadTableView:^{
                __strong typeof (wTableView) tableView=wTableView;
                [tableView reloadData];
            }];
        }
        return footView;
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    UleSectionBaseModel * model= self.mDataArray[section];
    return model.headHeight;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    UleSectionBaseModel * model= self.mDataArray[section];
    return model.footHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UleSectionBaseModel * section=self.mDataArray[indexPath.section];
    UleCellBaseModel *model= section.cellArray[indexPath.row];
    if (model.cellClick) {
        model.cellClick(tableView, indexPath);
    }
}

#pragma mark - <UICollection delegate and datasource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.mDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    UleSectionBaseModel * sectionModel=self.mDataArray[section];
    return sectionModel.cellArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionModel=self.mDataArray[indexPath.section];
    UleCellBaseModel * cellModel=sectionModel.cellArray[indexPath.row];
    NSString *identifier= cellModel.cellName;
    Class cls=NSClassFromString(identifier);
    if (![_reuseCellSet containsObject:identifier]) {
        [collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
        [_reuseCellSet addObject:identifier];
    }
    UICollectionViewCell<UleTableViewCellProtocol> * cell= [collectionView dequeueReusableCellWithReuseIdentifier:cellModel.cellName forIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setModel:)]) {
        [cell setModel:cellModel];
    }
    if ([cell respondsToSelector:@selector(setDelegate:)]) {
        [cell setDelegate:self];
    }
    if ([cell respondsToSelector:@selector(setReloadCollectionView:)]) {
        __weak typeof(collectionView) wCollectionView = collectionView;
        [cell setReloadCollectionView:^{
            __strong typeof(wCollectionView) collectionView = wCollectionView;
            if (!collectionView) return;
            [collectionView reloadData];
        }];
    }
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * sectionModel=self.mDataArray[indexPath.section];
    NSString * identifier;
    NSMutableSet *reuseSet;
    if (kind == UICollectionElementKindSectionHeader) {
        identifier = sectionModel.headViewName;
        reuseSet = _reuseHeaderSet;
    } else if (kind == UICollectionElementKindSectionFooter) {
        identifier = sectionModel.footViewName;;
        reuseSet = _reuseFooterSet;
    } else {
        return nil;
    }
    if (![reuseSet containsObject:identifier]) {
        Class cls=NSClassFromString(identifier);
        [collectionView registerClass:cls forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
        [reuseSet addObject:identifier];
    }
    if (identifier.length>0) {
         UICollectionReusableView<UleTableViewCellProtocol> * tempView= [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
        if ([tempView respondsToSelector:@selector(setModel:)]) {
            [tempView setModel:sectionModel.sectionData];
        }
        if ([tempView respondsToSelector:@selector(setReloadCollectionView:)]) {
            __weak typeof(collectionView) wCollectionView = collectionView;
            [tempView setReloadCollectionView:^{
                __strong typeof(wCollectionView) collectionView = wCollectionView;
                if (!collectionView) return;
                [collectionView reloadData];
            }];
        }
        return tempView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UleSectionBaseModel * section=self.mDataArray[indexPath.section];
    UleCellBaseModel *model= section.cellArray[indexPath.row];
    if (model.collectionClick) {
        model.collectionClick(collectionView, indexPath);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (NSMutableArray *)mDataArray{
    if (!_mDataArray) {
        _mDataArray = [NSMutableArray new];
    }
    return _mDataArray;
}
@end
