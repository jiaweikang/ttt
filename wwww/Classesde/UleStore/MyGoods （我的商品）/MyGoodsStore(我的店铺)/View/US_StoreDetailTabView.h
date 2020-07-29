//
//  US_StoreDetailTabView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol US_StoreDetailTabViewDelegate <NSObject>

@optional
- (void)didSelectedSortType:(NSString *)sortType sortOrder:(NSString *)sortOrder;

@end

NS_ASSUME_NONNULL_BEGIN

@interface US_TopTabItem : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * sortType;
@property (nonatomic, assign) BOOL canSortOrder;//是否可以排序

+ (instancetype) tabItemWithTitle:(NSString *)title sortType:(NSString *)sortType;
@end


@interface US_StoreDetailTabView : UIView
@property (nonatomic, weak) id<US_StoreDetailTabViewDelegate> delegate;

/**
 初始化排序tab

 @param items tab按键的类型和title @[@{@"title":@"销量",@"sortType":@"1"},@{@"title":@"收益",@"sortType":@"2"}]
 */
- (instancetype)initWithItems:(NSArray<US_TopTabItem *> *)items;


@end

NS_ASSUME_NONNULL_END
