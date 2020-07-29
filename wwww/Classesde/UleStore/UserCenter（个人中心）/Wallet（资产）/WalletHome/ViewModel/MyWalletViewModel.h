//
//  MyWalletViewModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyWalletViewModel : UleBaseViewModel
@property (nonatomic, weak) UITableView * rootTableView;
@property (nonatomic, strong) NSString * headerTitleStr;
- (void)loadLocalData:(NSMutableArray *)dataArray;
- (void)prepareLayoutDataArray;

//解析资产页列表
- (void)fetchWalletListWithData:(NSDictionary *)dic;
//解析钱包数据
- (NSDecimalNumber *)fetchWalletInfoValueWithData:(NSDictionary *) dic;
//显示用户是否实名认证
- (void)refeashUserRealNameAuthorization;

@end

NS_ASSUME_NONNULL_END
