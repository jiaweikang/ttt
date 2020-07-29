//
//  UleTableViewCellProtocol.h
//  UleMarket
//
//  Created by chenzhuqing on 2018/12/3.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef UleTableViewCellProtocol_h
#define UleTableViewCellProtocol_h

@protocol UleTableViewCellProtocol <NSObject>

@optional
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, weak) UITableView * tableView;
@property (nonatomic, copy) void(^reloadCollectionView)(void);
@property (nonatomic, copy) void(^reloadTableView)(void);
- (void)setModel:(id)model;
- (void)setDelegate:(id)delegate;


@end

#endif /* UleTableViewCellProtocol_h */
