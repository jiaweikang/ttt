//
//  MineCellModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/4.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "UleCellBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineCellModel : UleCellBaseModel


@property (nonatomic, strong) NSString * iconUrlStr;
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) NSString * rightTitleStr;
@property (nonatomic, assign) NSString * groupId;
@property (nonatomic, strong) NSString * ios_action;
@property (nonatomic, strong) NSString * functionId;
@property (nonatomic, strong) NSString * wh_rate;

@property (nonatomic, strong) NSMutableArray <MineCellModel *> * walletButtonArr;

@end

NS_ASSUME_NONNULL_END
