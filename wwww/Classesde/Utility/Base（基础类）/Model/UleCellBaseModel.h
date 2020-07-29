//
//  UleCellBaseModel.h
//  UleApp
//
//  Created by chenzhuqing on 2018/11/14.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, TableCellLayoutType) {
    TableCellSDAutoLayout,
    TableCellMasonryLayout,
};


typedef void(^TableCellClickBlock)(UITableView * tableView,NSIndexPath * indexPath);
typedef void(^CollectionCellClickBlock)(UICollectionView * collectionView,NSIndexPath * indexPath);
@interface UleCellBaseModel : NSObject
@property (nonatomic, strong) NSString * identify;
@property (nonatomic, strong) NSString * cellName;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat weidth;
@property (nonatomic, strong) TableCellClickBlock cellClick;
@property (nonatomic, strong) CollectionCellClickBlock collectionClick;
@property (nonatomic, strong) id data;
@property (nonatomic, assign) TableCellLayoutType layoutType;


- (instancetype) initWithCellName:(NSString *)cellName;
@end

NS_ASSUME_NONNULL_END
