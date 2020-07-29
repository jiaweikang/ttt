//
//  MineViewModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineViewModel : UleBaseViewModel
@property (nonatomic, weak) UITableView * rootTableView;
@property (nonatomic, strong) NSString * functionId;
@property (nonatomic, assign) BOOL haveWalletCell;
@property (nonatomic, assign) BOOL haveCartCell;
@property (nonatomic, assign) BOOL haveInvitedPersonCell;
- (void)fetchUserCenterListDicInfo:(NSDictionary *) dic;
- (void)fetchWalletValueWithModel:(NSDictionary *) dic;
- (void)fetchInviterValueWithModel:(NSDictionary *) dic;
- (void)fetchShopCartValueWithModel:(NSDictionary *) dic;

- (void)prepareLayoutDataArray:(BOOL)needReload;
@end

NS_ASSUME_NONNULL_END
