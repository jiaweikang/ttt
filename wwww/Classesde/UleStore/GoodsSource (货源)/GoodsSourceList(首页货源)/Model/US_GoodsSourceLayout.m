//
//  US_GoodsSourceLayout.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsSourceLayout.h"

@interface US_GoodsSourceLayout ()
@property (nonatomic, strong) NSMutableArray * allAttributes;
@property (nonatomic, assign) CGFloat mheight;
@property (nonatomic, strong) NSMutableArray * yArray;
@end

@implementation US_GoodsSourceLayout

- (void)prepareLayout{
    [super prepareLayout];
    _allAttributes=[[NSMutableArray alloc] init];
    self.mheight=0;
    NSInteger sections=[self.collectionView numberOfSections];
    for (int i=0; i<sections; i++) {
        US_GoodsSectionModel* sectionModel=self.dataArray[i];
        if (sectionModel.headHeight>=0) {
            if (sectionModel.headViewName.length>0) {
                NSIndexPath * indexPath=[NSIndexPath indexPathForItem:0 inSection:i];
                UICollectionViewLayoutAttributes * headerAttributes=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
                headerAttributes.frame=CGRectMake(0, self.mheight, __MainScreen_Width, sectionModel.headHeight);
                [self.allAttributes addObject:headerAttributes];
            }
            self.mheight+=sectionModel.headHeight;
        }
        if (sectionModel.layoutType==US_CustemLinearLayout) {
            [self layoutLinearTypeFor:sectionModel atSection:i];
        }else{
            [self layoutFlowTypeFor:sectionModel atSection:i];
        }
        if (sectionModel.footHeight>=0) {
            if (sectionModel.footViewName.length>0) {
                NSIndexPath * indexPath=[NSIndexPath indexPathForItem:0 inSection:i];
                UICollectionViewLayoutAttributes * footerAttributes=[UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:indexPath];
                footerAttributes.frame=CGRectMake(0, self.mheight, __MainScreen_Width, sectionModel.footHeight);
                [self.allAttributes addObject:footerAttributes];
            }
            self.mheight+=sectionModel.footHeight;
        }
    }
}

- (void)layoutLinearTypeFor:(US_GoodsSectionModel *)sectionModel atSection:(NSInteger)section{
    CGFloat pointX=0;
    CGFloat pointY=self.mheight;
    CGFloat lastY=pointY;
    NSInteger cellNum=sectionModel.cellArray.count;
    NSString *lastCellSort=@"";
    for (int j=0; j<cellNum; j++) {
        US_GoodsCellModel * cellModel=sectionModel.cellArray[j];
        NSIndexPath * cellIndexPath=[NSIndexPath indexPathForRow:j inSection:section];
        UICollectionViewLayoutAttributes * cellAttributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
         CGFloat delt=pointX+cellModel.weidth+cellModel.minCellOffset-__MainScreen_Width;
        if (pointX>0&&(![lastCellSort isEqualToString:cellModel.sortId]||delt>10)) {
            pointX=0+cellModel.minCellOffset;
            pointY=lastY+cellModel.minLinSpace;
        }
        if (pointX==0) {
            pointX=cellModel.minCellOffset;
        }
        cellAttributes.frame=CGRectMake(pointX, pointY+cellModel.minLinSpace,cellModel.weidth, cellModel.height);
        [self.allAttributes addObject:cellAttributes];
        if ((pointX+cellModel.weidth+cellModel.minItemSpace+2*cellModel.minCellOffset)>=(__MainScreen_Width)) {
            pointX=0+cellModel.minCellOffset;
            pointY=pointY+cellModel.height+cellModel.minLinSpace;
            lastY=pointY;
        }else{
            pointX=pointX+cellModel.weidth+cellModel.minItemSpace;
            lastY=pointY+cellModel.height+cellModel.minLinSpace;
        }
        lastCellSort=cellModel.sortId;
    }
    self.mheight=lastY;
}

- (void)layoutFlowTypeFor:(US_GoodsSectionModel *)sectionModel atSection:(NSInteger)section{
    NSMutableArray * yArray=[[NSMutableArray alloc] init];
     NSInteger cellNum=sectionModel.cellArray.count;
    if (sectionModel.columns>0&&sectionModel) {
        for (int k=0; k<sectionModel.columns; k++) {
            [yArray addObject:@(self.mheight)];
        }
    }
    CGFloat minLineSpace=0;
    for (int j=0; j<cellNum; j++) {
        CGFloat miny=[yArray[0] floatValue];
        NSInteger minx=0;
        for (int k=0; k<yArray.count; k++) {
            CGFloat y=[yArray[k] floatValue];
            if (y<miny) {
                miny=y;
                minx=k;
            }
        }
        US_GoodsCellModel * cellModel=sectionModel.cellArray[j];
        NSIndexPath * cellIndexPath=[NSIndexPath indexPathForRow:j inSection:section];
        UICollectionViewLayoutAttributes * cellAttributes=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:cellIndexPath];
        CGFloat x= (cellModel.weidth+cellModel.minItemSpace)*minx+cellModel.minCellOffset;
        cellAttributes.frame=CGRectMake(x, miny,cellModel.weidth, cellModel.height);
        yArray[minx]=@(miny+cellModel.height+cellModel.minLinSpace);
        [self.allAttributes addObject:cellAttributes];
        minLineSpace=cellModel.minLinSpace;
    }
    CGFloat height=self.mheight;
    for (int j=0; j<yArray.count; j++) {
        //取出记录的最大的Y值，并减去最后的minLinSpce,确保cell的头部底部没有空隙只有cell之间有。
        CGFloat y=[yArray[j] floatValue]-minLineSpace;
        if (height<y) {
            height=y;
        }
    }
    self.mheight=height;
}

- (CGSize)collectionViewContentSize{
    return CGSizeMake(__MainScreen_Width, self.mheight);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray * array=[[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes * attributes in self.allAttributes) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [array addObject:attributes];
        }
    }
    return [array copy];
}
    /*
    //UICollectionViewLayoutAttributes：我称它为collectionView中的item（包括cell和header、footer这些）的《结构信息》
    //截取到父类所返回的数组（里面放的是当前屏幕所能展示的item的结构信息），并转化成不可变数组
    NSMutableArray *superArray = [NSMutableArray arrayWithArray:array];//[[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //创建存索引的数组，无符号（正整数），无序（不能通过下标取值），不可重复（重复的话会自动过滤）
    NSMutableIndexSet *noneHeaderSections = [NSMutableIndexSet indexSet];
    //遍历superArray，得到一个当前屏幕中所有的section数组
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        //如果当前的元素分类是一个cell，将cell所在的分区section加入数组，重复的话会自动过滤
        if (attributes.representedElementCategory == UICollectionElementCategoryCell)
        {
            [noneHeaderSections addIndex:attributes.indexPath.section];
        }
    }
    
    //遍历superArray，将当前屏幕中拥有的header的section从数组中移除，得到一个当前屏幕中没有header的section数组
    //正常情况下，随着手指往上移，header脱离屏幕会被系统回收而cell尚在，也会触发该方法
    for (UICollectionViewLayoutAttributes *attributes in superArray)
    {
        //如果当前的元素是一个header，将header所在的section从数组中移除
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            [noneHeaderSections removeIndex:attributes.indexPath.section];
        }
    }
    
    //遍历当前屏幕中没有header的section数组
    [noneHeaderSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop){
        
        //取到当前section中第一个item的indexPath
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        //获取当前section在正常情况下已经离开屏幕的header结构信息
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        //如果当前分区确实有因为离开屏幕而被系统回收的header
        if (attributes&&attributes.frame.size.height>0)
        {
            //将该header结构信息重新加入到superArray中去
            [superArray addObject:attributes];
        }
    }];
    
    //遍历superArray，改变header结构信息中的参数，使它可以在当前section还没完全离开屏幕的时候一直显示
    for (int i=0; i<superArray.count;i++) {
        UICollectionViewLayoutAttributes *attributes=superArray[i];
        //如果当前item是header
        if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader])
        {
            //得到当前header所在分区的cell的数量
            NSInteger numberOfItemsInSection = [self.collectionView numberOfItemsInSection:attributes.indexPath.section];
            //得到第一个item的indexPath
            NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
            //得到最后一个item的indexPath
            NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:MAX(0, numberOfItemsInSection-1) inSection:attributes.indexPath.section];
            //得到第一个item和最后一个item的结构信息
            UICollectionViewLayoutAttributes *firstItemAttributes, *lastItemAttributes;
            if (numberOfItemsInSection>0)
            {
                //cell有值，则获取第一个cell和最后一个cell的结构信息
                firstItemAttributes = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
                lastItemAttributes = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
            }else
            {
                //cell没值,就新建一个UICollectionViewLayoutAttributes
                firstItemAttributes = [UICollectionViewLayoutAttributes new];
                //然后模拟出在当前分区中的唯一一个cell，cell在header的下面，高度为0，还与header隔着可能存在的sectionInset的top
                CGFloat y = CGRectGetMaxY(attributes.frame)+self.sectionInset.top;
                firstItemAttributes.frame = CGRectMake(0, y, 0, 0);
                //因为只有一个cell，所以最后一个cell等于第一个cell
                lastItemAttributes = firstItemAttributes;
            }
            
            //获取当前header的frame
            CGRect rect = attributes.frame;
            
            //当前的滑动距离 + 因为导航栏产生的偏移量，默认为64（如果app需求不同，需自己设置）
            CGFloat offset = self.collectionView.contentOffset.y;
            //第一个cell的y值 - 当前header的高度 - 可能存在的sectionInset的top
            CGFloat headerY = firstItemAttributes.frame.origin.y - rect.size.height - self.sectionInset.top;

            //哪个大取哪个，保证header悬停
            //针对当前header基本上都是offset更加大，针对下一个header则会是headerY大，各自处理
            CGFloat maxY = MAX(offset,headerY);
            
            //最后一个cell的y值 + 最后一个cell的高度 + 可能存在的sectionInset的bottom - 当前header的高度
            //当当前section的footer或者下一个section的header接触到当前header的底部，计算出的headerMissingY即为有效值
            CGFloat headerMissingY = CGRectGetMaxY(lastItemAttributes.frame) + self.sectionInset.bottom - rect.size.height;
            
            //给rect的y赋新值，因为在最后消失的临界点要跟谁消失，所以取小
            rect.origin.y = MIN(maxY,headerMissingY);
            //给header的结构信息的frame重新赋值
            attributes.frame = rect;
            
            //如果按照正常情况下,header离开屏幕被系统回收，而header的层次关系又与cell相等，如果不去理会，会出现cell在header上面的情况
            //通过打印可以知道cell的层次关系zIndex数值为0，我们可以将header的zIndex设置成1，如果不放心，也可以将它设置成非常大，这里随便填了个7
            attributes.zIndex = 7;
        }
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}
 */

//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewLayoutAttributes * headerAttributes=[UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:elementKind withIndexPath:indexPath];
//
//    return headerAttributes;
//}


@end
