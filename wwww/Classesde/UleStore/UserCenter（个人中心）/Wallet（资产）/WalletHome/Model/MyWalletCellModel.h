//
//  MyWalletCellModel.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleCellBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyWalletCellModel : UleCellBaseModel

@property (nonatomic, strong) NSAttributedString * rightTitle;

@property (nonatomic, strong) NSString * iconUrlStr;
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) NSString * sub_titleStr;
@property (nonatomic, strong) NSString * groupId;
@property (nonatomic, strong) NSString * ios_action;
@property (nonatomic, strong) NSString * functionId;
@property (nonatomic, strong) NSString * img_wh_rate;
@property (nonatomic, strong) NSString * statistics_flag;
@property (nonatomic, strong) NSString * log_title;

@end

NS_ASSUME_NONNULL_END
